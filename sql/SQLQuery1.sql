-- What is the overall health and performance of the loan portfolio? 
SELECT COUNT(*) AS total_loans,
       SUM(loan_status) AS total_defaults,
       ROUND(AVG(CAST(loan_status AS FLOAT)) * 100.0, 2) AS default_rate_pct,
       ROUND(AVG(loan_amnt), 0) AS avg_loan_amount,
       ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate,
       ROUND(AVG(person_income), 0) AS avg_income,
       ROUND(AVG(loan_to_income_ratio), 3) AS avg_lti_ratio,
       ROUND(AVG(debt_to_income_ratio), 3) AS avg_dti_ratio
FROM loans;

-- Which loan grades demonstrate safer repayment trends versus higher risk profiles?
SELECT loan_grade,
       COUNT(*) AS total_loans,
       SUM(loan_status) AS defaults,
       ROUND(AVG(CAST(loan_status AS FLOAT)) * 100.0, 2) AS default_rate_pct,
       ROUND(AVG(loan_int_rate), 2) AS avg_int_rate,
       ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt
FROM loans
GROUP BY loan_grade
ORDER BY loan_grade desc 

-- Do specific loan intents (e.g., education, medical, personal) carry higher default risk?
SELECT loan_intent,
       COUNT(*) AS total_loans,
       SUM(loan_status) AS defaults,
       ROUND(AVG(CAST(loan_status AS FLOAT)) * 100.0, 2) AS default_rate_pct,
       ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt,
       ROUND(AVG(loan_int_rate), 2) AS avg_int_rate
FROM loans
GROUP BY loan_intent
ORDER BY default_rate_pct DESC;

-- Are there notable differences in default patterns among borrowers in the US, UK, and Canada?
SELECT country,
       COUNT(*) AS total_loans,
       ROUND(AVG(CAST(loan_status AS FLOAT)) * 100.0, 2) AS default_rate_pct,
       ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt,
       ROUND(AVG(loan_int_rate), 2) AS avg_int_rate,
       ROUND(AVG(person_income), 0) AS avg_income,
       ROUND(AVG(debt_to_income_ratio), 3) AS avg_dti
FROM loans
GROUP BY country
ORDER BY default_rate_pct DESC;

-- Does employment type significantly impact default risk?
SELECT employment_type,
    COUNT(*) AS total_loans,
    SUM(loan_status) AS defaults,
    ROUND(AVG(CAST(loan_status AS FLOAT)) * 100.0, 2) AS default_rate_pct,
    ROUND(AVG(person_income), 0) AS avg_income,
    ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt
FROM loans
GROUP BY employment_type
ORDER BY default_rate_pct DESC;

-- Q6 – Which specific combinations of borrower segments exhibit the highest probability of default?
SELECT TOP 20
    loan_grade,
    loan_intent,
    employment_type,
    COUNT(*) AS borrowers,
    ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,
    ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt,
    ROUND(AVG(loan_int_rate), 2) AS avg_int_rate,
    ROUND(AVG(debt_to_income_ratio), 3) AS avg_dti
FROM loans
GROUP BY loan_grade, loan_intent, employment_type
HAVING COUNT(*) >= 50 AND AVG(CAST(loan_status AS FLOAT)) > 0.35
ORDER BY default_rate_pct DESC;

-- How do Loan-to-Income (LTI) and Debt-to-Income (DTI) risk bands correlate with loan repayment outcomes?
SELECT top 20
    lti_tier,
    dti_tier,
    COUNT(*) AS loans,
    SUM(loan_status) AS total_defaults,
    ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,
    ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt
FROM loans
GROUP BY lti_tier, dti_tier
HAVING COUNT(*) >= 100
ORDER BY default_rate_pct DESC

-- How do past delinquency records affect current loan outcomes?
SELECT
    past_delinquencies,
    COUNT(*) AS borrowers,
    SUM(loan_status) AS total_defaults,
    ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,
    ROUND(AVG(credit_utilization_ratio)*100, 1) AS avg_credit_utilization_pct
FROM loans
GROUP BY past_delinquencies
ORDER BY past_delinquencies;

-- What is the impact of a prior default on file on future credit performance?
SELECT
    cb_person_default_on_file AS prior_default_on_file,
    COUNT(*) AS borrowers,
    ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,
    ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt,
    ROUND(AVG(loan_int_rate), 2) AS avg_int_rate
FROM loans
GROUP BY cb_person_default_on_file;

-- Does a longer loan term correlate with an increased default rate?
SELECT loan_term_months,
       COUNT(*) AS loans,
       ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,
       ROUND(AVG(loan_int_rate), 2) AS avg_int_rate,
       ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt
FROM loans
GROUP BY loan_term_months
ORDER BY loan_term_months;

-- How is total exposure distributed across identified risk tiers?
SELECT risk_tier,
    COUNT(*) AS borrowers,
    ROUND(COUNT(*)*100.0 / SUM(COUNT(*)) OVER(), 1) AS share_pct,
    ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,
    ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt,
    ROUND(SUM(loan_amnt), 0) AS total_exposure,
    ROUND(AVG(loan_int_rate), 2) AS avg_int_rate
FROM loans
GROUP BY risk_tier
ORDER BY default_rate_pct DESC;

-- Can we identify early warning signals by combining high DTI, past delinquencies, and low credit grades?

SELECT
    COUNT(*) AS flagged_borrowers,
    ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,
    ROUND(SUM(loan_amnt), 0) AS total_exposure,
    ROUND(AVG(loan_int_rate), 2) AS avg_int_rate
FROM loans
WHERE
    debt_to_income_ratio > 0.5
    AND past_delinquencies >= 2
    AND cb_person_default_on_file = 'Y'
    AND loan_grade IN ('D','E','F','G');

-- Is there a correlation between education level, average income, and default rates?
SELECT
    education_level,
    COUNT(*) AS borrowers,
    ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,

    ROUND(AVG(person_income), 0)  AS avg_income,
    ROUND(AVG(loan_amnt), 0)  AS avg_loan_amnt
FROM loans
GROUP BY education_level
ORDER BY default_rate_pct DESC;

-- How does housing status (Rent vs. Own vs. Mortgage) influence borrower reliability?
SELECT
    person_home_ownership,
    COUNT(*) AS borrowers,
    ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,
    ROUND(AVG(person_income), 0) AS avg_income,
    ROUND(AVG(loan_amnt), 0) AS avg_loan_amnt
FROM loans
GROUP BY person_home_ownership
ORDER BY default_rate_pct DESC;

-- Do gender and marital status reveal hidden patterns in credit repayment behavior?
SELECT
    gender,
    marital_status,
    COUNT(*) AS borrowers,
    ROUND(AVG(CAST(loan_status AS FLOAT))*100.0, 2) AS default_rate_pct,
    ROUND(AVG(loan_amnt), 0)              AS avg_loan_amnt
FROM loans
GROUP BY gender, marital_status
ORDER BY gender, default_rate_pct DESC;
