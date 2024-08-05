/*
Question: What skills are required for the top paying data analyst jobs?
- Use top 10 paying jobs from first query
- add specific skills required for these jobs 
- helps to focus on what skill I should develop
*/

WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
    LIMIT 10
)


SELECT 
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;


--NEW QUERY--
/* top 10 paying jobs, with skills in order
per location of interest with filters for analyst roles
*/

WITH ranked_jobs AS (
    SELECT
        job_postings_fact.job_id,
        job_postings_fact.job_title_short,
        job_postings_fact.salary_year_avg,
        company_dim.name AS company_name,
        job_postings_fact.job_location,
        ROW_NUMBER() OVER (
            PARTITION BY 
                CASE
                    WHEN job_postings_fact.job_location = 'Anywhere' THEN 'Remote'
                    WHEN job_postings_fact.job_location = 'Portland, OR' THEN 'Portland, OR'
                    WHEN job_postings_fact.job_location = 'Seattle, WA' THEN 'Seattle, WA'
                    WHEN job_postings_fact.job_location = 'Boston, MA' THEN 'Boston, MA'
                    WHEN job_postings_fact.job_location = 'Austin, TX' THEN 'Austin, TX'
                    WHEN job_postings_fact.job_location = 'San Diego, CA' THEN 'San Diego, CA'
                    ELSE 'Other'
                END
            ORDER BY job_postings_fact.salary_year_avg DESC
        ) AS row_num
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        salary_year_avg IS NOT NULL
    AND
        salary_year_avg <= 100000
    AND
        (job_title_short ILIKE '%Analyst%' OR job_title_short ILIKE '%Business Analyst%')
    AND
        job_title_short NOT ILIKE '%Director%'
    AND
        job_title_short NOT ILIKE '%Senior%'
    AND
        job_title_short NOT ILIKE '%Head%'
    AND
        job_title_short NOT ILIKE '%Engineer%'
    AND
        job_title_short NOT ILIKE '%Scientist%'
    AND
        job_title_short NOT ILIKE '%Manager%'
    AND
        (job_location = 'Anywhere' OR 
         job_location IN ('Portland, OR', 'Seattle, WA', 'Boston, MA', 'Austin, TX', 'San Diego, CA'))
)

SELECT 
    ranked_jobs.job_id,
    ranked_jobs.job_title_short,
    ranked_jobs.salary_year_avg,
    ranked_jobs.company_name,
    ranked_jobs.job_location,
    skills_dim.skills,
    CASE
        WHEN ranked_jobs.job_location = 'Anywhere' THEN 'Remote'
        WHEN ranked_jobs.job_location = 'Portland, OR' THEN 'Portland, OR'
        WHEN ranked_jobs.job_location = 'Seattle, WA' THEN 'Seattle, WA'
        WHEN ranked_jobs.job_location = 'Boston, MA' THEN 'Boston, MA'
        WHEN ranked_jobs.job_location = 'Austin, TX' THEN 'Austin, TX'
        WHEN ranked_jobs.job_location = 'San Diego, CA' THEN 'San Diego, CA'
        ELSE 'Other'
    END AS location_category
FROM
    ranked_jobs
INNER JOIN
    skills_job_dim ON ranked_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    ranked_jobs.row_num <= 10
ORDER BY
    location_category,
    ranked_jobs.salary_year_avg DESC;


