-- Avergae order value per region

CREATE TABLE order_reg AS
SELECT
    rd.RegionName,
    COUNT(sf.SalesID) AS TotalOrders,
    SUM(sf.TotalRevenue) AS TotalRevenue,
    AVG(sf.TotalRevenue) AS AvgOrderValue
FROM
    salesfact sf
JOIN
    regiondim rd ON sf.RegionID = rd.RegionID
GROUP BY
    rd.RegionName;
-- Average order value per segment

CREATE TABLE order_seg AS
SELECT
    cs.SegmentName,
    COUNT(sf.SalesID) AS TotalOrders,
    SUM(sf.TotalRevenue) AS TotalRevenue,
    AVG(sf.TotalRevenue) AS AvgOrderValue
FROM
    salesfact sf
JOIN
    customerdim cd ON sf.CustomerID = cd.CustomerID
JOIN
    customersegment cs ON cd.SegmentID = cs.SegmentID
GROUP BY
    cs.SegmentName;