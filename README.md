# LinkedIn Job Postings Analytics (PostgreSQL Project)

## 📌 Project Overview
This project focuses on designing, populating, and analyzing a PostgreSQL database built from LinkedIn job postings data.  
The goal is to demonstrate practical database engineering and SQL analytics skills, including schema design, data ingestion, partitioning, and advanced querying.

The dataset contains real-world job posting information such as job titles, companies, salaries, locations, experience levels, and posting dates.  
Using this data, we answer business-oriented questions related to hiring trends, company activity, salary distributions, and market demand.

---

## 🛠 Technologies Used
- **PostgreSQL** (partitioned tables, constraints, indexing)
- **Python** (Pandas, psycopg2)
- **SQL** (advanced queries, window functions, CTEs)
- **pgAdmin / psql**

---

## 🗂 Database Schema
Main tables:
- `companies` — company metadata
- `jobs` — job postings (partitioned by `listed_at`)
- Additional lookup columns for salary, location, experience, and job attributes

Key features:
- **Range partitioning** on `jobs.listed_at`
- **Primary & foreign keys**
- **Data type validation**
- **ON CONFLICT handling**

---

##  Data Ingestion
- CSV files are loaded using **Python + psycopg2**
- Robust error handling for:
  - Foreign key violations
  - Numeric overflow
  - Missing or invalid timestamps
- Incremental commits for stability and recoverability

---

## SQL Analysis
The project includes 10+ analytical queries demonstrating:
- JOINs (INNER, LEFT)
- Aggregations (`COUNT`, `AVG`, `MIN`, `MAX`)
- Filtering (`WHERE`, `HAVING`, `BETWEEN`, `ILIKE`)
- Window functions (`ROW_NUMBER`, `RANK`, `LAG`)
- CTEs and subqueries
- Date/time analysis
- Partition-pruned queries
- Performance analysis using `EXPLAIN ANALYZE`

---

## Business Insights
Examples of questions answered:
- Which companies post the most jobs?
- How do salaries vary by experience level?
- What are hiring trends over time?
- Which roles are most frequently posted?
- How does remote work affect salary?

---

## How to Run
1. Create the PostgreSQL database and tables
2. Insert data using the provided Python scripts
3. Run analytical SQL queries
4. Use `EXPLAIN ANALYZE` to inspect performance

---

## Conclusion
This project demonstrates end-to-end database development, from schema design and data ingestion to advanced analytics and performance optimization using PostgreSQL.

---

## Data note
`data/postings.csv` (~490 MB) exceeds GitHub's file size limit and is not included. The dataset is the public LinkedIn Job Postings dataset on Kaggle; place `postings.csv` in `data/` before running the ingestion notebook.
