--													JOINS
-- 1)Get the firstname and lastname of the employees who placed orders between 15th August,1996 and 15th August,1997
SELECT FirstName , LastName
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
WHERE ord.OrderDate BETWEEN '1996-08-15' AND '1997-08-15'
GROUP BY emp.EmployeeID, emp.FirstName, emp.LastName;

-- 2) Get the distinct EmployeeIDs who placed orders before 16th October,1996
SELECT DISTINCT emp.EmployeeID 
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
WHERE ord.OrderDate < '1996-10-16' ;

-- 3)  How many products were ordered in total by all employees between 13th of January,1997 and 16th of April,1997.
SELECT COUNT(*) As Total_no_of_products
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
WHERE ord.OrderDate BETWEEN '1997-01-13' AND '1997-04-16';

--4)What is the total quantity of products for which Anne Dodsworth placed orders between 13th of January,1997 and 16th of April,1997.
SELECT sum(Quantity) AS 'Total_Quantity'
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
JOIN OrderDetails ordDetails
ON ord.OrderID = ordDetails.OrderID
WHERE (emp.FirstName='Anne' AND emp.LastName = 'Dodsworth') AND (ord.OrderDate BETWEEN '1997-01-13' AND '1997-04-16') ;

--5)  How many orders have been placed in total by Robert King
SELECT count(*) AS 'Total_Orders'
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
WHERE (emp.FirstName='Robert' AND emp.LastName = 'King');

--6)  How many products have been ordered by Robert King between 15th August,1996 and 15th August,1997
SELECT COUNT( DISTINCT ProductID) AS Total_Products
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
JOIN OrderDetails ordDetails
ON ord.OrderID = ordDetails.OrderID
WHERE (emp.FirstName='Robert' AND emp.LastName = 'King') AND (ord.OrderDate BETWEEN '1996-08-15' AND '1997-08-15') ;

--7) I want to make a phone call to the employees to wish them on the occasion of Christmas who placed 
-- orders between 13th of January,1997 and 16th of April,1997. I want the EmployeeID, Employee Full Name, 
-- HomePhone Number.
SELECT DISTINCT emp.EmployeeID, emp.FirstName + ' '+ emp.LastName AS Full_Name, emp.HomePhone
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
WHERE ord.OrderDate BETWEEN '1997-01-13' AND '1997-04-16' ;

--8) Which product received the most orders. Get the product's ID and Name and number of orders it received.
SELECT  TOP 1 WITH TIES ord.ProductID, p.ProductName, COUNT(*) AS No_of_Orders
FROM OrderDetails ord
JOIN products p
ON ord.ProductID = p.ProductID
GROUP BY ord.ProductID,p.ProductName
ORDER BY No_of_Orders DESC;

--9) Which are the least shipped products. List only the top 5 from your list.
SELECT TOP 5 p.ProductID, COUNT(ShipperID) AS Least_Shipped
FROM Orders ord
JOIN OrderDetails orddetails
ON ord.OrderID = orddetails.OrderID
JOIN Products p
ON orddetails.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER by Least_Shipped;

--10) What is the total price that is to be paid by Laura Callahan for the order placed on 13th of January,1997
SELECT (orddetails.UnitPrice * orddetails.Quantity) - ((orddetails.UnitPrice * orddetails.Quantity)*orddetails.Discount) AS total_price
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
JOIN OrderDetails orddetails
ON ord.OrderID = orddetails.OrderID
WHERE (FirstName = 'Laura' AND LastName = 'Callahan') AND (ord.OrderDate = '1997-01-13');

--11)  How many number of unique employees placed orders for Gorgonzola Telino or Gnocchi di nonna Alice or 
--Raclette Courdavault or Camembert Pierrot in the month January,1997
SELECT COUNT( DISTINCT emp.EmployeeID) AS Total_Unique_Employees
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
JOIN OrderDetails orddetails
ON ord.OrderID = orddetails.OrderID
JOIN Products p
ON orddetails.ProductID = p.ProductID
WHERE MONTH(ord.OrderDate) = 1 AND YEAR(ord.OrderDate) = 1997 AND p.ProductName IN ('Gorgonzola Telino','Gnocchi di nonna Alice','Raclette Courdavault','Camembert Pierrot');

--12) What is the full name of the employees who ordered Tofu between 13th of January,1997 and 30th of 
--January,1997
SELECT emp.LastName + ' ' + emp.FirstName AS Full_Name
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
JOIN OrderDetails orddetails
ON orddetails.OrderID = ord.OrderID
JOIN Products p
ON p.ProductID = orddetails.ProductID
WHERE p.ProductName = 'Tofu' AND (ord.OrderDate BETWEEN '1997-01-13' AND '1997-01-30');

--13) What is the age of the employees in days, months and years who placed orders during the month of 
-- August. Get employeeID and full name as well
SELECT DISTINCT emp.EmployeeID, emp.FirstName + ' ' + emp.LastName AS Full_Name,
				DATEDIFF(day, emp.BirthDate, GETDATE()) AS Age_In_Days,
                DATEDIFF(month, emp.BirthDate, GETDATE()) AS Age_In_Months,
				DATEDIFF(year, emp.BirthDate, GETDATE()) AS Age_In_Years	
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
WHERE MONTH(ord.OrderDate) = 8;

--14) Get all the shipper's name and the number of orders they shipped
SELECT ship.CompanyName, COUNT(ord.OrderID) AS No_of_orders_shipped
FROM Orders ord
JOIN Shippers ship
ON ord.ShipperID = ship.ShipperID
GROUP BY ship.CompanyName;

--15) Get the all shipper's name and the number of products they shipped
SELECT ship.CompanyName, COUNT(orddetails.ProductID) AS No_of_products
FROM Orders ord
JOIN Shippers ship
ON ord.ShipperID = ship.ShipperID
JOIN OrderDetails orddetails
ON orddetails.OrderID = ord.OrderID
GROUP BY ship.CompanyName;

--16) Which shipper has bagged most orders. Get the shipper's id, name and the number of orders.
SELECT TOP 1 WITH TIES ship.CompanyName, COUNT(ord.OrderID) AS No_of_orders_shipped
FROM Orders ord
JOIN Shippers ship
ON ord.ShipperID = ship.ShipperID
GROUP BY ship.CompanyName
ORDER BY No_of_orders_shipped DESC;

--17) Which shipper supplied the most number of products between 10th August,1996 and 20th 
--September,1998. Get the shipper's name and the number of products
SELECT TOP 1 WITH TIES ship.CompanyName, COUNT(orddetails.ProductID) AS No_of_products
FROM Orders ord
JOIN Shippers ship
ON ord.ShipperID = ship.ShipperID
JOIN OrderDetails orddetails
ON orddetails.OrderID = ord.OrderID
WHERE ord.OrderDate BETWEEN '1996-08-10' AND '1998-09-20'
GROUP BY ship.CompanyName
ORDER BY No_of_products DESC;

--18)  Which employee didn't order any product 4th of April 1997
SELECT * 
FROM Employee emp1
WHERE emp1.EmployeeID NOT IN (
								SELECT emp.EmployeeID 
								FROM Employee emp
								JOIN Orders ord
								ON emp.EmployeeID = ord.EmployeeID
								WHERE ord.OrderDate = '1997-04-04'
							  );

--19) How many products where shipped to Steven Buchanan
SELECT count(DISTINCT orddetails.ProductID) AS Total_no_of_products
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
JOIN OrderDetails orddetails
ON orddetails.OrderID = ord.OrderID
WHERE emp.FirstName='Steven' AND emp.LastName='Buchanan';

--20) How many orders where shipped to Michael Suyama by Federal Shipping
SELECT count(DISTINCT ord.OrderID) AS No_of_orders
FROM Employee emp
JOIN Orders ord
ON emp.EmployeeID = ord.EmployeeID
JOIN Shippers shiprs
ON shiprs.ShipperID = ord.ShipperID
WHERE emp.FirstName='Michael' AND emp.LastName='Suyama' AND shiprs.CompanyName = 'Federal Shipping';

--21) How many orders are placed for the products supplied from UK and Germany
SELECT count(Distinct orddetails.OrderID) AS Total_No_of_products
FROM Suppliers sup
JOIN Products prdts
ON prdts.SupplierID = sup.SupplierID
JOIN OrderDetails orddetails
ON orddetails.ProductID = prdts.ProductID
WHERE sup.Country = 'UK' or sup.Country = 'Germany';

--22) How much amount Exotic Liquids received due to the order placed for its products in the month of January,1997
SELECT sum(orddetails.UnitPrice*orddetails.Quantity) AS Total_amount
FROM Orders ord
JOIN OrderDetails orddetails
ON ord.OrderID = orddetails.OrderID
JOIN Products p
ON p.ProductID = orddetails.ProductID
JOIN Suppliers sup
ON sup.SupplierID = p.SupplierID
WHERE MONTH(ord.OrderDate) = 1 AND YEAR(ord.OrderDate) = 1997 AND sup.CompanyName = 'Exotic Liquids';

--23) In which days of January, 1997, the supplier Tokyo Traders haven't received any orders.
--SELECT * 
--FROM Orders ord
--JOIN OrderDetails orddetails
--ON ord.OrderID = orddetails.OrderID
--JOIN Products p
--ON p.ProductID = orddetails.ProductID
--JOIN Suppliers sup
--ON sup.SupplierID = p.SupplierID
--WHERE MONTH(ord.OrderDate) = 1 AND YEAR(ord.OrderDate) = 1997 AND sup.CompanyName = 'Tokyo Traders';

--SELECT CAST( DATEADD(day, number, '1997-01-01') AS DATE )AS Dates
--FROM master..spt_values
--WHERE type = 'P'
--AND number BETWEEN 0 AND 30;

--select DATEADD(day,-30,'1997-01-31');

SELECT CAST( DATEADD(DAY,number,'1997-01-01') AS DATE ) AS No_orders_day
FROM master..spt_values 
WHERE ( type = 'p' AND number between 0 and 30) AND CAST( DATEADD(DAY, number, '1997-01-01') AS DATE) NOT IN (
												SELECT CAST(ord.OrderDate AS DATE)
												FROM Orders ord
												JOIN OrderDetails orddetails
												ON ord.OrderID = orddetails.OrderID
												JOIN Products p
												ON p.ProductID = orddetails.ProductID
												JOIN Suppliers sup
												ON sup.SupplierID = p.SupplierID
												WHERE MONTH(ord.OrderDate) = 1 AND YEAR(ord.OrderDate) = 1997 AND sup.CompanyName = 'Tokyo Traders'
											);


--24) Which of the employees did not place any order for the products supplied by Ma Maison in the month of May
SELECT emp1.EmployeeID, emp1.FirstName + ' ' + emp1.LastName AS Full_name
FROM Employee emp1
WHERE emp1.EmployeeID NOT IN  (
							SELECT emp.EmployeeID
							FROM Employee emp
							JOIN Orders ord
							ON emp.EmployeeID = ord.EmployeeID
							JOIN OrderDetails orddetails
							ON ord.OrderID = orddetails.OrderID
							JOIN Products p
							ON p.ProductID = orddetails.ProductID
							JOIN Suppliers sup
							ON sup.SupplierID = p.SupplierID
							WHERE sup.CompanyName = 'Ma Maison' AND MONTH(ord.OrderDate) = 5
							);

-- 25) Which shipper shipped the least number of products for the month of September and October,1997 combined.
SELECT TOP 1 WITH TIES s.ShipperID, s.CompanyName, count(orddetails.ProductID) AS Least_no_of_products
FROM Orders ord
JOIN OrderDetails orddetails
ON ord.OrderID = orddetails.OrderID
JOIN Shippers s
ON s.ShipperID = ord.ShipperID
WHERE MONTH(ord.OrderDate) = 10 AND YEAR(ord.OrderDate) = 1997
GROUP BY s.ShipperID, s.CompanyName
ORDER BY Least_no_of_products;

--26)  What are the products that weren't shipped at all in the month of August, 1997
SELECT p1.ProductID, p1.ProductName
FROM Products p1
WHERE P1.ProductID NOT IN (
							SELECT orddetails.ProductID 
							FROM Orders ord
							JOIN OrderDetails orddetails
							ON ord.OrderID = orddetails.OrderID
							WHERE MONTH(ord.OrderDate) = 8 AND YEAR(ord.OrderDate) = 1997
						);

--27) What are the products that weren't ordered by each of the employees. List each employee and the 
-- products that he didn't 
SELECT emp1.EmployeeID, ProductName 
FROM Employee emp1
CROSS JOIN Products
WHERE ProductName NOT IN ( 
							SELECT DISTINCT p.ProductName
							FROM Orders ord
							JOIN OrderDetails orddetails
							ON ord.OrderID = orddetails.OrderID
							JOIN Products p
							ON p.ProductID = orddetails.ProductID
							WHERE ord.EmployeeID = emp1.EmployeeID
						)
ORDER BY emp1.EmployeeID;

--28) Who is busiest shipper in the months of April, May and June during the year 1996 and 1997
SELECT s.ShipperID, s.CompanyName, count(*) AS No_of_orders
FROM Orders ord
JOIN Shippers s
ON ord.ShipperID = s.ShipperID
WHERE ( MONTH(ord.OrderDate) IN (4,5,6) ) AND (YEAR(ord.OrderDate) IN (1996,1997))
GROUP BY s.ShipperID, s.CompanyName
HAVING COUNT(*) = ( SELECT TOP 1 COUNT(*) 
                    FROM Orders ord1
					JOIN Shippers s1
					ON ord1.ShipperID = s1.ShipperID
					WHERE ( MONTH(ord1.OrderDate) IN (4,5,6) ) AND (YEAR(ord1.OrderDate) IN (1996,1997))
					GROUP BY s1.ShipperID
				);

--29) Which country supplied the maximum products for all the employees in the year 1997
SELECT TOP 1 WITH TIES sup.Country, COUNT(p.ProductID) AS No_of_products
FROM Orders ord
JOIN OrderDetails orddetails
ON orddetails.OrderID = ord.OrderID
JOIN Products p
ON p.ProductID = orddetails.ProductID
JOIN Suppliers sup
ON p.SupplierID = sup.SupplierID
WHERE YEAR(ord.OrderDate) = 1997
GROUP BY sup.Country
ORDER BY No_of_products DESC;

--30) What is the average number of days taken by all shippers to ship the product after the order has been 
-- placed by the employees
SELECT s.ShipperID, SUM(DATEDIFF(day,ord.OrderDate,ord.ShippedDate))/( COUNT(ord.OrderID) * 1.0) AS Avg_days_to_ship
FROM Orders ord
JOIN Shippers s
ON ord.ShipperID = s.ShipperID
GROUP BY s.ShipperID
order by s.ShipperID;

--31) Who is the quickest shipper of all.
SELECT TOP 1 WITH TIES ord.OrderID, 
	   sh.CompanyName,
	   COUNT(*) AS No_of_products,
	   sum(DATEDIFF(day,ord.OrderDate,ord.ShippedDate))/COUNT(*) AS No_of_days_to_ship
FROM Orders ord
JOIN Shippers sh
ON sh.ShipperID = ord.ShipperID
JOIN OrderDetails orddetails
ON ord.OrderID = orddetails.OrderID
WHERE ord.ShippedDate IS NOT NULL
GROUP BY ord.OrderID, sh.CompanyName
ORDER BY No_of_days_to_ship ;

--32) Which order took the least number of shipping days. Get the orderid, employees full name, number of 
--products, number of days took to ship and shipper company name.
SELECT TOP 1 WITH TIES ord.OrderID, 
	   emp.FirstName + ' ' +emp.LastName AS Full_Name,
	   COUNT(*) AS No_of_products,
	   sum(DATEDIFF(day,ord.OrderDate,ord.ShippedDate))/COUNT(*) AS No_of_days_to_ship
FROM Employee emp
JOIN (SELECT * FROM Orders WHERE ShippedDate IS NOT NULL) ord
ON emp.EmployeeID = ord.EmployeeID
JOIN OrderDetails orddetails
ON ord.OrderID = orddetails.OrderID
GROUP BY ord.OrderID, emp.FirstName, emp.LastName
ORDER BY No_of_days_to_ship ;

--													UNIONS
--33)  Which orders took the least number and maximum number of shipping days? Get the orderid, employees 
-- full name, number of products, number of days taken to ship the product and shipper company name. Use 
-- 1 and 2 in the final result set to distinguish the 2 orders
WITH No_of_shiping_days
AS 
(
	SELECT ord.OrderID, 
	   emp.FirstName + ' ' +emp.LastName AS Full_Name,
	   COUNT(*) AS No_of_products,
	   sum(DATEDIFF(day,ord.OrderDate,ord.ShippedDate))/COUNT(*) AS No_of_days_to_ship,
	   sh.CompanyName
	FROM Employee emp
	JOIN Orders ord
	ON emp.EmployeeID = ord.EmployeeID
	JOIN OrderDetails orddetails
	ON ord.OrderID = orddetails.OrderID
	JOIN Shippers sh
	ON sh.ShipperID = ord.ShipperID
	WHERE ord.ShippedDate IS NOT NULL
	GROUP BY ord.OrderID, emp.FirstName, emp.LastName, sh.CompanyName
),
Least_no_of_days AS
(
SELECT TOP 1 WITH TIES *
FROM No_of_shiping_days 
ORDER BY No_of_days_to_ship
),
Maximum_no_of_days AS
(
SELECT TOP 1 WITH TIES *
FROM No_of_shiping_days 
ORDER BY No_of_days_to_ship DESC
)

SELECT * FROM Least_no_of_days
UNION
SELECT * FROM Maximum_no_of_days;

--34) Which is cheapest and the costliest of products purchased in the second week of October, 1997. Get the 
--product ID, product Name and unit price. Use 1 and 2 in the final result set to distinguish the 2 products.
WITH Product_with_price
AS
(
SELECT p.ProductID, p.ProductName, orddetails.UnitPrice
FROM Orders ord
JOIN OrderDetails orddetails
ON ord.OrderID = orddetails.OrderID
JOIN Products p
ON p.ProductID = orddetails.ProductID
WHERE (DATEPART(week,ord.OrderDate)%MONTH(ord.OrderDate)) = 2 AND YEAR(ord.OrderDate) = 1997 AND MONTH(ord.OrderDate) = 10
),
Minimum_price AS
(
SELECT TOP 1 WITH TIES *
FROM Product_with_price
ORDER BY UnitPrice
),
Maximum_price AS
(
SELECT TOP 1 WITH TIES *
FROM Product_with_price
ORDER BY UnitPrice DESC
)

--													CASE
--35)  Find the distinct shippers who are to ship the orders placed by employees with IDs 1, 3, 5, 7
--Show the shipper's name as "Express Speedy" if the shipper's ID is 2 and "United Package" if the shipper's 
--ID is 3 and "Shipping Federal" if the shipper's ID is 1
SELECT emp.EmployeeID,
	  CASE
		WHEN ord.ShipperID = 1 THEN 'Shipping Federal'
		WHEN ord.ShipperID = 2 THEN 'Express Speedy'
		WHEN ord.ShipperID = 3 THEN 'United Package'
	  END AS CompanyName
FROM Employee emp
JOIN Orders ord
ON ord.EmployeeID = emp.EmployeeID
WHERE emp.EmployeeID IN (1,3,5,7)
ORDER BY emp.EmployeeID;




select * from Employee;
select * from Orders  ;
select * from OrderDetails;
select * from Products;
select * from Suppliers;
select * from Shippers;

