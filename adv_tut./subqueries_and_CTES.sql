-- Subqueries and CTEs--
/*
Subqueries and Common Table Expressions (CTEs): used for organizing and simplifying complex queries.
- helps to break down complex queries into smaller, more manageable parts
- can be used to create temporary tables that can be referenced in the main query
WHEN TO USE:
Subqueries: for simpler queries that are not reused
CTEs: for more complex queries that are reused
*/

-- Subqueries: query nested within another query
-- can be used in SELECT, FROM, WHERE clauses
/*
SYNTAX:
SELECT * 
FROM (-- Subquery starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month FROM job_posted_date) = 1
   ) AS jan_jobs;
   -- Subquery ends here
*/

SELECT * 
FROM (-- Subquery starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month FROM job_posted_date) = 1
   ) AS jan_jobs;
   -- Subquery ends here

   -- Common Table Expressions (CTEs): define temporary result set that you can reference
   -- within a SELECT, INSERT, UPDATE, DELETE statement
   -- Defined using WITH clause
    /*
    SYNTAX:
    WITH jan_jobs AS ( -- CTE starts here
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(month FROM job_posted_date) = 1
    ) -- CTE ends here

SELECT *
FROM jan_jobs;
    */

WITH jan_jobs AS ( -- CTE starts here
    SELECT *
     FROM job_postings_fact
    WHERE EXTRACT(month FROM job_posted_date) = 1
) -- CTE ends here

SELECT *
FROM jan_jobs;



--                            PRACTICE
--SUBQUERIES
   -- EX use in where clause
--PROBLEM: Get a list of jobs that dont require a degree

Select
    company_id,
    job_no_degree_mention
From
    job_postings_fact
Where
    job_no_degree_mention = true
    ;

/* from job postings table we dont have company name 
we will need to use subquery to get the jobs with no degree mentioned
then filter within company_dim table to get the company name*/

SELECT  
    name AS company_name,
    company_id
FROM 
    company_dim
WHERE company_id IN ( --where in company_id is it in subquery
    Select
        company_id
    From
        job_postings_fact
    Where
        job_no_degree_mention = true
    ORDER BY company_id
);

--CTEs
--PROBLEM: Find the companies with the most job postings
-- PART 1: get total number of job postings per companu id (job_fact table)
-- PART 2:  Combine with company name within company_dim table

-- make core statment, get total count of job postings / company_id
SELECT
   company_id,
   count(*)
FROM
    job_postings_fact
GROUP BY
    company_id


--cte
WITH company_job_count AS (
    SELECT
        company_id,
        count(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

-- check work by querying TRS
/*SELECT *
FROM
    company_job_count;*/

--combine with company name using left join
-- use company_dim table as a table 
--this ensures comaonies with no job postings are still included

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
From
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC;