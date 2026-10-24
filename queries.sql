-- =========================================
-- 1. Identify which companies are most actively hiring
-- Business insight: Helps HR/recruiters see which companies are hiring the most jobs
SELECT 
    c.name AS company_name,
    COUNT(j.job_id) AS total_jobs
FROM jobs j
INNER JOIN companies c ON j.company_id = c.company_id
GROUP BY c.name
ORDER BY total_jobs DESC
LIMIT 10;


-- =========================================
-- 2. Compare median salaries across different work types (FULL_TIME, PART_TIME)
-- Business insight: Shows which work types offer higher pay
SELECT
    COALESCE(j.work_type, 'Unknown') AS work_type,
    AVG(j.med_salary) AS avg_salary
FROM jobs j
GROUP BY j.work_type
ORDER BY avg_salary DESC;


-- =========================================
-- 3. Identify high-paying jobs in the US for premium candidates
-- Business insight: Targets top-paying opportunities for candidate outreach
SELECT 
    j.title,
    c.name AS company_name,
    j.med_salary,
    j.location
FROM jobs j
INNER JOIN companies c ON j.company_id = c.company_id
WHERE j.med_salary > 100000
  AND c.country = 'US'
ORDER BY j.med_salary DESC;


-- =========================================
-- 4. Find the most popular job postings (high candidate interest)
-- Business insight: Identifies jobs attracting the most applications
SELECT
    j.title,
    c.name AS company_name,
    COALESCE(j.applies, 0) AS applications
FROM jobs j
LEFT JOIN companies c ON j.company_id = c.company_id
ORDER BY applications DESC
LIMIT 5;


-- =========================================
-- 5. Compare median salaries by state
-- Business insight: Helps guide strategic recruitment based on salary ranges
SELECT
    c.state,
    COUNT(j.job_id) AS total_jobs,
    MIN(j.min_salary) AS min_salary,
    MAX(j.max_salary) AS max_salary
FROM jobs j
INNER JOIN companies c ON j.company_id = c.company_id
GROUP BY c.state
HAVING COUNT(j.job_id) > 10
ORDER BY max_salary;


-- =========================================
-- 6. Top-paying jobs per company
-- Business insight: Highlights highest-paying roles for each company
SELECT
    j.title,
    c.name AS company_name,
    j.med_salary,
    RANK() OVER(PARTITION BY j.company_id ORDER BY j.med_salary DESC) AS salary_rank
FROM jobs j
INNER JOIN companies c ON j.company_id = c.company_id
WHERE j.med_salary IS NOT NULL
ORDER BY salary_rank, company_name
LIMIT 20;


-- =========================================
-- 7. Analyze where each company is hiring the most
-- Business insight: Reveals geographic concentration of hiring per company
WITH company_location AS (
    SELECT
        c.name AS company_name,
        j.location,
        COUNT(j.job_id) AS total_jobs
    FROM jobs j
    INNER JOIN companies c ON j.company_id = c.company_id
    GROUP BY c.name, j.location
)
SELECT *
FROM company_location
WHERE total_jobs > 5
ORDER BY total_jobs DESC;


-- =========================================
-- 8. Companies receiving the most candidate interest
-- Business insight: Shows which companies attract the most applications per job
SELECT
    c.name AS company_name,
    AVG(COALESCE(j.applies, 0)) AS avg_applications
FROM jobs j
INNER JOIN companies c ON j.company_id = c.company_id
GROUP BY c.name
ORDER BY avg_applications DESC
LIMIT 10;


-- =========================================
-- 9. Discover trending roles across all companies
-- Business insight: Identifies most frequently posted job titles
SELECT
    j.title,
    COUNT(j.job_id) AS count_jobs
FROM jobs j
GROUP BY j.title
ORDER BY count_jobs DESC
LIMIT 10;


-- =========================================
-- 10. Identify jobs with largest pay differences
-- Business insight: Highlights roles with wide salary ranges
SELECT
    j.title,
    c.name AS company_name,
    j.max_salary,
    j.min_salary,
    (j.max_salary - j.min_salary) AS salary_range
FROM jobs j
INNER JOIN companies c ON j.company_id = c.company_id
WHERE j.max_salary IS NOT NULL AND j.min_salary IS NOT NULL
ORDER BY salary_range DESC
LIMIT 10;


-- =========================================
-- 11. Analyze distribution of remote vs onsite jobs
-- Business insight: Understand work mode trends in the market
SELECT
    CASE 
        WHEN j.remote_allowed THEN 'Remote'
        ELSE 'Onsite'
    END AS work_mode,
    COUNT(j.job_id) AS total_jobs
FROM jobs j
GROUP BY work_mode;


-- =========================================
-- 12a. Salary distribution by type of work (percentiles)
-- Business insight: Shows salary ranking per job type
SELECT
    title,
    work_type,
    med_salary,
    PERCENT_RANK() OVER(PARTITION BY work_type ORDER BY med_salary) AS salary_percentile
FROM jobs
WHERE med_salary IS NOT NULL
ORDER BY work_type, salary_percentile DESC;


-- =========================================
-- 12b. Daily posting trends for April 2024
-- Business insight: Tracks hiring activity over time
SELECT
    DATE_TRUNC('day', j.listed_at) AS day,
    COUNT(*) AS jobs_posted
FROM jobs j
WHERE j.listed_at >= '2024-04-01'
  AND j.listed_at < '2024-05-01'
GROUP BY day
ORDER BY day;


-- =========================================
-- 13. Companies with most postings on 2024-04-15
-- Business insight: Highlights peak recruiting activity on a specific date
SELECT
    c.name AS company_name,
    COUNT(j.job_id) AS jobs_posted
FROM jobs j
INNER JOIN companies c ON j.company_id = c.company_id
WHERE j.listed_at >= '2024-04-15 00:00:00'
  AND j.listed_at < '2024-04-16 00:00:00'
GROUP BY c.name
ORDER BY jobs_posted DESC
LIMIT 5;


-- =========================================
-- 14. Average median salary for jobs posted during the first week of April 2024
-- Business insight: Gives insight into pay levels for early April hiring
SELECT
    AVG(j.med_salary) AS avg_median_salary
FROM jobs j
WHERE j.listed_at >= '2024-04-01'
  AND j.listed_at < '2024-04-08';


-- =========================================
-- 15. EXPLAIN ANALYZE examples for performance insights
EXPLAIN ANALYZE
SELECT
    c.name AS company_name,
    COUNT(j.job_id) AS jobs_posted
FROM jobs j
INNER JOIN companies c ON j.company_id = c.company_id
WHERE j.listed_at >= '2024-04-15 00:00:00'
  AND j.listed_at < '2024-04-16 00:00:00'
GROUP BY c.name
ORDER BY jobs_posted DESC
LIMIT 5;





