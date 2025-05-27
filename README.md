# 🧬 Breast Cancer Survival Analysis Using Synthetic mCODE Data

## 📋 Overview
This project performs a comprehensive survival analysis using synthetic breast cancer patient data generated with the Synthea™ platform and conforming to the mCODE (Minimal Common Oncology Data Elements) standard. The analysis includes data import, cleaning, integration, Kaplan-Meier survival estimation, and Cox proportional hazards modeling with gender and age.

---

## ⚙️ Workflow

### Step 0: Define Library
Set up the SAS library to access datasets.

### Step 1: Import Data
All six mCODE-based CSVs are imported: `patients`, `conditions`, `medications`, `procedures`, `encounters`, and `observations`.

### Step 2: Clean & Prepare
- Clean UUIDs from FHIR format.
- Merge tables using patient IDs.
- Calculate patient age as of January 1, 2025.
- Extract breast cancer patients using diagnosis keyword matching.

### Step 3: Deduplication & Merging
- Ensure one row per patient for conditions.
- Merge breast cancer diagnoses with patient demographics.

### Step 4: Link Medications and Procedures
Medications and procedures are filtered and linked to the breast cancer patients.

### Step 5: Simulate and Analyze Survival Data
- Simulated event dates and durations.
- Kaplan-Meier curves stratified by gender.
- Cox regression using gender and age.

### Step 6: Visualize Results
- Kaplan-Meier survival curves using `PROC LIFETEST` and `PROC SGPLOT`
- Hazard ratios estimated via `PROC PHREG`

### Step 7: Export Final Datasets
Export final merged and cleaned datasets as CSVs for reproducibility or further downstream analysis.

---

## 📊 Key Outputs

- `breast_patients.csv`: Cleaned breast cancer patient cohort
- `breast_meds.csv`: Medications taken by cohort
- `breast_procs.csv`: Procedures received
- `breast_survival.csv`: Survival-ready data with durations and event flags
- Kaplan-Meier survival plot stratified by gender
- Cox model showing risk by age and gender

---

## 📦 Data Source
This project uses publicly available **synthetic breast cancer patient data** generated using [Synthea™](https://synthetichealth.github.io/synthea/) and post-processed to conform to [mCODE STU1 standards](https://mcodeinitiative.org/).

- **Dataset Title:** Approx. 2,000 Patient Records with 10 Years of Medical History  
- **Source:** MITRE Corporation via CodeX (HL7/ONC initiative)  
- **Direct Download:** [mitre.box.com link](https://mitre.box.com/shared/static/13ypa62hpnnb3j67wdfmd4dd2tzzf18s.zip)  
- **Patient Composition:**
  - Female breast cancer patients: 1,853  
  - Male breast cancer patients: 19  
  - Other cancer types: 211  

> This dataset is free of cost, privacy, and security restrictions. It is designed for secondary use in academia, research, and industry. While based on mCODE FHIR standards, it is synthetic and **not suitable for clinical decision-making or discovery**.

---

## 🧠 Skills Demonstrated
- SAS programming (data cleaning, merging, macros)
- Clinical trial survival analysis (Kaplan-Meier, Cox regression)
- Working with mCODE & FHIR-based synthetic data
- Exploratory visualization and export
- Preparation of production-ready analytics code for pharma/biotech settings

---

## 📫 Contact
For questions or collaborations, feel free to reach out via [https://github.com/sohel10]) or sohelcu06@gmail.com.
