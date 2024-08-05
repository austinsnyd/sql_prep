--          Practice Problem CTEs
/* Find the count of the number of remote job postings per skill 
          -display top 5 skills by their demand in remote jobs
          -include skill ID, name, and count of postings requiring skill
*/


-- get remote job postings
-- 1. build CTE that collects number of job postings per skill
-- use innerjoins because jobs need to exist

SELECT
    skill_id,
    count(*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
WHERE
    job_postings.job_work_from_home = true
GROUP BY 
    skill_id

-- build cte
WITH remote_job_skills AS (
    SELECT
        skill_id,
        count(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
    WHERE
        job_postings.job_work_from_home = true
    AND
        Job_postings.job_title_short = 'Data Analyst'
    GROUP BY 
        skill_id
)

SELECT 
   skills.skill_id,
   skills AS skill_name,
   skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;

/* now we have temporary results in remote_job_skills
    - we can now join with skills_dim to get skill names
    - we can also rank the skills by their demand
*/


