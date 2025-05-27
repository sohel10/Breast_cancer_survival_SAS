/**************************************************************************
Project: Survival Analysis Using Synthetic Breast Cancer mCODE Data
Author: Sohel Ahmed, Email: sohelcu06@gmail.com
Description: This program imports, merges, analyzes, and models synthetic
             breast cancer patient data for survival analysis using 
             Kaplan-Meier and Cox Proportional Hazards Models.
**************************************************************************/

/* Step 0: Define library */
libname mydata "your/local/path/";

/* Step 1: Import all CSVs */
%macro import_csv(file);
    proc import datafile="your/local/path/&file..csv"
        out=mydata.&file
        dbms=csv replace;
        getnames=yes;
    run;
%mend;

%import_csv(patients);
%import_csv(conditions);
%import_csv(medicationrequests);
%import_csv(procedures);
%import_csv(encounters);
%import_csv(observations);

/* Step 1.5: Add patient age as of Jan 1, 2020 */
data mydata.patients_with_age;
    set mydata.patients;
    format birth_date yymmdd10.;
    age = intck('year', birth_date, '01JAN2025'd) -
          (month(birth_date) > 1 or (month(birth_date) = 1 and day(birth_date) > 1));
run;

/* Step 2: Clean UUIDs */
%macro clean_uuid(input, output);
    data mydata.&output;
        set mydata.&input;
        length patient_id_clean $36;
        patient_id_clean = tranwrd(patient_id, "urn:uuid:", "");
    run;
%mend;

%clean_uuid(conditions, conditions_clean);
%clean_uuid(medicationrequests, medication_clean);
%clean_uuid(procedures, procedures_clean);

data mydata.patients_clean;
    set mydata.patients;
    length patient_id_clean $36;
    patient_id_clean = patient_id;
run;

/* Step 3: Identify breast cancer cases */
data mydata.breast_conditions;
    set mydata.conditions_clean;
    description_lc = lowcase(description);
    if index(description_lc, 'breast') > 0 and 
       (index(description_lc, 'malignant') > 0 or index(description_lc, 'neoplasm') > 0);
run;

/* Step 4: Deduplicate */
proc sort data=mydata.breast_conditions nodupkey out=mydata.breast_dx;
    by patient_id_clean;
run;

/* Step 5: Join patients with breast cancer diagnoses */
proc sql;
    create table mydata.breast_patients as
    select 
        p.patient_id_clean as patient_id,
        p.gender,
        p.birth_date,
        d.onset_date,
        d.description as diagnosis
    from mydata.patients_clean p
    inner join mydata.breast_dx d
    on p.patient_id_clean = d.patient_id_clean;
quit;

/* Step 6: Link medications and procedures */
data mydata.medication_clean;
    set mydata.medicationrequests;
    patient_id_clean = scan(patient_id, -1, ':');
run;

data mydata.procedures_clean;
    set mydata.procedures;
    patient_id_clean = scan(patient_id, -1, ':');
run;

proc sql;
    create table mydata.breast_meds as
    select * from mydata.medication_clean
    where patient_id_clean in (select patient_id from mydata.breast_patients);

    create table mydata.breast_procs as
    select * from mydata.procedures_clean
    where patient_id_clean in (select patient_id from mydata.breast_patients);
quit;

/* Step 7: Simulate survival data */
data mydata.breast_survival;
    set mydata.breast_patients;
    onset_date_clean = datepart(onset_date);
    simulated_death_date = .;
    death_or_censor_date = '01JAN2025'd;
    event_observed = (simulated_death_date ne .);
    observed_duration = death_or_censor_date - onset_date_clean;
    format onset_date_clean yymmdd10. death_or_censor_date yymmdd10.;
run;

/* Step 8: Simulate deaths in ~20% for KM and Cox modeling */
data mydata.breast_survival;
    set mydata.breast_survival;
    retain seed 12345;
    rand = ranuni(seed);
    if rand <= 0.2 then do;
        simulated_death_date = onset_date_clean + int(1000 * rand);
        event_observed = 1;
        death_or_censor_date = simulated_death_date;
    end;
    observed_duration = death_or_censor_date - onset_date_clean;
run;

/* Step 9: Kaplan-Meier Curve */
proc lifetest data=mydata.breast_survival plots=survival;
    time observed_duration * event_observed(0);
run;

/* Step 10: Cox Proportional Hazards Model */
data mydata.breast_survival;
    set mydata.breast_survival;
    age_at_onset = intck('year', birth_date, onset_date_clean, 'C');
run;

proc phreg data=mydata.breast_survival;
    class gender;
    model observed_duration * event_observed(0) = gender age_at_onset;
    baseline out=surv_scores survival=surv_prob / method=PL;
run;

/* Step 11: Export Results */
proc export data=surv_scores
    outfile="your/local/path/breast_survival_with_risk.csv"
    dbms=csv replace;
run;
