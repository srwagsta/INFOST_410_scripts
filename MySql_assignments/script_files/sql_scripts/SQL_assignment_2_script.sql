USE wagstaff_INFOST_410;

/** List the complete Part table. **/
SELECT *
FROM Part;

/** List the number and name of every customer represented by sales rep 35. **/
SELECT CustomerName, CustomerNum
FROM Customer
WHERE RepNum = 35;

/** List the number and name of all customers that are represented by sales rep 35 and that have credit limits of $10,000. **/
SELECT CustomerName, CustomerNum
FROM Customer
WHERE RepNum = 35 && CreditLimit = 10000;

/** List the number and name of all customers that are represented by sales rep 35 or that have credit limits of $10,000. **/
SELECT CustomerName, CustomerNum
FROM Customer
WHERE RepNum = 35 || CreditLimit = 10000;

/**
For each order, list the order number, order date, number of the customer that placed the order,
and name of the customer that placed the order. (HINT: to retrieve this information you will need to use JOIN.
You can complete JOIN by either including clause: WHERE Orders.CustomerNum=Customer.CustomerNum or
by applying JOIN operation: FROM Orders JOIN Customer ON Orders.CustomerNum=Customer.CustomerNum)
**/
SELECT OrderNum, OrderDate, Customer.CustomerNum, Customer.CustomerName
FROM Orders
JOIN Customer
ON Orders.CustomerNum = Customer.CustomerNum;

/** List the number and name of all customers represented by Juan Perez. (JOIN Customer and Rep) **/
SELECT CustomerName, CustomerNum
FROM Customer
JOIN Rep
ON Customer.RepNum = Rep.RepNum
WHERE Rep.FirstName = 'Juan';

/** Or this can be accomplished with the following subquery, but there is a loss in performance.
SELECT CustomerName, CustomerNum
FROM Customer
WHERE RepNum = (SELECT RepNum FROM Rep WHERE FirstName = 'Juan' && LastName = 'Perez');
**/

/** How many orders were placed on 10/20/2013? (Hint: use COUNT(*) FROM Orders WHERE OrderDate='2013-10-20') **/
SELECT COUNT(*)
FROM Orders
WHERE OrderDate='2013-10-20';

/** Find the total of the balances for all customers represented by sales rep 35. (SUM(Balance)) **/
SELECT SUM(Balance)
FROM Customer
WHERE RepNum = 35;


/** Give the part number, description, and on-hand value (OnHand *Price) for each part in item class HW. **/
SELECT PartNum, Description, (OnHand * Price) AS 'on-hand value'
FROM Part
WHERE Class = 'HW';

/** List all columns and all rows in the Part table. Sort the results by part description. **/
SELECT *
FROM Part
ORDER BY Description;

/** List all columns and all rows in the Part table. Sort the results by part number within item class. **/
SELECT *
FROM Part
ORDER BY Class, PartNum;

/** List the item class and the sum of the number of units on hand. Group the results by item class. **/
SELECT Class, SUM(OnHand)
FROM Part
GROUP BY Class;

/** Create a new table named SportingGoods to contain the columns PartNum, Description, OnHand, Warehouse, and Price for all rows in which the item class is SG. (CREATE TABLE .. AS SELECT .. FROM.. WHERE.. ) **/
CREATE TABLE SportingGoods
AS
SELECT PartNum, Description, OnHand, Warehouse, price
FROM Part
WHERE Class = 'SG';

/** In the SportingGoods table, change the description of part BV06 to "Fitness Gym." (UPDATE .. SET.. WHERE.. clause) **/
UPDATE SportingGoods
SET Description = 'Fitness Gym'
WHERE PartNum = 'BV06';

/** In the SportingGoods table, delete every row in which the price is greater than $1,000. (DELETE .. FROM .. WHERE ) **/
DELETE
FROM SportingGoods
WHERE Price > 1000;

/** List the order number for each order that contains an order line for a part located in warehouse 3. **/
SELECT OrderNum
FROM OrderLine
JOIN Part
ON OrderLine.PartNum = Part.PartNum
WHERE Part.Warehouse = 3;

/** For each sales rep, list the rep number, the number of customers assigned to the rep, and the average balance of the rep's customers. Group the records by rep number and order the records ?? rep number. **/
SELECT RepNum, COUNT(CustomerNum) AS 'Customer Count', AVG(Balance) AS 'Average Balance'
FROM Customer
GROUP BY RepNum
ORDER BY RepNum;

/**
For each sales rep with fewer than four customers, list the rep number, the number of customers assigned to the rep, and the average balance of the rep's customers.
Rename the count of the number of customers and the average of the balances to NumCustomers and AveragcBalance, respectively. Order the groups by RepNumber
**/
SELECT RepNum, COUNT(CustomerNum) AS 'NumCustomers', AVG(Balance) AS 'AverageBalance'
FROM Customer
GROUP BY RepNum
HAVING COUNT(CustomerNum) < 4
ORDER BY RepNum;

/** List number, name, and balance for each customer whose balance is between $1000 and $5000 **/
SELECT CustomerNum, CustomerName, Balance
FROM Customer
WHERE Balance > 1000 && Balance < 5000;

/** List the number, name, and available credit for all customers. Computed field:  AvaliableCredit: CreditLimit-Balance **/
SELECT CustomerNum, CustomerName, (CreditLimit - Balance) AS 'AvaliableCredit'
FROM Customer;

/** List the number, name, and available credit for all customers with credit limits that exceed their balances. **/
SELECT CustomerNum, CustomerName, (CreditLimit - Balance) AS 'AvaliableCredit'
FROM Customer
WHERE CreditLimit > Balance;

/** List the number, name, and complete address of every customer located on a street that contains the letters Oxford. **/
SELECT CustomerNum, CustomerName, CONCAT(Street, ' ', City, ' ', State, ' ', Zip) AS 'Address'
FROM Customer
WHERE Street
LIKE '%oxford%';

/** List the number, name, street, and credit limit for every customer with a credit limit of $ 7500, $10000, or $15,000. **/
SELECT CustomerNum, CustomerName, Street, CreditLimit
FROM Customer
WHERE CreditLimit IN (7500, 10000, 15000);

/** List the number, name, street, and credit limit of all customers. Order (sort) the customers by name. **/
SELECT CustomerNum, CustomerName, Street, CreditLimit
FROM Customer
ORDER BY CustomerName;

/** List the number, name, street, and credit limit of all customers. Order the customers by name within descending credit limit. (In other words, sort the customers by credit limit in descending order. Within each group of customers that have a common credit limit, sort the customers by name.) **/
SELECT CustomerNum, CustomerName, Street, CreditLimit
FROM Customer
ORDER BY CreditLimit DESC, CustomerName;

/** How many parts are in the item class HW **/
SELECT COUNT(PartNum) AS 'Parts of class HW'
FROM Part
WHERE Class = 'HW';

/** Find the number of customers and the total of their balances. **/
SELECT COUNT(CustomerNum) AS 'Total Customers', SUM(Balance) AS 'Total Balances'
FROM Customer;


/** Find the total number of customers and the total of their balances. Change the column names for the number of customers and the total of their balances to CustomerCount and BalanceTotal, respectively. **/
SELECT COUNT(CustomerNum) AS 'CustomerCount', SUM(Balance) AS 'BalanceTotal'
FROM Customer;
