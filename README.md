# 🏥 Healthcare Analytics — Faith Specialist Hospital

> End-to-end SQL analysis of patient demographics, admissions, chronic disease prevalence, lifestyle risk factors, and doctor performance at a specialist hospital.

---

## 📌 Project Overview

This project involves a comprehensive relational database design and analytical SQL queries to uncover actionable insights from hospital records. The analysis spans patient demographics, discharge patterns, chronic illness comorbidities, lifestyle risk factors, and clinical performance evaluation.

**Key Question:** What patient, lifestyle, and clinical factors most significantly drive adverse outcomes (mortality, DAMA, chronic disease burden) at Faith Specialist Hospital?

---

## 🗂️ Database Schema

Four core tables form the relational model:

```
patients         — Demographics (age, sex, education, occupation, marital status)
doctors          — Physician profiles (specialization, contact)
admissions       — Clinical outcomes (DAMA, mortality, chronic conditions, dialysis)
risk_factors     — Lifestyle data (alcohol, tobacco, NSAID use)
```

**Relationships:**
- `admissions` links to `patients` and `doctors` via foreign keys
- `risk_factors` links to `patients` via `hospital_no`
- Indexes added on `doctor_id` and `hospital_no` for query performance

---

## 🎯 Analytical Objectives

### 1. Patient Demographics & Outcomes
- Age-group breakdown with death rate, DAMA rate, CKD rate, and diabetes rate
- Gender-based outcome comparison (mortality, DAMA, stroke)
- Education level vs. health outcomes

### 2. Discharge Against Medical Advice (DAMA)
- DAMA reasons ranked by frequency and post-discharge mortality
- DAMA patterns segmented by gender and education level
- **Key Finding:** Financial barriers drove **88% of DAMA cases**

### 3. Chronic Disease Analysis
- Prevalence of CKD, Diabetes, Stroke, Cancer, and PUD across all admissions
- Comorbidity analysis — patients with 2+ conditions and their mortality rates
- CKD deep-dive: causes, dialysis rates, and average dialysis sessions
- **Key Findings:** Stroke (23.48%) and CKD (21.92%) were the highest-prevalence conditions

### 4. Lifestyle Risk Factors
- Prevalence of alcohol use, tobacco use, and NSAID use
- Correlation between lifestyle factors and chronic disease rates
- Lifestyle combinations and their impact on mortality

### 5. Doctor Performance Evaluation
- Workload, death rate, and DAMA rate per physician
- Specialization-level outcome benchmarking
- Chronic disease patient load and CKD-specific mortality by doctor
- **Key Finding:** Significant performance variation identified across doctors, prompting quality intervention recommendations

### 6. Hospital-Wide KPIs & High-Risk Profiles
- Overall KPIs: total patients, doctors, death rate, DAMA rate, average age
- High-risk patient profiling (sex, age decade, lifestyle factors) ranked by mortality

---

## 🛠️ Tools & Techniques

| Tool | Usage |
|------|-------|
| MySQL | Database design, querying, data transformation |
| SQL JOINs | Multi-table relational analysis |
| CASE WHEN | Conditional aggregations for rate calculations |
| Subqueries | Comorbidity scoring and nested analysis |
| Indexes | Performance optimization on foreign key columns |
| ALTER TABLE | Data type management during import workflow |

---

## 📁 File Structure

```
healthcare-analytics-sql/
│
├── README.md
├── COLLINS-CAPSTONE_PROJECT.sql    # Full script: schema + data prep + all analysis
```

---

## 💡 Key Insights & Recommendations

| # | Insight | Recommendation |
|---|---------|----------------|
| 1 | Financial barriers cause 88% of DAMA | Partner with health insurance schemes; introduce payment plans |
| 2 | Stroke (23.48%) and CKD (21.92%) are the leading conditions | Build dedicated chronic disease management protocols |
| 3 | Comorbid patients have significantly higher mortality | Implement multi-disciplinary care teams for complex cases |
| 4 | Significant variation in doctor performance metrics | Establish peer review and outcome benchmarking programs |
| 5 | Lifestyle factors (alcohol, tobacco, NSAIDs) correlate with CKD | Strengthen patient lifestyle counselling at admission |

---

## 🚀 How to Run

1. Open MySQL Workbench (or any MySQL client)
2. Run the full script: `COLLINS-CAPSTONE_PROJECT.sql`
3. The script will:
   - Create the `Faith_Specialist_Hospital` database
   - Set up all four tables with appropriate foreign keys and indexes
   - Guide you through the data import process (with temporary type adjustments)
   - Execute all six analytical objective queries

> **Note:** You will need to import your own dataset CSV files into the respective tables after the schema is created. The script includes the necessary `ALTER TABLE` steps to handle import type conversions.

---

## 👤 Author

**Hassan Ambi Isaac**
Data Analyst | [LinkedIn](https://www.linkedin.com/in/hassanambi) | [GitHub](https://github.com/hassanambi)
