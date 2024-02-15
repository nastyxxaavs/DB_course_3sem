
1 Найти название самого продаваемого продукта.
SELECT p.Name from Production.Product AS p
WHERE p.ProductID = (
    SELECT TOP 1 sod.ProductID FROM Sales.SalesOrderDetail AS sod
    GROUP BY sod.ProductID
    ORDER BY SUM(sod.OrderQty) DESC
    )

2 Найти покупателя, совершившего покупку на самую большую сумм, считая
сумму покупки исходя из цены товара без скидки (UnitPrice).
SELECT soh.CustomerID from Sales.SalesOrderHeader as soh
WHERE soh.SalesOrderID = (
    SELECT TOP 1 sod.SalesOrderID FROM Sales.SalesOrderDetail as sod
    GROUP BY sod.ProductID, sod.SalesOrderID
    ORDER BY SUM(sod.UnitPrice * sod.OrderQty) DESC)


3 Найти такие продукты, которые покупал только один покупатель.
SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail 
WHERE SalesOrderID IN(
 SELECT SalesOrderID
 FROM Sales.SalesOrderHeader
 WHERE CustomerID IN (
  SELECT CustomerID FROM Sales.SalesOrderHeader soh
  INNER JOIN Sales.SalesOrderDetail sod
  ON soh.SalesOrderID = sod.SalesOrderID
  where sod.ProductID = ProductID
  GROUP BY CustomerID
  HAVING COUNT(*) = 1)
)

4 Вывести список продуктов, цена которых выше средней цены товаров в
подкатегории, к которой относится товар.
SELECT ProductID FROM Production.Product as p
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product
WHERE ProductSubcategoryID = p.ProductSubcategoryID)

5 Найти такие товары, которые были куплены более чем одним покупателем, при
этом все покупатели этих товаров покупали товары только одного цвета и товары
не входят в список покупок покупателей, купивших товары только двух цветов.
SELECT DISTINCT sod.ProductID FROM Sales.SalesOrderDetail AS sod
WHERE sod.SalesOrderID IN (
    SELECT soh.SalesOrderID FROM Sales.SalesOrderHeader as soh
    WHERE soh.CustomerID IN (
        SELECT soh2.CustomerID FROM Sales.SalesOrderHeader as soh2
         JOIN Sales.SalesOrderDetail AS sod2 on soh2.SalesOrderID = sod2.SalesOrderID
         JOIN Production.Product as p on sod2.ProductID = p.ProductID
         WHERE Color is not null AND soh2.CustomerID NOT IN (
             SELECT soh3.CustomerID FROM Sales.SalesOrderHeader as soh3
             JOIN Sales.SalesOrderDetail AS sod3 on soh3.SalesOrderID = sod3.SalesOrderID
             JOIN Production.Product as p2 on sod3.ProductID = p2.ProductID
             WHERE Color is not null
             GROUP BY soh3.CustomerID, Color
             HAVING COUNT(Color) = 2)
         GROUP BY soh2.CustomerID, Color
         HAVING COUNT(Color) = 1
        )
    )

6 Найти такие товары, которые были куплены такими покупателями, у которых
они присутствовали в каждой их покупке.
select distinct p.productid from Sales.SalesOrderDetail as p
where p.ProductID in (
select ProductID from Sales.SalesOrderDetail as sod
join sales.SalesOrderHeader as soh on soh.SalesOrderID = sod.SalesOrderID
where soh.CustomerID in(
select CustomerID from Sales.SalesOrderHeader as soh1
where soh1.CustomerID = soh.CustomerID  and soh.SalesOrderID = soh1.SalesOrderID
group by soh1.CustomerID
HAVING COUNT(*) = (SELECT COUNT(CustomerID) FROM Sales.SalesOrderHeader WHERE soh.CustomerID = CustomerID))
)

7 Найти покупателей, у которых есть товар, присутствующий в каждой
покупке/чеке.
SELECT distinct [CustomerID]
FROM [Sales].[SalesORDERHeader] AS SOH1
GROUP BY [CustomerID]
HAVING count(*)=all
(SELECT count(*)
FROM [Sales].[SalesORDERHeader] AS SOH INner JOIN
[Sales].[SalesORDERDetail] AS SOD
ON soh.SalesORDERID=sod.SalesORDERID
GROUP BY soh.[CustomerID], sod.ProductID
HAVING soh.CustomerID=soh1.CustomerID)

8 Найти такой товар или товары, которые были куплены не более чем тремя
различными покупателями.

SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail 
WHERE SalesOrderID IN(
 SELECT SalesOrderID
 FROM Sales.SalesOrderHeader
 WHERE CustomerID IN (
  SELECT CustomerID FROM Sales.SalesOrderHeader soh
  INNER JOIN Sales.SalesOrderDetail sod
  ON soh.SalesOrderID = sod.SalesOrderID
  where sod.ProductID = ProductID
  GROUP BY CustomerID
  HAVING COUNT(*) <= 3)
)

SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail
WHERE ProductID IN (
    SELECT sod.ProductID FROM Sales.SalesOrderDetail  sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY sod.ProductID
    HAVING COUNT(DISTINCT soh.CustomerID) <= 3
    )


SELECT DISTINCT ProductID
FROM [Sales].[SalesOrderDetail]
WHERE ProductID IN (
SELECT soh.Productid
FROM [Sales].[SalesORDERheader] AS sod JOIN
[Sales].[SalesORDERDetail] AS soh
ON sod.SalesORDERID=soh.SalesORDERID
WHERE
exists(SELECT CustomerID
FROM [Sales].[SalesORDERheader] AS sod1 JOIN
[Sales].[SalesORDERdetail] AS soh1
ON sod.SalesORDERID=soh.SalesORDERID
WHERE soh1.ProductID=soh.ProductID AND
sod1.CustomerID!=sod.CustomerID
group by CustomerID
having count(sod1.Customerid) <= 3
))

9 Найти все товары, такие что их покупали всегда с товаром, цена которого
максимальна в своей категории.

SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN (
    SELECT sod.SalesOrderID FROM Sales.SalesOrderDetail sod
    WHERE sod.ProductID IN (
        SELECT p.ProductID FROM Production.Product p
        WHERE p.ListPrice = ANY (
            SELECT MAX(p.ListPrice) FROM Production.Product p
   INNER JOIN Production.ProductSubcategory ps
   ON p.ProductSubcategoryID = ps.ProductSubcategoryID
   INNER JOIN Production.ProductCategory pc
   ON ps.ProductCategoryID = pc.ProductCategoryID
   GROUP BY pc.ProductCategoryID
        )
        )
    )

ИЛИ 
  
SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN (
    SELECT sod.SalesOrderID FROM Sales.SalesOrderDetail sod
    WHERE sod.ProductID IN (
        SELECT p.ProductID FROM Production.Product p
        WHERE p.ListPrice in (
            SELECT MAX(p.ListPrice) FROM Production.Product p
   INNER JOIN Production.ProductSubcategory ps
   ON p.ProductSubcategoryID = ps.ProductSubcategoryID
   INNER JOIN Production.ProductCategory pc
   ON ps.ProductCategoryID = pc.ProductCategoryID
   GROUP BY pc.ProductCategoryID
        )
        )
    )

10 Найти номера тех покупателей, у которых есть как минимум два чека, и
каждый из этих чеков содержит как минимум три товара, каждый из которых как
минимум был куплен другими покупателями три раза.
SELECT CustomerID FROM Sales.SalesOrderHeader soh
WHERE soh.SalesOrderID IN (
        SELECT sod.SalesOrderID FROM Sales.SalesOrderDetail sod
        WHERE sod.ProductID IN (
            SELECT sod2.ProductID FROM Sales.SalesOrderDetail sod2
      INNER JOIN Sales.SalesOrderHeader soh2
      ON sod2.SalesOrderID = soh2.SalesOrderID
            GROUP BY sod2.ProductID
            HAVING COUNT(DISTINCT soh2.CustomerID) >= 3
            )
        GROUP BY sod.SalesOrderID
        HAVING COUNT(DISTINCT ProductID) >= 3
    )
GROUP BY CustomerID
HAVING COUNT(DISTINCT SalesOrderID) >= 2

11 Найти все чеки, в которых каждый товар был куплен дважды этим же
покупателем.
SELECT DISTINCT SalesorderID
FROM [Sales].[SalesOrderHeader]
WHERE SalesOrderID IN (
SELECT soh.SalesOrderID
FROM [Sales].[SalesORDERdetail] AS sod JOIN
[Sales].[SalesORDERheader] AS soh
ON sod.SalesORDERID=soh.SalesORDERID
WHERE
exists(SELECT ProductID
FROM [Sales].[SalesORDErdetail] AS sod1 JOIN
[Sales].[SalesORDERheader] AS soh1
ON sod.SalesORDERID=soh.SalesORDERID
WHERE soh1.SalesOrderID=soh.salesorderID AND soh1.CustomerID = soh.CustomerID and 
(sod1.ProductID=sod.ProductID and sod.OrderQty = 2)
))


12 Найти товары, которые были куплены минимум три раза различными
покупателями.(?!)
SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail
WHERE ProductID in (
SELECT sod2.ProductID FROM Sales.SalesOrderDetail AS sod2
INNER JOIN Sales.SalesOrderHeader AS soh2
ON sod2.SalesOrderID = soh2.SalesOrderID
GROUP BY sod2.ProductID
HAVING COUNT(DISTINCT CustomerID) >= 3)

  
13 Найти такую подкатегорию или подкатегории товаров, которые содержат
более трех товаров, купленных более трех раз.
select distinct ProductSubcategoryID from Production.Product
where ProductID in(
select ProductID from sales.SalesOrderDetail as sod
group by ProductID
having count(productid) > 3 and productid in (
select productid
from sales.SalesOrderDetail as sod1
join sales.SalesOrderHeader as soh1 on
soh1.SalesOrderID = sod1.SalesOrderID
group by ProductID, orderqty
having count(OrderQty) > 3))


14 Найти те товары, которые не были куплены более трех раз, и как минимум
дважды одним и тем же покупателем. (?!)
SELECT DISTINCT ProductID
FROM [Sales].[SalesOrderDetail]
WHERE ProductID not IN (
SELECT soh.Productid
FROM [Sales].[SalesORDERheader] AS sod JOIN
[Sales].[SalesORDERDetail] AS soh
ON sod.SalesORDERID=soh.SalesORDERID
WHERE
exists(SELECT CustomerID
FROM [Sales].[SalesORDERheader] AS sod1 JOIN
[Sales].[SalesORDERdetail] AS soh1
ON sod.SalesORDERID=soh.SalesORDERID
WHERE soh1.ProductID=soh.ProductID AND
(sod1.CustomerID=sod.CustomerID and soh.OrderQty = 2) AND
soh.OrderQty > 3
))

или 

SELECT DISTINCT ProductID
FROM [Sales].[SalesOrderDetail]
WHERE ProductID IN (
SELECT soh.Productid
FROM [Sales].[SalesORDERheader] AS sod JOIN
[Sales].[SalesORDERDetail] AS soh
ON sod.SalesORDERID=soh.SalesORDERID
WHERE
exists(SELECT CustomerID
FROM [Sales].[SalesORDERheader] AS sod1 JOIN
[Sales].[SalesORDERdetail] AS soh1
ON sod.SalesORDERID=soh.SalesORDERID
WHERE soh1.ProductID=soh.ProductID AND
(sod1.CustomerID=sod.CustomerID and soh.OrderQty = 2) AND
soh.OrderQty <= 3
))








