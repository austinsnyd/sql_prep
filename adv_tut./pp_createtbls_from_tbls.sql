/* 
-Create 3 Tables
 1. Jan 2023 jobs
 2. Feb 2023 jobs
 3. Mar 2023 jobs
- use CREATE TABLE table_name AS 
-filter out specific months uing EXTRACT
*/

--get info--
SELECT *
FROM job_postings_fact
LIMIT 10;

-- Filter for Jan--
SELECT *
FROM job_postings_fact
WHERE EXTRACT(month FROM job_posted_date) = 1
LIMIT 10;

--Make tables for months--
CREATE TABLE jan_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month FROM job_posted_date) = 1;

CREATE TABLE feb_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month FROM job_posted_date) = 2;

CREATE TABLE mar_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month FROM job_posted_date) = 3;

--check work--
SELECT job_posted_date
FROM mar_jobs