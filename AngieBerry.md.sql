
--CREATING TABLES FOR ANGIE BERRY'S DATABASE

create Table customer
(customer_id int primary key,
 first_name varchar (35),
 last_name varchar(35)
);

--load data into customer using copy command
copy customer FROM 
'C:\Program Files\PostgreSQL\Customers.csv' delimiter ',' csv header;

--To view customer table 
SELECT * FROM customer

create table employee 
(employee_id int primary key,
 first_name varchar (35),
 last_name varchar (35),
 start_date date,
 end_date date
);
--load data into employee using command copy
copy employee FROM 
'C:\Program Files\PostgreSQL\Employees.csv' delimiter ',' csv header;

-- To view employee table
select * from employee

create table product(
	product_id int primary key,
	name varchar (35),
	price float,
	unit varchar 
);
--load data into product using command copy
copy product from
'C:\Program Files\PostgreSQL\Products.csv' delimiter ',' csv header;

--To view table product
select * from product

create table transaction (
	transaction_id varchar (16),
	customer_id int,
	product_id int,
	quantity int,
	paid_at timestamp,
	Amount int
);

--load data into transaction using copy command
copy transaction from 
'C:\Program Files\PostgreSQL\Transactions.csv' delimiter ',' csv header;

SET datestyle = dmy;

--To view table transaction
select * from transaction


--- BUSINESS REQUIREMENTS 

--1. Angie's berry corner's average daily sales volume

SELECT 
	round(AVG(quantity)) AS avg_quantity_sales_per_day,
	round(AVG(amount)) AS avg_amount
FROM transaction;

--2.  Which products sell best

 SELECT
 p.product_id, p.name,
 SUM (quantity) AS total_quantity,
 SUM(amount) AS total_amt
 FROM product p INNER JOIN transaction t ON 
 p.product_id = t.product_id
 GROUP BY 1
 ORDER BY 4,3 DESC
 LIMIT 5;
 
 --3. Top 5 angie loyalty customer
 
 SELECT c.customer_id,
 		t.amount,
 		concat(first_name, ' ',last_name) AS full_name, 
		SUM(amount) AS total_amt,
		2*(amount) AS loyalty_pt 
		FROM customer c INNER JOIN transaction t ON 
		c.customer_id = t.customer_id
		GROUP BY 1,2,3
		ORDER BY 5 DESC
		LIMIT 5;
		
--4. What is the full name of their current staff

SELECT employee_id,
	   first_name,
	   last_name,
	   concat(first_name,' ', last_name) AS full_name
FROM employee
WHERE end_date IS null;

--5. What is the product that generate the least income and by how much

 SELECT p.product_id, p.name,
 		SUM(amount) as total_income
FROM transaction t INNER JOIN product p 
 		ON t.product_id = p.product_id
		GROUP BY 1
 		ORDER BY 3
 		LIMIT 1;
		
--6. The organization want to ascertain the income realize from sales

SELECT 
		SUM (amount) AS total_Sales_income 
FROM 	transaction;


--7. The organization want to ascertain the amount they generate from each product

SELECT p.product_id, p.name,
	   SUM(amount) AS total_amt
FROM product p INNER JOIN transaction t 
ON p.product_id = t.product_id
	   GROUP BY 1
	   ORDER BY 3;
	 
	 
--8. Product that generate the highest income and by how much 

SELECT p.product_id, p.name,
	   SUM(amount) AS total_income
FROM transaction t INNER JOIN product p 
ON t.product_id = p.product_id
	  GROUP BY 1
	   ORDER BY 3 DESC
	 LIMIT 1;
	   

--9. The organization is looking at identifying the customer that patronize 
--them the most in order for them to encourage them with a gift
--*Tips: purchase frequency, average purchase amount, lack of returns, response to survey requests, positive reviews on surveys, and posting positive opinions on social media*  

 
 SELECT c.customer_id, concat(first_name, ' ',last_name) AS full_name,
 		round(AVG (amount)) AS avg_purchase 
FROM transaction t INNER JOIN customer c 
     ON t.customer_id = c.customer_id
	  GROUP BY 1
	 ORDER BY 3 DESC
	 LIMIT 5;
 			
--10. Which customer generate least income and by how much?

SELECT c.customer_id, concat(first_name, ' ',last_name),
	   SUM(amount) AS customer_income
FROM transaction t INNER JOIN customer c 
	 on t.customer_id = c.customer_id
	 GROUP BY 1
	 ORDER BY 3
	LIMIT 5;
	 
--11. Which of the employee spend the least day at angie

SELECT employee_id, concat(first_name, ' ',last_name) as full_name, 
		start_date, 
		end_date,
		((end_date - start_date) + 1) as least_day
FROM employee
GROUP BY 1,2,3,4
HAVING end_date IS NOT Null
ORDER BY 5
LIMIT 1;				
				
				
--12. What is the organization busiest hour?  
	
 SELECT Date_part ('hour', paid_at) AS buzy_time,
		SUM (amount)
		FROM transaction
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1;
		
--13. Which day of the week does the organization sales the most
								
SELECT date_part('dow', paid_at) AS week_day,
		SUM(amount) AS sales
FROM   transaction 
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1;
---The output gave 6, which iterally means FRIDAY
				
				
---14. Which month of the year does the organization makes the most sales
  
SELECT date_part ('month', paid_at) AS most_sales_month,
		SUM(amount) AS sales
FROM  transaction 
	    GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1;		
--- The output gave 7, which literally denotes JULY
				
				
	
