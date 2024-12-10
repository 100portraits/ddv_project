-- Identify repeat customers
SELECT
    CustomerID,
    COUNT(*) AS TotalTransactions
FROM
    salesfact
GROUP BY
    CustomerID
HAVING
    TotalTransactions > 1;
    
 -- Join customer to segments
SELECT
    sf.CustomerID,
    cs.SegmentName,
    COUNT(*) AS TotalTransactions
FROM
    salesfact sf
JOIN
    customerdim cd ON sf.CustomerID = cd.CustomerID
JOIN
    customersegment cs ON cd.SegmentID = cs.SegmentID
GROUP BY
    sf.CustomerID, cs.SegmentName
HAVING
    COUNT(*) > 1;
    
    -- Customer rate per segment
CREATE TABLE repeat_segment AS 
SELECT
    cs.SegmentName,
    COUNT(DISTINCT CASE WHEN sf.CustomerID IN (
        SELECT CustomerID
        FROM salesfact
        GROUP BY CustomerID
        HAVING COUNT(*) > 1
    ) THEN sf.CustomerID END) AS RepeatCustomers,
    COUNT(DISTINCT sf.CustomerID) AS TotalCustomers,
    COUNT(DISTINCT CASE WHEN sf.CustomerID IN (
        SELECT CustomerID
        FROM salesfact
        GROUP BY CustomerID
        HAVING COUNT(*) > 1
    ) THEN sf.CustomerID END) / COUNT(DISTINCT sf.CustomerID) AS RepeatCustomerRate
FROM
    salesfact sf
JOIN
    customerdim cd ON sf.CustomerID = cd.CustomerID
JOIN
    customersegment cs ON cd.SegmentID = cs.SegmentID
GROUP BY
    cs.SegmentName;




-- Customer rate per region
CREATE TABLE repeat_region AS
SELECT
    rd.RegionName,
    COUNT(DISTINCT CASE WHEN sf.CustomerID IN (
        SELECT CustomerID
        FROM salesfact
        GROUP BY CustomerID
        HAVING COUNT(*) > 1
    ) THEN sf.CustomerID END) AS RepeatCustomers,
    COUNT(DISTINCT sf.CustomerID) AS TotalCustomers,
    COUNT(DISTINCT CASE WHEN sf.CustomerID IN (
        SELECT CustomerID
        FROM salesfact
        GROUP BY CustomerID
        HAVING COUNT(*) > 1
    ) THEN sf.CustomerID END) / COUNT(DISTINCT sf.CustomerID) AS RepeatCustomerRate
FROM
    salesfact sf
JOIN
    regiondim rd ON sf.RegionID = rd.RegionID
GROUP BY
    rd.RegionName;
    
    


