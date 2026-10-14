-- Mutual Fund Analytics - SQL Practice
-- Week 1 Data Analyst Deliverable

-- 1. Basic fund information
SELECT
    scheme_name,
    fund_house,
    category,
    risk_category
FROM fund_master;

-- 2. Equity funds
SELECT
    scheme_name,
    fund_house,
    risk_category
FROM fund_master
WHERE category = 'Equity';

-- 3. High and Very High risk equity funds
SELECT
    scheme_name,
    fund_house,
    risk_category
FROM fund_master
WHERE category = 'Equity'
  AND risk_category IN ('High', 'Very High');

-- 4. Funds ordered by expense ratio
SELECT
    scheme_name,
    fund_house,
    expense_ratio_pct
FROM fund_master
ORDER BY expense_ratio_pct DESC;

-- 5. Fund count by fund house
SELECT
    fund_house,
    COUNT(*) AS fund_count
FROM fund_master
GROUP BY fund_house
ORDER BY fund_count DESC;

-- 6. Expense ratio statistics by fund house
SELECT
    fund_house,
    ROUND(AVG(expense_ratio_pct), 2) AS avg_expense_ratio,
    MIN(expense_ratio_pct) AS min_expense_ratio,
    MAX(expense_ratio_pct) AS max_expense_ratio
FROM fund_master
GROUP BY fund_house
ORDER BY avg_expense_ratio DESC;

-- 7. Fund houses with more than 3 funds
SELECT
    fund_house,
    COUNT(*) AS fund_count
FROM fund_master
GROUP BY fund_house
HAVING COUNT(*) > 3
ORDER BY fund_count DESC;

-- 8. Join fund master with NAV history
SELECT
    f.amfi_code,
    f.scheme_name,
    f.fund_house,
    n.date,
    n.nav
FROM fund_master f
JOIN nav_history n
    ON f.amfi_code = n.amfi_code
LIMIT 10;

-- 9. NAV record count by fund
SELECT
    f.scheme_name,
    COUNT(n.nav) AS nav_records
FROM fund_master f
JOIN nav_history n
    ON f.amfi_code = n.amfi_code
GROUP BY f.scheme_name
ORDER BY nav_records DESC;

-- 10. Funds above average expense ratio
SELECT
    scheme_name,
    fund_house,
    expense_ratio_pct
FROM fund_master
WHERE expense_ratio_pct > (
    SELECT AVG(expense_ratio_pct)
    FROM fund_master
)
ORDER BY expense_ratio_pct DESC;

-- 11. Fund(s) with highest expense ratio
SELECT
    scheme_name,
    fund_house,
    expense_ratio_pct
FROM fund_master
WHERE expense_ratio_pct = (
    SELECT MAX(expense_ratio_pct)
    FROM fund_master
);

-- 12. Rank funds by expense ratio within each fund house
SELECT
    fund_house,
    scheme_name,
    expense_ratio_pct,
    RANK() OVER (
        PARTITION BY fund_house
        ORDER BY expense_ratio_pct DESC
    ) AS expense_rank
FROM fund_master
ORDER BY fund_house, expense_rank;

-- 13. Highest-expense fund(s) in each fund house
SELECT
    fund_house,
    scheme_name,
    expense_ratio_pct
FROM (
    SELECT
        fund_house,
        scheme_name,
        expense_ratio_pct,
        RANK() OVER (
            PARTITION BY fund_house
            ORDER BY expense_ratio_pct DESC
        ) AS expense_rank
    FROM fund_master
)
WHERE expense_rank = 1
ORDER BY expense_ratio_pct DESC;

-- 14. Fund houses with more than 3 funds and average expense ratio
SELECT
    fund_house,
    COUNT(*) AS fund_count,
    ROUND(AVG(expense_ratio_pct), 2) AS avg_expense_ratio
FROM fund_master
GROUP BY fund_house
HAVING COUNT(*) > 3
ORDER BY avg_expense_ratio DESC;
