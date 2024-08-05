/* 
Question: What are the top paying data analyst jobs?
- Identify top paying remote positions for data analysts
- Flter for roles that have salaies listed
- This will shed light on the highest paying remote data analyst roles
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::DATE,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
AND
    job_location = 'Anywhere'
AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

-- altered to focus on 'Analyst' roles, exclude 'Director' and 'Senior' roles
-- and include additional filters for perferred locations
SELECT
    job_id,
    job_title_short,
    job_location,
    salary_year_avg,
    name AS company_name,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location IN ('Portland, OR', 'Seattle, WA', 'Boston, MA', 'Austin, TX', 'San Diego, CA') THEN 'Preferred City'
        ELSE 'Other'
    END AS location_category
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    (job_title_short ILIKE '%Analyst%' OR job_title_short ILIKE '%Data Analyst%' OR job_title_short ILIKE '%Business%')  -- Include analyst roles
AND
    job_title_short NOT LIKE '%Director%'  -- Exclude 'Director' roles
AND
    job_title_short NOT LIKE '%Senior%'  -- Exclude 'Senior' roles
AND
    job_title_short NOT LIKE '%Engineer%'  -- Exclude 'Engineer' roles
AND
    job_title_short NOT LIKE '%Scientist%'  -- Exclude 'Scientist' roles
AND
    salary_year_avg IS NOT NULL
AND
    (job_location = 'Anywhere'  -- Include remote jobs
    OR job_location IN ('Portland, OR', 'Seattle, WA', 'Boston, MA', 'Austin, TX', 'San Diego, CA'))  -- Include preferred cities
ORDER BY
    salary_year_avg DESC
LIMIT 200;


   