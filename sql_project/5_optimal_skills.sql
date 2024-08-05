/*
Answer: What are the most optimal skills to learn?
-Identify skills high in demand with high average sallaies
-concentrate on remote positons with specific salaries
*/


WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,  -- Fully qualify the column to avoid ambiguity
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), 
average_salary AS ( -- Correct alignment for multiple CTEs
    SELECT 
        skills_dim.skill_id,  -- Fully qualify the column
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN
    average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;



-- more consise--
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;



--role and location specific--

WITH ranked_skills AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary,
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
            ORDER BY AVG(job_postings_fact.salary_year_avg) DESC, COUNT(skills_job_dim.job_id) DESC
        ) AS row_num
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        (job_title_short ILIKE '%Analyst%' OR job_title_short ILIKE '%Business%')
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
        salary_year_avg IS NOT NULL
    AND
        (job_work_from_home = TRUE OR
         job_postings_fact.job_location IN ('Portland, OR', 'Seattle, WA', 'Boston, MA', 'Austin, TX', 'San Diego, CA'))
    GROUP BY
        skills_dim.skill_id, skills_dim.skills, job_postings_fact.job_location
)

SELECT 
    skill_id,
    skills,
    demand_count,
    avg_salary,
    location_category
FROM
    ranked_skills
WHERE
    row_num <= 5
ORDER BY
    location_category,
    avg_salary DESC,
    demand_count DESC;






