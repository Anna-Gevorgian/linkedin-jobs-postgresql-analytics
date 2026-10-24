-- ===============================
-- DROP PARTITIONS AND FACT TABLE
-- ===============================
DROP TABLE IF EXISTS jobs_2024_03_04_15;
DROP TABLE IF EXISTS jobs_2024_04_15_04_30;
DROP TABLE IF EXISTS jobs;

-- ===============================
-- DROP BRIDGE TABLES
-- ===============================
DROP TABLE IF EXISTS job_skills;
DROP TABLE IF EXISTS job_industries;

-- ===============================
-- DROP DIMENSION TABLES
-- ===============================
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS industries;

-- ===============================
-- DIMENSION TABLES
-- ===============================
CREATE TABLE companies (
    company_id BIGINT PRIMARY KEY,
    name TEXT,
    description TEXT,
	state TEXT,
    country TEXT,
    city TEXT,
    zip_code TEXT,
    address TEXT,
    url TEXT
);

CREATE TABLE skills (
    skill_abr TEXT PRIMARY KEY,
    skill_name TEXT
);

CREATE TABLE industries (
    industry_id BIGINT PRIMARY KEY,
    industry_name TEXT
);

-- ===============================
-- FACT TABLE (PARTITIONED)
-- ===============================
CREATE TABLE jobs (
    job_id BIGINT NOT NULL,
    company_id BIGINT REFERENCES companies(company_id),
    company_name TEXT,
    title TEXT,
    description TEXT,
    max_salary NUMERIC,
    med_salary NUMERIC,
    min_salary NUMERIC,
    pay_period TEXT,
    formatted_work_type TEXT,
    location TEXT,
    applies INT,
    original_listed_time BIGINT,
    remote_allowed BOOLEAN,
    job_posting_url TEXT,
    application_url TEXT,
    application_type TEXT,
    expiry BIGINT,
    closed_time BIGINT,
    formatted_experience_level TEXT,
    skills_desc TEXT,
    listed_at TIMESTAMP NOT NULL,
    posting_domain TEXT,
    sponsored INT,
    work_type TEXT,
    currency TEXT,
    compensation_type TEXT,
    normalized_salary NUMERIC,
    zip_code TEXT,
    fips TEXT,
    PRIMARY KEY (job_id, listed_at)
) PARTITION BY RANGE (listed_at);

-- ===============================
-- PARTITIONS
-- ===============================
CREATE TABLE jobs_2024_03_04_15 PARTITION OF jobs
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-15');

CREATE TABLE jobs_2024_04_15_04_30 PARTITION OF jobs
    FOR VALUES FROM ('2024-04-15') TO ('2024-04-30');

-- ===============================
-- BRIDGE TABLES (NO FK TO JOBS)
-- ===============================
CREATE TABLE job_skills (
    job_id BIGINT NOT NULL,
    skill_abr TEXT NOT NULL REFERENCES skills(skill_abr),
    PRIMARY KEY (job_id, skill_abr)
);

CREATE TABLE job_industries (
    job_id BIGINT NOT NULL,
    industry_id BIGINT NOT NULL REFERENCES industries(industry_id),
    PRIMARY KEY (job_id, industry_id)
);




















