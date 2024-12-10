CREATE TABLE BaseMargin_Category AS
SELECT
    pc.CategoryName,
    COUNT(sf.SalesID) AS TotalOrders,
    AVG(pd.ProductBaseMargin) AS AvgBaseMargin
FROM
    salesfact sf
JOIN
    productdim pd ON sf.ProductID = pd.ProductID
JOIN
    productcategory pc ON pd.CategoryID = pc.CategoryID
GROUP BY
    pc.CategoryName;
    
    
CREATE TABLE BaseMargin_Region AS
SELECT
    rd.RegionName,
    COUNT(sf.SalesID) AS TotalOrders,
    AVG(pd.ProductBaseMargin) AS AvgBaseMargin
FROM
    salesfact sf
JOIN
    productdim pd ON sf.ProductID = pd.ProductID
JOIN
    regiondim rd ON sf.RegionID = rd.RegionID
GROUP BY
    rd.RegionName;