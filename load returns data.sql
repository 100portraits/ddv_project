-- create returns table
CREATE TABLE superstoresales_returns (
    OrderID INT,
    Status VARCHAR(255)
);


-- Load returns data into a temporary table
LOAD DATA LOCAL INFILE 'SuperstoreSales_returns.csv'
INTO TABLE superstoresales_returns
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderID, Status);
