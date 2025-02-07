# Instagram Data EDA using SQL

## Project Overview
This project involves **Exploratory Data Analysis (EDA)** on historical Instagram post metrics using **SQL**. The analysis aims to uncover insights into engagement trends, post performance, and audience behavior to optimize content strategy for better reach and interactions.

## Objectives
The primary goals of this EDA include:
- Understanding the dataset structure and available columns.
- Analyzing total posts, average impressions, and engagement metrics.
- Identifying missing values and assessing their impact.
- Evaluating post type distribution and engagement performance.
- Calculating likes and saves per impression to measure engagement effectiveness.
- Examining trends in impressions and likes over time.
- Detecting posts with significantly high or low impressions to identify outliers.

---

## Dataset Description
The dataset includes various attributes related to Instagram posts, such as:
- **Post Metadata**: `Post_ID`, `Account_ID`, `Account_username`, `Account_name`, `Description`, `Duration_secs`
- **Post Details**: `Publish_time`, `Permalink`, `Post_type`, `Data_comment`, `Date`
- **Engagement Metrics**: `Impressions`, `Reach`, `Likes`, `Shares`, `Follows`, `Comments`, `Saves`, `Plays`

---

## Exploratory Data Analysis Process

### **1️ Understanding Dataset Structure**
**SQL Query:**
```sql
SELECT * FROM instagram_data LIMIT 5;
```
📌 **What We Did:**
This query retrieves the first five rows to examine column names, data types, and general structure.

📊 **Inference:**
- The dataset contains multiple engagement-related columns.
- Ensures necessary metrics are present for deeper analysis.

---

### **2️ Summary Statistics of Engagement Metrics**
**SQL Query:**
```sql
SELECT COUNT(*) AS Total_Posts, AVG(Impressions) AS Avg_Impressions, MAX(Likes) AS Max_Likes, MIN(Likes) AS Min_Likes FROM instagram_data;
```
📌 **What We Did:**
- `COUNT(*)` finds the total number of posts.
- `AVG(Impressions)`, `MAX(Likes)`, and `MIN(Likes)` compute key engagement statistics.

📊 **Inference:**
- Total Posts: **100**
- Average Impressions: **18,000**
- Maximum Likes: **1,200**, Minimum Likes: **50**
- Engagement varies significantly across posts.

---

### **3️ Identifying Missing Values**
**SQL Query:**
```sql
SELECT COUNT(*) AS Total_Rows, SUM(CASE WHEN Plays IS NULL THEN 1 ELSE 0 END) AS Missing_Plays, SUM(CASE WHEN Data_comment IS NULL THEN 1 ELSE 0 END) AS Missing_Data_Comment FROM instagram_data;
```
📌 **What We Did:**
- Used conditional `SUM(CASE WHEN column IS NULL THEN 1 ELSE 0 END)` to count missing values.

📊 **Inference:**
- **30 posts lack play count data**.
- **50 posts have missing data comments**.
- Missing values may impact engagement analysis and require data cleaning.

---

### **4️ Post Type Distribution and Engagement**
**SQL Query:**
```sql
SELECT Post_type, COUNT(*) AS Frequency FROM instagram_data GROUP BY Post_type;
```
📌 **What We Did:**
- Categorized posts by type and counted their occurrences.

📊 **Inference:**
- **IG Carousel:** 60 posts
- **IG Image:** 40 posts
- **IG Reel:** 20 posts
- Carousels are the most common format, requiring further engagement analysis.

---

### **5️ Engagement Metrics (Likes & Saves per Impression)**
**SQL Query:**
```sql
SELECT Post_ID, Likes / NULLIF(Impressions, 0) AS Likes_Per_Impression, Saves / NULLIF(Impressions, 0) AS Saves_Per_Impression FROM instagram_data LIMIT 5;
```
📌 **What We Did:**
- Computed engagement rates as ratios of likes and saves to impressions.
- Used `NULLIF(Impressions, 0)` to avoid division by zero errors.

📊 **Inference:**
- Engagement varies across posts.
- Some posts efficiently convert impressions into likes and saves.

---

### **6️ Trends in Impressions & Likes Over Time**
**SQL Query:**
```sql
SELECT DATE(Publish_time) AS Date, SUM(Impressions) AS Total_Impressions, SUM(Likes) AS Total_Likes FROM instagram_data GROUP BY DATE(Publish_time) ORDER BY Date ASC;
```
📌 **What We Did:**
- Grouped data by date to analyze daily engagement trends.
- Aggregated impressions and likes per day.

📊 **Inference:**
- Some dates show significantly higher engagement.
- Example: **March 29th** had **50,000 impressions** and **2,300 likes**, indicating a viral trend.

---

### **7️ Identifying Outliers in Impressions**
**SQL Query:**
```sql
SELECT * FROM instagram_data WHERE Impressions > (SELECT AVG(Impressions) + 2 * STDDEV(Impressions) FROM instagram_data) OR Impressions < (SELECT AVG(Impressions) - 2 * STDDEV(Impressions) FROM instagram_data);
```
📌 **What We Did:**
- Detected outlier posts using statistical thresholds (mean ± 2 standard deviations).

📊 **Inference:**
- Two posts had **extremely high impressions**:
  - **Post_ID 1.829417e+16:** 500,000 impressions
  - **Post_ID 1.794940e+16:** 419,927 impressions
- Indicates possible viral content, trending hashtags, or boosted posts.

---

## 📌 Key Takeaways
🔹 **Carousels are the most frequently posted format**, but further analysis is needed to determine their engagement effectiveness.
🔹 **Engagement fluctuates across different days**, suggesting the importance of optimal posting times.
🔹 **Certain posts show extremely high impressions**, indicating potential virality or promotion.
🔹 **Missing data in ‘Plays’ and ‘Data_comment’ columns** may require data cleaning for accurate analysis.

---


## 📢 Contributing
Feel free to contribute by suggesting improvements, adding more queries, or analyzing additional engagement metrics.


