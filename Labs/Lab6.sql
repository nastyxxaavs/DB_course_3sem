1 Найти долю продаж каждого продукта (цена продукта * количество продукта),
на каждый чек, в денежном выражении.
SELECT productid, SUM(unitprice * OrderQty) 
OVER (PARTITION BY salesorderid, productid) / SUM(UnitPrice * OrderQty) OVER () as sales_share
FROM sales.SalesOrderDetail


???2 Вывести на экран список продуктов, их стоимость, а также разницу между
стоимостью этого продукта и стоимостью самого дешевого продукта в той же
подкатегории, к которой относится продукт.

select p.ProductID, p.ListPrice, p.ListPrice-min(listprice) 
over(partition by productsubcategoryid)
from Production.Product as p
(where ListPrice>0)

with tmp (productid, totalprice,subid)
AS
(
SELECT od.ProductID, sum(orderqty*od.UnitPrice), oh.productsubcategoryid
FROM [Sales].[SalesORDERDetail] AS OD
INner JOIN production.product AS OH
ON od.productid=oh.productid
GROUP BY od.productid, oh.ProductSubcategoryID
)
SELECT productid, totalprice, totalprice- min(totalprice) OVER(partitiON BY subid)
FROM tmp

SELECT sod.productid, sum(orderqty*sod.UnitPrice), sum(orderqty*sod.UnitPrice) - min(sum(orderqty*sod.UnitPrice)) OVER (PARTITION BY productsubcategoryid) as price_diff
FROM sales.SalesOrderDetail as sod join Production.Product as p on p.ProductID = sod.ProductID
group by sod.ProductID, p.ProductSubcategoryID

3 Вывести три колонки: номер покупателя, номер чека покупателя
(отсортированный по возрастанию даты чека) и искусственно введенный
порядковый номер текущего чека, начиная с 1, для каждого покупателя.
SELECT customerid, salesorderid, ROW_NUMBER() OVER (PARTITION BY customerid ORDER BY orderdate) as number
FROM sales.SalesOrderHeader

??4 Вывести номера продуктов, таких что их цена выше средней цены продукта в
подкатегории, к которой относится продукт. Запрос реализовать двумя
способами. В одном из решений допускается использование обобщенного
табличного выражения.

1 вариант:
SELECT ProductID FROM Production.Product as p
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product
WHERE ProductSubcategoryID = p.ProductSubcategoryID)

2 вариант:
SELECT productid
FROM ( SELECT productid,ListPrice, AVG(ListPrice) OVER (PARTITION BY productsubcategoryid) as avg_price
    FROM 
        Production.Product
		where ProductSubcategoryID is not null
) t
WHERE 
     ListPrice > t.avg_price;


??5 Вывести на экран номер продукта, название продукта, а также информацию о
среднем количестве этого продукта, приходящихся на три последних по дате
чека, в которых был этот продукт

SELECT p.productid, p.name, AVG(sod.orderqty) OVER (PARTITION BY p.productid ORDER BY soh.orderdate DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as avg_quantity
FROM 
    production.product as p JOIN sales.SalesOrderDetail as sod ON p.productid = sod.ProductID
JOIN 
    sales.SalesOrderHeader as soh ON sod.SalesOrderID = soh.SalesOrderID
	


SELECT distinct p.productid, p.name, AVG(sod.orderqty) OVER (PARTITION BY p.productid ORDER BY soh.orderdate DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as avg_quantity
FROM 
    production.product as p JOIN sales.SalesOrderDetail as sod ON p.productid = sod.ProductID
JOIN 
    sales.SalesOrderHeader as soh ON sod.SalesOrderID = soh.SalesOrderID
	








