create database superstore;
use superstore

select * from Customer$
select * from Orders$
select * from People$
select * from Region$
select * from Returns$
select * from Product$
-------
--Ques 1 : Display the top 5 customers who generated the highest profit for the company--
SELECT TOP 5 c.[Customer ID],
 c.[Customer Name],
 SUM(o.profit) AS total_profit
FROM Customer$ c
INNER JOIN Orders$ o 
ON c.[Customer ID] = o.[Customer ID]
GROUP BY c.[Customer ID], c.[Customer Name]
ORDER BY total_profit DESC;

--Ques 2 : Display the top 10 most profitable product categories.--
SELECT TOP 10
    p.[Product ID],
    p.Category,
    SUM(o.profit) AS total_profit
FROM 
    Product$ p
INNER JOIN 
    Orders$ o ON p.[Product ID] = o.[Product ID]
GROUP BY 
    p.[Product ID],p.Category
ORDER BY 
    total_profit DESC;

select top 10 p.Category,sum(o.Profit) from Orders$ as o inner join Product$ p on (o.[Product ID]=p.[Product ID]) group by Category order by sum(Profit) desc;

--Ques 3 : Display the number of orders that were shipped late for each region.---
select c.Region,
count(DATEDIFF(DAY,o.[Order Date],o.[Ship Date])) as late_orders from Orders$ o 
join 
Customer$ c
on o.[Customer ID] = c.[Customer ID]
where DATEDIFF(DAY,o.[Order Date],o.[Ship Date]) >4 
group by Region

--Ques 4 : Display the average sales per customer for each region.--

select avg(Sales) as avg_sales,c.Region from Orders$ o
join Customer$ c
on o.[Customer ID] = c.[Customer ID]
group by Region


--Ques 5 : Display the number of unique customers per region who made at least one purchase.--

select COUNT(distinct o.[Customer ID]),
c.Region 
from Orders$ o
join Customer$ c
on o.[Customer ID] = c.[Customer ID]
group by Region

--Ques  6 : Display the top 5 cities with the highest average profit per order.--
SELECT TOP 5
    c.[City],
    avg(o.profit) AS avg_profit
FROM 
    Customer$ c
INNER JOIN 
    Orders$ o ON c.[Customer ID] = o.[Customer ID]
GROUP BY 
    c.[City]
ORDER BY 
    avg_profit DESC;

--Ques  7 : Display the number of orders for each subcategory in the "Technology" category.--
select count(o.[Product ID]),p.[Sub-Category] from Orders$ o
join Product$ p
on o.[Product ID] = p.[Product ID]
where p.Category = 'Technology' 
group by p.[Sub-Category]

--Ques 8 : Display the number of unique customers who made a purchase in each city, but exclude customers who made less than 2 purchases.
select c.city,count(distinct o.[Customer ID]) from Orders$ o
join Customer$ c
on o.[Customer ID] = c.[Customer ID]
group by c.City
having count(o.[Customer ID]) >= 2

--Ques 9 : Display the total sales, returns, and profit for each subcategory and region, but exclude orders where the sales were less than $1000.
SELECT Customer$.Region, Product$.[Sub-Category],
	   SUM(Orders$.Sales) AS TOTAL_SALES,
	   COUNT(Returns$.Returned) AS TOTAL_RETURN,
	   SUM(Orders$.Profit) AS TOTAL_PROFIT
FROM Orders$
JOIN Product$ ON Orders$.[Product ID]= Product$.[Product ID]
JOIN Customer$ ON Orders$.[Customer ID] = Customer$.[Customer ID]
LEFT JOIN Returns$ ON Orders$.[Order ID] = Returns$.[Order ID]
WHERE Orders$.Sales >= 1000
GROUP BY Customer$.Region, Product$.[Sub-Category]
ORDER BY Customer$.Region
--QUES 10: Display the number of unique customers who made a purchase in each category and subcategory.--

SELECT p.category,
 p.[Sub-Category],
 COUNT(DISTINCT o.[Customer ID]) AS unique_customers
FROM Orders$ o
JOIN Product$ p ON o.[Product ID]= p.[Product ID]
GROUP BY 
    p.category, p.[Sub-Category]

--Ques 11: Display the average profit per order and the percentage of orders that were returned for each category and segment, but exclude orders where the sales were less than $100.
SELECT 
    p.category,
    c.segment,
    AVG(o.profit) AS average_profit_per_order,
    (COUNT( r.[Order ID]) * 100.0 / COUNT(o.[Order ID])) AS return_percentage
FROM 
   Orders$ o
JOIN 
    Customer$ c ON o.[Customer ID] = c.[Customer ID]
JOIN 
    Product$ p ON o.[Product ID] = p.[Product ID]
JOIN 
    Returns$ r ON o.[Order ID] = r.[Order ID]
WHERE 
    o.sales >= 100
GROUP BY 
    p.category, c.segment;


--Ques 12  : Display the percentage of orders that were returned for each region and category.--
SELECT 
    c.region,
    p.category,
    COUNT(r.[Order ID]) * 100.0 / COUNT(*) AS return_percentage
FROM 
   Orders$ o
JOIN 
   Product$ p ON o.[Product ID] = p.[Product ID]
JOIN 
    Customer$ c ON o.[Customer ID] = c.[Customer ID]
JOIN 
   Returns$ r ON o.[Order ID] = r.[Order ID]
GROUP BY 
    c.region, p.category
	
--Ques 13 : Display the average revenue per order for each region.--
SELECT 
    c.region,
    AVG(o.sales) AS avg_revenue_per_order
FROM 
   Orders$ o
JOIN 
    Customer$ c ON o.[Customer ID] = c.[Customer ID]
GROUP BY 
    c.region;

--QUES 14: Retrieve the total sales and profit for each subcategory and brand combination, including only those orders that were not returned and were made by customers in East region.--
SELECT p.[Sub-Category],
    SUM(o.sales) AS total_sales,
    SUM(o.sales - o.profit) AS total_profit
FROM Orders$ o
JOIN Product$ p 
ON o.[Product ID] = p.[Product ID]
JOIN Customer$ c 
ON o.[Customer ID] = c.[Customer ID]
WHERE c.region = 'East' 
AND o.[Order ID]  IN (SELECT [Order ID] FROM Returns$)
GROUP BY  p.[Sub-Category]


--QUES 15: Retrieve the top 10 products by total profit, including only those orders that were not returned.
SELECT Top 10 p.[Product ID],
p.[Product Name],
SUM(o.sales - o.profit) AS total_profit
FROM Orders$ o
JOIN Product$ p 
ON o.[Product ID] = p.[Product ID]
WHERE o.[Order ID] NOT IN (SELECT [Order ID] FROM Returns$)
GROUP BY 
    p.[Product ID], p.[Product Name]
ORDER BY total_profit DESC


---Ques 16: Retrieve the total sales and profit for each brand in each subcategory.
select p.[Sub-Category],p.[Product Name],sum(o.Sales) as TotalSales ,sum(o.Profit) as TotalProfit
from Orders$ o
join Product$ p
on o.[Product ID] = p.[Product ID]
group by p.[Sub-Category],p.[Product Name]

--QUES 17: Retrieve the top 10 states by total sales, including only those orders that were not returned.
select top 10 sum(o.sales) as totalsales,c.State from Orders$ o
join Customer$ c
on o.[Customer ID] = c.[Customer ID]
WHERE o.[Order ID] NOT IN (SELECT [Order ID] FROM Returns$)
GROUP BY c.state
order by totalsales desc 


--Ques 18: Retrieve the top 10 customers who have made the most returns, along with the total value of their returns.

SELECT TOP 10
    c.[Customer ID],
    c.[Customer Name],
    COUNT(r.[Order ID]) AS total_returns,
    SUM(o.sales) AS total_return_value
FROM Returns$ r
JOIN Orders$ o 
ON r.[Order ID] = o.[Order ID]
JOIN Customer$ c 
ON o.[Customer ID] = c.[Customer ID]
GROUP BY 
    c.[Customer ID], c.[Customer Name]
ORDER BY 
    total_returns DESC


-- QUES 19: Retrieve the average sales per order for each subcategory, only for orders that were shipped using a  First Class ship mode.
select avg(o.Sales),[Sub-Category] from Orders$ o
join Product$ p
on o.[Product ID] = p.[Product ID]
where [Ship Mode] = 'First Class'
group by p.[Sub-Category]


--QUES 20: Retrieve the number of orders made by each brand in central region
select p.[Product Name],count(o.[Order ID]) from Orders$ o
join Customer$ c
on o.[Customer ID] = c.[Customer ID]
join Product$ p 
on (o.[Product ID]=p.[Product ID])
where Region = 'Central'
group by p.[Product Name]


--QUES 21: Retrieve the number of orders made by each customer segment in New Mexico.
select c.segment,count(o.[Order ID]) from Orders$ o
join Customer$ c
on o.[Customer ID] = c.[Customer ID]
where State = 'New Mexico'
GROUP BY c.segment;

--QUES 22: Retrieve the number of orders that were returned for each product subcategory .
select count(r.[Order ID]) as returns,p.[Sub-Category] from Returns$ r
join Orders$ o
on o.[Order ID] = r.[Order ID]
join Product$ p
on p.[Product ID] = o.[Product ID]
group by p.[Sub-Category]

--QUES 23: What is the maximum discount ever given?---
select max(discount) from Orders$

--QUES 24: What are the different shipping modes? ---
select distinct [Ship Mode] from Orders$

--QUES 25: Retrieve the maximum delay in shipping the order.---
select MAX(DATEDIFF(DAY,o.[Order Date],o.[Ship Date])) as Delay from Orders$ o 

