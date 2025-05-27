# Breast_cancer_survival_SAS
# Breast Cancer Survival Analysis using Synthetic Clinical Trial Data (SAS)

This repository contains a comprehensive SAS-based analysis pipeline applied to synthetic oncology patient data (mCODE FHIR Bundle format). The analysis focuses on identifying breast cancer patients, linking their treatment and procedure history, and conducting survival analysis using Kaplan-Meier methods.

## 🔍 Project Overview

This project demonstrates real-world clinical trial data processing and survival analysis workflows typically used in pharmaceutical research. Key components include:

- Patient demographics and age calculation
- CDISC-style data merging and cleaning (e.g., UUID standardization)
- Condition filtering for breast cancer
- Linking medications and procedures
- Kaplan-Meier survival estimation
- Export of clean, analysis-ready datasets

## 🧬 Technologies Used

- **SAS Studio (ODAMID)**
- **mCODE-compliant FHIR JSON** → Converted CSV files
- **SAS/STAT procedures**: `PROC LIFETEST`, `PROC EXPORT`, `PROC SQL`
- **Data cleaning and integration** using `DATA`, `MACRO`, `PROC SQL`

## 📊 Key Analytical Steps

1. **Data Import**: Load patient, condition, medication, and procedure CSVs.
2. **Cleaning & Merging**:
   - Standardize `patient_id`
   - Calculate patient age as of Jan 1, 2025
   - Merge patient-level variables across tables
3. **Breast Cancer Identification**:
   - Filter `conditions` for breast cancer (SNOMED: "Malignant neoplasm of breast")
   - Join with medications and procedures
4. **Survival Analysis**:
   - Simulate or assign survival/censor dates
   - Calculate observed duration
   - Plot Kaplan-Meier survival curve (overall and by gender)
5. **Cox Proportional Hazards Model** *(Optional)*:
   - Include age and gender as covariates

## 📁 Output Files

- `breast_patients.csv` — Patients with breast cancer diagnosis
- `breast_meds.csv` — Medications received
- `breast_procs.csv` — Procedures received
- `breast_survival.csv` — Survival dataset with censoring flags and durations

## 🧪 Use Case Relevance

This project mirrors SAS workflows used in:

- Clinical trial analysis
- CDISC/ADaM data preparation
- Regulatory submission preparation (SDTM, ADaM, Define.xml)
- Safety/efficacy reporting

## 🚀 Future Work

- Add CDISC SDTM and ADaM conversion macros
- Integrate Cox regression for risk prediction
- Expand to other cancers or synthetic datasets
- Automate Define.XML metadata generation

## 📫 Contact

**Author:** Sohel Ahmed  
📍 Statistician and Data Scientist | SAS , Stata & Python Developer | Clinical Trials | 


---

