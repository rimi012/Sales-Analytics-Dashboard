-- ============================================================
-- SALES ANALYTICS PROJECT
-- SQL Analysis using MySQL
-- ============================================================

-- Create / select database
CREATE DATABASE IF NOT EXISTS sales_analytics;
USE sales_analytics;


-- ============================================================
-- 1. OVERALL REVENUE PERFORMANCE
-- ============================================================

SELECT
    SUM(AnnualTargetQAR) AS Total_Target,
    SUM(AchievementTillDate) AS Total_Achievement,
    SUM(AnnualTargetDeltaQAR) AS Total_Delta,
    ROUND(
        SUM(AchievementTillDate) /
        NULLIF(SUM(AnnualTargetQAR), 0) * 100,
        2
    ) AS Achievement_Percentage
FROM SalesOverview1;


-- ============================================================
-- 2. ACCOUNT MANAGER PERFORMANCE
-- ============================================================

SELECT
    AccountManager,
    SUM(AnnualTargetQAR) AS Revenue_Target,
    SUM(AchievementTillDate) AS Revenue_Achieved,
    SUM(AnnualTargetDeltaQAR) AS Delta,
    ROUND(
        SUM(AchievementTillDate) /
        NULLIF(SUM(AnnualTargetQAR), 0) * 100,
        2
    ) AS Achievement_Percentage
FROM SalesOverview1
GROUP BY AccountManager
ORDER BY Revenue_Achieved DESC;


-- ============================================================
-- 3. ACCOUNT MANAGER PERFORMANCE RANKING
-- ============================================================

SELECT
    AccountManager,
    SUM(AchievementTillDate) AS Total_Achievement,
    RANK() OVER (
        ORDER BY SUM(AchievementTillDate) DESC
    ) AS Performance_Rank
FROM SalesOverview1
GROUP BY AccountManager
ORDER BY Performance_Rank;


-- ============================================================
-- 4. TOP 5 ACCOUNT MANAGERS
-- ============================================================

SELECT
    AccountManager,
    SUM(AchievementTillDate) AS Total_Achievement
FROM SalesOverview1
GROUP BY AccountManager
ORDER BY Total_Achievement DESC
LIMIT 5;


-- ============================================================
-- 5. ACCOUNT MANAGERS EXCEEDING THEIR TARGET
-- ============================================================

SELECT
    AccountManager,
    SUM(AnnualTargetQAR) AS Target,
    SUM(AchievementTillDate) AS Achievement,
    SUM(AnnualTargetDeltaQAR) AS Delta
FROM SalesOverview1
GROUP BY AccountManager
HAVING SUM(AnnualTargetDeltaQAR) > 0
ORDER BY Delta DESC;


-- ============================================================
-- 6. YEAR-WISE REVENUE PERFORMANCE
-- ============================================================

SELECT
    Year,
    SUM(AnnualTargetQAR) AS Revenue_Target,
    SUM(AchievementTillDate) AS Revenue_Achieved,
    SUM(AnnualTargetDeltaQAR) AS Delta,
    ROUND(
        SUM(AchievementTillDate) /
        NULLIF(SUM(AnnualTargetQAR), 0) * 100,
        2
    ) AS Achievement_Percentage
FROM SalesOverview1
GROUP BY Year
ORDER BY Year;


-- ============================================================
-- 7. YEAR-WISE GROSS MARGIN PERFORMANCE
-- ============================================================

SELECT
    Year,
    SUM(GrossMarginAnnualTarget) AS Gross_Margin_Target,
    SUM(GMAchievementTillDate) AS Gross_Margin_Achieved,
    ROUND(
        SUM(GMAchievementTillDate) /
        NULLIF(SUM(GrossMarginAnnualTarget), 0) * 100,
        2
    ) AS Gross_Margin_Achievement_Percentage
FROM SalesOverview1
GROUP BY Year
ORDER BY Year;


-- ============================================================
-- 8. MONTHLY CLOSED DEALS
-- ============================================================

SELECT
    MonthNo,
    Month,
    SUM(ClosedDeals) AS Total_Closed_Deals
FROM SalesOverview
GROUP BY MonthNo, Month
ORDER BY MonthNo;


-- ============================================================
-- 9. MONTHLY EXPECTED vs COMMITTED vs CLOSED SALES
-- ============================================================

SELECT
    MonthNo,
    Month,
    SUM(ExpectedClosing) AS Expected_Closing,
    SUM(CommittedValue) AS Committed_Value,
    SUM(ClosedDeals) AS Closed_Deals,
    SUM(Delta) AS Total_Delta
FROM SalesOverview
GROUP BY MonthNo, Month
ORDER BY MonthNo;


-- ============================================================
-- 10. MONTHLY SALESPERSON PERFORMANCE
-- ============================================================

SELECT
    SalesOver,
    Month,
    SUM(ExpectedClosing) AS Expected_Closing,
    SUM(CommittedValue) AS Committed_Value,
    SUM(ClosedDeals) AS Closed_Deals,
    SUM(Delta) AS Delta
FROM SalesOverview
GROUP BY SalesOver, MonthNo, Month
ORDER BY MonthNo, Closed_Deals DESC;


-- ============================================================
-- 11. ACCOUNT MANAGER PERFORMANCE CATEGORIZATION
-- ============================================================

SELECT
    AccountManager,

    ROUND(
        SUM(AchievementTillDate) /
        NULLIF(SUM(AnnualTargetQAR), 0) * 100,
        2
    ) AS Achievement_Percentage,

    CASE
        WHEN SUM(AchievementTillDate) /
             NULLIF(SUM(AnnualTargetQAR), 0) * 100 >= 100
            THEN 'Target Achieved'

        WHEN SUM(AchievementTillDate) /
             NULLIF(SUM(AnnualTargetQAR), 0) * 100 >= 75
            THEN 'Near Target'

        ELSE 'Below Target'
    END AS Performance_Category

FROM SalesOverview1
GROUP BY AccountManager
ORDER BY Achievement_Percentage DESC;


-- ============================================================
-- 12. QUARTERLY PERFORMANCE
-- ============================================================

SELECT
    'Q1' AS Quarter,
    SUM(Q1TargetSplitQAR) AS Target,
    SUM(Q1Achieved) AS Achieved,
    SUM(Q1TargetSplitDeltaQAR) AS Delta
FROM SalesOverview1

UNION ALL

SELECT
    'Q2',
    SUM(Q2TargetSplitQAR),
    SUM(Q2Achieved),
    SUM(Q2TargetSplitDeltaQAR)
FROM SalesOverview1

UNION ALL

SELECT
    'Q3',
    SUM(Q3TargetSplitQAR),
    SUM(Q3Achieved),
    SUM(Q3TargetSplitDeltaQAR)
FROM SalesOverview1

UNION ALL

SELECT
    'Q4',
    SUM(Q4TargetSplitQAR),
    SUM(Q4Achieved),
    SUM(Q4TargetSplitDeltaQAR)
FROM SalesOverview1;


-- ============================================================
-- 13. BEST PERFORMING YEAR
-- ============================================================

SELECT
    Year,
    SUM(AchievementTillDate) AS Total_Achievement
FROM SalesOverview1
GROUP BY Year
ORDER BY Total_Achievement DESC
LIMIT 1;


-- ============================================================
-- 14. BEST PERFORMING ACCOUNT MANAGER
-- ============================================================

SELECT
    AccountManager,
    SUM(AchievementTillDate) AS Total_Achievement
FROM SalesOverview1
GROUP BY AccountManager
ORDER BY Total_Achievement DESC
LIMIT 1;


-- ============================================================
-- 15. TARGET GAP ANALYSIS
-- ============================================================

SELECT
    AccountManager,
    Year,
    SUM(AnnualTargetQAR) AS Target,
    SUM(AchievementTillDate) AS Achievement,
    SUM(AnnualTargetDeltaQAR) AS Target_Gap
FROM SalesOverview1
GROUP BY AccountManager, Year
ORDER BY Target_Gap DESC;