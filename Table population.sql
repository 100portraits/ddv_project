-- Date table
CREATE TABLE Date_Dim (
    Date_ID INT PRIMARY KEY AUTO_INCREMENT,
    Full_Date DATE NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Day INT NOT NULL,
    Weekday VARCHAR(10) NOT NULL
);

INSERT INTO Date_Dim (Full_Date, Year, Quarter, Month, Day, Weekday)
SELECT DISTINCT
    `Order Date` AS Full_Date,
    YEAR(`Order Date`) AS Year,
    QUARTER(`Order Date`) AS Quarter,
    MONTH(`Order Date`) AS Month,
    DAY(`Order Date`) AS Day,
    DAYNAME(`Order Date`) AS Weekday
FROM superstoresales_main_new
WHERE `Order Date` IS NOT NULL
  AND `Order Date` NOT IN (SELECT Full_Date FROM Date_Dim);

-- Insert unique Ship Dates
INSERT INTO Date_Dim (Full_Date, Year, Quarter, Month, Day, Weekday)
SELECT DISTINCT
    `Ship Date` AS Full_Date,
    YEAR(`Ship Date`) AS Year,
    QUARTER(`Ship Date`) AS Quarter,
    MONTH(`Ship Date`) AS Month,
    DAY(`Ship Date`) AS Day,
    DAYNAME(`Ship Date`) AS Weekday
FROM superstoresales_main_new
WHERE `Ship Date` IS NOT NULL
  AND `Ship Date` NOT IN (SELECT Full_Date FROM Date_Dim);
  
  -- Customer table
CREATE TABLE Customer_Dim (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_Name VARCHAR(255),
    Province VARCHAR(255),
    Region VARCHAR(255),
    Customer_Segment VARCHAR(255)
);
INSERT INTO Customer_Dim (Customer_Name, Province, Region, Customer_Segment)
SELECT DISTINCT
    `Customer Name`,
    Province,
    Region,
    `Customer Segment`
FROM superstoresales_main_new;

-- Product table
CREATE TABLE Product_Dim (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(255),
    Product_Sub_Category VARCHAR(255),
    Product_Category VARCHAR(255),
    Product_Container VARCHAR(255),
    Product_Base_Margin FLOAT,
    Unit_Price FLOAT
);

INSERT INTO Product_Dim (Product_Name, Product_Sub_Category, Product_Category, Product_Container, Product_Base_Margin, Unit_Price)
SELECT DISTINCT
    `Product Name`,
    `Product Sub-Category`,
    `Product Category`,
    `Product Container`,
    `Product Base Margin`,
    `Unit Price`
FROM superstoresales_main_new;


-- Order table
CREATE TABLE Order_Dim (
    Order_ID VARCHAR(255) PRIMARY KEY,
    Order_Priority VARCHAR(255),
    Ship_Mode VARCHAR(255)
);

INSERT INTO Order_Dim (Order_ID, Order_Priority, Ship_Mode)
SELECT
    `Order ID`,
    MAX(`Order Priority`) AS Order_Priority,
    MAX(`Ship Mode`) AS Ship_Mode
FROM superstoresales_main_new
GROUP BY `Order ID`;



-- Sales table
CREATE TABLE Sales_Fact (
    Fact_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID VARCHAR(255),
    Customer_ID INT,
    Product_ID INT,
    Order_Date_ID INT,
    Ship_Date_ID INT,
    Order_Quantity INT,
    Sales FLOAT,
    Discount FLOAT,
    Profit FLOAT,
    Shipping_Cost FLOAT,
    FOREIGN KEY (Order_ID) REFERENCES Order_Dim(Order_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer_Dim(Customer_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product_Dim(Product_ID),
    FOREIGN KEY (Order_Date_ID) REFERENCES Date_Dim(Date_ID),
    FOREIGN KEY (Ship_Date_ID) REFERENCES Date_Dim(Date_ID)
);


INSERT INTO Sales_Fact (Order_ID, Customer_ID, Product_ID, Order_Date_ID, Ship_Date_ID, Order_Quantity, Sales, Discount, Profit, Shipping_Cost)
SELECT
    s.`Order ID`,
    c.Customer_ID,
    p.Product_ID,
    od.Date_ID AS Order_Date_ID,
    sd.Date_ID AS Ship_Date_ID,
    s.`Order Quantity`,
    s.Sales,
    s.Discount,
    s.Profit,
    s.`Shipping Cost`
FROM superstoresales_main_new s
JOIN Order_Dim o ON s.`Order ID` = o.Order_ID
JOIN Customer_Dim c ON s.`Customer Name` = c.Customer_Name
JOIN Product_Dim p ON s.`Product Name` = p.Product_Name
JOIN Date_Dim od ON s.`Order Date` = od.Full_Date
JOIN Date_Dim sd ON s.`Ship Date` = sd.Full_Date;






