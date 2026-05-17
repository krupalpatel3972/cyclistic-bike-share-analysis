# 🚲 Cyclistic Bike-Share Analysis
### Google Data Analytics Professional Certificate — Capstone Project

![Badge](https://img.shields.io/badge/Tool-SQL-blue) ![Badge](https://img.shields.io/badge/Tool-Excel-green) ![Badge](https://img.shields.io/badge/Platform-BigQuery-orange) ![Badge](https://img.shields.io/badge/Status-Complete-brightgreen)

📖 **Full case study write-up:** [Read on Medium](https://medium.com/@krupalpatel3972/cyclistic-case-study-9c5a110290c0)

---

## 📋 Business Task

Cyclistic is a bike-sharing company in Chicago. The director of marketing believes the company's future success depends on maximizing annual memberships.

**Goal:** Analyze how casual riders and annual members use Cyclistic bikes differently, and provide data-driven recommendations to convert casual riders into annual members.

---

## 👥 Key Stakeholders

| Stakeholder | Role |
|---|---|
| Lily Moreno | Director of Marketing |
| Cyclistic Marketing Analytics Team | Data collection, analysis, reporting |
| Cyclistic Executive Team | Final approval of marketing program |

---

## 🗂️ Data Source

- **Dataset:** Cyclistic historical trip data — full year 2022 (12 months)
- **Source:** [Divvy Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html) provided by Motivate International Inc.
- **License:** [Data License Agreement](https://divvybikes.com/data-license-agreement)
- **Format:** CSV files (one per month), merged into quarterly tables using BigQuery

---

## 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| Microsoft Excel | Data cleaning, new column creation |
| Google BigQuery (SQL) | Merging 12 monthly files, aggregation, analysis |
| Google Cloud Console | File upload and storage |

---

## 🧹 Data Cleaning (Excel)

Steps performed on each monthly CSV file:

- Removed duplicate records
- Filtered and deleted rows with **null values**
- Removed trip IDs containing special characters
- Removed rows where station ID and station name were missing
- Deleted trips where **end time ≤ start time** (invalid records)
- Created new column **`week_day`** using:
  ```
  =CHOOSE(WEEKDAY(C2),"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
  ```
- Created new column **`travel_time`** using:
  ```
  =D2-C2
  ```

---

## 🔍 Analysis (SQL — BigQuery)

All SQL queries are available in [`analysis.sql`](analysis.sql)

### Key analyses performed:
- Total rides per month and per quarter
- Percentage of rides by member type (annual vs. casual)
- Ride frequency by day of week
- Top 3 start and end stations by rider type
- Bike type usage per quarter
- Average and maximum ride length by rider type

---

## 📊 Key Findings

### 1. Members dominate overall — but casual riders surge in summer
- Annual members accounted for **60.97%** of all rides in 2022
- Casual rider share jumped to **43.10% in Q2** and **43.52% in Q3**
- Casual riders are weather-sensitive; members ride consistently year-round

### 2. Ride duration — casual riders ride longer
| Rider Type | Average Ride Length |
|---|---|
| Casual | 23 min 58 sec |
| Member | 12 min 26 sec |

Casual riders take longer leisure trips; members take shorter, routine commute trips.

### 3. Weekends are the most popular — especially Sunday
- **Sunday had the highest ride frequency** with **605,010 rides**
- Both rider types peak on weekends, but casual riders show a stronger weekend bias

### 4. Station patterns reveal rider purpose
| Rider Type | Top Stations | Interpretation |
|---|---|---|
| Casual | Streeter Dr & Grand Ave, Michigan Ave & Oak St, DuSable Lake Shore Dr & Monroe St | Tourist/leisure locations near lakefront & Millennium Park |
| Member | Kingsbury St & Kinzie St, Clark St & Elm St, Clinton St & Washington Blvd | Residential/commercial — commuting & daily errands |

---

## 💡 Recommendations

1. **Summer conversion campaign:** Target casual riders in Q2 and Q3 with promotions emphasizing annual membership cost savings, convenience, and flexibility during peak riding season.

2. **Location-based marketing:** Place campaigns at the top 3 casual rider stations — Streeter Dr & Grand Ave, Michigan Ave & Oak St, and DuSable Lake Shore Dr & Monroe St — where casual riders are already concentrated.

3. **Weekend incentive program:** Offer weekend-specific discounts or trial memberships, since weekends (especially Sundays) are the most active days for casual riders.

---

## 🔬 Areas for Further Research

- **Demographics:** Age, gender, and occupation data to enable better customer segmentation
- **External factors:** Weather, holidays, and local events as predictors of bike usage and availability
- **Customer feedback:** Surveys to understand barriers to annual membership conversion

---

## 📁 Repository Structure

```
cyclistic-bike-share-analysis/
│
├── README.md               ← Project overview (you are here)
├── analysis.sql            ← All BigQuery SQL queries
└── visualizations/         ← Charts and graphs from analysis
    ├── rides_per_month.png
    ├── rides_per_quarter.png
    ├── weekday_rides.png
    ├── top_stations.png
    └── bike_type_usage.png
```

---

## 👤 About

**Krupal Patel** — IT Graduate | Financial Data Analyst | Python · SQL · Power BI  
📍 Waterloo, Ontario, Canada  
🔗 [LinkedIn](https://www.linkedin.com/in/krupal-patel-099462207) | 📖 [Medium](https://medium.com/@krupalpatel3972)
