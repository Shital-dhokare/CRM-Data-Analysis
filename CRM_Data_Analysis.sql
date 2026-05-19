CREATE DATABASE CRM_Data_Analysis;
USE CRM_Data_Analysis;

show tables;
select * from leadtable;
select * from opportunity;
select * from opportunity product;
select * from account;
select * from user;

#*****************************Lead KPI'S **********************************

# 1. Total Lead
select count('Lead ID') as total_lead from leadtable;

# 2. Converted leads
SELECT SUM(CASE WHEN Converted = 'True' THEN 1 ELSE 0 END) AS converted_leads from leadtable;

# 3. Conversion Rate
SELECT 
    COUNT(`Lead ID`) AS total_leads,
    SUM(CASE WHEN Converted = 'True' THEN 1 ELSE 0 END) AS converted_leads,
    ROUND(
        SUM(CASE WHEN Converted = 'True' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(`Lead ID`), 2
    ) AS conversion_rate
FROM leadtable;

# 4. Converted Accounts
SELECT COUNT(DISTINCT `Converted Account ID`) AS Converted_Accounts
FROM leadtable
WHERE Converted = 'True';


# 5. converted opportunity
 SELECT 
    COUNT(DISTINCT `Converted Opportunity ID`) AS converted_opportunities
FROM leadtable
WHERE Converted = 'True';



#***************************Views*************************************

# 6. leads by sources
SELECT 
    `Lead Source`,
    COUNT(`Lead ID`) AS total_leads
FROM leadtable
GROUP BY `Lead Source`
ORDER BY total_leads DESC;


# 7. leads by industry
SELECT 
    Industry,
    COUNT(`Lead ID`) AS total_leads
FROM leadtable
GROUP BY Industry
ORDER BY total_leads DESC;


# 8. Leads by stage(status)
SELECT 
    Status AS lead_stage,
    COUNT(`Lead ID`) AS total_leads
FROM leadtable
GROUP BY Status
ORDER BY total_leads DESC;


#*************************************** Opportunity Kpi******************************************


# 1. Expected amount
SELECT SUM(`Expected Amount`) AS total_expected_amount
FROM opportunity
WHERE Active_Flag = 1;   -- only open opportunities

# 2. active opportunity
SELECT 
    COUNT(*) AS active_opportunities
FROM opportunity
WHERE Stage NOT IN ('Closed Won', 'Closed Lost');



# 3.  Conversion rate
SELECT 
    (COUNT(CASE WHEN Stage = 'Closed Won' THEN 1 END) * 100.0) 
    / COUNT(*) AS conversion_rate
FROM opportunity;


# 4. Win rate
SELECT 
    (COUNT(CASE WHEN Stage = 'Closed Won' THEN 1 END) * 100.0) /
    COUNT(CASE WHEN Stage IN ('Closed Won','Closed Lost') THEN 1 END) 
    AS win_rate
FROM opportunity;


# 5. Loss rate
SELECT 
    (COUNT(CASE WHEN Stage = 'Closed Lost' THEN 1 END) * 100.0) /
    COUNT(*) AS loss_rate
FROM opportunity;


# a. Expected Vs Forecast Trend
SELECT 
    `Created Date`,
    SUM(`Expected Amount`) AS total_expected,
    SUM(Amount) AS total_forecast
FROM opportunity
GROUP BY `Created Date`
ORDER BY `Created Date`;

# b. Active Vs Total Opportunities
SELECT 
    `Created Date`,
    SUM(CASE WHEN Active_Flag = 1 THEN 1 ELSE 0 END) AS active_opps,
    COUNT(*) AS total_opps
FROM opportunity
GROUP BY `Created Date`
ORDER BY `Created Date`;

# c. Closed Won Vs Total Opportunities

SELECT
    COUNT(CASE WHEN Stage = 'Closed Won' THEN 1 END) AS closed_won_count,
    COUNT(`Opportunity ID`) AS total_opps
FROM opportunity;

# d. Closed Won vs Total Closed

SELECT 
    COUNT(CASE WHEN Stage = 'Closed Won' THEN 1 END) AS closed_won_count,
    COUNT(CASE WHEN Stage IN ('Closed Won','Closed Lost') THEN 1 END) AS total_closed
FROM opportunity;


# 7. Expected Amount by Opportunity Type
SELECT 
    `Lead Source`,
    SUM(`Expected Amount`) AS total_expected
FROM opportunity
GROUP BY `Lead Source`;


# 8.Opportunities by Industry
SELECT Industry, COUNT(*) AS opp_count
FROM opportunity
GROUP BY Industry;

