USE wagstaff_INFOST_410;

SELECT CustomerNum, CustomerName, Balance, CreditLimit
FROM Customer;

SELECT * 
FROM Part;

SELECT * 
FROM Orders;

SELECT CustomerName 
FROM Customer
WHERE CreditLimit = 10000;

SELECT CustomerName
FROM Customer
WHERE CustomerNum = 148;

SELECT CustomerName
FROM Customer
WHERE City = 'Grove';

SELECT CustomerNum, CustomerName, Balance, CreditLimit
FROM Customer
WHERE CreditLimit > Balance;

SELECT Description, OnHand, Warehouse
FROM Part
WHERE OnHand > 20 && Warehouse = 3;

SELECT Description, OnHand, Warehouse
FROM Part
WHERE OnHand > 20 || Warehouse = 3;

SELECT Description
FROM Part
WHERE Warehouse != 3;