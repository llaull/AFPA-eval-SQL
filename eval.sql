-- Liste des contacts français
SELECT * FROM [Northwind].[dbo].[Customers] WHERE Country = 'france'
/*
CustomerID CompanyName                              ContactName                    ContactTitle                   Address                                                      City            Region          PostalCode Country         Phone                    Fax
---------- ---------------------------------------- ------------------------------ ------------------------------ ------------------------------------------------------------ --------------- --------------- ---------- --------------- ------------------------ ------------------------
BLONP      Blondesddsl père et fils                 Frédérique Citeaux             Marketing Manager              24, place Kléber                                             Strasbourg      NULL            67000      France          88.60.15.31              88.60.15.32
BONAP      Bon app'                                 Laurence Lebihan               Owner                          12, rue des Bouchers                                         Marseille       NULL            13008      France          91.24.45.40              91.24.45.41
DUMON      Du monde entier                          Janine Labrune                 Owner                          67, rue des Cinquante Otages                                 Nantes          NULL            44000      France          40.67.88.88              40.67.89.89
FOLIG      Folies gourmandes                        Martine Rancé                  Assistant Sales Agent          184, chaussée de Tournai                                     Lille           NULL            59000      France          20.16.10.16              20.16.10.17
FRANR      France restauration                      Carine Schmitt                 Marketing Manager              54, rue Royale                                               Nantes          NULL            44000      France          40.32.21.21              40.32.21.20
LACOR      La corne d'abondance                     Daniel Tonini                  Sales Representative           67, avenue de l'Europe                                       Versailles      NULL            78000      France          30.59.84.10              30.59.85.11
LAMAI      La maison d'Asie                         Annette Roulet                 Sales Manager                  1 rue Alsace-Lorraine                                        Toulouse        NULL            31000      France          61.77.61.10              61.77.61.11
PARIS      Paris spécialités                        Marie Bertrand                 Owner                          265, boulevard Charonne                                      Paris           NULL            75012      France          (1) 42.34.22.66          (1) 42.34.22.77
SPECD      Spécialités du monde                     Dominique Perrier              Marketing Manager              25, rue Lauriston                                            Paris           NULL            75016      France          (1) 47.55.60.10          (1) 47.55.60.20
VICTE      Victuailles en stock                     Mary Saveley                   Sales Agent                    2, rue du Commerce                                           Lyon            NULL            69004      France          78.32.54.86              78.32.54.87
VINET      Vins et alcools Chevalier                Paul Henriot                   Accounting Manager             59 rue de l'Abbaye                                           Reims           NULL            51100      France          26.47.15.10              26.47.15.11

(11 ligne(s) affectée(s))
*/


-- 2 - Produits vendus par le fournisseur « Exotic Liquids »
SELECT [ProductName] AS Produit, UnitPrice as prix  FROM [Northwind].[dbo].[Suppliers] 
INNer JOIN [Products] ON [Suppliers].[SupplierID] = [Products].[SupplierID]
WHERE [CompanyName] = 'Exotic Liquids'
/*Produit                                  prix
---------------------------------------- ---------------------
Chai                                     18,00
Chang                                    19,00
Aniseed Syrup                            10,00

(3 ligne(s) affectée(s))
*/

-- 3 - Nombre de produits vendus par les fournisseurs Français dans l’ordre décroissant
Select CompanyName AS "Fournisseur", count(*) as "Nb produit" FROM Suppliers AS S
INNer JOIN [Products] AS P ON S.[SupplierID] = P.[SupplierID]
WHERE S.[Country] = 'France'
GROUP BY CompanyName
ORDER BY "Nb produit" DESC

/*Fournisseur                              Nb produit
---------------------------------------- -----------
Aux joyeux ecclésiastiques               2
Gai pâturage                             2
Escargots Nouveaux                       1

(3 ligne(s) affectée(s))
*/

-- 4 - Liste des clients Français ayant plus de 10 commandes :
Select CompanyName AS Client, count(*) as "Nb commande" FROM [dbo].[Customers] AS C
INNer JOIN [Orders] AS O ON C.[CustomerID] = O.[CustomerID]
WHERE [Country] = 'France'
GROUP BY CompanyName
HAVING  count(*) > 10

/*
Fournisseur                              Nb produit
---------------------------------------- -----------
Aux joyeux ecclésiastiques               2
Gai pâturage                             2
Escargots Nouveaux                       1

(3 ligne(s) affectée(s))
*/


-- 5- Liste des clients ayant un chiffre d’affaires > 30.000 :
Select [CompanyName] AS Client, SUM([UnitPrice]*[Quantity]) AS CA, [Country] AS Pays FROM [Customers] AS client
INNer JOIN [Orders] AS O ON client.[CustomerID] = O.[CustomerID]
INNer JOIN [Order Details] AS Od ON o.[OrderID] = Od.[OrderID]
GROUP BY [CompanyName], [Country]
HAVING SUM([UnitPrice]*[Quantity]) > 30000
ORDER BY SUM([UnitPrice]*[Quantity]) DESC

/*Client                                   CA                    Pays
---------------------------------------- --------------------- ---------------
QUICK-Stop                               117483,39             Germany
Save-a-lot Markets                       115673,39             USA
Ernst Handel                             113236,68             Austria
Hungry Owl All-Night Grocers             57317,39              Ireland
Rattlesnake Canyon Grocery               52245,90              USA
Hanari Carnes                            34101,15              Brazil
Folk och fä HB                           32555,55              Sweden
Mère Paillarde                           32203,90              Canada
Königlich Essen                          31745,75              Germany
Queen Cozinha                            30226,10              Brazil

(10 ligne(s) affectée(s))
*/

-- Liste des pays dont les clients ont passé commande de produits fournis par « Exotic Liquids » :

Select distinct(client.[Country]) AS Pays FROM [Customers] AS client
INNer JOIN [Orders] AS O ON client.[CustomerID] = O.[CustomerID]
INNer JOIN [Order Details] AS Od ON o.[OrderID] = Od.[OrderID]
INNer JOIN [Products] AS P ON Od.[ProductID] = P.[ProductID]
INNer JOIN [Suppliers] AS S ON P.[SupplierID] = S.[SupplierID]
WHERE S.[CompanyName] = 'Exotic Liquids'
GROUP BY client.[Country]
ORDER BY client.[Country] ASC
/*
Pays
---------------
Austria
Belgium
Brazil
Canada
Denmark
Finland
France
Germany
Ireland
Italy
Mexico
Poland
Portugal
Spain
Sweden
Switzerland
UK
USA
Venezuela

(19 ligne(s) affectée(s))*/

-- 7 – Montant des ventes de 1997
SELECT SUM([UnitPrice]*[Quantity]) AS CA FROM  [Orders] AS O
INNer JOIN [Order Details] AS Od ON o.[OrderID] = Od.[OrderID]
WHERE datepart(YEAR,orderDate) = 1997
GROUP By datepart(YEAR,orderDate) 
/*CA
---------------------
658388,75

(1 ligne(s) affectée(s))
*/

-- 8 – Montant des ventes de 1997 mois par mois :
SELECT DATEPART(MONTH, OrderDate) AS 'mois',  SUM([UnitPrice]*[Quantity]) AS CA 
 FROM  [Orders] AS O
INNer JOIN [Order Details] AS Od ON o.[OrderID] = Od.[OrderID]
WHERE datepart(YEAR,OrderDate) = 1997
GROUP By datepart(MONTH,OrderDate) 
ORDER BY DATEPART(MONTH, OrderDate)
/*
mois        CA
----------- ---------------------
1           66692,80
2           41207,20
3           39979,90
4           55699,39
5           56823,70
6           39088,00
7           55464,93
8           49981,69
9           59733,02
10          70328,50
11          45913,36
12          77476,26

(12 ligne(s) affectée(s))*/

-- 9 – Depuis quelle date le client « Du monde entier » n’a plus commandé ?
SELECT max(OrderDate) AS 'date derniere commande' FROM [Orders] AS O
INNer JOIN [Customers] AS C ON O.[CustomerID] = C.[CustomerID]
WHERE COmpanyName = 'Du monde entier'

/*date derniere commande
-----------------------
1998-02-16 00:00:00.000

(1 ligne(s) affectée(s))*/

-- 10 – Quel est le délai moyen de livraison en jours ?

SELECT avg(datediff(day, orderDate,ShippedDate)) AS 'Delais moyen de livraison en jours' From orders
/*
Delais moyen de livraison en jours
----------------------------------
8
Avertissement : la valeur NULL est éliminée par un agrégat ou par une autre opération SET.

(1 ligne(s) affectée(s))
*/