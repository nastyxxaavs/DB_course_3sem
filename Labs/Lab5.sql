1 Найти среднее количество покупок на чек для каждого покупателя (2 способа).
SELECT t.customerid, avg(c)
FROM 
(
SELECT p2.customerid, count(p.productid) as c
FROM Sales.SalesOrderHeader AS p2 join sales.SalesOrderDetail as p on p.SalesOrderID = p2.SalesOrderID
group by p2.SalesOrderID, CustomerID
) t
group by t.customerid

ИЛИ
  
WITH Sales_CTE (SalesORDERID, productid)
AS
(
SELECT sod.SalesORDERID, count(*)
FROM sales.SalesOrderDetail as sod
group by SalesOrderID
)
SELECT customerid,avg(productid)
from sales.SalesOrderHeader as s join Sales_CTE on s.SalesOrderID = Sales_CTE.SalesORDERID
GROUP BY customerid

2 Найти для каждого продукта и каждого покупателя соотношение количества
фактов покупки данного товара данным покупателем к общему количеству
фактов покупки товаров данным покупателем (?!)
WITH tmp(id, productID, qty) 
AS
(SELECT sod.SalesOrderID, sod.productID, SUM(sod.OrderQty) FROM Sales.SalesOrderDetail AS sod
GROUP BY sod.ProductID, sod.SalesOrderID
)
SELECT SUM(qty)/COUNT(*) AS averageQty FROM tmp
INNER JOIN Sales.SalesOrderHeader AS soh
ON tmp.id = soh.SalesOrderID
GROUP BY soh.CustomerID, productID

3 Вывести на экран следящую информацию: Название продукта, Общее
количество фактов покупки этого продукта, Общее количество покупателей
этого продукта
with res1 (name, id)
as (select p.Name, p.ProductID
from Production.Product as p
), 
res2 (qty, id, salesid)
as (select sod.OrderQty, sod.ProductID, sod.SalesOrderID
from sales.SalesOrderDetail as sod)
select r.name, sum(d.qty), count(distinct customerid)
from res1 as r join res2 as d on r.id = d.id
join sales.SalesOrderHeader as h on h.SalesOrderID = d.salesid
group by r.name


4 Вывести для каждого покупателя информацию о максимальной и минимальной
стоимости одной покупки, чеке, в виде таблицы: номер покупателя,
максимальная сумма, минимальная сумма.
WITH tmp(salesorderID, price) AS
(SELECT sod.SalesOrderID, SUM(sod.OrderQty * sod.UnitPrice) FROM Sales.SalesOrderDetail AS sod
GROUP BY SalesOrderID)
SELECT CustomerID, MAX(price), MIN(price)
FROM Sales.SalesOrderHeader AS soh
INNER JOIN tmp ON soh.salesorderID = tmp.salesorderID
GROUP BY CustomerID

5 Найти номера покупателей, у которых не было нет ни одной пары чеков с
одинаковым количеством наименований товаров.
WITH tmp(salesOrderID, qty) AS
(SELECT sod.SalesOrderID, COUNT(DISTINCT ProductID) FROM Sales.SalesOrderDetail AS sod
GROUP BY SalesOrderID)
SELECT CustomerID, COUNT(qty) FROM
Sales.SalesOrderHeader AS soh
INNER JOIN tmp ON tmp.salesOrderID = soh.SalesOrderID
GROUP BY CustomerID
HAVING COUNT(qty) = COUNT(DISTINCT qty)

6 Найти номера покупателей, у которых все купленные ими товары были
куплены как минимум дважды, т.е. на два разных чека.
with res1 (salesid, id)
as (select p.SalesOrderID, p.ProductID
from sales.SalesOrderDetail p
)
select h.CustomerID
from Sales.SalesOrderHeader as h join res1 on h.SalesOrderID = res1.salesid
group by CustomerID
having count(distinct h.SalesOrderID) >= 2
