# 📊 End-to-End Data Analysis Project
## SQL Server | Power BI | DAX

![SQL](https://img.shields.io/badge/Tool-SQL%20Server-blue)
![PowerBI](https://img.shields.io/badge/Visualization-Power%20BI-yellow)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)


## 👩‍💻 About This Project

This project demonstrates a complete end-to-end data 
analysis workflow applied to two real-world datasets. 
Starting from raw, uncleaned data, the project covers 
every stage of the data analysis pipeline — from 
understanding and profiling the data, identifying and 
resolving quality issues, performing exploratory data 
analysis using SQL, and finally building interactive 
dashboards in Power BI to communicate insights to 
stakeholders.

The project was completed entirely using:
- **SQL Server Management Studio (SSMS)**
  for all data understanding, cleaning, and EDA
- **Power BI Desktop** with DAX and Power Query
  for all visualizations and dashboards

This demonstrates that a full professional-grade 
analysis can be performed using only SQL and Power BI 
— tools widely used in business and data analytics 
roles across industries.



## 🗂️ Dataset 1 — OnlineRetail

### Overview
| Property       | Detail                        |
|----------------|-------------------------------|
| Source         | Kaggle.com|
| Period         | December 2010 – December 2011 |
| Raw Rows       | 541,909                       |
| Clean Rows     | 530,099                       |
| Columns        | 8                             |
| Tool           | SSMS (T-SQL)                  |
| Grain          | 1 row = 1 product per invoice |

### Columns
| Column      | Type    | Description              |
|-------------|---------|--------------------------|
| InvoiceNo   | VARCHAR | Transaction identifier   |
| StockCode   | VARCHAR | Product identifier       |
| Description | VARCHAR | Product name             |
| Quantity    | INT     | Units purchased          |
| InvoiceDate | DATE    | Date of transaction      |
| UnitPrice   | DECIMAL | Price per unit (£)       |
| CustomerID  | VARCHAR | Customer identifier      |
| Country     | VARCHAR | Customer country         |

### Data Cleaning Steps
- ✅ No formal primary key — identified composite key
  (InvoiceNo + StockCode)
- ✅ 135,080 NULL CustomerIDs filled with 'Guest'
- ✅ 9,288 cancelled transactions removed (C prefix)
- ✅ 3 bad debt adjustments removed (A prefix)
- ✅ 10,624 negative quantity rows removed
- ✅ 2 NULL UnitPrice rows removed
- ✅ InvoiceDate standardised to YYYY-MM-DD
- ✅ UnitPrice rounded to 2 decimal places
- ✅ Raw table never modified — cleaned via SQL View

### Key EDA Findings
- 💰 Total Revenue: **£10.66M**
- 📦 Top Product: **REGENCY CAKESTAND 3 TIER** (£174K)
- 🌍 Top Country: **United Kingdom** (£9M — 84%)
- 📅 Peak Month: **November** (£1.51M)
- 👥 Top Customer: **ID 14646** (£280,206)
- 🛒 Most Ordered: **WHITE HANGING HEART T-LIGHT HOLDER**
  (2,256 invoices)

---

### 📈 Power BI Dashboard

**Dashboard Pages:**
- Overview — KPIs, revenue trend, top products
- Products — Most purchased, top sellers
- Customers — Segments, top buyers, behaviour
- Countries — Revenue by market

**DAX Measures Created:**
- Total Revenue, Total Orders, Total Customers
- Average Order Value, Total Units Sold
- Revenue % by Country, MoM Revenue Change
- Customer Segment classification
- Guest vs Registered Orders split


### Dashboard Preview
> OnlineRetail Power BI Dashboard

<img width="983" height="560" alt="Screenshot 2026-06-12 152307" src="https://github.com/user-attachments/assets/7a572228-ec28-42d1-92db-6c4dfae67257" />


---

## 🎬 Dataset 2 — Netflix Titles

### Overview
| Property       | Detail                        |
|----------------|-------------------------------|
| Source         | Kaggle — Netflix Movies & Shows|
| Period         | 2008 – 2021                   |
| Raw Rows       | 8,807                         |
| Clean Rows     | 8,807                         |
| Columns        | 12                            |
| Tool           | SSMS (T-SQL)                  |
| Grain          | 1 row = 1 Netflix title       |

### Columns
| Column       | Type    | Description               |
|--------------|---------|---------------------------|
| show_id      | VARCHAR | Unique content identifier |
| type         | VARCHAR | Movie or TV Show          |
| title        | VARCHAR | Title of content          |
| director     | VARCHAR | Director name             |
| cast         | VARCHAR | Cast members              |
| country      | VARCHAR | Country of production     |
| date_added   | DATE    | Date added to Netflix     |
| release_year | INT     | Year of original release  |
| rating       | VARCHAR | Content rating            |
| duration     | VARCHAR | Length — mins or seasons  |
| listed_in    | VARCHAR | Genre categories          |
| description  | VARCHAR | Content synopsis          |

### Data Cleaning Steps
- ✅ show_id confirmed as unique primary key
- ✅ 2,634 NULL directors filled with 'Not Listed'
  (91.41% from TV Shows — expected behaviour)
- ✅ 831 NULL countries filled with 'Unknown'
- ✅ 825 NULL cast values filled with 'Not Listed'
- ✅ 98 NULL date_added filled with 'Unknown'
- ✅ 4 NULL ratings filled with 'Not Rated'
- ✅ 3 NULL durations filled with 'Not Available'
- ✅ No rows removed — all nulls in non-critical columns
- ✅ Raw table never modified — cleaned via SQL View

### Key EDA Findings
- 🎬 Movies: **6,131 (69.62%)** |
  📺 TV Shows: **2,676 (30.38%)**
- 🌍 Top Country: **United States** (2,818 titles)
- 📅 Peak Year Added: **2019** (1,999 titles)
- ⭐ Top Rating: **TV-MA** (3,207 — 36.41%)
- 🎭 Top Genre: **Dramas, International Movies** (362)
- 🎬 Top Director: **Rajiv Chilaka** (19 titles)
- 📉 Post 2020 decline due to COVID production impact



### 📈 Power BI Dashboard

**Dashboard Pages:**
- 🏠 Overview — KPIs, content split, growth trend
- 🎬 Movies — Top movies, duration, ratings, genres
- 📺 TV Shows — Top shows, seasons, ratings, genres
- 👥 People — Top directors, featured cast members
- 🌍 Countries — Content by market, map visual

**DAX Measures Created:**
- Total Titles, Total Movies, Total TV Shows
- Movie %, TV Show %, Content Ratio
- Total Countries, Total Directors, Total Genres
- Avg Movie Duration, Avg Seasons
- Rating Distribution %, Content % by Country
- Titles per Year, Avg Titles per Year

**Calculated Columns Created:**
- Duration Minutes (Movies)
- Duration Bucket (Short/Medium/Standard/Long)
- Seasons (TV Shows)
- Decade of Release
- Rating Group (Adult/Teen/Family/Kids)
- Year Added


### Dashboard Preview
> Netflix Analysis Power BI Dashboard

<img width="506" height="281" alt="Screenshot 2026-06-13 074059" src="https://github.com/user-attachments/assets/f3d555e1-f4c2-46b6-b105-1bce453bbb42" />


---

## 🛠️ Tools & Technologies

| Tool          | Purpose                        |
|---------------|--------------------------------|
| SQL Server    | Database storage               |
| SSMS (T-SQL)  | Data cleaning & EDA            |
| Power BI      | Dashboard & visualization      |
| Power Query   | Data transformation in Power BI|
| DAX           | Calculated columns & measures  |

---

## 🔄 Methodology
Raw Data
↓
Schema Inspection
↓
Primary Key Identification
↓
Null Analysis
↓
Duplicate Detection
↓
Data Type Validation
↓
Outlier Detection
↓
Data Cleaning (SQL View)
↓
Save Clean Table
↓
Exploratory Data Analysis
↓
Power BI Dashboard

---

## 💡 Key Recommendations

### OnlineRetail
- Stock top products ahead of Q4 Christmas surge
- Target Germany & France for international growth
- Retain High Value customers with loyalty programme
- Run February promotions to lift weakest month

### Netflix
- Invest further in Korean & Japanese TV content
- Expand family & children content category
- Increase Documentaries & Stand-Up originals
- Leverage December for strategic content drops

---

## 🏆 Project Outcomes

```
✅ Two complete datasets analysed end-to-end
✅ 541,909 + 8,807 = 550,716 total rows processed
✅ All data quality issues identified and resolved
✅ Non-destructive cleaning — raw data preserved
✅ Full EDA performed using only SQL
✅ Two professional Power BI dashboards built
✅ DAX measures and calculated columns created
✅ Business insights and recommendations documented
✅ Complete project documentation produced


## 👩‍💻 Author

**Vivian Okoaze**
- Tool: SQL Server Management Studio & Power BI
- Date: June 2026
