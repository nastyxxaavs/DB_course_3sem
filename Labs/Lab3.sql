1 Найти и вывести на экран название продуктов и название категорий товаров, к
которым относится этот продукт, с учетом того, что в выборку попадут только
товары с цветом Red и ценой не менее 100.
select p.name, pc.name
from AdventureWorks2017.Production.Product as p join 
AdventureWorks2017.Production.ProductSubcategory as psc
on p.ProductSubcategoryID = psc.ProductSubcategoryID
join AdventureWorks2017.Production.ProductCategory as pc 
on pc.ProductCategoryID = psc.ProductCategoryID
where p.Color = 'Red' and p.ListPrice >= 100


2 Вывести на экран названия подкатегорий с совпадающими именами.
//ну лаба на джойны, так что видимо требуется что-то такое
SELECT PSSubC.name
FROM [AdventureWorks2017].[Production].[Product] AS P INNER JOIN
[AdventureWorks2017].[Production].[ProductSubcategory] AS PSC
ON P.ProductSubcategoryID=PSC.ProductSubcategoryID
INNER JOIN [AdventureWorks2017].[Production].[ProductCategory] AS PC
ON PSC.ProductCategoryID=PC.ProductCategoryID
GROUP BY PsC.name
having COUNT(*) > 1

  
3 Вывести на экран название категорий и количество товаров в данной
категории.
SELECT PC.name, count(*)
FROM [AdventureWorks2017].[Production].[Product] AS P INNER JOIN
[AdventureWorks2017].[Production].[ProductSubcategory] AS PSC
ON P.ProductSubcategoryID=PSC.ProductSubcategoryID
INNER JOIN [AdventureWorks2017].[Production].[ProductCategory] AS PC
ON PSC.ProductCategoryID=PC.ProductCategoryID
GROUP BY PC.name


4 Вывести на экран название подкатегории, а также количество товаров в данной
подкатегории с учетом ситуации, что могут существовать подкатегории с
одинаковыми именами.
select psc.name, count(*)
from AdventureWorks2017.Production.Product as p join 
AdventureWorks2017.Production.ProductSubcategory as psc
on p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY  psc.ProductSubcategoryID, psc.Name


5 Вывести на экран название первых трех подкатегорий с небольшим(min?)
количеством товаров.
SELECT TOP 3 with ties PsC.ProductsubCategoryID, count(*)
FROM [AdventureWorks2017].[Production].[Product] AS P INNER JOIN
[AdventureWorks2017].[Production].[ProductSubcategory] AS PSC
ON P.ProductSubcategoryID=PSC.ProductSubcategoryID
GROUP BY PsC.ProductsubCategoryID
ORDER BY COUNT(*) asc


6 Вывести на экран название подкатегории и максимальную цену продукта с
цветом Red в этой подкатегории.
select psc.name, max(p.listprice)
from AdventureWorks2017.Production.Product as p join 
AdventureWorks2017.Production.ProductSubcategory as psc
on p.ProductSubcategoryID = psc.ProductSubcategoryID
where p.Color = 'Red' 
group by psc.name



7 Вывести на экран название поставщика и количество товаров, которые он
поставляет.
select v.name, count(pv.productid) // или тут p.productid
from AdventureWorks2017.Purchasing.productvendor as pv join 
AdventureWorks2017.Production.Product as p
on pv.ProductID = p.ProductID
join AdventureWorks2017.Purchasing.Vendor as v 
on pv.BusinessEntityID = v.BusinessEntityID
group by v.name

8 Вывести на экран название товаров, которые поставляются более чем одним
поставщиком.
select p.name, v.OnOrderQty
from AdventureWorks2017.Production.product as p join
AdventureWorks2017.Purchasing.ProductVendor as v
on p.ProductID = v.ProductID
where v.OnOrderQty > 1
group by p.name, v.onOrderQty

или 
select p.name, v.OnOrderQty
from AdventureWorks2017.Production.product as p join
AdventureWorks2017.Purchasing.ProductVendor as v
on p.ProductID = v.ProductID
where v.OnOrderQty > 1
group by p.ProductID,p.name, v.onOrderQty


9 Вывести на экран название самого продаваемого товара.
select top 1 with ties p.name
from AdventureWorks2017.Production.product as p join
AdventureWorks2017.Sales.SpecialOfferProduct as s 
on p.ProductID = s.ProductID
join AdventureWorks2017.sales.SalesOrderDetail as o
on s.SpecialOfferID = o.SpecialOfferID
group by p.name, o.OrderQty
order by o.OrderQty desc

10 Вывести на экран название категории, товары из которой продаются наиболее
активно.
select top 1 with ties pc.name, o.OrderQty
from AdventureWorks2017.Production.product as p join
AdventureWorks2017.Production.ProductsubCategory as psc
on p.ProductsubcategoryID = psc.ProductSubcategoryID
join AdventureWorks2017.Production.ProductCategory as pc
on psc.ProductSubcategoryID = pc.ProductCategoryID
join AdventureWorks2017.Sales.SpecialOfferProduct as s 
on p.ProductID = s.ProductID
join AdventureWorks2017.sales.SalesOrderDetail as o
on s.SpecialOfferID = o.SpecialOfferID
group by pc.name, o.OrderQty
order by o.OrderQty desc


11 Вывести на экран названия категорий, количество подкатегорий и количество
товаров в них.
select pc.name, count(psc.ProductsubCategoryID), count(p.productid)
from AdventureWorks2017.Production.Product as p join 
AdventureWorks2017.Production.ProductSubcategory as psc
on p.ProductSubcategoryID = psc.ProductSubcategoryID
join AdventureWorks2017.Production.ProductCategory as pc 
on pc.ProductCategoryID = psc.ProductCategoryID
group by pc.name


12 Вывести на экран номер кредитного рейтинга и количество товаров,
поставляемых компаниями, имеющими этот кредитный рейтинг.
select v.CreditRating, count(p.productid)
from AdventureWorks2017.Purchasing.productvendor as pv join 
AdventureWorks2017.Production.Product as p
on pv.ProductID = p.ProductID
join AdventureWorks2017.Purchasing.Vendor as v 
on pv.BusinessEntityID = v.BusinessEntityID
group by v.CreditRating

