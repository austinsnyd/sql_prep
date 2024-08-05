/* 
CASE EXPRESSION: a way to apply conditional logic to a query.
Syntax:
SELECT
    CASE
        WHEN column_name = 'value1' THEN 'description for value 1'
        WHEN column_name = 'value2' THEN 'description for value 2'
        ELSE 'other'
    END AS column_description
FROM
    table_name;
*/

/* 
CASE - beginsthe expression
WHEN - specifies conditions to look at
THEN - what to do when the condition is true
ELSE - optional, provides  output if none of WHEN conditions are met
END - cocncludes case expression
*/

--EX reclassify where a jobs location is--

SELECT
    job_title_short,
    job_location
FROM
    job_postings_fact;

/* 
label columns so that
- 'Anywhere' is 'Remote'
- 'Portland, OR' is 'Local'
- Otherwise 'Onsite'
*/

SELECT
    job_title_short,
    job_location,
        CASE
            WHEN job_location = 'Anywhere' THEN 'Remote'    
            WHEN job_location = 'Portland, OR' THEN 'Local'
            ELSE 'Onsite'
        END AS location_category
FROM
    job_postings_fact;

-- look at jobs that are local and remote to see how many i can apply to--
SELECT
    COUNT(job_id) AS number_of_jobs,
        CASE
            WHEN job_location = 'Anywhere' THEN 'Remote'    
            WHEN job_location = 'Portland, OR' THEN 'Local'
            ELSE 'Onsite'
        END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    location_category;










