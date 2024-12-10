CREATE TABLE OrderAccuracy_PerRegion AS
SELECT
    rd.RegionName,
    COUNT(sf.SalesID) AS TotalOrders,
    SUM(CASE WHEN sf.OrderAccuracyRate = 0 THEN 1 ELSE 0 END) AS ReturnedOrders,
    (SUM(CASE WHEN sf.OrderAccuracyRate = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(sf.SalesID)) AS ReturnRate
FROM
    SalesFact sf
JOIN
    RegionDim rd ON sf.RegionID = rd.RegionID
GROUP BY
    rd.RegionName
ORDER BY
    rd.RegionName;
    

CREATE TABLE OrderAccuracy_OverTime AS
SELECT
    td.Year,
    td.Month,
    COUNT(sf.SalesID) AS TotalOrders,
    SUM(CASE WHEN sf.OrderAccuracyRate = 0 THEN 1 ELSE 0 END) AS ReturnedOrders,
    (SUM(CASE WHEN sf.OrderAccuracyRate = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(sf.SalesID)) AS ReturnRate
FROM
    SalesFact sf
JOIN
    TimeDim td ON sf.TimeID = td.TimeID
GROUP BY
    td.Year, td.Month
ORDER BY
    td.Year, td.Month;