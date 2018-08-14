USE wagstaff_INFOST_410;

/** For each order, list the order number and order date along with the number and the name of the customer that placed
the order. (Example 5-1 in the slides) **/
SELECT OrderNum, OrderDate, Orders.CustomerNum, Customer.CustomerName
FROM Orders
JOIN Customer
ON Orders.CustomerNum = Customer.CustomerNum;

/** For each order placed on October 21, 2013, list the order number along with the number and name of the customer that
 placed the order. (Example 5-2 in the slides) **/
SELECT OrderNum, Orders.CustomerNum, Customer.CustomerName
FROM Orders
JOIN Customer
ON Orders.CustomerNum = Customer.CustomerNum
WHERE OrderDate = DATE("2013-10-21");

/** For each order, list the order number, order date, part number, number of units quoted price for each order line
that makes up the order.(Example 5-3 in the slides) **/
SELECT Orders.OrderNum, Orders.OrderDate, PartNum, NumOrdered, QuotedPrice
FROM OrderLine
JOIN Orders
ON Orders.OrderNum = OrderLine.OrderNum;

/** Use the IN operator to find the number and name of each customer that placed an order on October 21, 2013.(Example 5-5) **/
SELECT CustomerNum, CustomerName
FROM Customer
WHERE CustomerNum In (SELECT CustomerNum FROM Orders WHERE OrderDate = DATE("2013-10-21"));

/** Repeat question 4, but this time use the EXISTS operator in your answer. (Example 5-6) **/
SELECT CustomerNum, CustomerName
FROM Customer
WHERE EXISTS (
  SELECT CustomerNum
  FROM Orders
  WHERE Customer.CustomerNum = Orders.CustomerNum
  AND OrderDate = DATE("2013-10-21")
  );

/** Find the number and name of each customer that did not place an order on October 21 , 2013.
(Hint: NOT IN ) (Example 5-5, but use NOT IN) **/
SELECT CustomerNum, CustomerName
FROM Customer
WHERE CustomerNum NOT IN (SELECT CustomerNum FROM Orders WHERE OrderDate = DATE("2013-10-21"));

/** For each order, list the order number, order date, part number, part description, and item class for each part
that makes up the order. (Hint: JOIN three tables) (Example 5-16) **/
SELECT Orders.OrderNum, Orders.OrderDate, OrderLine.PartNum, Part.Description, Part.Class
FROM Orders
JOIN OrderLine
ON Orders.OrderNum = OrderLine.OrderNum
JOIN Part
ON OrderLine.PartNum = Part.PartNum;

/** Repeat question 7, but this time order the rows by item class and then by order number
(Example 5-16 with ORDER BY clause added) **/
SELECT Orders.OrderNum, Orders.OrderDate, OrderLine.PartNum, Part.Description, Part.Class
FROM Orders
JOIN OrderLine
ON Orders.OrderNum = OrderLine.OrderNum
JOIN Part
ON OrderLine.PartNum = Part.PartNum
ORDER BY Part.Class, Orders.OrderNum;

/** Use а subquery to find the rep number, last name, and first name of each sales rep who represents at least
one customer with а credit limit of $5,000. (Hint: Use WHERE RepNum IN ) (Example 5-6) **/
SELECT RepNum, LastName, FirstName
FROM Rep
WHERE RepNum IN (SELECT RepNum FROM Customer WHERE CreditLimit = 5000);

/** Repeat question 9, but this time do not use а subquery.(Example 5-4) **/
SELECT DISTINCT Rep.RepNum, Rep.LastName, Rep.FirstName
FROM Rep
JOIN Customer
ON Rep.RepNum = Customer.RepNum
WHERE Customer.CreditLimit = 5000;

/** Find the number and name of each customer that currently has an order on file for а ‘Gas Range’. (Example 5-16) **/
SELECT Customer.CustomerNum, Customer.CustomerName
FROM Customer, Orders, OrderLine, Part
WHERE Customer.CustomerNum = Orders.CustomerNum
AND Orders.OrderNum = OrderLine.OrderNum
AND OrderLine.PartNum = Part.PartNum
AND Part.Description = 'Gas Range';

/** List the part number, part description, and item class for each pair of parts that are in same item class.
(For example, one such pair would bе part АТ 94 and part FD21, because the item class for both parts is HW.
Pairs of parts would have different part numbers but be in the same class). Order output by class. (Example 5-12) **/
SELECT A.PartNum, A.Description, B.PartNum, B.Description, A.Class
FROM Part A, Part B
WHERE A.Class = B.Class
AND A.PartNum < B.PartNum
ORDER BY A.Class, A.PartNum, B.PartNum;

/** List the order number and order date for each order placed by the customer named “Johnson's Department Store”.
(Hint: To enter an apostrophe use single quotation mark) within а string of characters, type two single quotation marks.
Customer.CustomerName`='Johnson''s Department Store') (Example 5-4) **/
SELECT OrderNum, OrderDate
FROM Orders, Customer
WHERE Customer.CustomerName = 'Johnson''s Department Store'
AND Orders.CustomerNum = Customer.CustomerNum;

/** List the order number and order date for each order that contains an order line for an lron.(Example 5-16) **/
SELECT Orders.OrderNum, Orders.OrderDate
FROM Orders, OrderLine, Part
WHERE Part.Description = 'Iron'
AND OrderLine.PartNum = Part.PartNum
AND Orders.OrderNum = OrderLine.OrderNum;

/** Use UNION to list the order number and order date for each order that either was placed by Johnson's Department
Store or that contains an order line for а Gas Range. (Example 5-20) **/
SELECT Orders.OrderNum, Orders.OrderDate
FROM Orders, Customer
WHERE CustomerName = 'Johnson''s Department Store'
AND Orders.CustomerNum = Customer.CustomerNum
UNION
SELECT Orders.OrderNum, Orders.OrderDate
FROM Orders, OrderLine, Part
WHERE Part.Description = 'Gas Range'
AND OrderLine.PartNum = Part.PartNum
AND Orders.OrderNum = OrderLine.OrderNum;