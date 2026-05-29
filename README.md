## 🔍 What This Project Does
Nova Bank provides personal loans across the **USA, UK, and Canada** — but its 
portfolio carries a default rate of **21.82%**. The core challenge is finding the 
right balance: approving too many high-risk loans leads to financial losses, while 
being overly strict means turning away creditworthy customers.

This project uses loan data to help Nova Bank understand who is likely to default, 
why they default, and how lending decisions can be made more reliably.

---

## 💡 Key Results


| Finding | Detail |
|---|---|
| Top predictor | `loan_grade` — Grade G reaches **98.4%** default rate vs Grade A at **10.0%** |
| Strongest gap | `home_ownership` — Renters default at **4×** the rate of homeowners (31.6% vs 7.5%) |
| Income risk | Borrowers earning under $30K carry a **45.5%** default rate |
| Prior default | A prior default on file increases risk by **2.06×** |
| Early warning | 37 borrowers meet all 4 high-risk conditions → **75.7%** default rate |
| No regional bias | USA / UK / Canada all sit at ~21.8% — lending policy is applied consistently |

---

## 🔄 Analysis Pipeline

Data Ingestion       →   Load raw Excel (32,581 records · 37 features)
Data Cleaning        →   Fix outlier ages · Group-median imputation for missing values
Feature Engineering  →   Risk scoring · LTI/DTI tiers · Age/Income buckets · Early warning flag
SQL Analysis         →   15 queries in SSMS covering portfolio health and borrower segmentation
Power BI Dashboard   →   4-page interactive dashboard · 12 DAX measures · Cross-page filtering

## 📊 Power BI Dashboard

### Page 1 — Executive Overview
![Executive Overview](https://github.com/minhduc342005/Nova-Bank-Credit-Risk/blob/main/assets/Overview.PNG)

High-level view of the entire loan portfolio, designed for senior management and 
executives who need a quick read on overall portfolio health and risk concentration.

- **Core KPIs:** Total Loans: 33K · Default Rate: 21.82% · Total Exposure: $312M · 
  Default Exposure: $77M · Avg Interest Rate: 11.01% · Early Warning Count: 37
- **Default Rate by Loan Grade:** A clear gradient from Grade A (10.0%) to Grade G 
  (98.4%) — Grades D through G account for 76% of all defaults while representing 
  only 14% of the portfolio
- **Risk Tier Distribution:** 47.8% of borrowers fall under Medium Risk and 44.6% 
  under High Risk — only 3.3% sit in the Low Risk tier
- **Country Comparison:** USA, UK, and Canada all record ~21.8% default rates — 
  no regional bias detected, confirming consistent underwriting standards across markets
- **LTI × DTI Heatmap:** The intersection of High LTI and High DTI produces an 
  81.3% default rate — the single most dangerous segment in the portfolio

---

### Page 2 — Borrower Profile

![Borrower Profile](https://github.com/minhduc342005/Nova-Bank-Credit-Risk/blob/main/assets/Profile.PNG)

Borrower characteristics breakdown targeting loan officers and credit policy teams 
who need to understand which demographic and financial profiles drive default risk.

- **Default Rate by Loan Intent:** Debt Consolidation carries the highest default rate 
  at 28.6%, followed by Medical (26.7%) and Home Improvement (26.1%). Venture loans 
  are the safest at 14.8% — borrowers seeking growth capital tend to be more financially stable
- **Home Ownership Impact:** Renters default at 31.6% versus 7.5% for homeowners — 
  a 24.1 percentage-point gap that makes home ownership the single strongest 
  non-grade predictor in the dataset
- **Income Level:** Borrowers earning under $30K default at 45.5%. This drops 
  sharply to 13.3% for the $60K–$100K group and 9.2% for those earning $100K–$200K
- **Employment Type:** All four employment categories fall within 1.1 percentage 
  points of each other (21.6%–22.7%) — employment type is not a meaningful predictor 
  and should carry low weight in any credit scoring model
- **Age Group:** The 20–25 age group is both the largest segment (15,352 borrowers) 
  and carries the highest default rate (23.0%). Borrowers aged 60+ show an elevated 
  rate of 26.6% despite very low volume
- **Gender and Marital Status:** The maximum gap across all gender-marital combinations 
  is under 3 percentage points — these demographic factors have no meaningful 
  predictive power and should be excluded from scoring models to ensure fair lending

---

### Page 3 — Financial Risk Signals

![Financial Risk Signals](https://github.com/minhduc342005/Nova-Bank-Credit-Risk/blob/main/assets/Financial%20Risk%20Signals.PNG)

Financial ratio and credit history analysis targeting risk analysts and the credit 
committee who evaluate structural risk factors beyond borrower demographics.

- **Prior Default Uplift:** Borrowers with a prior default on file carry a 37.8% 
  default rate versus 18.4% for clean-record borrowers — a 2.06× uplift. This 
  single binary flag is one of the most reliable predictors in the dataset
- **LTI × DTI Risk Matrix:** The combined effect of high leverage ratios is far 
  more predictive than either ratio alone. Low LTI + Low DTI produces an 11–13% 
  default rate, while High LTI + High DTI reaches 81.3%
- **Scatter Plot by Grade:** Plotting average interest rate against average loan 
  amount by grade reveals a clear risk cluster — Grades D through G sit in the 
  upper-right quadrant (high rate, high amount, large bubble size) while Grades 
  A and B cluster in the lower-left (low rate, low amount, small bubble)
- **Past Delinquency Count:** Surprisingly, the number of past delinquencies has 
  almost no relationship with current default outcomes — the default rate stays 
  between 21% and 23% regardless of delinquency count. The binary prior-default 
  flag is a far stronger signal than counting past incidents
- **Credit History Length:** Borrowers with shorter credit histories (0–2 years) 
  carry a slightly higher default rate (23.6%) which gradually falls to 20.6% 
  at 6–10 years, suggesting that a longer credit track record provides modest 
  but real protection

---

### Page 4 — Deep Dive / Segment Intelligence

![Deep Dive](https://github.com/minhduc342005/Nova-Bank-Credit-Risk/blob/main/assets/Depp%20Dive.PNG)

Granular segment analysis designed for data analysts and model development teams 
who need to identify the specific borrower combinations that produce extreme outcomes.

- **Top Riskiest Combinations:** Filtering to segments with at least 50 borrowers 
  reveals the most dangerous combinations in the portfolio. Grade E + Debt 
  Consolidation + Full-time employment produces a 100% default rate across 80 
  borrowers. Grade E + Medical + Full-time reaches 97.2% across 106 borrowers. 
  Grade D + Debt Consolidation + Full-time affects 346 borrowers at 91.9%
- **Delta vs Portfolio Average:** Grades A and B sit 11.9pp and 5.5pp below the 
  21.82% portfolio average respectively, confirming their safe status. Grade G 
  sits 76.6pp above average — nearly four times the portfolio default rate
- **Decomposition Tree:** Starting from the 21.82% portfolio default rate, 
  drilling by Country → Grade → Employment → Home Ownership → Income Group 
  → Interest Rate uncovers extreme pockets. The path USA → Grade D → 
  Self-employed → RENT → income $100K–$200K → interest rate ~15% produces 
  a 100% default rate — a counter-intuitive finding showing that even 
  higher-income borrowers in poor structural conditions carry extreme risk
- **Safe Zone vs Risk Zone:** Borrowers meeting Grade A–B + income above $60K 
  + mortgage or owned home average around 8% default rate. Borrowers in Grade 
  D–G + renting + DTI above 0.4 average around 68% — an 8× difference between 
  the safest and riskiest segments in the portfolio

---

## 🛠️ Skills Demonstrated

| Area | What I Did |
|---|---|
| Data Cleaning | Outlier treatment, group-median imputation, data consistency checks |
| Feature Engineering | Composite risk scoring model, tier bucketing, early warning flag |
| SQL Analysis | 15 business queries in SSMS covering 8 analytical dimensions |
| DAX & Power BI | 12 DAX measures, calculated columns, cross-page slicers, conditional formatting |
| Business Thinking | Translated analytical findings into 5 actionable lending policy recommendations |

---

## 📁 Project Structure
```
Nova-Bank-Credit-Risk/
├── assets/                           # Dashboard screenshots
├── data/
│   └── credit_risk_cleaned.csv
├── notebook/
│   └── NovaBank_Pipeline.ipynb
├── sql/
│   └── SQLQuery1.sql
├── dashboard/
│   └── Credit_risk.pbix
├── report/
│   └── NovaBank_CreditRisk_Report.docx
└── README.md
```

## 📂 Dataset

| | |
|---|---|
| Records | 32,581 personal loans |
| Features | 37 (demographic, financial, and credit history) |
| Target | `loan_status` — 0: Non-default · 1: Default |
| Countries | USA · UK · Canada |
| Default Rate | 21.82% |

---

## How to Run

```bash
# 1. Clone the repository
git clone https://github.com/your-username/Nova-Bank-Credit-Risk.git

# 2. Install dependencies
pip install pandas numpy sqlalchemy pyodbc openpyxl jupyter

# 3. Run the Python pipeline
jupyter notebook notebook/NovaBank_Pipeline.ipynb

# 4. Execute SQL queries in SSMS
# Open sql/SQLQuery1.sql and run against the NovaBank_Risk database

# 5. Open the Power BI dashboard
# Open dashboard/Credit_risk.pbix in Power BI Desktop
```

---

