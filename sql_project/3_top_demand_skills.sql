/* 
Question: What are the top skills in demand for data analyst jobs?
-Join job posting to inner join table
-Idetify top skills in demand for data analyst jobs
-Focus on all job postings 
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5






WITH ranked_skills AS (
    SELECT 
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count,
        CASE
            WHEN job_postings_fact.job_location = 'Anywhere' THEN 'Remote'
            WHEN job_postings_fact.job_location = 'Portland, OR' THEN 'Portland, OR'
            WHEN job_postings_fact.job_location = 'Seattle, WA' THEN 'Seattle, WA'
            WHEN job_postings_fact.job_location = 'Boston, MA' THEN 'Boston, MA'
            WHEN job_postings_fact.job_location = 'Austin, TX' THEN 'Austin, TX'
            WHEN job_postings_fact.job_location = 'San Diego, CA' THEN 'San Diego, CA'
            ELSE 'Other'
        END AS location_category,
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
            ORDER BY COUNT(skills_job_dim.job_id) DESC
        ) AS row_num
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        (job_title_short ILIKE '%Analyst%' OR job_title_short ILIKE '%Business Analyst%')  -- Focus on specific analyst roles
    AND
        job_title_short NOT ILIKE '%Director%'  -- Exclude 'Director' roles
    AND
        job_title_short NOT ILIKE '%Senior%'  -- Exclude 'Senior' roles
    AND
        job_title_short NOT ILIKE '%Head%'  -- Exclude 'Head' roles
    AND
        job_title_short NOT ILIKE '%Engineer%'  -- Exclude 'Engineer' roles
    AND
        job_title_short NOT ILIKE '%Scientist%'  -- Exclude 'Scientist' roles
    AND
        job_title_short NOT ILIKE '%Manager%'  -- Exclude 'Manager' roles
    AND
        (job_location = 'Anywhere' OR 
         job_location IN ('Portland, OR', 'Seattle, WA', 'Boston, MA', 'Austin, TX', 'San Diego, CA'))  -- Include remote and specified cities
    GROUP BY
        skills_dim.skills, job_postings_fact.job_location
)

SELECT 
    skills,
    demand_count,
    location_category
FROM
    ranked_skills
WHERE
    row_num <= 10
ORDER BY
    location_category,
    demand_count DESC;
