--                 UNION opertors
/*
Union operator is used to combine the result-set of two or more SELECT statements into a single result-set.
UNION: remove all duplicate rows
UNION ALL: Includes all duplicate rows
- Each SELECT statement within UNION must have the same number of columns in the result sets with similar data types.
- The columns in each SELECT statement must also be in the same order.

SYNTAX:
SELECT column_name
FROM table_one

UNION -- combine the two tables 

SELECT column_name
FROM table_two;
*/

--EX UNION
--Get jobs and companies from January 
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    jan_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    feb_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    mar_jobs


--EX UNION ALL (more common as we usally wan to get al data back)
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    jan_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    feb_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    mar_jobs

