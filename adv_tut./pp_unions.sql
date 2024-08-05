/* Find job postings from the first quarter that have a salary greater than $70,000
    - Combine job postings from the first quarter of 2023 (Jan-Mar)
    - Get job postngs with an average yearly salary > $70,000
*/

--1. Union all tables
SELECT *
FROM
    jan_jobs
UNION ALL
SELECT *
FROM
    feb_jobs
UNION ALL
SELECT *
FROM
    mar_jobs

--2. subquery
SELECT 
    q1_postings.job_title_short,
    q1_postings.job_location,
    q1_postings.job_via,
    q1_postings.job_posted_date::DATE,
    q1_postings.salary_year_avg
FROM
    (
        SELECT *
        FROM
            jan_jobs
        UNION ALL
        SELECT *
        FROM
            feb_jobs
        UNION ALL
        SELECT *
        FROM
            mar_jobs
    ) AS Q1_postings --give alias
WHERE
    q1_postings.salary_year_avg > 70000
AND 
    q1_postings.job_title_short = 'Data Analyst'
ORDER BY
    q1_postings.salary_year_avg DESC