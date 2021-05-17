use ZRESTAURANTE;

-- Mostrar cuantas facturas se registraron con horaApertura entre las 21 y las 22 horas, renombrar a La columna cantidad

SELECT COUNT(*) AS Cantidad
FROM Facturas
WHERE horaApertuta >= '1900-01-01 21:00'
AND horaApertuta <= '1900-01-01 22:00'

-- Mostrar los id de los mozos y la cantidad total de sus ventas, renombrar a la columna TotalXMozo
SELECT IdMozo, COUNT(*) AS TotalXMozo 
FROM Facturas
GROUP BY IdMozo

-- Mostrar el id del mozo que vendió más de 200 pesos, renombrar a la columna venta_total  
SELECT IdMozo, SUM(total) AS venta_total
FROM Facturas
GROUP BY IdMozo
HAVING SUM(TOTAL) > 200

-- mostrar el id de ingrediente, la descripción y el stock de los artículos 116, 300 y 301 
SELECT IdIngrediente, descripcion, stock
FROM Ingredientes
WHERE IdIngrediente = 116
OR IdIngrediente = 300
OR IdIngrediente = 301

-- mostrar el total del stock de todos los ingredientes que sean helado, renombrar a este campo stock_helado   
SELECT SUM(stock) AS stock_helado
FROM Ingredientes
WHERE descripcion LIKE '%helado%'

-- mostrar la descripción de los ingredientes que tienen un stock superior a 10000, un precio de compra inferior a 50 y un punto de reposición superior a 10   
SELECT descripcion
FROM Ingredientes
where stock > 10000
AND precComp < 50
AND puntoRep > 10

-- De la tabla ItemsFactura mostrar el nrofactura, la cantidad total de productos de cada una  
SELECT NroFactura, SUM(cantida) AS CantidadTotal
FROM ItemsFactura
GROUP BY NroFactura

-- De la tabla Factura, mostrar el nrofactura y el importe total, donde se haya vendido más de 100 pesos, renombrar al ultimo campo como: importe_total  
SELECT NroFactura, total AS importe_total
FROM Facturas
WHERE total > 100

-- Mostrar el id y la descripción de las unidades que estén expresados en bolsas 
SELECT *
FROM Unidades
WHERE descripcion like '%Bolsa%'

-- mostrar todos los campos de la tabla teléfono mozo, solo de los que tengan celular   
SELECT *
FROM TelefonoMozo
WHERE celular > 0

-- mostrar todos los campos de la tabla teléfono proveedor, solo de los que pertenezcan al código de área 64   
SELECT *
FROM TelefonoProveedor
WHERE codArea = 64

-- mostrar los teléfonos de los proveedores 50 y 60   
SELECT numero
FROM TelefonoProveedor
WHERE IdProveedor
IN (50, 60)