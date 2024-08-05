-- Make a table--
CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

SELECT * FROM job_applied;
-- Insert data into the table --
INSERT INTO job_applied (job_id, application_sent_date, custom_resume, resume_file_name, cover_letter_sent, cover_letter_file_name, status)
VALUES
(1, '2024-07-01', TRUE, 'resume_1.pdf', TRUE, 'cover_letter_1.pdf', 'Interview Scheduled'),
(2, '2024-07-05', FALSE, NULL, TRUE, 'cover_letter_2.pdf', 'Application Sent'),
(3, '2024-07-10', TRUE, 'resume_3.docx', FALSE, NULL, 'Offer Received'),
(4, '2024-07-12', FALSE, NULL, TRUE, 'cover_letter_4.pdf', 'Application Sent'),
(5, '2024-07-15', TRUE, 'resume_5.pdf', FALSE, NULL, 'Rejected');

SELECT * FROM job_applied;

-- Add a new column to the table --
ALTER TABLE job_applied
ADD contact VARCHAR(50);

-- Add data to the new column --
/*UPDATE job_applied
SET contact = 'Rick James'
WHERE job_id = 1; */

-- use CASE statement to update multiple rows --

UPDATE job_applied
SET contact = CASE
    WHEN job_id = 1 THEN 'Rick James'
    WHEN job_id = 2 THEN 'John Doe'
    WHEN job_id = 3 THEN 'Jane Smith'
    WHEN job_id = 4 THEN 'Emily Brown'
    WHEN job_id = 5 THEN 'Michael Johnson'
END;

SELECT * FROM job_applied;

-- Rename a column --
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

-- Change datatype of column  --
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

-- Drop a column --
ALTER TABLE job_applied
DROP COLUMN contact_name;

-- Drop the table --
DROP TABLE job_applied;