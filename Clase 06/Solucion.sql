--1) Los clientes que no realizaron ning�n pedido.
Select * From Clientes where ID NOT IN 
	(
		Select Distinct IDCliente From Pedidos
	)
--2) Los materiales que no fueron utilizados en ning�n producto.
Select * From Materiales Where ID Not IN
	(
		Select Distinct IDMaterial From Productos
	)

--3) Los clientes que no realizaron ning�n pedido en Febrero de 2019.
Select * From Clientes Where ID Not IN 
	(
		Select Distinct IDCliente From Pedidos Where Month(FECHASOLICITUD) = 2 and Year(FECHASOLICITUD) = 2019	
	)

--4) Los productos que tengan un precio de venta mayor al precio de venta promedio.
Select * From Productos Where Precio > (Select AVG(precio) From productos)

--5) Todos los datos de los productos cuyo precio de venta sea mayor a cualquier producto cuyo nombre de material sea "Pino".
Select * from Productos where PRECIO >ALL 
	(
		Select Precio from Productos P 
		INNER JOIN MATERIALES as M ON M.ID = P.IDMATERIAL
		Where M.NOMBRE Like 'Pino'
	)

--6) Todos los datos de los productos cuyo precio de venta sea mayor a alg�n producto cuyo nombre de material sea "Melamina".
Select * from Productos where PRECIO >Any 
	(
		Select Precio from Productos P 
		INNER JOIN MATERIALES as M ON M.ID = P.IDMATERIAL
		Where M.NOMBRE Like 'Melamina'
	)

--7) Todos los datos de los productos cuyo precio de venta sea menor a cualquier producto cuyo nombre de material sea "Pino".
Select * from Productos where PRECIO <ALL 
	(
		Select Precio from Productos P 
		INNER JOIN MATERIALES as M ON M.ID = P.IDMATERIAL
		Where M.NOMBRE Like 'Pino'
	)

--8) Por cada cliente, listar el apellido y nombre y la cantidad de pedidos realizados de productos que requieran se�a y la cantidad de pedidos realizados de productos que no requieran se�a.
Select CL.Apellidos, CL.Nombres,
	(
		Select count(*) from PEDIDOS as PE 
		Inner Join Productos as PR ON PR.ID = PE.IDPRODUCTO
		Where PR.SE�A = 1 and PE.IDCLIENTE = CL.ID
	) as RequiereSe�a,
	(
		Select count(*) from PEDIDOS as PE 
		Inner Join Productos as PR ON PR.ID = PE.IDPRODUCTO
		Where PR.SE�A = 0 and PE.IDCLIENTE = CL.ID
	) as NoRequiereSe�a
From Clientes as CL

--9) Por cada pedido, listar el ID y la cantidad de colaboraciones de colaboradores de sexo masculino que participaron y la cantidad de colaboraciones de colaboradores de sexo femenino que participaron.
Select PE.ID,
	(
		Select Count(*) From COLABORADORES AS C
		Inner Join COLABORADORES_X_PEDIDO AS CXP ON C.LEGAJO = CXP.LEGAJO
		Where C.GENERO = 'M' AND CXP.IDPEDIDO = PE.ID
	) AS CantMasc,
	(
		Select Count(*) From COLABORADORES AS C
		Inner Join COLABORADORES_X_PEDIDO AS CXP ON C.LEGAJO = CXP.LEGAJO
		Where C.GENERO = 'F' AND CXP.IDPEDIDO = PE.ID
	) AS CantFem
From Pedidos as PE

--10) Apellido y nombres de los clientes que hayan realizado m�s pedidos de productos que requieren se�a que pedidos que no requieren se�a.
-- Alternativa sin subconsulta en el FROM
Select CL.Apellidos, CL.Nombres,
	(
		Select count(*) from PEDIDOS as PE 
		Inner Join Productos as PR ON PR.ID = PE.IDPRODUCTO
		Where PR.SE�A = 1 and PE.IDCLIENTE = CL.ID
	) as RequiereSe�a,
	(
		Select count(*) from PEDIDOS as PE 
		Inner Join Productos as PR ON PR.ID = PE.IDPRODUCTO
		Where PR.SE�A = 0 and PE.IDCLIENTE = CL.ID
	) as NoRequiereSe�a
From Clientes as CL
Where (
		Select count(*) from PEDIDOS as PE 
		Inner Join Productos as PR ON PR.ID = PE.IDPRODUCTO
		Where PR.SE�A = 1 and PE.IDCLIENTE = CL.ID
	) >  (
		Select count(*) from PEDIDOS as PE 
		Inner Join Productos as PR ON PR.ID = PE.IDPRODUCTO
		Where PR.SE�A = 0 and PE.IDCLIENTE = CL.ID
	)

-- Alternativa con subconsulta en el FROM
SELECT * FROM
	(
		Select CL.Apellidos, CL.Nombres,
		(
			Select count(*) from PEDIDOS as PE 
			Inner Join Productos as PR ON PR.ID = PE.IDPRODUCTO
			Where PR.SE�A = 1 and PE.IDCLIENTE = CL.ID
		) as RequiereSe�a,
		(
			Select count(*) from PEDIDOS as PE 
			Inner Join Productos as PR ON PR.ID = PE.IDPRODUCTO
			Where PR.SE�A = 0 and PE.IDCLIENTE = CL.ID
		) as NoRequiereSe�a
		From Clientes as CL	
	) AS AUX
WHERE AUX.RequiereSe�a > AUX.NoRequiereSe�a

-- 11) La cantidad de pedidos en los que hubo misma cantidad de colaboraciones de colaboradores de sexo masculino que femenino.
SELECT COUNT(*) AS CantidadPedidos FROM (
	Select PE.ID,
		(
			Select Count(*) From COLABORADORES AS C
			Inner Join COLABORADORES_X_PEDIDO AS CXP ON C.LEGAJO = CXP.LEGAJO
			Where C.GENERO = 'M' AND CXP.IDPEDIDO = PE.ID
		) AS CantMasc,
		(
			Select Count(*) From COLABORADORES AS C
			Inner Join COLABORADORES_X_PEDIDO AS CXP ON C.LEGAJO = CXP.LEGAJO
			Where C.GENERO = 'F' AND CXP.IDPEDIDO = PE.ID
		) AS CantFem
	From Pedidos as PE
) AS AUX
WHERE AUX.CantFem = AUX.CantMasc

--12) El porcentaje de pedidos que fueron enviados con respecto al total de pedidos.
Select (Select count(*) From Envios)*1.0 / (Select Count(*) From Pedidos)*100 AS Porcentaje

--13) El porcentaje de facturaci�n de los pedidos realizados en Febrero de 2019 con respecto al total facturado.
Select (Select SUM(Costo) From Pedidos Where Month(FECHASOLICITUD) = 2 and Year(FECHASOLICITUD) = 2019) / (Select Sum(Costo) From Pedidos)*100 As Porcentaje

--14) Por cada categor�a de producto, listar el porcentaje de productos de dicha categor�a en relaci�n a la totalidad de productos.
Select CAT.Nombre, 
	(Select Count(*) From Productos Where IDCATEGORIA = CAT.ID)*1.0 / (Select Count(*) From Productos)*100 As Porcentaje
From CATEGORIAS AS CAT

