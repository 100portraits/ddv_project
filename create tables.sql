-- Drop tables if they exist
DROP TABLE IF EXISTS SalesFact, TimeDim, CustomerDim, CustomerSegment, ProductDim, ProductCategory, ProductSubcategory, ShippingDim, Province, RegionDim;

-- Time Dimension
CREATE TABLE TimeDim (
    TimeID INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    ShipDate DATE NOT NULL,
    Year INT GENERATED ALWAYS AS (YEAR(OrderDate)) STORED,
    Month INT GENERATED ALWAYS AS (MONTH(OrderDate)) STORED,
    Day INT GENERATED ALWAYS AS (DAY(OrderDate)) STORED,
    Week INT GENERATED ALWAYS AS (WEEK(OrderDate)) STORED
);

-- Customer Segment Dimension
CREATE TABLE CustomerSegment (
    SegmentID INT AUTO_INCREMENT PRIMARY KEY,
    SegmentName VARCHAR(255) UNIQUE
);

-- Customer Dimension
CREATE TABLE CustomerDim (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(255),
    SegmentID INT,
    FOREIGN KEY (SegmentID) REFERENCES CustomerSegment(SegmentID)
);

-- Product Subcategory Dimension
CREATE TABLE ProductSubcategory (
    SubcategoryID INT AUTO_INCREMENT PRIMARY KEY,
    SubcategoryName VARCHAR(255) UNIQUE
);

-- Product Category Dimension
CREATE TABLE ProductCategory (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(255) UNIQUE
);

-- Update Product Dimension to Reference Subcategory Directly
CREATE TABLE ProductDim (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(255),
    CategoryID INT,
    SubcategoryID INT,
    ProductContainer VARCHAR(255),
    ProductBaseMargin FLOAT,
    FOREIGN KEY (CategoryID) REFERENCES ProductCategory(CategoryID),
    FOREIGN KEY (SubcategoryID) REFERENCES ProductSubcategory(SubcategoryID)
);


-- Region Dimension
CREATE TABLE RegionDim (
    RegionID INT AUTO_INCREMENT PRIMARY KEY,
    RegionName VARCHAR(255) UNIQUE
);


-- Province Dimension
CREATE TABLE Province (
    ProvinceID INT AUTO_INCREMENT PRIMARY KEY,
    ProvinceName VARCHAR(255) UNIQUE,
    RegionID INT,
    FOREIGN KEY (RegionID) REFERENCES RegionDim(RegionID)
);

-- Shipping Dimension
CREATE TABLE ShippingDim (
    ShippingID INT AUTO_INCREMENT PRIMARY KEY,
    ShipMode VARCHAR(255),
    OrderPriority VARCHAR(255)
);

-- Fact Table with Order Fulfillment Time
CREATE TABLE SalesFact (
    SalesID INT AUTO_INCREMENT PRIMARY KEY,
    TimeID INT,
    CustomerID INT,
    ProductID INT,
    RegionID INT,
    ShippingID INT,
    OrderQuantity INT,
    TotalRevenue FLOAT,
    Profit FLOAT,
    Discount FLOAT,
    ShippingCost FLOAT,
    OrderAccuracyRate FLOAT,
    OrderFulfillmentTime INT, -- Time in days between OrderDate and ShipDate
    FOREIGN KEY (TimeID) REFERENCES TimeDim(TimeID),
    FOREIGN KEY (CustomerID) REFERENCES CustomerDim(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES ProductDim(ProductID),
    FOREIGN KEY (RegionID) REFERENCES RegionDim(RegionID),
    FOREIGN KEY (ShippingID) REFERENCES ShippingDim(ShippingID)
);

