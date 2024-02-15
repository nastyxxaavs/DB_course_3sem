1. Найти и вывести на экран количество товаров каждого цвета, исключив из
поиска товары, цена которых меньше 30.
SELECT COUNT(*) AS "Amount"
FROM [AdventureWorks2017].[Production].[Product] as p
WHERE p.ListPrice<30 AND p.Color is not null
GROUP BY p.Color

2. Найти и вывести на экран список, состоящий из цветов товаров, таких, что
минимальная цена товара данного цвета более 100. (?!)
SELECT Color, ListPrice
FROM [AdventureWorks2017].[Production].[Product] AS p
WHERE p.Color is not null
GROUP BY p.Color, p.ListPrice
HAVING MIN(p.ListPrice)>100

3. Найти и вывести на экран номера подкатегорий товаров и количество товаров
в каждой (под)категории.
SELECT [ProductSubcategoryID], COUNT(*) AS "Amount"
FROM [AdventureWorks2017].[Production].[Product]
WHERE [ProductSubcategoryID] IS NOT NULL
GROUP BY [ProductSubcategoryID]


4. Найти и вывести на экран номера товаров и количество фактов продаж данного
товара (используется таблица SalesORDERDetail).
SELECT ProductID, SUM(OrderQty) AS 'Amount'
FROM Sales.SalesOrderDetail
GROUP BY ProductID

5. Найти и вывести на экран номера товаров, которые были куплены более пяти
раз.
SELECT [ProductID]
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail]
GROUP BY [ProductID]
HAVING COUNT(OrderQty)>5 

6. Найти и вывести на экран номера покупателей, CustomerID, у которых
существует более одного чека, SalesORDERID, с одинаковой датой
SELECT CustomerID, OrderDate, COUNT(SalesOrderID) AS 'Same_day_orders'
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, OrderDate
HAVING COUNT(SalesOrderID) > 1


7. Найти и вывести на экран все номера чеков, на которые приходится более трех
продуктов.
SELECT [SalesORDERID]
FROM [AdventureWorks2017].[Production].[Product]
GROUP BY [SalesORDERID]
HAVING COUNT(*)>3

8. Найти и вывести на экран все номера продуктов, которые были куплены более
трех раз.
SELECT [ProductID]
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail]
GROUP BY [ProductID]
HAVING COUNT(OrderQty)>3


9. Найти и вывести на экран все номера прод
уктов, которые были куплены или
три или пять раз.
SELECT [ProductID]
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail]
GROUP BY [ProductID]
HAVING COUNT(OrderQty)=3 OR COUNT(OrderQty)=5


10. Найти и вывести на экран все номера подкатегорий, в которым относится
более десяти товаров.
SELECT [ProductSubcategoryID]
FROM [AdventureWorks2017].[Production].[Product]
GROUP BY [ProductSubcategoryID]
HAVING COUNT(*)>10

???11. Найти и вывести на экран номера товаров, которые всегда покупались в
одном экземпляре за одну покупку.
SELECT [ProductID]
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail]
GROUP BY [SalesORDERID], [OrderQty], [ProductID]
HAVING COUNT(*) = 1

12 Найти и вывести на экран номер чека, SalesORDERID, на который приходится
с наибольшим разнообразием товаров купленных на этот чек.
SELECT  TOP 1 WITH TIES [SalesORDERID], COUNT(DISTINCT[ProductID])
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail]
GROUP BY [SalesORDERID]
Order by COUNT(DISTINCT[ProductID]) desc


13 Найти и вывести на экран номер чека, SalesORDERID с наибольшей суммой
покупки, исходя из того, что цена товара – это UnitPrice, а количество
конкретного товара в чеке – это ORDERQty.
SELECT TOP 1 SalesOrderID, SUM(UnitPrice * OrderQty) 
FROM AdventureWorks2017.Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY SUM(UnitPrice * OrderQty) DESC

14 Определить количество товаров в каждой подкатегории, исключая товары,
для которых подкатегория не определена, и товары, у которых не определен цвет.
SELECT COUNT(*) AS 'Amount'
FROM [AdventureWorks2017].[Production].[Product]
WHERE [ProductSubcategoryID] IS NOT NULL AND [Color] IS NOT NULL
GROUP BY [Color],[ProductSubcategoryID]

15 Получить список цветов товаров в порядке убывания количества товаров
данного цвета
SELECT [Color]
FROM [AdventureWorks2017].[Production].[Product]
GROUP BY [Color]
ORDER BY COUNT(*) DESC

16 Вывести на экран ProductID тех товаров, что всегда покупались в количестве
более 1 единицы на один чек, при этом таких покупок было более двух.
SELECT [ProductID]
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail]
WHERE OrderQty > 1
GROUP BY [ProductID]
HAVING COUNT(SalesOrderID) > 2
