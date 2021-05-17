USE ZRESTAURANTE

--  Calcular y mostrar la propina (10%) del total facturado por cada mozo, mostrando: Nombre, Apellido, Total Facturado, Valor Propina 
GO
CREATE FUNCTION propina()
RETURNS TABLE
AS RETURN (
    SELECT M.nombre, M.apellido, SUM(F.total) as Total, SUM(F.total) * 0.1 AS Propina
    FROM Mozos AS M
    INNER JOIN Facturas AS F ON M.IdMozo = F.IdMozo
    GROUP BY M.IdMozo, M.nombre, M.apellido
)
GO

-- Mostrar ordenado el Top X (ejemplo top 5) de los platos más vendidos por el restaurant: El resultado debe ser la Lista de Platos 
GO
CREATE FUNCTION topx(@top INT)
RETURNS TABLE
AS RETURN (
    SELECT TOP(@top) COUNT(Items.IdPlato) AS Cantidad, P.descripcion
    FROM Platos AS P
    INNER JOIN ItemsFactura AS Items ON P.IdPlato = Items.IdPlato
    GROUP BY P.descripcion
    ORDER BY Cantidad DESC 
)
GO

SELECT * FROM topx(5);

-- Mostrar ordenadas las X (Ejemplo 10) mesas más utilizadas en el restaurant: El resultado debe ser la Lista de Mesas
GO
CREATE FUNCTION mesasMasUsadas(@cant INT)
RETURNS TABLE
AS RETURN (
    SELECT TOP(@cant) COUNT(F.IdMesa) AS Utilizada, M.Descripcion
    FROM Mesas AS M
    INNER JOIN Facturas AS F ON M.IdMesa = F.IdMesa
    GROUP BY M.Descripcion
    ORDER BY Utilizada DESC
)
GO

SELECT * FROM topx(5);

-- Mostrar cual es el ingrediente más utilizado en los platos. Mostrar: Su precio, punto de reposición y la cantidad de platos donde se utiliza 
GO
CREATE FUNCTION ingredienteMasUsado()
RETURNS TABLE
AS RETURN (
    SELECT TOP(1) I.descripcion, I.precComp AS Precio, I.puntoRep AS Reposicion, COUNT(Pin.IdPlato) AS Cantidad
    FROM Ingredientes AS I
    INNER JOIN PlaIng AS Pin ON I.IdIngrediente = Pin.IdIngrediente
    GROUP BY I.descripcion, I.precComp, I.puntoRep
    ORDER BY Cantidad DESC
)
GO

SELECT * FROM ingredienteMasUsado();

-- Mostrar por cada ingrediente su proveedor con los siguientes datos: Nombre del Ingrediente, Nombre del Proveedor, Dirección, Teléfono
GO
CREATE FUNCTION IngredientePorProveedor()
RETURNS TABLE
AS RETURN (
    SELECT I.descripcion, P.razsoc, P.calle, TP.numero
    FROM Ingredientes AS I
    INNER JOIN ProIng AS Pro ON I.IdIngrediente = Pro.IdIngrediente
    INNER JOIN Proveedores AS P ON Pro.IdProveedor = P.IdProveedor
    INNER JOIN TelefonoProveedor AS TP ON P.IdProveedor = TP.IdProveedor
)
GO

SELECT * FROM IngredientePorProveedor();




-- SP
-- Cree un procedimiento para registrar un nuevo mozo
GO
CREATE PROCEDURE SP_NEW_MOZO
    @Nombre varchar(20),
    @Apellido varchar(20),
    @Calle varchar(40),
    @Numero int,
    @Piso int,
    @Departamento varchar(4),
    @CodigoPostal int,
    @TelCodArea int,
    @TelCentral int,
    @TelNumero int,
    @TelCel int
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @IdMozo INT
            DECLARE @IdTelefono INT

            SET @IdMozo = (SELECT TOP(1) IdMozo FROM Mozos ORDER BY IdMozo DESC)
            SET @IdTelefono = (SELECT TOP(1) IdTelefono FROM Mozos ORDER BY IdTelefono DESC)

            INSERT INTO Mozos (IdMozo, nombre, apellido, calle, numero, piso, departamento, IdCodPos)
            VALUES (@IdMozo + 1, @Nombre, @Apellido, @Calle, @Numero, @Piso, @Departamento, @CodigoPostal)

            INSERT INTO TelefonoMozo (IdTelefono, IdMozo, codArea, central, numero, celular)
            VALUES (@IdTelefono + 1, @IdMozo + 1, @TelCodArea, @TelCentral, @TelNumero, @TelCel)

        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        PRINT 'ERROR: TRANSACITION END'
    END CATCH
END