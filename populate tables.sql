
-- Step 1: Populate TimeDim
INSERT INTO TimeDim (OrderDate, ShipDate)
SELECT DISTINCT 
    `Order Date`, 
    `Ship Date`
FROM superstoresales_main_new;

-- Step 2: Populate CustomerSegment
INSERT INTO CustomerSegment (SegmentName)
SELECT DISTINCT 
    `Customer Segment`
FROM superstoresales_main_new;

-- Step 3: Populate CustomerDim
INSERT INTO CustomerDim (CustomerName, SegmentID)
SELECT DISTINCT 
    `Customer Name`, 
    (SELECT SegmentID FROM CustomerSegment WHERE SegmentName = `Customer Segment`)
FROM superstoresales_main_new;

-- 4. product category
INSERT INTO ProductCategory (CategoryName)
SELECT DISTINCT `Product Category`
FROM superstoresales_main_new;

-- 5. product subcategory
INSERT INTO ProductSubcategory (SubcategoryName, CategoryID)
SELECT DISTINCT 
    `Product Sub-Category`,
    (SELECT CategoryID FROM ProductCategory WHERE CategoryName = `Product Category`)
FROM superstoresales_main_new;



-- 6. product dim
INSERT INTO ProductDim (ProductName, CategoryID, SubcategoryID, ProductContainer, ProductBaseMargin)
SELECT DISTINCT 
    `Product Name`,
    (SELECT CategoryID FROM ProductCategory WHERE CategoryName = `Product Category`),
    (SELECT SubcategoryID FROM ProductSubcategory WHERE SubcategoryName = `Product Sub-Category`),
    `Product Container`,
    `Product Base Margin`
FROM superstoresales_main_new;


-- Step 7: Populate RegionDim
INSERT INTO RegionDim (RegionName)
SELECT DISTINCT 
    `Region`
FROM superstoresales_main_new;

-- Step 8: Populate Province
INSERT INTO Province (ProvinceName, RegionID)
SELECT DISTINCT 
    `Province`, 
    (SELECT RegionID FROM RegionDim WHERE RegionName = `Region`)
FROM superstoresales_main_new;

-- Step 9: Populate ShippingDim
INSERT INTO ShippingDim (ShipMode, OrderPriority)
SELECT DISTINCT 
    `Ship Mode`, 
    `Order Priority`
FROM superstoresales_main_new;

-- Step 10: Populate SalesFact
INSERT INTO SalesFact (
    TimeID, CustomerID, ProductID, RegionID, ShippingID,
    OrderQuantity, TotalRevenue, Profit, Discount, ShippingCost,
    OrderAccuracyRate, OrderFulfillmentTime
)
SELECT 
    -- Fetch TimeID using OrderDate and ShipDate
    (SELECT MIN(TimeID) 
     FROM TimeDim 
     WHERE OrderDate = `Order Date` AND ShipDate = `Ship Date`),
     
    -- Fetch CustomerID using CustomerName
    (SELECT MIN(CustomerID) 
     FROM CustomerDim 
     WHERE CustomerName = `Customer Name`),
     
    -- Fetch ProductID using ProductName
    (SELECT MIN(ProductID) 
     FROM ProductDim 
     WHERE ProductName = `Product Name`),
     
    -- Fetch RegionID using RegionName
    (SELECT MIN(RegionID) 
     FROM RegionDim 
     WHERE RegionName = `Region`),
     
    -- Fetch ShippingID using ShipMode and OrderPriority
    (SELECT MIN(ShippingID) 
     FROM ShippingDim 
     WHERE ShipMode = `Ship Mode` AND OrderPriority = `Order Priority`),
     
    -- Transactional data from source table
    `Order Quantity`,
    `Sales`,
    `Profit`,
    `Discount`,
    `Shipping Cost`,
    
    -- Default OrderAccuracyRate to 1 (accurate); update later for returned orders
    1,
    
    -- Calculate OrderFulfillmentTime as the difference between ShipDate and OrderDate
    DATEDIFF(`Ship Date`, `Order Date`)
FROM superstoresales_main_new;


-- Step 11: Update OrderAccuracyRate for Returned Orders
UPDATE SalesFact
SET OrderAccuracyRate = 0 -- Mark as inaccurate
WHERE SalesID IN (
    SELECT DISTINCT SalesID
    FROM (
        SELECT 
            f.SalesID
        FROM SalesFact f
        JOIN superstoresales_returns r ON f.SalesID = r.`OrderID`
    ) AS Subquery
);
