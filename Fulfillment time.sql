-- Fulillment time per region
CREATE TABLE AvgFulfillmentTime_Region AS
SELECT
    rd.RegionName,
    COUNT(sf.SalesID) AS TotalOrders,
    AVG(sf.OrderFulfillmentTime) AS AvgFulfillmentTime
FROM
    salesfact sf
JOIN
    regiondim rd ON sf.RegionID = rd.RegionID
GROUP BY
    rd.RegionName;

-- Fulfillment time by order size
CREATE TABLE AvgFulfillmentTime_OrderSize AS
SELECT
    CASE
        WHEN sf.OrderQuantity <= 10 THEN 'Small'
        WHEN sf.OrderQuantity BETWEEN 11 AND 50 THEN 'Medium'
        WHEN sf.OrderQuantity > 50 THEN 'Large'
    END AS OrderSize,
    COUNT(sf.SalesID) AS TotalOrders,
    AVG(sf.OrderFulfillmentTime) AS AvgFulfillmentTime
FROM
    salesfact sf
GROUP BY
    OrderSize;
    