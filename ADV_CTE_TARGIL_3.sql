use AdventureWorks2017
GO
WITH Y13
AS
(select year(S.orderdate) AS YY , T.Name,sum(s.TotalDue) AS sumsales
	,count(S.SalesOrderID) AS count_orders
from Sales.SalesOrderHeader S JOIN Sales.SalesTerritory t
ON S.TerritoryID = T.TerritoryID
WHERE year(S.orderdate)=2013
GROUP BY year(S.orderdate), T.Name),
Y14
AS
(select year(S.orderdate) AS YY , T.Name,sum(s.TotalDue) AS sumsales
,count(S.SalesOrderID) AS count_orders
from Sales.SalesOrderHeader S JOIN Sales.SalesTerritory t
ON S.TerritoryID = T.TerritoryID
WHERE year(S.orderdate)=2014
GROUP BY year(S.orderdate), T.Name)
SELECT Y13.NAME AS Territoy
,y13.yy as year2013
,y13.count_orders count2013
,FORMAT(y13.sumsales,'C') as sum13
,y14.yy as year2014
, y14.count_orders AS count2014
,FORMAT(y14.sumsales,'C') as sum14
,y14.count_orders- y13.count_orders AS difforders
,FORMAT(y14.sumsales-y13.sumsales,'C') AS diffsum
FROM Y13   join y14
ON Y13.NAME = Y14.NAME




go

WITH TBL
AS
(
select year(S.orderdate) AS YY , T.Name,sum(s.TotalDue) AS sumsales
	,count(S.SalesOrderID) AS count_orders
from Sales.SalesOrderHeader S JOIN Sales.SalesTerritory t
ON S.TerritoryID = T.TerritoryID
WHERE year(S.orderdate) IN (2013,2014)
GROUP BY year(S.orderdate), T.Name
),
tbl1
AS
(SELECT *, LAG(count_orders,1) over(PARTITION BY  NAME ORDER BY YY, NAME ) LAG_ORDERS13
FROM tbl)
SELECT * ,count_orders as y2014,count_orders -LAG_ORDERS13
FROM tbl1
WHERE LAG_ORDERS13 is not null