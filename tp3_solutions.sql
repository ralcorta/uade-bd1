USE ZRESTAURANTE

-- Mostrar la lista de mozos que NO poseen número de teléfonos. 
GO
SELECT *
FROM Mozos
WHERE IdMozo IN (
    SELECT IdMozo
    FROM TelefonoMozo
)

-- Mostrar la lista de todos los platos existentes con sus respectivos ingredientes, ordenar por nombre de plato. 
GO
SELECT Platos.descripcion, Ingredientes.descripcion 
FROM Platos
INNER JOIN PlaIng ON Platos.IdPlato = PlaIng.IdPlato
INNER JOIN Ingredientes ON PlaIng.IdIngrediente = Ingredientes.IdIngrediente
ORDER BY Platos.descripcion

-- Mostrar el menú del restaurant considerando Rubro, Plato, Precio.
GO
SELECT *
FROM Platos
INNER JOIN Rubros ON Platos.IdRubro = Rubros.IdRubro

-- Mostrar la razón social, dirección (Formato: “Calle – Altura, Piso: x”) y localidad de los proveedores que tengan un departamento como oficina. 
GO
SELECT P.razsoc AS RazonSocial, CONCAT(p.calle, ' - ', p.numero, ', Piso: ', P.piso) AS Direccion, L.localida
FROM Proveedores as P
INNER JOIN Localidades AS L ON P.IdCodPos = L.IdCodpos
WHERE P.departamento <> ''

-- Crear una vista donde se muestre el nrofactura, la cantidad total y el importe total, donde se haya vendido más de 30 pesos y más de 5 ítems, 
-- renombrar los campos a cantidad_items e importe_total, además mostrar la cantidad de personas atendidas en cada factura. 
GO
CREATE VIEW
TOTAL_POR_FACTURA AS (
    SELECT F.NroFactura AS NroFactura, F.total as importe_total, SUM(Items.cantida) AS cantidad_items
    FROM Facturas AS F
    INNER JOIN ItemsFactura AS Items on F.NroFactura = Items.NroFactura
    GROUP BY F.NroFactura, F.total
    HAVING SUM(F.total) > 30 AND SUM(Items.cantida) > 5
)
GO
SELECT * FROM TOTAL_POR_FACTURA

-- Crear una vista donde se muestre ordenado por proveedor la lista de ingredientes que ofrece cada uno y su precio. 
GO
CREATE VIEW
INGREDIENTES_POR_PROVEEDOR AS (
    SELECT P.IdProveedor, descripcion, precComp
    FROM Ingredientes AS I
    INNER JOIN ProIng AS PRI ON I.IdIngrediente = PRI.IdIngrediente
    INNER JOIN Proveedores AS P ON PRI.IdProveedor = P.IdProveedor
    ORDER BY P.IdProveedor 
)
GO
SELECT * FROM INGREDIENTES_POR_PROVEEDOR

-- Usando solo subconsultas, encuentre todos los platos que no se han facturado y sus precios. Como visualización final obtenga el importe total de los platos que inician con b.
GO
SELECT SUM(RESULT.precio) as ImporteTotal
FROM (
    SELECT *
    FROM Platos AS P
    WHERE P.IdPlato NOT IN (
        SELECT IdPlato
        FROM ItemsFactura
    )
) AS RESULT
where RESULT.descripcion LIKE 'b%'

--  Analice las tablas y genere vistas con consultas que no se hayan usado en los ejercicios anteriores, con las siguientes características: 
--      Una vista con un left join de dos tablas, filtrar con una subconsulta usando in. 
--      Una vista con un join y un left join, debe tener al menos 3 tablas, filtrar con between. 

-- Paja...