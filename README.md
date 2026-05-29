## 🔍 What This Project Does

Nova Bank cung cấp các khoản vay cá nhân tại **USA, UK và Canada** — nhưng tỷ lệ nợ quá hạn lên đến **21.82%**. Project này trả lời 3 câu hỏi kinh doanh:

1. **Ai có khả năng vỡ nợ?** → Phân tích 15 yếu tố rủi ro từ dữ liệu vay
2. **Yếu tố nào quan trọng nhất?** → Xếp hạng predictors theo mức độ ảnh hưởng
3. **Làm thế nào để ngăn chặn sớm?** → Xây dựng hệ thống early warning flag

Pipeline hoàn chỉnh: **Python → SQL Server → Power BI dashboard 4 trang**.

---

## 💡 Key Results

| Finding | Detail |
|---|---|
| **Top predictor** | `loan_grade` — Grade G có tỷ lệ default **98.4%** vs Grade A chỉ **10.0%** |
| **Strongest gap** | `home_ownership` — Người thuê nhà default gấp **4×** người sở hữu nhà (31.6% vs 7.5%) |
| **Income risk** | Thu nhập < $30K có tỷ lệ default **45.5%** |
| **Prior default** | Có tiền sử default → rủi ro tăng **2.06×** |
| **Early warning** | 37 borrowers đáp ứng 4 điều kiện rủi ro → **75.7%** default rate |
| **No bias found** | USA / UK / Canada đều ~21.8% — chính sách cho vay đồng đều |

---

## 🔄 Analysis Pipeline

Data Ingestion       Load raw Excel (32,581 records · 37 features)
↓
Data Cleaning        Fix outlier ages · Group-median imputation
↓
Feature Engineering  Risk score · LTI/DTI tiers · Age/Income buckets · Early warning flag
↓
SQL Analysis         15 queries in SSMS covering portfolio health & borrower segmentation
↓
Power BI Dashboard   4-page interactive dashboard · 12 DAX measures · Cross-page filtering


---

## 📊 Power BI Dashboard

### Preview
![Dashboard Page 1](assets/dashboard_1.png)

Dashboard gồm **4 trang** phân tích:

### 1. Executive Overview
Tổng quan danh mục cho vay — KPIs, phân bổ rủi ro và so sánh giữa các quốc gia.
- **Total Loans:** 33K · **Default Rate:** 21.82% · **Total Exposure:** $312M
- Grade D–G chiếm **76% tổng defaults** dù chỉ chiếm 14% portfolio
- LTI High + DTI High = **81.3% default rate** (vùng nguy hiểm nhất)

### 2. Borrower Profile
Phân tích đặc điểm người vay — thu nhập, loại nhà ở, mục đích vay.
- Debt Consolidation: **28.6%** vs Venture: **14.8%**
- Thu nhập < $30K: **45.5%** default rate
- Employment type: gap < 1.1pp — **không phải yếu tố dự báo**

### 3. Financial Risk Signals
Tín hiệu rủi ro tài chính — LTI/DTI matrix, tiền sử tín dụng, lãi suất.
- Prior default = Y: **37.8%** vs N: **18.4%** (uplift **2.06×**)
- Delinquency count: yếu tố **weak predictor** (gap < 1.5pp)

### 4. Deep Dive — Segment Intelligence
Phân tích tổ hợp borrower nguy hiểm nhất và Decomposition Tree.
- Grade E + Debt Consolidation + Full-time = **100% default rate**
- Decomposition Tree drill 6 tầng: Country → Grade → Employment → Home → Income → Rate

---

## 🛠️ Skills Demonstrated

| Area | What I Did |
|---|---|
| **Data Cleaning** | Outlier treatment, group-median imputation, consistency checks |
| **Feature Engineering** | Risk scoring model, tier bucketing, composite early warning flag |
| **SQL Analysis** | 15 business queries in SSMS covering 8 analytical dimensions |
| **DAX & Power BI** | 12 measures, calculated columns, cross-page slicers, conditional formatting |
| **Business Thinking** | Translated findings into 5 actionable lending policy recommendations |

---

## 📁 Project Structure
Nova-Bank-Credit-Risk/
├── assets/              # Dashboard screenshots
├── data/
│   └── credit_risk_cleaned.csv
├── notebook/
│   └── 1.py             # Python cleaning & feature engineering pipeline
├── sql/
│   └── SQLQuery1.sql    # 15 analytical queries
├── dashboard/
│   └── Credit_risk.pbix
├── report/
│   └── NovaBank_CreditRisk_Report.docx
└── README.md

---

## 📂 Dataset

**Credit Risk Dataset** — 32,581 loan records · 37 features

| | |
|---|---|
| Records | 32,581 personal loans |
| Features | 37 (demographic, financial, credit history) |
| Target | `loan_status` — 0: Non-default · 1: Default |
| Countries | USA · UK · Canada |
| Default Rate | 21.82% |

---

## ⚙️ How to Run

```bash
# 1. Clone repo
git clone https://github.com/your-username/Nova-Bank-Credit-Risk.git

# 2. Install dependencies
pip install pandas numpy sqlalchemy pyodbc openpyxl

# 3. Run Python pipeline
python notebook/1.py

# 4. Run SQL queries in SSMS
# Open sql/SQLQuery1.sql → Execute against NovaBank_Risk database

# 5. Open dashboard
# Open dashboard/Credit_risk.pbix in Power BI Desktop
