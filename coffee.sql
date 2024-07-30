create database coffee_sales;
select * from coffee; 
describe coffee;
-- Data Cleaning
select transaction_date,STR_TO_DATE(transaction_date,'%d-%m-%Y')from coffee;
UPDATE coffee
SET transaction_date=STR_TO_DATE(transaction_date,'%d-%m-%Y');
ALTER TABLE coffee
MODIFY COLUMN transaction_date DATE;

select transaction_time,STR_TO_DATE(transaction_time,'%H:%i:%s')from coffee;
UPDATE coffee
SET transaction_time=STR_TO_DATE(transaction_time,'%H:%i:%s');
ALTER TABLE coffee
MODIFY COLUMN transaction_time time;

ALTER TABLE coffee
CHANGE COLUMN ï»¿transaction_id transaction_id INT;

DESCRIBE coffee;
-- MONTH WISE TOTAL SALES
SELECT  month(transaction_date),ROUND(SUM(unit_price*transaction_qty),1) FROM 
coffee 
group by MONTH(transaction_date);

-- MONTH ON MONTH INCREASE AND DECRESE IN SALES
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
-- TOTAL ORDER PER MONTH
SELECT month(transaction_date),COUNT(transaction_id) AS TOTAL_ORDER
FROM coffee
group by month(transaction_date);

-- MONTH ON MONTH INCREASE AND DECRESE IN ORDER
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_sales,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
-- TOTAL ORDER PER MONTH
SELECT month(transaction_date),SUM(transaction_qty) AS TOTAL_QNT
FROM coffee
group by month(transaction_date);

-- MONTH ON MONTH INCREASE AND DECRESE IN SALES
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_sales,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
-- DAILY SALES OF PARTICULAR MONTH
SELECT transaction_date,SUM(unit_price * transaction_qty) AS SALES
FROM coffee
WHERE month(transaction_date)=05
GROUP BY transaction_date;

SELECT avg(sum(unit_price * transaction_qty))OVER() FROM coffee;

SELECT transaction_date,
CASE
WHEN T_SALES > AVG_SALES THEN "ABOVE AVERAGE"
WHEN T_SALES < AVG_SALES THEN "BELOW AVERAGE"
ELSE "AVERAGE"
END AS SALES_STATUS
FROM(SELECT transaction_date,SUM(unit_price * transaction_qty) AS T_SALES,
AVG(SUM(unit_price * transaction_qty)) OVER() AS AVG_SALES
FROM coffee
WHERE month(transaction_date)=05
GROUP BY transaction_date)AS ST;

-- SALES BY PRODUCT CATEGORY OF PARTICULAR MONTH
SELECT product_category,SUM(unit_price * transaction_qty) 
FROM coffee
WHERE month(transaction_date)=05
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC ;

-- SALES BY WEEKDAY / WEEKEND:
SELECT 
CASE 
WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
ELSE 'Weekdays'
END AS day_type,
ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM coffee
WHERE MONTH(transaction_date) = 5
GROUP BY day_type;
-- TOP 10 PRODUCT BY SALES
SELECT  product_type,SUM(unit_price * transaction_qty)AS SALES
FROM coffee
WHERE month(transaction_date)=05
GROUP BY product_type
order by SUM(unit_price * transaction_qty) DESC
LIMIT 10
;
-- DAY|HOUR WISE SALES
select hour(transaction_time),SUM(unit_price * transaction_qty) AS SALES,
COUNT(transaction_id)AS NO_ORDER,SUM(transaction_qty) AS QTY
FROM coffee
WHERE dayofweek(transaction_date)=1 AND month(transaction_date)=05 -- sunday sales of month may
group by hour(transaction_time)
order by  hour(transaction_time) ;



 







