# ⚽ FIFA Player Performance Analysis using SQL & PostgreSQL

## 📌 Overview
This project analyzes FIFA player data to uncover insights related to player performance, market value, club investments, transfer risks, and talent identification using SQL and PostgreSQL.
The objective of this project is to simulate real-world sports analytics scenarios and demonstrate practical data analysis skills through Exploratory Data Analysis (EDA), data cleaning, and advanced SQL querying techniques.
The project concludes with a professional report and presentation created using Gamma AI to communicate findings effectively.

---

## 📊 Dataset
The dataset contains player-level information from FIFA including performance metrics, financial data, and club information.

### Dataset Features
- Player ID
- Player Name
- Age
- Nationality
- Club
- Position
- Overall Rating
- Potential Rating
- Matches Played
- Goals
- Assists
- Minutes Played
- Market Value (Million eur)
- Contract Years Left
- Injury Prone Status
- Transfer Risk Level

### Dataset Statistics

| Metric | Value |
|---------|-------|
| Total Players | 2,800 |
| Total Clubs | 7 |
| Total Nationalities | 8 |
| Total Positions | 9 |
| Average Age | 28 Years |
| Average Overall Rating | 76.87 |
| Average Market Value | €90.57 Million |

---

## 🛠 Tools & Technologies

- 🐘 **PostgreSQL** – Database management and SQL execution
- 🗄️ **SQL** – Data querying and business analysis
- 📊 **Excel** – Data export and visualization
- 📑 **Gamma AI** – Presentation creation and storytelling
- 🌐 **GitHub** – Project hosting and portfolio showcase
- 🔧 **Git** – Version control and project management

---

## 🔄 Project Workflow

### 1️⃣ Data Loading
- Imported the dataset into PostgreSQL.
- Created database tables and defined schema.

### 2️⃣ Exploratory Data Analysis (EDA)
- Explored dataset structure and distributions.
- Analyzed players across clubs, positions, and nationalities.

### 3️⃣ Data Cleaning
- Checked for missing values.
- Validated data consistency and quality.

### 4️⃣ SQL Analysis
- Solved real-world football business problems using SQL.
- Applied advanced SQL concepts to generate insights.

### 5️⃣ Reporting
- Prepared a detailed analytical report.

### 6️⃣ Presentation
- Created a professional presentation using Gamma AI.

---

## 🏗 Project Architecture

```text
Dataset CSV
    ↓
PostgreSQL Database
    ↓
Data Cleaning
    ↓
EDA
    ↓
SQL Analysis
    ↓
Business Insights
    ↓
Report Generation
    ↓
Gamma Presentation
```

---

## 🧠 SQL Concepts Used

### Basic SQL
- SELECT
- WHERE
- GROUP BY
- ORDER BY
- Aggregate Functions

### Intermediate SQL
- CASE Statements
- Subqueries
- HAVING Clause

### Advanced SQL
- Joins
- Common Table Expressions (CTEs)
- Window Functions
- Ranking Functions
- ROW_NUMBER()
- LAG()
- LEAD()

---

## 📈 Business Questions Solved

- Find clubs where total market value exceeds €30,000 million. 
- Which players are more valuable than the average player in the club? 
- Which player is the most expensive in each playing position? 
- Find the players with the largest gap between potential and overall rating? 
- Which clubs have an average market value greater than €90 million? 
- Which clubs spend more than €200 million on injury-prone players? 
- Find the second highest-rated player in each club? 
- Find players whose market value is higher than the previous player in their club? 
- Find the top scorer and second top scorer in each club? 
- 

---

## 📊 Key Results

- Juventus recorded the highest total squad market value (**€39.09B**).
- Real Madrid achieved the highest average player rating (**77.60**).
- Right Wingers had the highest average market value (**€93.50M**).
- Goalkeepers had the lowest average market value (**€86.73M**).
- Juventus had the highest number of injury-prone players (**116**).
- Young players demonstrated the largest improvement potential.

---

## 📂 Project Structure

```text
fifa-player-performance-analysis/
│
├── dataset/
│   └── fifa_player_performance_analysis.csv
│
├── sql_queries/
│   ├── data_cleaning.sql
│   ├── eda.sql
│   ├── business_questions.sql
│   └── advanced_queries.sql
│
├── docs/
│   └── FIFA_Player_Performance_Analysis_Report.pdf
│   └── FIFA_Player_Performance_Analysis_Presentation.pptx
│
└── README.md
```

---

## 🚀 How to Run

### Clone the Repository

```bash
git clone https://github.com/rahul36-glitch/fifa-player-performance-analysis.git
```

### Create Database

```sql
CREATE DATABASE fifa_player_performance_analysis;
```

### Import Dataset
Import the CSV file into PostgreSQL using pgAdmin Import/Export functionality.

### Execute SQL Scripts
Run the SQL files in the following order:

1. `data_cleaning.sql`
2. `eda.sql`
3. `business_questions.sql`
4. `advanced_queries.sql`

### Review Outputs
- SQL Query Results
- Visualizations
- Project Report
- Gamma Presentation

---

## 🎯 Skills Demonstrated
- SQL
- PostgreSQL
- Data Cleaning
- Exploratory Data Analysis (EDA)
- Window Functions
- CTEs
- Subqueries
- Business Analysis
- Data Storytelling
- Reporting
- Presentation Design

---

## 🔮 Future Improvements

- 📊 Interactive Power BI Dashboard
- 🤖 ETL Automation using Python
- 📈 Multi-Season FIFA Trend Analysis
- 🧠 Machine Learning for Market Value Prediction
- 🔍 Player Scouting Recommendation System
- ⚡ SQL Query Optimization

---

## 👨‍💻 Author

**Rahul Naik**

GitHub: https://github.com/rahul36-glitch

LinkedIn: https://www.linkedin.com/in/rahul-naik-2bb36a415

---

## ⭐ Project Objective
This project demonstrates the application of SQL and PostgreSQL in solving real-world sports analytics problems and converting raw football data into actionable business insights for recruitment, transfer planning, and squad development.
