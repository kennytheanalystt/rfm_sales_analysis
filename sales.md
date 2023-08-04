# Data-Driven Sales Strategies: The Impact of RFM Analysis and KPI Reports Unveiled

## Let's take a look at RFM analysis and KPI report of Sales data with SQl and tablue

<!--  common question to answer -->
<br>

In this article;

- What is Sales Analysis?
- What are KPI's?
- RFM analysis, and What it is?
- Analyze a Sales data of an imaginary store.
- RFM analysis on a sales data.
- Make Visuals/Dashboard & KPI Report from the analysis above.
- Finally, Elaborate about why Sales analysis is import for business's and how it can benefit them.

Target: Bussiness analyst, Data analyst, Bussiness managers.

Note: The code in this article can be found in this github repo: [Sales Analysis](github.com/kennytheanalystt)

<br>
<!-- Introduction;
1 Explain what sales analysis is
2 Explain the data set -->

In the fast-paced and competitive landscape of business, data-driven decision-making has become a cornerstone for achieving success. Among the plethora of analytical techniques, sales analysis stands as a crucial pillar that empowers organizations to gain valuable insights into their sales performance and customer behavior. Within the realm of sales analysis, two powerful tools emerge as beacons of understanding – RFM analysis and KPI reports.
<br>
At its core, sales analysis involves the systematic examination of sales data to extract meaningful information about a company's sales performance, customer interactions, and market trends. Armed with these invaluable insights, businesses can make well-informed decisions, optimize strategies, and strengthen their competitive edge in the market.
<br>
The analytics proccess involves the systematic review of sales-related information, such as revenue, units sold, customer demographics, product performance, and other relevant metrics.

The main objectives of sales analysis are to:

- Evaluate Performance.
- Identify Trends and Pattern.
- Understand Customer Behavior.
- Optimize Inventory Management.
- Assess Marketing Effectiveness.
- Forecast Future Sales.

<br>

Sales analysis is an essential aspect of business intelligence, as it empowers companies to make informed decisions, spot opportunities for growth, and identify areas for improvement in their sales processes. It plays a vital role in driving sales strategies, increasing revenue, and overall business success.

<br>

RFM Analysis: One of the fundamental methodologies within sales analysis is the RFM analysis, an acronym for Recency, Frequency, and Monetary Value. RFM analysis is a customer segmentation technique that provides a comprehensive understanding of customer behavior based on their transaction history.

<br>

KPI Reports: Key Performance Indicators (KPIs) play a vital role in comprehending the overall effectiveness and success of a company's sales operations. KPIs are quantifiable metrics that serve as benchmarks, providing businesses with specific targets to monitor and analyze.

<br>

<!-- aim -->

In this article, we will delve into the intricacies of RFM analysis and KPI reports, exploring how they revolutionize sales data interpretation, foster growth, and drive success in the ever-evolving world of business.

<br>
<!-- Prerequisite -->
PREREQUISITE: Any SQL Tool and Tableau

<br>

### LOADING THE DATA SET

At first we need to load the dataset we are going to work with. There are several ways to load/import data set into an SQl database, for this guide i am going to use python to import the data set into PostgreSQL.

> Note: The data set use in this notebook is sourced from [kaggle](kaggle.com) > <br>

### To import data set into SQL using python;

<p>The to_sql() function in Python is used to write records from a Pandas DataFrame to a SQL database. It is a very powerful function that can be used to store data in a variety of database formats.  <br>
The syntax for the to_sql() function is as follows:

```python
import pandas as pd
sales_df = pd.read_csv('Superstore data.csv', encoding='ISO 8859-1')
```

```python
from sqlalchemy import create_engine
engine = create_engine('postgresql://postgres:mlyt09@localhost:5432/projectsql')
```

> Here: `postgresql://` > the sql_tool, `postgres:` > the user, ~~`mlyt09`~~ > the password, `@localhost:` > the host, `5432` > the port, `/projectsql` the database.

```python
player_df.to_sql(name='sales', con=engine,index=False if_exists='replace')
```

Check to confirm the data is in PSQL...

```sql
projectsql=# \dt sales
```

List of relations
| Schema | Name | Type | Owner |
-------- | ----- | ----- | -------- |
| public | sales | table | postgres |

```
projectsql=# \d sales
```

Table "public.sales"
| Column | Type |
| ---------- | ---------------- |
| row_id | bigint |  
| order_id | text |  
| order_date | date |  
| ship_date | text |  
| ship_mode | text |
| customer_id | text |
| customer_name | text |
segment | text |
country | text |
city | text |
state | text |
postal_code | bigint |
region | text |
product_id | text |
category | text |
sub_category | text |
product_name | text |
sales | double precision |
quantity | bigint |
discount | double precision |
profit | double precision |
year | integer |
month | integer |

<br>

### Querying the data to answer the questions.

---

### (Qr1) Check to confirm the total number of records.

```sql
SELECT COUNT(*) FROM sales;
```

| count |
| ----- |
| 9994  |

<br>

### (Qr2) Extracting Year and Month from the 'order_date' column.

```sql
ALTER TABLE sales ALTER COLUMN order_date TYPE DATE USING order_date::DATE
```

ALTER TABLE

```sql
SELECT EXTRACT(YEAR FROM order_date) FROM sales
```

| extract |
| ------- |
| 2016    |
| 2015    |
| 2015    |
| 2014    |

+9990 others

```sql
SELECT EXTRACT(MONTH FROM order_date) FROM sales
```

| extract |
| ------- |
| 12      |
| 11      |
| 11      |
| 11      |

+9990 others

```sql
ALTER TABLE sales ADD year INT
```

ALTER TABLE

```sql
ALTER TABLE sales ADD month INT
```

ALTER TABLE

```sql
UPDATE sales SET year = EXTRACT(YEAR FROM order_date)
```

UPDATE 9994

```sql
UPDATE sales SET month = EXTRACT(MONTH FROM order_date)
```

UPDATE 9994

<br>

### (Qr3) Checking the Unique values for Some of the data_variables.

```sql
SELECT DISTINCT year FROM sales
```

| year |
| ---- |
| 2014 |
| 2015 |
| 2016 |
| 2017 |

```sql
SELECT DISTINCT ship_mode FROM sales
```

| ship_mode      |
| -------------- |
| First Class    |
| Second Class   |
| Standard Class |
| Same day       |

```sql
SELECT DISTINCT segment FROM sales
```

| segment     |
| ----------- |
| Consumer    |
| Home office |
| corporate   |

```sql
SELECT DISTINCT region FROM sales
```

| region  |
| ------- |
| South   |
| West    |
| East    |
| Central |

```sql
SELECT DISTINCT category FROM sales
```

| Category        |
| --------------- |
| Furniture       |
| Office Supplies |
| Technology      |

<br>
<!-- -- prudct with most sales through 2014-2017 -->

### (Qr4) Product Category with the most Sales through 2014-2017.

```sql
SELECT sub_category, ROUND(SUM(sales)) AS sales
	FROM sales
  	GROUP BY sub_category
	ORDER BY sales DESC
```

| sub_category | sales  |
| ------------ | ------ |
| Phones       | 330007 |
| Chairs       | 328449 |
| Storage      | 223844 |
| Tables       | 206966 |
| Binders      | 203413 |
| Machines     | 189239 |
| Accessories  | 167380 |
| Copiers      | 149528 |
| Bookcases    | 114880 |
| Appliances   | 107532 |
| Furnishings  | 91705  |
| Paper        | 78479  |
| Supplies     | 46674  |
| Art          | 27119  |
| Envelopes    | 16476  |
| Labels       | 12486  |
| Fasteners    | 3024   |

<br>

<!-- -- prudct with most profit through 2014-2017 -->

### (Qr5) Product Category with the most profit through 2014-2017.

```sql
SELECT sub_category, ROUND(SUM(profit)) AS profit
	FROM sales
  	GROUP BY sub_category
	ORDER BY profit DESC;
```

| sub_category | profit |
| ------------ | ------ |
| Copiers      | 55618  |
| Phones       | 44516  |
| Accessories  | 41937  |
| Paper        | 34054  |
| Binders      | 30222  |
| Chairs       | 26590  |
| Storage      | 21279  |
| Appliances   | 18138  |
| Furnishings  | 13059  |
| Envelopes    | 6964   |
| Art          | 6528   |
| Labels       | 5546   |
| Machines     | 3385   |
| Fasteners    | 950    |
| Supplies     | -1189  |
| Bookcases    | -3473  |
| Tables       | -17725 |

(17 rows)

<!-- -- year with most sales through 2014-2017 -->
<br>

### (Qr6) year with the most sales through 2014-2017.

```sql
SELECT year, ROUND(SUM(sales)) AS sales
	FROM sales
  	GROUP BY year
	ORDER BY sales DESC;
```

| year | sales   |
| ---- | ------- |
| 2017 | 733,215 |
| 2016 | 609,206 |
| 2014 | 484,247 |
| 2015 | 470,533 |

(4 rows)

<br>

 <!-- Sales and Profit by consumer Segment... -->

### (Qr7) Trends in Sales and Profit by consumer Segment....

In sales analysis, understanding trends in sales and profit by consumer segment is critical for businesses to make informed decisions and optimize their marketing strategies. Analyzing sales and profit data by consumer segments helps identify patterns, preferences, and behaviors among different customer groups, leading to more targeted and effective sales initiatives.

<br>
Sales analysis provides invaluable insights into trends in sales and profit by consumer segment. By understanding consumer behavior, seasonal patterns, and profitability, businesses can refine their sales strategies, optimize marketing efforts, and cater to the specific needs of different customer groups, ultimately driving growth and success.

<br>

```sql
SELECT segment, COUNT(order_id) AS total_orders,
	   ROUND(SUM(SALES)) AS total_sales, ROUND(SUM(profit)) AS total_profit
FROM sales GROUP BY segment ORDER BY total_profit DESC;
```

| segment     | total_orders | total_sales | total_profit |
| ----------- | ------------ | ----------- | ------------ |
| Consumer    | 5191         | 1,161,401   | 134,119      |
| Corporate   | 3020         | 706,146     | 91,979       |
| Home Office | 1783         | 429,653     | 60,299       |

(3 rows)

<br>

 <!-- -- Sales and Profit by region... -->

### (Qr8) Trends in Sales and Profit by region....

Analyzing trends in sales and profit by region is essential for sales analysis in businesses operating in multiple locations. By understanding regional variations in sales and profitability, companies can make data-driven decisions, tailor their marketing efforts, optimize distribution strategies, and identify growth opportunities in specific geographic areas.

```sql
SELECT region, COUNT(order_id) AS total_orders,
	   ROUND(SUM(SALES)) AS total_sales, ROUND(SUM(profit)) AS total_profit
FROM sales GROUP BY region ORDER BY total_profit DESC;
```

| region  | total_orders | total_sales | total_profit |
| ------- | ------------ | ----------- | ------------ |
| West    | 3203         | 725,458     | 108,418      |
| East    | 2848         | 678,781     | 91,523       |
| South   | 1620         | 391,722     | 46,749       |
| Central | 2323         | 501,240     | 39,706       |

(4 rows)

<br>

<!-- what was the best month for sales in a specific year ?
   what's sales for the month?  -->

### (Qr9) what was the best month for sales in a specific year ?

### what's the sales for the month?

In sales analysis, determining the best month in a specific year for sales involves identifying the month with the highest sales revenue or volume. It provides valuable insights into peak periods of customer demand and sales performance. This analysis helps businesses optimize their resources, plan promotions, and capitalize on favorable market conditions.

In addition to finding the best month, it's also essential to assess the sales performance in that month compared to the previous year or previous months of the same year. This year-over-year or month-over-month analysis can provide a deeper understanding of growth patterns and identify areas for improvement.

<br>

```sql
-- 2014
SELECT month,ROUND(SUM(sales)) AS revenue_for_2014,
	   COUNT(order_id) AS total_orders, SUM(quantity) AS total_quantity_order
	FROM sales
	WHERE year = 2014
 	GROUP BY month
	ORDER BY revenue_for_2014 DESC;
```

| month | revenue_for_2014 | total_orders | total_quantity_order |
| ----- | ---------------- | ------------ | -------------------- |
| 9     | 81777            | 268          | 1000                 |
| 11    | 78629            | 318          | 1219                 |
| 12    | 69546            | 278          | 1079                 |
| 3     | 55691            | 157          | 585                  |
| 6     | 34595            | 135          | 521                  |
| 7     | 33946            | 143          | 550                  |
| 10    | 31453            | 159          | 573                  |
| 4     | 28295            | 135          | 536                  |
| 8     | 27909            | 153          | 609                  |
| 5     | 23648            | 122          | 466                  |
| 1     | 14237            | 79           | 284                  |
| 2     | 4520             | 46           | 159                  |

(12 rows)

```sql
-- 2015
SELECT month,ROUND(SUM(sales)) AS sales_for_2015,
	   COUNT(order_id) AS total_orders, SUM(quantity) AS total_quantity_order
	FROM sales
	WHERE year = 2015
 	GROUP BY month
	ORDER BY sales_for_2015 DESC;
```

| month | sales_for_2015 | total_orders | total_quantity_order |
| ----- | -------------- | ------------ | -------------------- |
| 11    | 75973          | 324          | 1310                 |
| 12    | 74920          | 316          | 1203                 |
| 9     | 64596          | 293          | 1086                 |
| 3     | 38726          | 138          | 515                  |
| 8     | 36898          | 159          | 598                  |
| 4     | 34195          | 160          | 543                  |
| 10    | 31405          | 166          | 631                  |
| 5     | 30132          | 146          | 575                  |
| 7     | 28765          | 140          | 557                  |
| 6     | 24797          | 138          | 486                  |
| 1     | 18174          | 58           | 236                  |
| 2     | 11951          | 64           | 239                  |

(12 rows)

```sql
-- 2016
SELECT month,ROUND(SUM(sales)) AS sales_for_2016,
	   COUNT(order_id) AS total_orders, SUM(quantity) AS total_quantity_order
	FROM sales
	WHERE year = 2016
 	GROUP BY month
	ORDER BY sales_for_2016 DESC
```

| month | sales_for_2015 | total_orders | total_quantity_order |
| ----- | -------------- | ------------ | -------------------- |
| 11    | 75973          | 324          | 1310                 |
| 12    | 74920          | 316          | 1203                 |
| 9     | 64596          | 293          | 1086                 |
| 3     | 38726          | 138          | 515                  |
| 8     | 36898          | 159          | 598                  |
| 4     | 34195          | 160          | 543                  |
| 10    | 31405          | 166          | 631                  |
| 5     | 30132          | 146          | 575                  |
| 7     | 28765          | 140          | 557                  |
| 6     | 24797          | 138          | 486                  |
| 1     | 18174          | 58           | 236                  |
| 2     | 11951          | 64           | 239                  |

(12 rows)

```sql
-- 2017
SELECT month,ROUND(SUM(sales)) AS sales_for_2017,
	   COUNT(order_id) AS total_orders, SUM(quantity) AS total_quantity_order
	FROM sales
	WHERE year = 2017
 	GROUP BY month
	ORDER BY sales_for_2017 DESC;
```

| month | sales_for_2017 | total_orders | total_quantity_order |
| ----- | -------------- | ------------ | -------------------- |
| 11    | 118448         | 459          | 1840                 |
| 9     | 87867          | 459          | 1660                 |
| 12    | 83829          | 462          | 1723                 |
| 10    | 77777          | 298          | 1133                 |
| 8     | 63121          | 218          | 884                  |
| 3     | 58872          | 238          | 885                  |
| 6     | 52982          | 245          | 931                  |
| 7     | 45264          | 226          | 840                  |
| 5     | 44261          | 242          | 887                  |
| 1     | 43971          | 155          | 597                  |
| 4     | 36522          | 203          | 733                  |
| 2     | 20301          | 107          | 363                  |

(12 rows)

In conclusion, sales analysis helps businesses pinpoint the best month for sales in a specific year, enabling them to make data-driven decisions, replicate successful strategies, and leverage market opportunities effectively. Understanding the drivers behind exceptional sales performance during that month empowers businesses to optimize their sales efforts and achieve continued success.

<br>

<!-- -- base on product -->

### (Qr10) Dive in through the best month to check for the best Product Category...

By conducting a deep dive into the top-selling product category during the best month of a particular year, businesses can gain valuable insights that inform future sales strategies. Understanding customer preferences, market dynamics, and the success of marketing efforts can help replicate successful tactics, optimize product offerings, and drive sustainable growth.

### Top 5 best selling product category in the best month of each year.

```sql
-- 2014
SELECT month, sub_category, ROUND(SUM(sales)) AS sales_for_2014,
	   ROUND(SUM(profit)) AS profit_for_2014, SUM(quantity) total_quantity_orders
	   FROM sales
 	   WHERE year = 2014 and month = 9
       GROUP BY month, sub_category
	   ORDER BY sales_for_2014 DESC;
```

| month | sub_category | sales_for_2014 | profit_for_2014 | total_quantity_orders |
| ----- | ------------ | -------------- | --------------- | --------------------- |
| 9     | Machines     | 22420          | -2626           | 45                    |
| 9     | Chairs       | 13849          | 1434            | 69                    |
| 9     | Binders      | 12744          | 5130            | 123                   |
| 9     | Storage      | 8810           | 553             | 92                    |
| 9     | Tables       | 4612           | -176            | 34                    |

```sql
-- 2015
SELECT month, sub_category, ROUND(SUM(sales)) AS sales_for_2015,
	   ROUND(SUM(profit)) AS profit_for_2015,SUM(quantity) total_quantity_orders
	   FROM sales
 	   WHERE year = 2015 and month = 11
       GROUP BY month, sub_category
	   ORDER BY sales_for_2015 DESC;
```

| month | sub_category | sales_for_2015 | profit_for_2015 | total_quantity_orders |
| ----- | ------------ | -------------- | --------------- | --------------------- |
| 11    | Chairs       | 12743          | 1748            | 90                    |
| 11    | Bookcases    | 8377           | 747             | 48                    |
| 11    | Phones       | 8176           | 1111            | 92                    |
| 11    | Machines     | 7850           | 3454            | 16                    |
| 11    | Storage      | 6716           | 783             | 112                   |

```sql
-- 2016
SELECT month, sub_category, ROUND(SUM(sales)) AS sales_for_2016,
	   ROUND(SUM(profit)) AS profit_for_2016,SUM(quantity) total_quantity_orders
	   FROM sales
 	   WHERE year = 2016 and month = 11
       GROUP BY month, sub_category
	   ORDER BY sales_for_2016 DESC;
```

| month | sub_category | sales_for_2016 | profit_for_2016 | total_quantity_orders |
| ----- | ------------ | -------------- | --------------- | --------------------- |
| 11    | Chairs       | 13173          | 369             | 99                    |
| 11    | Phones       | 9103           | 1574            | 93                    |
| 11    | Tables       | 8778           | -164            | 52                    |
| 11    | Machines     | 8757           | -5221           | 33                    |
| 11    | Accessories  | 8081           | 1972            | 139                   |

```sql
-- 2017
SELECT month, sub_category, ROUND(SUM(sales)) AS sales_for_2017,
  ROUND(SUM(profit)) AS profit_for_2017,SUM(quantity) total_quantity_orders
  FROM sales
  WHERE year = 2017 and month = 11
  GROUP BY month, sub_category
  ORDER BY sales_for_2017 DESC;
```

| month | sub_category | sales_for_2017 | profit_for_2017 | total_quantity_orders |
| ----- | ------------ | -------------- | --------------- | --------------------- |
| 11    | Phones       | 17407          | 2563            | 175                   |
| 11    | Chairs       | 14561          | 954             | 87                    |
| 11    | Tables       | 13659          | -1176           | 81                    |
| 11    | Copiers      | 12360          | 5427            | 8                     |
| 11    | Storage      | 11911          | 1384            | 174                   |

<br>

### (Qr11) what's the Total Sales, Profit, Quantity Sold and Total quantity sold.

```sql
SELECT ROUND(SUM(sales)) AS total_sales,
	   ROUND(SUM(profit)) AS total_profit,
	   ROUND(AVG(sales)) AS average_sales,
	   Sum(quantity) AS total_quantity_sold
FROM sales;
```

| total_sales | total_profit | average_sales | total_quantity_sold |
| ----------- | ------------ | ------------- | ------------------- |
| 2,297,201   | 286,397      | 230           | 37,873              |

<!--
		RFM analysis
	Explain waht rfm analysis is
-->

### (Qr12) RFM Analysis.

RFM analysis is a valuable marketing technique used to analyze customer behavior and segment customers based on their purchasing patterns. The acronym "RFM" stands for Recency, Frequency, and Monetary Value, which are the three key metrics used in this analysis.

1. Recency (R): This metric measures how recently a customer made a purchase. It indicates the time elapsed since the last transaction, and customers who made recent purchases are considered more engaged and potentially more valuable.

2. Frequency (F): This metric refers to the number of times a customer made a purchase within a specific timeframe. Customers who make frequent purchases are usually loyal and valuable to the business.

3. Monetary Value (M): This metric represents the total monetary value of a customer's purchases within a particular period. Customers with higher monetary spending are typically more valuable to the business.

By combining these three metrics, RFM analysis categorizes customers into various segments, such as high-value, medium-value, and low-value customers. This segmentation allows businesses to tailor their marketing strategies, personalized offers, and customer retention efforts to target each customer segment more effectively.

RFM analysis is commonly used in e-commerce, retail, and various other industries to identify their most valuable customers, understand customer behavior, and improve overall marketing efforts and sales performance.

### Checking for the recent order_date for each customer compare to recent_date.

```sql
-- last order
SELECT
 customer_name,
 ROUND(SUM(sales)) AS order$,
 ROUND(AVG(sales)) AS avgorder$,
 COUNT(order_id)AS  orders,
 SUM(quantity) AS quantity_order,
 MAX(order_date) AS last_order,
 (SELECT MAX(order_date) FROM sales) AS recent_date
 FROM sales
 GROUP BY customer_name
 ORDER BY quantity_order DESC;
```

| customer_name       | order$ | avgorder$ | orders | quantity_order | last_order | recent_date |
| ------------------- | ------ | --------- | ------ | -------------- | ---------- | ----------- |
| Jonathan Doherty    | 7611   | 238       | 32     | 150            | 2016-12-01 | 2017-12-30  |
| William Brown       | 6160   | 166       | 37     | 146            | 2017-12-10 | 2017-12-30  |
| John Lee            | 9800   | 288       | 34     | 143            | 2017-12-09 | 2017-12-30  |
| Paul Prost          | 7253   | 213       | 34     | 138            | 2017-09-24 | 2017-12-30  |
| Steven Cartwright   | 5226   | 201       | 26     | 133            | 2017-06-26 | 2017-12-30  |
| Emily Phan          | 5478   | 177       | 31     | 124            | 2017-12-18 | 2017-12-30  |
| Chloris Kastensmidt | 3155   | 99        | 32     | 122            | 2017-11-21 | 2017-12-30  |
| Cassandra Brandow   | 6076   | 234       | 26     | 122            | 2017-11-13 | 2017-12-30  |

.....

<br>

### (Qr13) How many days has it been a customer ordered?

```sql
-- last order day
SELECT
 customer_name,
 ROUND(SUM(sales)) AS order$,
 ROUND(AVG(sales)) AS avgorder$,
 COUNT(order_id)AS  orders,
 SUM(quantity) AS quantity_order,
 MAX(order_date) AS last_order,
 (SELECT MAX(order_date) FROM sales) AS recent_date,
 (SELECT MAX(order_date) FROM sales) - MAX(order_date) last_order_day
 FROM sales
 GROUP BY customer_name
 ORDER BY quantity_order DESC;
```

| customer_name       | order$ | avgorder$ | orders | quantity_order | last_order | recent_date | last_order_day |
| ------------------- | ------ | --------- | ------ | -------------- | ---------- | ----------- | -------------- |
| Jonathan Doherty    | 7611   | 238       | 32     | 150            | 2016-12-01 | 2017-12-30  | 394            |
| William Brown       | 6160   | 166       | 37     | 146            | 2017-12-10 | 2017-12-30  | 20             |
| John Lee            | 9800   | 288       | 34     | 143            | 2017-12-09 | 2017-12-30  | 21             |
| Paul Prost          | 7253   | 213       | 34     | 138            | 2017-09-24 | 2017-12-30  | 97             |
| Steven Cartwright   | 5226   | 201       | 26     | 133            | 2017-06-26 | 2017-12-30  | 187            |
| Emily Phan          | 5478   | 177       | 31     | 124            | 2017-12-18 | 2017-12-30  | 12             |
| Chloris Kastensmidt | 3155   | 99        | 32     | 122            | 2017-11-21 | 2017-12-30  | 39             |
| Cassandra Brandow   | 6076   | 234       | 26     | 122            | 2017-11-13 | 2017-12-30  | 47             |
| Edward Hooks        | 10311  | 322       | 32     | 120            | 2017-08-17 | 2017-12-30  | 135            |
| Matt Abelman        | 4299   | 126       | 34     | 117            | 2017-10-27 | 2017-12-30  | 64             |

......

<br>

<!-- -- ranking the recency, frequency, and monetary from high to low -->

### (Qr14) Ranking the Recency, Frequency and monetary value.

In sales analysis using RFM (Recency, Frequency, Monetary Value) segmentation, customers are ranked from 4 to 1 based on their RFM scores. RFM analysis categorizes customers into different segments to better understand their behavior and value. The RFM scores for each customer are calculated based on three metrics: Recency, Frequency, and Monetary Value. Here's how the ranking works:

1. RFM Score 4: This represents the highest score and indicates the most valuable customers. Customers with an RFM score of 4 in all three categories (Recency, Frequency, and Monetary Value) are those who have made recent purchases, frequent transactions, and high-value spending. These customers are considered top-tier and represent a significant portion of a company's revenue.

2. RFM Score 3: Customers with an RFM score of 3 in any two of the three categories are ranked as the second-highest group. This group includes customers who have either made recent and frequent purchases, frequent and high-value transactions, or recent and high-value spending. While they may not be as valuable as RFM 4 customers, they still contribute significantly to a company's success.

3. RFM Score 2: Customers with an RFM score of 2 in two categories and any score in the third category fall into this group. For example, a customer may have made frequent purchases but not recently, or they may have made recent purchases but with a lower monetary value. This group represents average customers who could potentially be nurtured and encouraged to move up to higher RFM segments.

4. RFM Score 1: This represents the lowest score, indicating the least valuable customers. Customers with an RFM score of 1 in all three categories (i.e., low recency, low frequency, and low monetary value) are the least engaged and contribute the least to a company's revenue. These customers may require more attention and targeted marketing efforts to increase their engagement and loyalty.

By ranking customers based on their RFM scores, businesses can tailor their marketing strategies and customer retention efforts more effectively. Targeted marketing campaigns can be directed at high RFM customers to encourage repeat purchases and build loyalty, while special promotions can be offered to low RFM customers to entice them to increase their engagement and spending. Understanding customer behavior through RFM analysis helps businesses optimize their sales and marketing efforts to drive revenue and overall business success.

```sql
WITH RECURSIVE rfm as(
	 SELECT
	 customer_name,
	 ROUND(SUM(sales)) AS order$,
	 ROUND(AVG(sales)) AS avgorder$,
	 COUNT(order_id)AS  orders,
	 SUM(quantity) AS quantity_order,
	 MAX(order_date) AS last_order,
	 (SELECT MAX(order_date) FROM sales) AS recent_date,
	 (SELECT MAX(order_date) FROM sales) - MAX(order_date) last_order_day
	 FROM sales
	 GROUP BY customer_name
),
rfm_calc as (
	SELECT r.*,
		  NTILE(4) OVER (ORDER BY last_order_day DESC) rfm_recency,
		  NTILE(4) OVER (ORDER BY order$) rfm_frequency,
		  NTILE(4) OVER (ORDER BY avgorder$) rfm_monetary
	FROM rfm AS r
)
SELECT *
FROM rfm_calc AS C;
```

| customer_name     | order$ | avgorder$ | orders | quantity_order | last_order | recent_date | last_order_day | rfm_recency | rfm_frequency | rfm_monetary |
| ----------------- | ------ | --------- | ------ | -------------- | ---------- | ----------- | -------------- | ----------- | ------------- | ------------ |
| Nicole Brennan    | 274    | 137       | 2      | 7              | 2014-10-22 | 2017-12-30  | 1165           | 1           | 1             | 2            |
| Georgia Rosenberg | 1284   | 257       | 5      | 23             | 2014-11-21 | 2017-12-30  | 1135           | 1           | 2             | 3            |
| Ricardo Emerson   | 48     | 48        | 1      | 5              | 2014-12-29 | 2017-12-30  | 1097           | 1           | 1             | 1            |
| Craig Molinari    | 3984   | 306       | 13     | 57             | 2015-03-01 | 2017-12-30  | 1035           | 1           | 4             | 4            |
| Valerie Takahito  | 1737   | 193       | 9      | 42             | 2015-04-05 | 2017-12-30  | 1000           | 1           | 2             | 3            |
| Pauline Chand     | 1061   | 354       | 3      | 18             | 2015-08-01 | 2017-12-30  | 882            | 1           | 1             | 4            |
| Andy Gerbode      | 1455   | 162       | 9      | 33             | 2015-09-07 | 2017-12-30  | 845            | 1           | 2             | 2            |
| Peter Fuller      | 9063   | 477       | 19     | 75             | 2015-09-17 | 2017-12-30  | 835            | 1           | 4             | 4            |
| David Philippe    | 1059   | 265       | 4      | 20             | 2015-10-10 | 2017-12-30  | 812            | 1           | 1             | 3            |
| Craig Carroll     | 2854   | 238       | 12     | 51             | 2015-10-23 | 2017-12-30  | 799            | 1           | 3             | 3            |

.....

<br>

<!-- concatinating the rfm values as string and as integer, this will allow us to classify
our customer from lost to loyal customer  -->

### (Qr15) Concatenating the RFM values and storing it in a different table.

```sql
-- Let's drop the table if it exhist...
DROP TABLE rfm

WITH RECURSIVE rfm as(
	 SELECT
	 customer_name,
	 ROUND(SUM(sales)) AS order$,
	 ROUND(AVG(sales)) AS avgorder$,
	 COUNT(order_id)AS  orders,
	 SUM(quantity) AS quantity_order,
	 MAX(order_date) AS last_order,
	 (SELECT MAX(order_date) FROM sales) AS recent_date,
	 (SELECT MAX(order_date) FROM sales) - MAX(order_date) last_order_day
	 FROM sales
	 GROUP BY customer_name
),
rfm_calc as (
	SELECT rfm.*,
		  NTILE(4) OVER (ORDER BY last_order_day DESC) rfm_recency,
		  NTILE(4) OVER (ORDER BY order$) rfm_frequency,
		  NTILE(4) OVER (ORDER BY avgorder$) rfm_monetary
	FROM rfm
)
 select
     rfm_calc.*, rfm_recency + rfm_frequency + rfm_monetary AS rfm_cell,
	 concat (rfm_recency,rfm_frequency,rfm_monetary) AS rfm_cell_string
	into rfm
	from rfm_calc;
```

SELECT 793

<br>

### (Qr16) Checking out the new table...

```sql
SELECT * FROM rfm;
```

| customer_name     | order$ | avgorder$ | orders | quantity_order | last_order | recent_date | last_order_day | rfm_recency | rfm_frequency | rfm_monetary | rfm_cell | rfm_cell_string |
| ----------------- | ------ | --------- | ------ | -------------- | ---------- | ----------- | -------------- | ----------- | ------------- | ------------ | -------- | --------------- |
| Nicole Brennan    | 274    | 137       | 2      | 7              | 2014-10-22 | 2017-12-30  | 1165           | 1           | 1             | 2            | 4        | 112             |
| Georgia Rosenberg | 1284   | 257       | 5      | 23             | 2014-11-21 | 2017-12-30  | 1135           | 1           | 2             | 3            | 6        | 123             |
| Ricardo Emerson   | 48     | 48        | 1      | 5              | 2014-12-29 | 2017-12-30  | 1097           | 1           | 1             | 1            | 3        | 111             |
| Craig Molinari    | 3984   | 306       | 13     | 57             | 2015-03-01 | 2017-12-30  | 1035           | 1           | 4             | 4            | 9        | 144             |
| Valerie Takahito  | 1737   | 193       | 9      | 42             | 2015-04-05 | 2017-12-30  | 1000           | 1           | 2             | 3            | 6        | 123             |
| Pauline Chand     | 1061   | 354       | 3      | 18             | 2015-08-01 | 2017-12-30  | 882            | 1           | 1             | 4            | 6        | 114             |
| Andy Gerbode      | 1455   | 162       | 9      | 33             | 2015-09-07 | 2017-12-30  | 845            | 1           | 2             | 2            | 5        | 122             |
| Peter Fuller      | 9063   | 477       | 19     | 75             | 2015-09-17 | 2017-12-30  | 835            | 1           | 4             | 4            | 9        | 144             |
| David Philippe    | 1059   | 265       | 4      | 20             | 2015-10-10 | 2017-12-30  | 812            | 1           | 1             | 3            | 5        | 113             |
| Craig Carroll     | 2854   | 238       | 12     | 51             | 2015-10-23 | 2017-12-30  | 799            | 1           | 3             | 3            | 7        | 133             |

.....

<br>

### (Qr17) Using the RFM ranking column to rank the customer.

```sql
SELECT customer_name,rfm_recency,rfm_frequency,rfm_monetary,
   CASE
     WHEN rfm_cell_string IN('111','122','121','124','134','113','222','133','114','123','112','212','211') THEN 'lost customers'
	 WHEN rfm_cell_string IN('312','322','321','223','234','223','241','143','142','244','313','144','233','213','322') THEN 'Sliping customers'
	 WHEN rfm_cell_string IN('411','422','423','421','424','413','412','323','311') THEN 'new customers'
	 WHEN rfm_cell_string IN('344','431','343','333','332','433','442','444','432','443','434','334') THEN 'loyal customers'
 END rfm_segment
FROM rfm;
```

| customer_name     | rfm_recency | rfm_frequency | rfm_monetary | rfm_segment       |
| ----------------- | ----------- | ------------- | ------------ | ----------------- |
| Nicole Brennan    | 1           | 1             | 2            | lost customers    |
| Georgia Rosenberg | 1           | 2             | 3            | lost customers    |
| Ricardo Emerson   | 1           | 1             | 1            | lost customers    |
| Craig Molinari    | 1           | 4             | 4            | Sliping customers |
| Valerie Takahito  | 1           | 2             | 3            | lost customers    |
| Pauline Chand     | 1           | 1             | 4            | lost customers    |
| Andy Gerbode      | 1           | 2             | 2            | lost customers    |
| Peter Fuller      | 1           | 4             | 4            | Sliping customers |
| David Philippe    | 1           | 1             | 3            | lost customers    |
| Craig Carroll     | 1           | 3             | 3            | lost customers    |
| Sam Craven        | 1           | 3             | 3            | lost customers    |
| Lycoris Saunders  | 1           | 1             | 1            | lost customers    |
| Duane Huffman     | 1           | 1             | 1            | lost customers    |
| Kelly Williams    | 1           | 1             | 1            | lost customers    |

....

<br>

<!-- -- what two or more item are often sold together. -->

### (Qr18) what two or more item are often sold together.

In sales analysis, the concept of "two or more products often sold together" refers to products that are frequently purchased in combination by customers. This purchasing behavior is known as product bundling or cross-selling. When customers tend to buy multiple items as a package or in conjunction with each other, it creates opportunities for businesses to capitalize on this trend and optimize their sales strategies.

Identifying which products are often sold together is crucial for several reasons:

1. Cross-Selling Opportunities: Knowing which products are frequently purchased together allows businesses to cross-sell complementary items. By suggesting related or additional products during the purchase process, companies can increase the average transaction value and boost revenue.

2. Targeted Marketing: Understanding product combinations that resonate with customers enables targeted marketing campaigns. Companies can tailor promotions, discounts, or product bundles based on customers' buying patterns to drive sales.

3. Inventory Management: Recognizing products that are often sold together helps businesses manage their inventory effectively. Maintaining sufficient stock of popular product combinations ensures that customers can easily purchase these items without experiencing stockouts.

4. Customer Satisfaction: Offering product bundles that align with customers' preferences enhances their overall shopping experience and satisfaction. Satisfied customers are more likely to return for future purchases, fostering brand loyalty.

To identify products often sold together, sales analysis involves examining transaction data, customer purchase history, and item associations. By analyzing large datasets, businesses can uncover patterns and relationships between different products, which can then inform sales strategies, marketing efforts, and inventory management decisions.

For example, a retail store may find that customers who purchase smartphones frequently buy phone cases and screen protectors as well. Armed with this knowledge, the store can bundle these items together, offer a discount on the package, and prominently display them as a recommended combination, encouraging customers to make additional purchases.

By leveraging insights from product bundling or cross-selling, businesses can optimize their sales tactics, enhance customer experience, and drive revenue growth. It allows companies to better meet customer needs, increase sales opportunities, and remain competitive in the market.

```sql
-- 2 items
SELECT DISTINCT order_id,
(SELECT string_agg(product_id,',')
   FROM sales AS p
   WHERE order_id IN
		 ( SELECT order_id FROM
		  		(SELECT order_id,COUNT(*) AS Num_of_ords FROM sales group by order_id) orid
		  WHERE Num_of_ords = 2) AND
 p.order_id = s.order_id) AS product_id

FROM sales AS s order by product_id;
```

| order_id       | product_id                      |
| -------------- | ------------------------------- |
| CA-2017-161200 | FUR-BO-10000468,FUR-FU-10001706 |
| CA-2015-168480 | FUR-BO-10000468,OFF-AR-10001044 |
| CA-2016-156251 | FUR-BO-10001337,OFF-BI-10003529 |
| CA-2016-152688 | FUR-BO-10001337,OFF-BI-10004584 |
| CA-2016-152156 | FUR-BO-10001798,FUR-CH-10000454 |
| CA-2017-110198 | FUR-BO-10001798,OFF-LA-10004409 |
| US-2017-132059 | FUR-BO-10001811,TEC-AC-10003280 |
| CA-2016-123337 | FUR-BO-10001918,OFF-AP-10002287 |
| US-2017-121251 | FUR-BO-10001918,TEC-PH-10004896 |
| CA-2017-167381 | FUR-BO-10001972,OFF-LA-10000134 |

.....
<br>

```sql
-- 3 items
SELECT DISTINCT order_id,
(SELECT string_agg(product_id,',')
   FROM sales AS p
   WHERE order_id IN
		 ( SELECT order_id FROM
		  		(SELECT order_id,COUNT(*) AS Num_of_ords FROM sales group by order_id) orid
		  WHERE Num_of_ords = 3) AND
 p.order_id = s.order_id) product_id

FROM sales AS s order by 2;
```

| order_id       | product_id                                      |
| -------------- | ----------------------------------------------- |
| CA-2017-140326 | FUR-BO-10000112,OFF-PA-10004041,OFF-AR-10001149 |
| CA-2017-125472 | FUR-BO-10000330,OFF-BI-10000591,FUR-FU-10001731 |
| CA-2015-130785 | FUR-BO-10000330,OFF-BI-10001900,FUR-BO-10003159 |
| CA-2014-156349 | FUR-BO-10000362,TEC-PH-10000441,TEC-PH-10002726 |
| CA-2016-157707 | FUR-BO-10001567,TEC-PH-10002583,FUR-CH-10004853 |
| CA-2017-159149 | FUR-BO-10001601,OFF-AR-10000937,TEC-PH-10000038 |
| CA-2016-123533 | FUR-BO-10001619,OFF-PA-10001609,OFF-AP-10002765 |
| CA-2015-156482 | FUR-BO-10002598,FUR-CH-10001708,OFF-AR-10001022 |
| CA-2017-143574 | FUR-BO-10002598,OFF-SU-10002537,FUR-FU-10003976 |
| CA-2017-143259 | FUR-BO-10003441,TEC-PH-10004774,OFF-BI-10003684 |
| CA-2015-105690 | FUR-BO-10003965,OFF-LA-10000240,TEC-CO-10001571 |
| CA-2016-123512 | FUR-BO-10004218,OFF-LA-10000081,OFF-PA-10001497 |
| CA-2015-147788 | FUR-BO-10004357,OFF-LA-10003766,OFF-ST-10000046 |

---

### Visualization (KPI Report)

KPI stands for Key Performance Indicator. It is a quantifiable metric used to evaluate the success or performance of an organization, project, or individual in achieving specific objectives. KPIs are essential in measuring progress toward goals and providing valuable insights into the effectiveness of strategies and processes.

<br>

KPIs can vary depending on the industry, department, or goals of the organization. For example, in sales, KPIs may include metrics like revenue, conversion rate, or customer acquisition cost. In customer service, KPIs could involve response time, customer satisfaction ratings, or issue resolution time.

<br>

The selection of KPIs is crucial because they act as benchmarks that help organizations make data-driven decisions. KPIs provide a clear understanding of performance trends and can highlight areas that require improvement. By regularly tracking and analyzing KPIs, businesses can identify strengths, weaknesses, and opportunities to optimize their operations and achieve greater success.

<br>
Examples:
In this notebook, we use the analysis in the previous chapter to creat visuals that are more understandable and readable i.e.

### (Viz1) Check for the sales trends through the years (2014-2017).

![image4](./images/Screenshot%202023-08-01%20204755.png)

### (Viz2) Check the difference in sales by shiping mode.

![image5](./images/Screenshot%202023-08-01%202048261.png)

### (Viz3) Check for the difference in Sales and Profit by consumer segment.

![image6](./images/Screenshot%202023-08-01%20204858.png)

### (Viz4) Check for the top selling product category.

![image7](./images/Screenshot%202023-08-01%20204929.png)

### (Viz5) The KPI Daashboard.

A KPI dashboard is a visual tool that presents Key Performance Indicators (KPIs) in a concise and easy-to-understand format. It provides a real-time overview of an organization's performance, helping stakeholders monitor progress and make data-driven decisions quickly.

![image1](./images/Screenshot%202023-08-01%20204721.png)

<br>

This article delves into the power of sales analysis through the lens of RFM (Recency, Frequency, Monetary Value) and KPI (Key Performance Indicators). It highlights how RFM analysis allows businesses to understand customer behavior and segmentation, leading to personalized strategies and improved customer retention. The article also emphasizes the significance of KPIs in measuring sales performance, guiding decision-making, and optimizing marketing efforts. Together, RFM and KPI form a dynamic duo, empowering businesses to unlock valuable insights, enhance sales strategies, and achieve data-driven success.

<br>
Thanks for coming this long....
<br>
If you like what you read, consider subscribing to my newsletter.

<br>

Find me on [GitHub](github.com/kennytheanalystt), [Twitter](twitter.com/Kennytheanalys)
