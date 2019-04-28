--El dueño de la fábrica de muebles solicitó los siguientes listados:
--1) Los clientes que no realizaron ningún pedido.
SELECT *FROM CLIENTES WHERE ID NOT IN (
Select Distinct  IDCliente From Pedidos)
--2) Los materiales que no fueron utilizados en ningún producto.
SELECT *FROM MATERIALES WHERE ID NOT IN (
SELECT DISTINCT IDMATERIAL FROM PRODUCTOS)

--3) Los clientes que no realizaron ningún pedido en Febrero de 2019. (XLS)
SELECT *FROM CLIENTES WHERE ID NOT IN (
SELECT IDCLIENTE FROM PEDIDOS WHERE MONTH (FECHASOLICITUD)=2 AND YEAR (FECHASOLICITUD)=2019 )

--4) Los productos que tengan un precio de venta mayor al precio de venta promedio. (XLS)
SELECT *FROM PRODUCTOS WHERE PRECIO >(
SELECT AVG (P.PRECIO) FROM PRODUCTOS AS P)

--5) Todos los datos de los productos cuyo precio de venta sea mayor a cualquier producto cuyo
--nombre de material sea "Pino". (XLS)
SELECT *FROM PRODUCTOS WHERE PRECIO > ALL (
SELECT PRECIO FROM PRODUCTOS AS P 
INNER JOIN MATERIALES  AS M ON M.ID =P.IDMATERIAL 
WHERE M.NOMBRE LIKE 'PINO'
)

--6) Todos los datos de los productos cuyo precio de venta sea mayor a algún producto cuyo
--nombre de material sea "Melamina".

--7) Todos los datos de los productos cuyo precio de venta sea menor a cualquier producto cuyo
--nombre de material sea "Pino".
--8) Por cada cliente, listar el apellido y nombre y la cantidad de pedidos realizados de productos
--que requieran seña y la cantidad de pedidos realizados de productos que no requieran seña. (XLS)
--9) Por cada pedido, listar el ID y la cantidad de colaboraciones de colaboradores de sexo
--masculino que participaron y la cantidad de colaboraciones de colaboradores de sexo femenino
--que participaron.
--10) Apellido y nombres de los clientes que hayan realizado más pedidos de productos que
--requieren seña que pedidos que no requieren seña. (XLS)
--11) La cantidad de pedidos en los que hubo misma cantidad de colaboraciones de colaboradores
--de sexo masculino que femenino.
--12) El porcentaje de pedidos que fueron enviados con respecto al total de pedidos.
--13) El porcentaje de facturación de los pedidos realizados en Febrero de 2019 con respecto al total
--facturado. (XLS)
--14) Por cada categoría de producto, listar el porcentaje de productos de dicha categoría en
--relación a la totalidad de productos.