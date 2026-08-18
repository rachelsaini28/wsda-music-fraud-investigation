# 🎼 WSDA Music Fraud Investigation
## ℹ️ Overview
This project investigates a discrepancy in the WSDA Music's financial records that occurred between the years 2011-2012. I created SQL queries to explore the data and locate the source of the discrepancy to a specific employee and customer record.

> Note: This project was completed as part of Walter Shields' SQL Essential Training course. The project prompt, dataset, and workflow were provided by the instructor while the implementation, analysis, and evaluation were written independently by me.

### 📁 Dataset
The WSDA Music database can be downloaded from Walter Shield's LinkedIn Learning course: [SQL Essential Training](https://www.linkedin.com/learning/sql-essential-training-20685933?u=76115650). It consists of data the company stores, such as various records of invoices, customers, and employees, throughout different years. As per LinkedIn Learning's terms of use, users must download the dataset through the course.

### 🖱️Getting Started
1. Download the WSDA Music database from the [course](https://www.linkedin.com/learning/sql-essential-training-20685933?u=76115650).
2. Clone the repository.
3. Open DB Browser For SQLite.
4. Load the database and open the `wsda_music_fraud_investigation.sql` file.
5. Run the desired queries one at a time.

### 🧪 Methods Used
* Analysis begins with a high-level overview of the database
    * exploring transaction amounts and total earnings during 2011 and 2012
* Exploration narrows down to customer and employee records
    * looking into customers, their assigned support representative, and their total spent
    * delving into average transaction amounts and which customers spent above the average
    * confirm which year had the highest transaction average
* Investigate which employees made the most commissions between 2011 and 2012
* Looking into the customer who had the highest spending

### ✍️ Skills Demonstrated
* Multi-table joins (`INNER JOIN`)
* Views for reusable queries
* Subqueries and aggregate comparisons
* Aggregate functions (`COUNT`, `SUM`, `AVG`)
* Date filtering and SQL date functions
* `GROUP BY`, `WHERE`, `HAVING` for filtering data
* `DISTINCT` and `ORDER BY` for readable tables

### 💻 Technologies Used
* SQLite
* DB Browser For SQLite

### 🧑‍🔬 Results
* Identified 167 transactions and total earnings of $1947.97 between 2011 and 2012
* Calculated average transaction totals for each customer's individual purchase, total purchases, and WSDA's yearly earnings
* Discovered the highest yearly transaction total average was in 2011 at $17.51, more than 3x the averages in other years
* Compared employee commissions, identifying Jane Peacock with the highest commissions at $199.77
* Uncovered a suspicious customer with null fields and spending $1000.86, suggesting the record may be fabricated
