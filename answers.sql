

Question 1: Achieving 1NF (First Normal Form) 

Problem:
The `Products` column in `ProductDetail` contains multiple values in one cell, which violates 1NF.

Goal:
Split each product into its own row.

Sample SQL to achieve 1NF:

Assuming you have a `ProductDetail` table structured like this:


CREATE TABLE ProductDetail (
  OrderID INT,
  CustomerName VARCHAR(100),
  Products VARCHAR(255)
);


Step 1: Insert sample data


INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');


Step 2: Transform to 1NF using a SELECT with string splitting (MySQL 8+ example using `JSON_TABLE`):


SELECT 
  OrderID, 
  CustomerName, 
  TRIM(product) AS Product
FROM (
  SELECT 
    OrderID, 
    CustomerName,
    JSON_TABLE(
      CONCAT('["', REPLACE(Products, ', ', '","'), '"]'),
      "$[*]" COLUMNS (product VARCHAR(100) PATH "$")
    ) AS jt
  FROM ProductDetail
) AS transformed;







Question 2: Achieving 2NF (Second Normal Form) 

Problem:
`CustomerName` depends only on `OrderID`, not the full composite key (`OrderID`, `Product`). This violates 2NF.

Goal:
Separate into two tables:

* One for orders (OrderID, CustomerName)
* One for order items (OrderID, Product, Quantity)

SQL to Normalize to 2NF:

Step 1: Create separate `Orders` and `OrderItems` tables


CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(100)
);

CREATE TABLE OrderItems (
  OrderID INT,
  Product VARCHAR(100),
  Quantity INT,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);


Step 2: Insert data into `Orders` (removing duplicates):


INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');


Step 3: Insert data into `OrderItems`:


INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

