1. Найти и вывести на экран названия продуктов, их цвет и размер.
SELECT p.Name, p.Color, p.Size
FROM [Production].[Product] AS p

2. Найти и вывести на экран названия, цвет и размер таких продуктов, у которых
цена более 100.
SELECT p.Name, p.Color, p.Size 
FROM [Production].[Product] AS p
WHERE p.ListPrice>=100

3. Найти и вывести на экран название, цвет и размер таких продуктов, у которых
цена менее 100 и цвет Black.
SELECT p.Name, p.Color, p.Size 
FROM [Production].[Product] AS p
WHERE (p.ListPrice<100 AND p.Color='Black')

4. Найти и вывести на экран название, цвет и размер таких продуктов, у которых
цена менее 100 и цвет Black, упорядочив вывод по возрастанию стоимости
продуктов.
SELECT p.Name, p.Color, p.Size
FROM [AdventureWorks2017].[Production].[Product] AS p
WHERE (p.ListPrice<100 AND p.Color='Black')
ORDER BY p.ListPrice ASC

5. Найти и вывести на экран название и размер первых трех самых дорогих
товаров с цветом Black.
SELECT top 3 with ties p.Name, p.Size
FROM [Production].[Product] AS p
WHERE p.Color='Black'
ORDER BY p.ListPrice desc

6. Найти и вывести на экран название и цвет таких продуктов, для которых
определен и цвет, и размер.
SELECT p.Name, p.Color
FROM[Production].[Product] AS p
WHERE (p.Color is NOT null AND p.Size is NOT null)
  
7. Найти и вывести на экран не повторяющиеся цвета продуктов, у которых цена
находится в диапазоне от 10 до 50 включительно.
SELECT DISTINCT p.Color
FROM [AdventureWorks2017].[Production].[Product] AS p
WHERE (p.ListPrice>=10 AND p.ListPrice>=50) (не знаю, стоит ли тут еще писать, что цвет определен)

8. Найти и вывести на экран все цвета таких продуктов, у которых в имени первая
буква ‘L’ и третья ‘N’.
SELECT p.Color
FROM [Production].[Product] AS p
WHERE (p.Name like 'L%' AND p.Name like '__N%')

9. Найти и вывести на экран названия таких продуктов, которых начинаются
либо на букву ‘D’, либо на букву ‘M’, и при этом длина имени – более трех
символов.
SELECT p.Name
FROM [Production].[Product] AS p
WHERE ((p.Name like 'D%' OR p.Name like 'M%') AND len(p.Name)>3)
  
10. Вывести на экран названия продуктов, у которых дата начала продаж – не
позднее 2012 года. (вроде  ок)
SELECT p.Name, p.SellStartDate
FROM [AdventureWorks2017].[Production].[Product] AS p
WHERE datepart(YEAR,p.SellStartDate)<=2012

ИЛИ

SELECT p.Name, p.SellStartDate
FROM [AdventureWorks2017].[Production].[Product] AS p
WHERE p.SellStartDate<='2012'

11. Найти и вывести на экран названия всех подкатегорий товаров.
SELECT p.ProductSubcategoryID
FROM [AdventureWorks2017].[Production].[Product] AS p
(WHERE p.ProductSubcategoryID is not NUll)


12. Найти и вывести на экран названия всех категорий товаров.
SELECT p.Name
FROM [AdventureWorks2017].[Production].[ProductCategory] AS p

13. Найти и вывести на экран имена всех клиентов из таблицы Person, у которых
обращение (Title) указано как «Mr.».
SELECT p.FirstName
FROM [AdventureWorks2017].[Person].[Person] AS p
WHERE p.Title like '%Mr.%'

14. Найти и вывести на экран имена всех клиентов из таблицы Person, для
которых не определено обращение (Title). 
SELECT p.FirstName
FROM [AdventureWorks2017].[Person].[Person] AS p
WHERE p.Title is null
