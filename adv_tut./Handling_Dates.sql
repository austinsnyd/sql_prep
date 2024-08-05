SELECT job_posted_date
FROM job_postings_fact
LIMIT 10

-- Use :: to cast--
--casting: convert to data type--

/*SELECT
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'TRUE'::BOOLEAN,
    '3.11'::REAL;*/
--make some aliases--
--no need for timestamp just date from posting date column--
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM
    job_postings_fact;

--AT TIME ZONE converts to a different time zone--
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date_time
FROM
    job_postings_fact
LIMIT 5;

/* If no time xone is present we must set 
initial time xone before we can alter it*/

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'PST'
FROM
    job_postings_fact
LIMIT 5;

--google psotgres documentation for all time zones--

--EXTRACT function--
--extracts parts of a date or time--
--make new column for month--

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'PST' AS date_time,
    EXTRACT(month FROM job_posted_date) AS date_month
FROM
    job_postings_fact
LIMIT 5;

--useful for trend analysis, ie how jobs trend montrh to month--
--ex--

SELECT
    job_id,
    Extract(month FROM job_posted_date) AS month
FROM
    job_postings_fact
LIMIT 5;

--now aggregate, count of job ID by month--

SELECT
    COUNT(job_id) AS job_posted_count,
    Extract(month FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    month
ORDER BY
    job_posted_count DESC;
