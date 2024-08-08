use classicmodels;

select * from customers;

## Day 3(1)
select customernumber, customername, state, creditlimit from customers 
where state is not null and creditlimit between 50000 and 100000  order by creditlimit desc;

## Day 3(2)
select * from productlines;
select productline from productlines where productline like "% cars";

## Day 4(1)
select ordernumber, status, COALESCE (comments,"-") as comments from orders;

## Day 4(2)
Select employeeNumber, firstName, jobTitle,
CASE
	When jobTitle = 'President' then 'P'
	When jobTitle Like 'Sales Manager%' or jobTitle like 'Sale Manager%' then 'SM'
	When jobTitle = 'Sales Rep' then 'SR'
	When jobTitle Like '%VP%' 
    then 'VP'
end as jobTitle_abbr
from employees
end;

## Day 5(1)
SELECT * FROM payments;
select year(paymentDate) as pay_year, min(amount) as min_amount from payments
group by year(paymentDate) Order by pay_year;

## Day 5(2)
SELECT * FROM orders;

SELECT YEAR(orderDate) AS order_year,
CASE
	WHEN QUARTER(orderDate) = 1 THEN 'Q1'
	WHEN QUARTER(orderDate) = 2 THEN 'Q2'
	WHEN QUARTER(orderDate) = 3 THEN 'Q3'
	WHEN QUARTER(orderDate) = 4 THEN 'Q4'
END AS order_quarter,
COUNT(DISTINCT customerNumber) AS unique_customers,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_year, order_quarter
ORDER BY order_year, order_quarter;

## Day 5(3)
select * from payments;
select monthname(paymentDate) `Month`, concat(round(sum(amount)/1000),"K")as 
formatted_amount  from payments group by `Month` having sum(amount) 
between 500000 and 1000000 order by formatted_amount desc;

## Day 6(1)
CREATE TABLE journey_j (
	Bus_ID INT PRIMARY KEY NOT NULL,
    Bus_Name VARCHAR(50) NOT NULL,
    Source_Station VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

desc journey_j;

## Day 6(2)
CREATE TABLE Vendor (
    Vendor_ID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Country VARCHAR(50) DEFAULT 'N/A'
);
desc Vendor;


## Day 6(3)
CREATE TABLE Movies (
    Movie_ID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Release_Year VARCHAR(4) DEFAULT '-',
    Cast VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female'),
    No_of_shows INT CHECK (No_of_shows > 0)
);
desc Movies;

## Day 6(4)(1)
-- Creating the Suppliers table
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100),
    location VARCHAR(100)
);
desc Suppliers;

-- Creating the Product table
CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);
desc product;

-- Creating the Stock table
CREATE TABLE Stock (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
desc stock;

##Day 7(1)
WITH CTE as 
(select salesRepEmployeeNumber,count(*) as unique_customers from customers group by salesRepEmployeeNumber)
select employeeNumber, concat(firstName, " ", lastName) as Sales_Person, unique_customers  from employees join CTE
on CTE.salesRepEmployeeNumber = employees.employeeNumber order by unique_customers desc;


##Day 7(2)
select  c.customerNumber, c.customerName ,p.productCode, productName, quantityOrdered as `Ordered Qty`, 
quantityInStock as `Total Inventory`, quantityInStock - quantityOrdered as `Left Qty` from 
orderdetails as o join products as p join orders as ord on ord.orderNumber = o.orderNumber join 
customers c on c.customerNumber = ord.customerNumber order by c.customerNumber; 

SELECT c.customerNumber, c.customerName, p.productCode,p.productName, SUM(od.quantityOrdered) AS OrderedQuantity,
p.quantityInStock AS TotalInventry, (p.quantityInStock - SUM(od.quantityOrdered)) AS LeftQuantity
FROM Customers c
JOIN Orders o ON c.customerNumber = o.customerNumber
JOIN Orderdetails od ON o.orderNumber = od.orderNumber
JOIN Products p ON od.productCode = p.productCode
GROUP BY c.customerNumber, p.productCode
ORDER BY c.customerNumber;


## Day 7(3)

CREATE TABLE Laptop (
Laptop_Name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Colours (
Colour_Name VARCHAR(20) PRIMARY KEY
);

INSERT INTO Laptop (Laptop_Name) VALUES ('HP'), ('DELL');

INSERT INTO Colours (Colour_Name) VALUES ('WHITE'), ('SILVER'), ('BLACK');

    
-- Find the number of rows
SELECT COUNT(*) AS No_laptp 
FROM Laptop
CROSS JOIN Colours;

-- Shows all columns
SELECT * FROM Laptop
CROSS JOIN Colours
ORDER BY Laptop_Name ,COLOUR_NAME DESC;


## Day 7(4)
CREATE TABLE Project (EmployeeID INT PRIMARY KEY, FullName VARCHAR(50), Gender VARCHAR(10),ManagerID INT);

INSERT INTO Project (EmployeeID, FullName, Gender, ManagerID) VALUES
(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);

SELECT * FROM Project;
-- Find out the names of employees and their related managers
SELECT 
	m.FullName AS ManagerName,
    e.FullName AS EmployeeName
FROM Project e
LEFT JOIN Project m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IS NOT NULL
ORDER BY ManagerName;


## Day 8
CREATE TABLE facility (Facility_ID INT, Name VARCHAR(100), State VARCHAR(100), Country VARCHAR(100));
ALTER TABLE facility ADD PRIMARY KEY (Facility_ID);
ALTER TABLE facility MODIFY COLUMN Facility_ID INT AUTO_INCREMENT;
ALTER TABLE facility ADD City VARCHAR(100) NOT NULL AFTER Name;
desc facility;


## Day 9
CREATE TABLE university (ID INT, Name VARCHAR(255));
INSERT INTO University VALUES (1, "       Pune          University     "), (2, "  Mumbai          University     "),
(3, "     Delhi   University     "), (4, "Madras University"), (5, "Nagpur University");
SELECT * FROM university;
UPDATE University SET Name = TRIM(BOTH ' ' FROM Name);
UPDATE University set name = REGEXP_REPLACE(Name, '[[:space:]]+', ' ');
SELECT * FROM university;


## Day 10
Create view product_Status as 
(WITH CTE_02 as
(WITH CTE_01 as 
(select o.orderNumber, year(orderDate) as 'Year', count(o.orderNumber) as `val` 
from orderdetails as o join orders as ord on o.orderNumber = ord.orderNumber group by o.orderNumber)
select Year, sum(val) as `Value` from CTE_01 group by Year)
select Year, concat(value, "(", round(Value*100/sum(value) over()), ")", "%") as `Value` from CTE_02) order by value ;


## Day 11(1)
#Stored Procedure
/*
CREATE PROCEDURE `GetCustomerLevel`(cid int)
BEGIN
declare x int default 0;
set x = (select creditLimit from customers where customerNumber = cid);
if x <25000 then
select "Silver" as Result;
elseif x between 25000 and 100000 then
select "Gold" as Result;
elseif x >100000 then
select "Platinum" as Result;
end if;
END
*/


## Day 11(2)
/*
CREATE PROCEDURE `Get_Country_Payments`(`Mention_Year` int, `Mention_Country` varchar(20))
BEGIN
WITH CTE as
(select year(paymentDate) as `Year`, country  , amount from customers c join payments p on c.customerNumber = p.customerNumber)
select `Year` , country, concat(round(sum(amount)/1000),"K") as TotalAmount from CTE group by `Year`, country having `Year` = `Mention_Year` and country = `Mention_Country`;
END
*/


## Day 12(1)
WITH CTE as
(select year(orderDate) as `Year`, monthname(orderDate) as `Month`, count(CustomerNumber) as Ttl_Orders 
from orders group by year(orderDate), monthname(orderDate))
select `Year`, `Month`, concat(round((Ttl_orders - lag(Ttl_Orders) 
over(Partition by `Year`))*100/lag(Ttl_Orders) over(Partition by `Year`)), "%") as Total_Orders from CTE;



## Day 12(2)
create table emp_udf(emp_id int primary key auto_increment, `Name` varchar(20), DOB Date);
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
select *, age(emp_id) from emp_udf;


## Day 13(1)
select customerNumber, customerName from customers where customerNumber 
not in (select customerNumber from orders group by customerNumber);


## Day 13(2)
select * from customers;
select * from orders;
select c.customerNumber, c.customerName, count(o.customerNumber) from customers c join orders o on 
c.customerNumber = o.customerNumber group by o.customerNumber;


## Day 13(3)
WITH CTE as
(select *, dense_rank() over(partition by orderNumber order by quantityOrdered desc) as rnk from orderdetails)
select orderNumber, quantityOrdered from CTE where rnk = 2;


## Day 13(4)
WITH CTE as
(select orderNumber, count(orderNumber) as Total from orderDetails group by orderNumber)
select max(Total), min(Total) from CTE;


## Day 13(5)
SELECT ProductLine, COUNT(*) AS Total
FROM Products
WHERE BuyPrice > (SELECT AVG(BuyPrice) FROM Products)
GROUP BY ProductLine;


## Day 14
CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(100)
);

DELIMITER //
DELIMITER $$

CREATE PROCEDURE InsertEmp_EH(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(50),
    IN p_EmailAddress VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error occurred' AS Message;
    END;

    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);

    SELECT 'Data inserted successfully' AS Message;
END $$

DELIMITER ;



## Day 15
CREATE TABLE Emp_BIT (
    Name VARCHAR(50),
    Occupation VARCHAR(50),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER $$

CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END;
$$

DELIMITER ;