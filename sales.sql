SELECT * FROM sales LIMIT 10

--

ALTER TABLE sales ALTER column order_date type date using order_date::date
SELECT EXTRACT(YEAR FROM order_date) FROM sales
SELECT EXTRACT(MONTH FROM order_date) FROM sales
ALTER TABLE sales ADD year INT
ALTER TABLE sales ADD month INT
UPDATE sales SET year = EXTRACT(YEAR FROM order_date)
UPDATE sales SET month = EXTRACT(MONTH FROM order_date)

--
SELECT DISTINCT year FROM sales  
--
SELECT DISTINCT ship_mode FROM sales
--
SELECT DISTINCT segment FROM sales
--
SELECT DISTINCT region FROM sales
--
SELECT DISTINCT category FROM sales
--
-- prudct with most sales through 2014-2017
SELECT sub_category, ROUND(SUM(sales)) AS sales 
	FROM sales
  	GROUP BY sub_category 
	ORDER BY sales DESC 
--
-- prudct with most profit through 2014-2017
SELECT sub_category, ROUND(SUM(profit)) AS profit 
	FROM sales
  	GROUP BY sub_category 
	ORDER BY profit DESC

-- year with most sales through 2014-2017
SELECT year, ROUND(SUM(sales)) AS sales 
	FROM sales
  	GROUP BY year 
	ORDER BY sales DESC 
--
-- Sales and Profit by consumer Segment...
SELECT segment, COUNT(order_id) AS total_orders, 
	   ROUND(SUM(SALES)) AS total_sales, ROUND(SUM(profit)) AS total_profit
FROM sales GROUP BY segment ORDER BY total_profit DESC

-- Sales and Profit by consumer Segment...
SELECT region, COUNT(order_id) AS total_orders, 
	   ROUND(SUM(SALES)) AS total_sales, ROUND(SUM(profit)) AS total_profit
FROM sales GROUP BY region ORDER BY total_profit DESC

/* what was the best month for sales in a specific year ? 
   what's sales for the month? */
-- 2014
SELECT month,ROUND(SUM(sales)) AS revenue_for_2014,
	   COUNT(order_id) AS total_orders, SUM(quantity) AS total_quantity_order 
	FROM sales
	WHERE year = 2014
 	GROUP BY month 
	ORDER BY revenue_for_2014 DESC
 
-- 2015
SELECT month,ROUND(SUM(sales)) AS sales_for_2015,
	   COUNT(order_id) AS total_orders, SUM(quantity) AS total_quantity_order 
	FROM sales
	WHERE year = 2015
 	GROUP BY month 
	ORDER BY sales_for_2015 DESC

-- 2016
SELECT month,ROUND(SUM(sales)) AS sales_for_2016,
	   COUNT(order_id) AS total_orders, SUM(quantity) AS total_quantity_order 
	FROM sales
	WHERE year = 2016
 	GROUP BY month 
	ORDER BY sales_for_2016 DESC

-- 2017
SELECT month,ROUND(SUM(sales)) AS sales_for_2017,
	   COUNT(order_id) AS total_orders, SUM(quantity) AS total_quantity_order 
	FROM sales
	WHERE year = 2017
 	GROUP BY month 
	ORDER BY sales_for_2017 DESC

-- base on product
-- 2014
SELECT month, sub_category, ROUND(SUM(sales)) AS sales_for_2014,
	   ROUND(SUM(profit)) AS profit_for_2014, SUM(quantity) total_quantity_orders 
	   FROM sales
 	   WHERE year = 2014 and month = 11
       GROUP BY month, sub_category 
	   ORDER BY sales_for_2014 DESC
-- 2015
SELECT month, sub_category, ROUND(SUM(sales)) AS sales_for_2015,
	   ROUND(SUM(profit)) AS profit_for_2015,SUM(quantity) total_quantity_orders 
	   FROM sales
 	   WHERE year = 2015 and month = 11
       GROUP BY month, sub_category 
	   ORDER BY sales_for_2015 DESC
-- 2016
SELECT month, sub_category, ROUND(SUM(sales)) AS sales_for_2016,
	   ROUND(SUM(profit)) AS profit_for_2016,SUM(quantity) total_quantity_orders 
	   FROM sales
 	   WHERE year = 2016 and month = 11
       GROUP BY month, sub_category 
	   ORDER BY sales_for_2016 DESC
-- 2017
SELECT month, sub_category, ROUND(SUM(sales)) AS sales_for_2017,
	   ROUND(SUM(profit)) AS profit_for_2017,SUM(quantity) total_quantity_orders 
	   FROM sales
 	   WHERE year = 2017 and month = 11
       GROUP BY month, sub_category 
	   ORDER BY sales_for_2017 DESC
--
SELECT ROUND(SUM(sales)) AS total_sales, ROUND(SUM(profit)) AS total_profit
FROM sales

RFM analysis
Explain waht rfm analysis is

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
 ORDER BY quantity_order DESC
 
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
 ORDER BY quantity_order DESC
--
-- ranking the recency, frequency, and monetary from high to low
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
/* concatinating the rfm values as string and as integer, this will allow us to classify 
our customer from lost to loyal customer */
 select 
     rfm_calc.*, rfm_recency + rfm_frequency + rfm_monetary AS rfm_cell,
	 concat (rfm_recency,rfm_frequency,rfm_monetary) AS rfm_cell_string
	into rfm
	from rfm_calc
--	
SELECT * FROM rfm
--
SELECT customer_name,rfm_recency,rfm_frequency,rfm_monetary,
   CASE 
     WHEN rfm_cell_string IN('111','122','121','124','134','113','222','133','114','123','112','212','211') THEN 'lost customers'
	 WHEN rfm_cell_string IN('312','322','321','223','234','223','241','143','142','244','313','144','233','213','322') THEN 'Sliping customers'
	 WHEN rfm_cell_string IN('411','422','423','421','424','413','412','323','311') THEN 'new customers'
	 WHEN rfm_cell_string IN('344','431','343','333','332','433','442','444','432','443','434','334') THEN 'loyal customers'
 END rfm_segment
FROM rfm
--


-- what two or more item are often sold together. 

SELECT DISTINCT order_id,
(SELECT string_agg(product_id,',') 
   FROM sales AS p 
   WHERE order_id IN 
		 ( SELECT order_id FROM 
		  		(SELECT order_id,COUNT(*) AS Num_of_ords FROM sales group by order_id) orid 
		  WHERE Num_of_ords = 2) AND 
 p.order_id = s.order_id) product_id

FROM sales AS s order by 2

--
-- what three item are often sold together. 

SELECT DISTINCT order_id,
(SELECT string_agg(product_id,',') 
   FROM sales AS p 
   WHERE order_id IN 
		 ( SELECT order_id FROM 
		  		(SELECT order_id,COUNT(*) AS Num_of_ords FROM sales group by order_id) orid 
		  WHERE Num_of_ords = 3) AND 
 p.order_id = s.order_id) product_id

FROM sales AS s order by 2
