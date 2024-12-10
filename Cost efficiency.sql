-- Cost efficiencu category
CREATE TABLE ShippingCostEfficiency_Category AS
SELECT
    pc.CategoryName,
    COUNT(sf.SalesID) AS TotalOrders,
    SUM(sf.ShippingCost) AS TotalShippingCost,
    SUM(sf.OrderQuantity) AS TotalQuantity,
    SUM(sf.TotalRevenue) AS TotalRevenue,
    SUM(sf.ShippingCost) / SUM(sf.OrderQuantity) AS CostPerUnit,
    SUM(sf.ShippingCost) / SUM(sf.TotalRevenue) AS CostPerRevenue
FROM
    salesfact sf
JOIN
    productdim pd ON sf.ProductID = pd.ProductID
JOIN
    productcategory pc ON pd.CategoryID = pc.CategoryID
GROUP BY
    pc.CategoryName;
    
-- Cost efficiency by mode    
CREATE TABLE ShippingCostEfficiency_ShippingMode AS
SELECT
    sd.ShipMode,
    COUNT(sf.SalesID) AS TotalOrders,
    SUM(sf.ShippingCost) AS TotalShippingCost,
    SUM(sf.OrderQuantity) AS TotalQuantity,
    SUM(sf.TotalRevenue) AS TotalRevenue,
    SUM(sf.ShippingCost) / SUM(sf.OrderQuantity) AS CostPerUnit,
    SUM(sf.ShippingCost) / SUM(sf.TotalRevenue) AS CostPerRevenue
FROM
    salesfact sf
JOIN
    Shippingdim sd ON sf.ShippingID = sd.ShippingID
GROUP BY
    sd.ShipMode;