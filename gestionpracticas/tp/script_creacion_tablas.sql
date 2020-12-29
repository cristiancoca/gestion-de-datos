USE GD2C2019
GO
CREATE PROCEDURE CRISPI.proc_create_tables
AS
BEGIN TRY	
	begin transaction;

	PRINT '----- Empezando a crear tablas -----'
	CREATE TABLE CRISPI.Usuario( 
		usuario_id int IDENTITY(1,1) PRIMARY KEY,
		usuario_username nvarchar(50) NOT NULL,
		usuario_password nvarchar(50) NOT NULL,
		usuario_proveedor_id int NULL,
		usuario_cliente_id int NULL,
		usuario_habilitado bit NOT NULL,
		usuario_estado bit DEFAULT 0,
		usuario_cantidad_errores int NOT NULL default 0,
	)

	CREATE TABLE CRISPI.Ciudad( 
		ciudad_id int IDENTITY(1,1) PRIMARY KEY,
		ciudad_nombre nvarchar(255) NOT NULL	
	)

	CREATE TABLE CRISPI.Cliente(
		cliente_id int IDENTITY(1,1) PRIMARY KEY,
		cliente_nombre nvarchar(255) NOT NULL,
		cliente_apellido nvarchar(255) NOT NULL,
		cliente_dni numeric(18,0)  NOT NULL,
		cliente_mail nvarchar(255) NOT NULL,
		cliente_telefono numeric(18,0) NOT NULL,
		cliente_direccion nvarchar(255) NOT NULL,
		cliente_fechanac datetime NOT NULL,	
		cliente_ciudad_id int NULL,
		cliente_codigo_postal int NULL,
		cliente_credito numeric(18,2) NULL,
		cliente_estado bit default 0
	)

	CREATE TABLE CRISPI.Funcionalidad( 
		funcionalidad_id int IDENTITY(1,1) PRIMARY KEY,
		funcionalidad_descripcion nvarchar(50) NOT NULL
	)

	CREATE TABLE CRISPI.Rol( 
		rol_id int IDENTITY(1,1) PRIMARY KEY,
		rol_nombre nvarchar(50) NOT NULL,
		rol_estado bit DEFAULT 0
	)

	CREATE TABLE CRISPI.Proveedor( 
		proveedor_id int IDENTITY(1,1) PRIMARY KEY,
		proveedor_cuit nvarchar(20) NOT NULL,
		proveedor_rs nvarchar(100) NOT NULL,
		proveedor_dom nvarchar(100) NOT NULL,
		proveedor_mail nvarchar(255) NULL,
		proveedor_ciudad_id int NOT NULL,
		proveedor_telefono numeric(18,0) NOT NULL,
		proveedor_estado bit DEFAULT 0
	)

	CREATE TABLE CRISPI.Rol_Por_Usuario( 
		rol_usuario_id int IDENTITY(1,1) PRIMARY KEY,
		usuario_id int NOT NULL,
		rol_id int NOT NULL
	)

	CREATE TABLE CRISPI.Rol_Por_Funcionalidad( 
		rol_id int NOT NULL,
		funcionalidad_id int NOT NULL
	)

	CREATE TABLE CRISPI.Rubro( 
		rubro_id int IDENTITY(1,1) PRIMARY KEY,
		rubro_nombre nvarchar(100) NOT NULL,
	
	)

	CREATE TABLE CRISPI.Rubro_Proveedor( 
		rubro_proveedor_id int IDENTITY(1,1) PRIMARY KEY,
		rubro_proveedor int NOT NULL,
		rubro_id int NOT NULL,
	)

	CREATE TABLE CRISPI.Tipo_pago( 
		tipo_pago_id int IDENTITY(1,1) PRIMARY KEY,
		tipo_pago_nombre nvarchar(100) NOT NULL,
	)

	CREATE TABLE CRISPI.Credito( 
		credito_id int IDENTITY(1,1) PRIMARY KEY,
		credito_fecha datetime NOT NULL,
		credito_monto numeric(18,2) NOT NULL,
		credito_cliente_id int NOT NULL, 
		credito_tipo_pago_id int NULL,
		credito_tarjeta decimal(18,0) NULL,
		credito_datos nvarchar(255) NULL,
	)

	CREATE TABLE CRISPI.Oferta( 
		oferta_id int IDENTITY(1,1) PRIMARY KEY,
		oferta_codigo nvarchar(50) NOT NULL,
		oferta_descripcion nvarchar(255) NOT NULL,
		oferta_precio numeric(18,2) NOT NULL,
		oferta_lista numeric(18,2) NOT NULL,
		oferta_cantidad numeric(18,0) NOT NULL,
		oferta_maxima int NOT NULL,
		oferta_fecha_inicio datetime,
		oferta_fecha_fin datetime, 
		oferta_usuario_creador_id int NULL,
		oferta_eliminado bit DEFAULT 0,
		oferta_rubro_proveedor_id int 
	)

	CREATE TABLE CRISPI.Facturacion(
		facturacion_id int IDENTITY(1,1) PRIMARY KEY,
		facturacion_nro numeric(18,0) NOT NULL,
		facturacion_tipo nvarchar(1) NOT NULL,
		facturacion_proveedor_id int NOT NULL,
		facturacion_fecha datetime NOT NULL,
		facturacion_monto numeric(18,2),	
	)

	CREATE TABLE CRISPI.Item_factura(
		item_factura_id int IDENTITY(1,1) PRIMARY KEY,
		facturacion_id int NOT NULL,
		cliente_id int NOT NULL,
		oferta_id int NOT NULL,
		item_factura_cantidad int	
	)

	CREATE TABLE CRISPI.Estado(
		estado_id int IDENTITY(1,1) PRIMARY KEY,
		estado_descripcion nvarchar(50)	
	)

	CREATE TABLE CRISPI.Cupones(
		cupones_id int IDENTITY(1,1) PRIMARY KEY,
		cupones_oferta_id int NOT NULL,
		cupones_precio_oferta numeric(18,2) NOT NULL,
		cupones_precio_lista numeric(18,2) NOT NULL,
		cupones_cliente_id int NOT NULL,
		cupones_estado_id int NOT NULL,		
	)

	CREATE TABLE CRISPI.Historial_cupones(
		historial_id int IDENTITY(1,1) PRIMARY KEY,
		historial_cupon_id int NOT NULL,
		historial_estado_id int NOT NULL,
		historial_detalle nvarchar(255) NOT NULL,
		historial_fecha datetime
	)

	CREATE TABLE CRISPI.Venta(
		venta_id int IDENTITY(1,1) PRIMARY KEY,
		venta_oferta_id int NOT NULL,
		venta_cliente_id int NOT NULL,
		venta_fecha datetime,
		venta_cliente_destino_id int NOT NULL,
		venta_cantidad int not null
	)

	ALTER TABLE CRISPI.Usuario ADD CONSTRAINT fk_usuario_cliente_id FOREIGN KEY (usuario_cliente_id) REFERENCES CRISPI.Cliente(cliente_id);

	ALTER TABLE CRISPI.Usuario ADD CONSTRAINT fk_usuario_proveedor_id FOREIGN KEY (usuario_proveedor_id) REFERENCES CRISPI.PROVEEDOR(proveedor_id);

	ALTER TABLE CRISPI.Ciudad ADD CONSTRAINT uq_ciudad_nombre UNIQUE (ciudad_nombre);

	ALTER TABLE CRISPI.Cliente ADD CONSTRAINT fk_cliente_ciudad_id FOREIGN KEY (cliente_ciudad_id) REFERENCES CRISPI.Ciudad(ciudad_id);

	ALTER TABLE CRISPI.Funcionalidad ADD CONSTRAINT uq_funcionalidad_descripcion UNIQUE (funcionalidad_descripcion);

	ALTER TABLE CRISPI.Rol ADD CONSTRAINT uq_rol_nombre UNIQUE (rol_nombre);

	ALTER TABLE CRISPI.Proveedor ADD CONSTRAINT uq_cuit_rs UNIQUE (proveedor_cuit,proveedor_rs);

	ALTER TABLE CRISPI.Proveedor ADD CONSTRAINT fk_proveedor_ciudad_id FOREIGN KEY (proveedor_ciudad_id) REFERENCES CRISPI.Ciudad(ciudad_id);

	ALTER TABLE CRISPI.Rol_Por_Usuario ADD CONSTRAINT fk_rolusuario_usuario FOREIGN KEY (usuario_id) REFERENCES CRISPI.Usuario(usuario_id);

	ALTER TABLE CRISPI.Rol_Por_Usuario ADD CONSTRAINT fk_rolusuario_rol FOREIGN KEY (rol_id) REFERENCES CRISPI.Rol(rol_id);

	ALTER TABLE CRISPI.Rol_Por_Funcionalidad ADD CONSTRAINT fk_rolfuncionalidad_rol FOREIGN KEY (rol_id) REFERENCES CRISPI.Rol(rol_id);

	ALTER TABLE CRISPI.Rol_Por_Funcionalidad ADD CONSTRAINT fk_rolfuncionalidad_funcionalidad FOREIGN KEY (funcionalidad_id) REFERENCES CRISPI.Funcionalidad(funcionalidad_id);

	ALTER TABLE CRISPI.Rubro ADD CONSTRAINT uq_rubro_nombre UNIQUE (rubro_nombre);

	ALTER TABLE CRISPI.Rubro_Proveedor ADD CONSTRAINT fk_rubro_proveedor FOREIGN KEY (rubro_proveedor) REFERENCES CRISPI.Proveedor(proveedor_id);

	ALTER TABLE CRISPI.Rubro_Proveedor ADD CONSTRAINT fk_rubro_id FOREIGN KEY (rubro_id) REFERENCES CRISPI.Rubro(rubro_id);

	ALTER TABLE CRISPI.Tipo_pago ADD CONSTRAINT uq_tipo_pago_nombre UNIQUE (tipo_pago_nombre);

	ALTER TABLE CRISPI.Credito ADD CONSTRAINT fk_credito_cliente_id FOREIGN KEY (credito_cliente_id) REFERENCES CRISPI.Cliente(cliente_id);

	ALTER TABLE CRISPI.Credito ADD CONSTRAINT fk_credito_tipo_pago_id FOREIGN KEY (credito_tipo_pago_id) REFERENCES CRISPI.Tipo_pago(tipo_pago_id);

	ALTER TABLE CRISPI.Oferta ADD CONSTRAINT fk_oferta_rubro_proveedor_id FOREIGN KEY (oferta_rubro_proveedor_id) REFERENCES CRISPI.Rubro_Proveedor(rubro_proveedor_id);

	ALTER TABLE CRISPI.Oferta ADD CONSTRAINT fk_oferta_usuario_creador_id FOREIGN KEY (oferta_usuario_creador_id) REFERENCES CRISPI.Usuario(usuario_id);

	ALTER TABLE CRISPI.Facturacion ADD CONSTRAINT fk_facturacion_proveedor_id FOREIGN KEY (facturacion_proveedor_id) REFERENCES CRISPI.Proveedor(proveedor_id);

	ALTER TABLE CRISPI.Item_factura ADD  CONSTRAINT fk_item_factura_facturacion_id FOREIGN KEY (facturacion_id) REFERENCES CRISPI.Facturacion(facturacion_id);

	ALTER TABLE CRISPI.Item_factura ADD  CONSTRAINT fk_item_factura_cliente_id FOREIGN KEY (cliente_id) REFERENCES CRISPI.Cliente(cliente_id);

	ALTER TABLE CRISPI.Item_factura ADD  CONSTRAINT fk_item_factura_oferta_id FOREIGN KEY (oferta_id) REFERENCES CRISPI.Oferta(oferta_id);

	ALTER TABLE CRISPI.Estado ADD CONSTRAINT uq_estado_descripcion UNIQUE (estado_descripcion);

	ALTER TABLE CRISPI.Cupones ADD  CONSTRAINT fk_cupones_estado_id FOREIGN KEY (cupones_estado_id) REFERENCES CRISPI.Estado(estado_id);

	ALTER TABLE CRISPI.Cupones ADD  CONSTRAINT fk_cupones_cliente_id FOREIGN KEY (cupones_cliente_id) REFERENCES CRISPI.Cliente(cliente_id);

	ALTER TABLE CRISPI.Cupones ADD  CONSTRAINT fk_cupones_oferta_id FOREIGN KEY (cupones_oferta_id) REFERENCES CRISPI.Oferta(oferta_id);

	ALTER TABLE CRISPI.Historial_cupones ADD  CONSTRAINT fk_historial_cupon_id FOREIGN KEY (historial_cupon_id) REFERENCES CRISPI.Cupones(cupones_id);

	ALTER TABLE CRISPI.Historial_cupones ADD  CONSTRAINT fk_historial_estado_id FOREIGN KEY (historial_estado_id) REFERENCES CRISPI.Estado(estado_id);

	ALTER TABLE CRISPI.Venta ADD  CONSTRAINT fk_venta_oferta_id FOREIGN KEY (venta_oferta_id) REFERENCES CRISPI.Oferta(oferta_id);

	ALTER TABLE CRISPI.Venta ADD  CONSTRAINT fk_venta_cliente_id FOREIGN KEY (venta_cliente_id) REFERENCES CRISPI.Cliente(cliente_id);

	ALTER TABLE CRISPI.Venta ADD  CONSTRAINT fk_venta_cliente_destino_id FOREIGN KEY (venta_cliente_destino_id) REFERENCES CRISPI.Cliente(cliente_id);

	PRINT '----- Creación de tablas exitosa -----'
	
	
	INSERT INTO CRISPI.Usuario(usuario_username,usuario_password,usuario_proveedor_id,usuario_cliente_id,usuario_habilitado,usuario_estado,usuario_cantidad_errores)
	VALUES ('admin', HASHBYTES('SHA2_256', CONVERT(nvarchar(50), 'w23e')),NULL,NULL,1,1,0);

	PRINT 'Creando roles'
	INSERT INTO CRISPI.Rol (rol_nombre, rol_estado)
	VALUES('Administrador', 1),
		('Usuario', 1),
		('Proveedor',1);
	PRINT 'Roles creados correctamente'
	
	PRINT 'Creando rol por usuario'
	INSERT INTO CRISPI.Rol_Por_Usuario (usuario_id, rol_id)
	VALUES(1, 1);
	PRINT 'rol por usuario creado correctamente'


	PRINT 'Creando funcionalidades'
	INSERT INTO CRISPI.Funcionalidad (funcionalidad_descripcion)
	VALUES('ALTA_ROL'),
		('BAJA_ROL'),
		('EDITAR_ROL'),
		('VISUALIZAR_ROL'),
		('ALTA_OFERTA'),
		('BAJA_OFERTA'),
		('EDITAR_OFERTA'),
		('VISUALIZAR_OFERTA'),
		('VISUALIZAR_CLIENTE'),
		('ALTA_CLIENTE'),
		('EDITAR_CLIENTE'),
		('ELIMINAR_CLIENTE'),
		('VISUALIZAR_PROVEEDOR'),
		('ALTA_PROVEEDOR'),
		('EDITAR_PROVEEDOR'),
		('ELIMINAR_PROVEEDOR'),
		('VISUALIZAR_LISTADO_ESTADISTICO'),
		('COMPRAR_OFERTA'),
		('CARGAR_CREDITO')

	PRINT 'Funcionalidades creadas correctamente'


	PRINT 'Asignando funcionalidad a los roles'
	INSERT INTO CRISPI.Rol_Por_Funcionalidad (rol_id, funcionalidad_id)
	(SELECT 1, funcionalidad_id FROM CRISPI.Funcionalidad);
	PRINT 'Funcionalidades asignadas a los roles correctamente'
	
	PRINT 'Asignando funcionalidad a los roles'
	INSERT INTO CRISPI.Rol_Por_Funcionalidad (rol_id, funcionalidad_id)
	(SELECT 2, funcionalidad_id FROM CRISPI.Funcionalidad where funcionalidad_id in(18,19) );
	PRINT 'Funcionalidades asignadas a los roles correctamente'

	PRINT 'Asignando funcionalidad a los roles'
	INSERT INTO CRISPI.Rol_Por_Funcionalidad (rol_id, funcionalidad_id)
	(SELECT 3, funcionalidad_id FROM CRISPI.Funcionalidad where funcionalidad_id in (5,6,7) );
	PRINT 'Funcionalidades asignadas a los roles correctamente'

	PRINT 'Migracion de ciudades'
	INSERT INTO CRISPI.Ciudad(ciudad_nombre)
	(SELECT Cli_Ciudad
	FROM gd_esquema.Maestra
	WHERE Cli_Ciudad IS NOT NULL
	group by Cli_Ciudad)
	union 
	(SELECT Provee_Ciudad 
	FROM gd_esquema.Maestra
	WHERE Provee_Ciudad IS NOT NULL
	group by Provee_Ciudad);
	PRINT 'Ciudades migrados correctamente'


	PRINT 'Migracion de rubro'
	INSERT INTO CRISPI.Rubro(rubro_nombre)
	(SELECT Provee_Rubro
	FROM gd_esquema.Maestra
	WHERE Provee_Rubro IS NOT NULL
	group by Provee_Rubro);
	PRINT 'Rubro migrados correctamente'


	PRINT 'Migracion de tipo_pago'
	INSERT INTO CRISPI.Tipo_pago(tipo_pago_nombre)
	(SELECT Tipo_Pago_Desc
	FROM gd_esquema.Maestra
	WHERE Tipo_Pago_Desc IS NOT NULL
	group by Tipo_Pago_Desc);
	PRINT 'Tipos de pago migrados correctamente'


	PRINT 'Migracion de clientes'
	INSERT INTO CRISPI.Cliente(cliente_apellido,cliente_nombre,cliente_dni,cliente_fechanac,cliente_direccion,cliente_mail,cliente_telefono,cliente_ciudad_id,cliente_credito)
	(SELECT Cli_Apellido,Cli_Nombre, Cli_Dni,Cli_Fecha_Nac,Cli_Direccion,Cli_Mail,Cli_Telefono,a.ciudad_id,SUM(ISNULL(Carga_Credito,0))
	FROM gd_esquema.Maestra m,CRISPI.Ciudad a
	WHERE m.Cli_Dni IS NOT NULL AND m.Cli_Ciudad = a.ciudad_nombre
	GROUP BY Cli_Apellido,Cli_Nombre, Cli_Dni,Cli_Fecha_Nac,Cli_Direccion,Cli_Mail,Cli_Telefono,a.ciudad_id);
	PRINT 'Clientes migrados correctamente'


	PRINT 'Migracion de  Proveedores'
	INSERT INTO CRISPI.Proveedor(proveedor_cuit,proveedor_dom,proveedor_rs,proveedor_telefono,proveedor_ciudad_id,proveedor_estado)
	SELECT DISTINCT Provee_CUIT,Provee_Dom,Provee_RS,Provee_Telefono,(select ciudad_id from CRISPI.Ciudad c where c.ciudad_nombre = m.Provee_Ciudad),1
	FROM gd_esquema.Maestra m
	WHERE m.Provee_RS IS NOT NULL
	PRINT 'Proveedores migrados correctamente'


	PRINT 'Migracion Rubro Proveedor'
	INSERT INTO CRISPI.Rubro_Proveedor(rubro_proveedor,rubro_id)
	SELECT DISTINCT a.proveedor_id,r.rubro_id
	FROM gd_esquema.Maestra m,CRISPI.Proveedor a,CRISPI.Rubro r
	WHERE m.Provee_CUIT IS NOT NULL AND m.Provee_CUIT=a.proveedor_cuit AND m.Provee_Rubro=r.rubro_nombre
	PRINT 'Rubro Proveedor migrados correctamente'


	PRINT 'Migracion Credito'
	INSERT INTO CRISPI.Credito(credito_fecha,credito_monto,credito_cliente_id,credito_tipo_pago_id)
	SELECT DISTINCT Carga_Fecha,Carga_Credito,r.cliente_id,a.tipo_pago_id
	FROM gd_esquema.Maestra m,CRISPI.Tipo_pago a,CRISPI.Cliente r
	WHERE m.Carga_Credito IS NOT NULL AND m.Tipo_Pago_Desc=a.tipo_pago_nombre AND m.Cli_Dni=r.cliente_dni
	PRINT 'Credito migrados correctamente'

	
	PRINT 'Migracion oferta'
	INSERT INTO CRISPI.Oferta(oferta_codigo,oferta_descripcion,oferta_precio,oferta_lista,oferta_cantidad,oferta_maxima,oferta_fecha_inicio,oferta_fecha_fin,oferta_rubro_proveedor_id)
	SELECT Oferta_Codigo,Oferta_Descripcion,Oferta_Precio,Oferta_Precio_Ficticio,Oferta_Cantidad,1,Oferta_Fecha,Oferta_Fecha_Venc,rp.rubro_proveedor_id
	FROM gd_esquema.Maestra m
	join CRISPI.Proveedor p on p.proveedor_rs = m.Provee_RS
	join CRISPI.Rubro r on r.rubro_nombre = m.Provee_Rubro	
	join CRISPI.Rubro_Proveedor rp on rp.rubro_proveedor = p.proveedor_id and rp.rubro_id = r.rubro_id
	where m.Oferta_Codigo is not null
	group by Oferta_Codigo,Oferta_Descripcion,Oferta_Precio,Oferta_Precio_Ficticio,Oferta_Cantidad,Oferta_Fecha,Oferta_Fecha_Venc,rp.rubro_proveedor_id
	PRINT 'oferta migrados correctamente'


	PRINT 'Migracion facturacion'
	INSERT INTO CRISPI.Facturacion(facturacion_nro,facturacion_tipo,facturacion_fecha,facturacion_monto,facturacion_proveedor_id)
	SELECT m.Factura_Nro,'A',m.Factura_Fecha,sum(Oferta_Precio),a.proveedor_id
	FROM gd_esquema.Maestra m,CRISPI.Proveedor a
	where m.Factura_Nro is not null and m.Provee_CUIT=a.proveedor_cuit
	group by m.Factura_Nro,m.Factura_Fecha,a.proveedor_id
	PRINT 'Rubro Proveedor migrados correctamente'


	PRINT 'Migracion item facturacion'
	INSERT INTO CRISPI.Item_factura(facturacion_id,cliente_id,oferta_id)
	select a.facturacion_id,c.cliente_id,o.oferta_id
	from gd_esquema.Maestra m,CRISPI.Facturacion a,CRISPI.Cliente c,CRISPI.Oferta o
	where m.Factura_Nro is not null and m.Factura_Nro=a.facturacion_nro and m.Cli_Dni=c.cliente_dni and m.Oferta_Codigo=o.oferta_codigo
	PRINT ' migrados correctamente'
	
	PRINT 'Estados Cupones'
	INSERT INTO CRISPI.Estado(estado_descripcion)
	VALUES('Disponible'),
		  ('Vencido'),
		  ('Cancelado')
	PRINT 'migrados correctamente'


	PRINT 'Migracion cupones'
	INSERT INTO CRISPI.Cupones(cupones_oferta_id,cupones_precio_oferta,cupones_precio_lista,cupones_cliente_id,cupones_estado_id)
	select o.oferta_id,m.Oferta_Precio,m.Oferta_Precio_Ficticio,c.cliente_id,1
	from gd_esquema.Maestra m,CRISPI.Oferta o,CRISPI.Cliente c
	where m.Factura_Nro is null and m.Oferta_Codigo=o.oferta_codigo and m.Cli_Dni=c.cliente_dni 
		and m.Oferta_Fecha_Compra is not null and m.Oferta_Entregado_Fecha is null
	PRINT 'migrados correctamente'	
	
	PRINT 'Migracion Ventas'
	INSERT INTO CRISPI.Venta(venta_oferta_id,venta_cliente_id,venta_fecha,venta_cliente_destino_id,venta_cantidad)
	select distinct o.oferta_id,c.cliente_id,m.Oferta_Fecha_Compra,c.cliente_id as cliente_destino,
		(select count(1) from gd_esquema.Maestra m2
		where m2.Oferta_Codigo = m.Oferta_Codigo and m2.Cli_Dni = c.cliente_dni and m2.Factura_Nro is null and
			m2.Oferta_Entregado_Fecha is null and Oferta_Fecha_Compra is not null and m2.Oferta_Fecha_Compra = m.Oferta_Fecha_Compra
			) as cantidad
	from gd_esquema.Maestra m
	join CRISPI.Oferta o on o.oferta_codigo = m.Oferta_Codigo
	join CRISPI.Cliente c on c.cliente_dni = m.Cli_Dni
	where m.Factura_Nro is null and Oferta_Entregado_Fecha is null and Oferta_Fecha_Compra is not null
	commit transaction
END TRY
BEGIN CATCH	
	SELECT  
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage; 
	rollback    
END CATCH
GO


--borrar 

CREATE PROCEDURE CRISPI.proc_drop_tables
AS
BEGIN TRY
	BEGIN TRANSACTION	

	ALTER TABLE CRISPI.Usuario DROP CONSTRAINT fk_usuario_cliente_id;

	ALTER TABLE CRISPI.Usuario DROP CONSTRAINT fk_usuario_proveedor_id;

	ALTER TABLE CRISPI.Cliente DROP CONSTRAINT fk_cliente_ciudad_id;

	ALTER TABLE CRISPI.Funcionalidad DROP CONSTRAINT uq_funcionalidad_descripcion;

	ALTER TABLE CRISPI.Proveedor DROP CONSTRAINT fk_proveedor_ciudad_id;

	ALTER TABLE CRISPI.Rol_Por_Usuario DROP CONSTRAINT fk_rolusuario_usuario;

	ALTER TABLE CRISPI.Rol_Por_Usuario DROP CONSTRAINT fk_rolusuario_rol;

	ALTER TABLE CRISPI.Rol_Por_Funcionalidad DROP CONSTRAINT fk_rolfuncionalidad_rol;

	ALTER TABLE CRISPI.Rol_Por_Funcionalidad DROP CONSTRAINT fk_rolfuncionalidad_funcionalidad;

	ALTER TABLE CRISPI.Rubro_Proveedor DROP CONSTRAINT fk_rubro_proveedor;

	ALTER TABLE CRISPI.Rubro_Proveedor DROP CONSTRAINT fk_rubro_id;

	ALTER TABLE CRISPI.Credito DROP CONSTRAINT fk_credito_cliente_id;

	ALTER TABLE CRISPI.Credito DROP CONSTRAINT fk_credito_tipo_pago_id;

	ALTER TABLE CRISPI.Oferta DROP CONSTRAINT fk_oferta_rubro_proveedor_id;

	ALTER TABLE CRISPI.Oferta DROP CONSTRAINT fk_oferta_usuario_creador_id;

	ALTER TABLE CRISPI.Facturacion DROP CONSTRAINT fk_facturacion_proveedor_id;

	ALTER TABLE CRISPI.Item_factura DROP  CONSTRAINT fk_item_factura_facturacion_id;

	ALTER TABLE CRISPI.Item_factura DROP  CONSTRAINT fk_item_factura_cliente_id;

	ALTER TABLE CRISPI.Item_factura DROP  CONSTRAINT fk_item_factura_oferta_id;

	ALTER TABLE CRISPI.Cupones DROP  CONSTRAINT fk_cupones_estado_id;

	ALTER TABLE CRISPI.Cupones DROP  CONSTRAINT fk_cupones_cliente_id;

	ALTER TABLE CRISPI.Cupones DROP  CONSTRAINT fk_cupones_oferta_id;

	ALTER TABLE CRISPI.Historial_cupones DROP  CONSTRAINT fk_historial_cupon_id;

	ALTER TABLE CRISPI.Historial_cupones DROP  CONSTRAINT fk_historial_estado_id;

	ALTER TABLE CRISPI.Venta DROP  CONSTRAINT fk_venta_oferta_id;

	ALTER TABLE CRISPI.Venta DROP  CONSTRAINT fk_venta_cliente_id;

	ALTER TABLE CRISPI.Venta DROP  CONSTRAINT fk_venta_cliente_destino_id;
	

	DROP TABLE  CRISPI.Rol_Por_Funcionalidad;
	DROP TABLE  CRISPI.Rol;
	DROP TABLE  CRISPI.Funcionalidad;
	DROP TABLE  CRISPI.Rubro_Proveedor;
	DROP TABLE  CRISPI.Rubro;
	DROP TABLE  CRISPI.Item_factura;
	DROP TABLE  CRISPI.Facturacion;
	DROP TABLE  CRISPI.Historial_cupones;
	DROP TABLE  CRISPI.Cupones;
	DROP TABLE  CRISPI.Estado;
	DROP TABLE  CRISPI.Venta;
	DROP TABLE  CRISPI.Oferta;
	DROP TABLE  CRISPI.Credito;
	DROP TABLE  CRISPI.Tipo_pago;
	DROP TABLE  CRISPI.Rol_Por_Usuario;
	DROP TABLE  CRISPI.Usuario;
	DROP TABLE  CRISPI.Cliente;
	DROP TABLE	CRISPI.Proveedor;
	DROP TABLE  CRISPI.Ciudad;

	COMMIT
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS errNumber,
		   ERROR_SEVERITY() AS errSeverity,
		   ERROR_STATE() AS errState,
		   ERROR_PROCEDURE() AS errProcedure,
		   ERROR_LINE() AS errLine,
		   ERROR_MESSAGE() AS errMessage
    ROLLBACK 
END CATCH
go
exec CRISPI.proc_create_tables

--vistas
IF OBJECT_ID('CRISPI.view_clientes', 'V') IS NOT NULL
    DROP VIEW CRISPI.view_clientes
GO

CREATE VIEW CRISPI.view_clientes AS
SELECT cliente_id,cliente_nombre,cliente_apellido,cliente_dni,cliente_mail,cliente_telefono,cliente_direccion,cliente_fechanac as fecha_nacimiento,ciudad_nombre as ciudad,cliente_codigo_postal as codigo_postal,cliente_credito
FROM CRISPI.Cliente c
join CRISPI.Ciudad ci on ci.ciudad_id = c.cliente_ciudad_id
GO



IF OBJECT_ID('CRISPI.view_proveedores', 'V') IS NOT NULL
    DROP VIEW CRISPI.view_proveedores
GO

CREATE VIEW CRISPI.view_proveedores AS
SELECT p.proveedor_id,p.proveedor_cuit as cuit,p.proveedor_rs as razon_social,p.proveedor_dom as domicilio,
	p.proveedor_mail as mail,p.proveedor_telefono as telefono,c.ciudad_nombre as ciudad,r.rubro_nombre as rubro
FROM CRISPI.Proveedor p
join CRISPI.Ciudad c on c.ciudad_id = p.proveedor_ciudad_id
join CRISPI.Rubro_Proveedor rp on rp.rubro_proveedor = p.proveedor_id
join CRISPI.Rubro r on r.rubro_id = rp.rubro_id
GO


IF OBJECT_ID('CRISPI.view_user', 'V') IS NOT NULL
    DROP VIEW CRISPI.view_user
GO

CREATE VIEW CRISPI.view_user AS
select u.usuario_id as id, u.usuario_username as username, r.rol_id as rol_id,u.usuario_proveedor_id as proveedor_id,
	u.usuario_cliente_id as cliente_id 
from CRISPI.Usuario u
join CRISPI.Rol_Por_Usuario r on r.usuario_id = u.usuario_id
GO


IF OBJECT_ID('CRISPI.ofertas_facturas', 'V') IS NOT NULL
    DROP VIEW CRISPI.ofertas_facturas
GO

CREATE VIEW CRISPI.ofertas_facturas AS
select o.oferta_codigo as codigo,o.oferta_descripcion as oferta_descripcion,c.cliente_nombre as cliente_nombre,
	v.venta_fecha as fecha_compra, v.venta_cantidad as cantidad,o.oferta_precio as precio,rp.rubro_proveedor as proveedor_id 
from CRISPI.Venta v
join CRISPI.Oferta o on o.oferta_id = v.venta_oferta_id
join CRISPI.Cliente c on c.cliente_id = v.venta_cliente_id
join CRISPI.Rubro_Proveedor rp on rp.rubro_proveedor_id = o.oferta_rubro_proveedor_id
GO

--procesos
create FUNCTION CRISPI.func_login (@username NVARCHAR(50),@pass NVARCHAR(50))
RETURNS int
AS 
BEGIN
    DECLARE @pass_enc varbinary(256)
	BEGIN
		SELECT @pass_enc = HASHBYTES('SHA2_256', @pass)
	END

	IF EXISTS(SELECT 1
	FROM CRISPI.Usuario
	WHERE usuario_username = @username and usuario_password = @pass_enc and usuario_habilitado = 1 and usuario_estado = 1)
	begin
		RETURN 1;
	end
	
	RETURN 0;
END
GO

 


create  function CRISPI.hasPermission (@rol_id int,@name_permission nvarchar(50))
RETURNS bit
AS 
BEGIN
	Declare @funcionalidad_id int;
	
	select @funcionalidad_id = funcionalidad_id from CRISPI.Funcionalidad where funcionalidad_descripcion = @name_permission;

	IF EXISTS(select 1 from CRISPI.Rol_Por_Funcionalidad where rol_id = @rol_id and funcionalidad_id = @funcionalidad_id)
	begin
		RETURN 1;
	end
	
	RETURN 0;

END
GO

create  procedure CRISPI.proc_create_cliente
	@nombre nvarchar(255),
	@apellido nvarchar(255),
	@dni numeric(18,0),
	@fecha_nacimiento datetime,
	@direccion nvarchar(255),
	@ciudad_nombre nvarchar(255),
	@mail nvarchar(255),
	@telefono numeric(18,0),
	@codigo_postal int,
	@estado bit,
	@id int output

as
begin try
	begin transaction
	
	Declare @ciudad_id int;
	
	set @ciudad_id = (select top 1 ciudad_id from CRISPI.Ciudad where ciudad_nombre = @ciudad_nombre);
	
	INSERT INTO CRISPI.Cliente(cliente_nombre,cliente_apellido,cliente_dni,cliente_mail,cliente_telefono,
								cliente_direccion,cliente_fechanac,cliente_ciudad_id,cliente_codigo_postal,
								cliente_credito,cliente_estado)
	values(@nombre,@apellido,@dni,@mail,@telefono,@direccion,@fecha_nacimiento,@ciudad_id,@codigo_postal,200,@estado);
	SET @id=SCOPE_IDENTITY();

	commit transaction
	RETURN  @id;
end try
begin catch
	rollback transaction
end catch
GO


create  procedure CRISPI.proc_create_usuario_cliente
	@nombre nvarchar(255),
	@apellido nvarchar(255),
	@username nvarchar(255),
	@password nvarchar(255),
	@fecha_nacimiento datetime,
	@dni numeric(18,0),
	@direccion nvarchar(255),
	@ciudad_nombre nvarchar(255),
	@codigo_postal int,
	@telefono numeric(18,0),
	@mail nvarchar(255),
	@estado bit
as
begin try
	begin transaction
	declare @id_usuario int;
	declare @id_cliente int;

	exec CRISPI.proc_create_cliente @nombre,@apellido,@dni,@fecha_nacimiento,@direccion,@ciudad_nombre,@mail,@telefono,@codigo_postal,@estado,@id = @id_cliente output;
		
	INSERT INTO CRISPI.Usuario(usuario_username,usuario_password,usuario_cliente_id,usuario_habilitado,usuario_estado,usuario_cantidad_errores)
	values(@username,HASHBYTES('SHA2_256', CONVERT(nvarchar(50), @password)),@id_cliente,1,@estado,0);
	SET @id_usuario=SCOPE_IDENTITY();

	INSERT INTO CRISPI.Rol_Por_Usuario(usuario_id,rol_id)
	values(@id_usuario,2);
	
	commit transaction
end try
begin catch
	rollback
end catch
GO


create procedure CRISPI.proc_inabilitar 
@u nvarchar(50)
as
begin try
	begin transaction
		update CRISPI.Usuario
		set usuario_estado=0
		where usuario_username=@u  
		 
		
	commit transaction
end try
begin catch
	rollback transaction
end catch
go


create  procedure CRISPI.proc_update_cliente
	@nombre nvarchar(255),
	@apellido nvarchar(255),
	@dni numeric(18,0),
	@fecha_nacimiento datetime,
	@direccion nvarchar(255),
	@ciudad_nombre nvarchar(255),
	@mail nvarchar(255),
	@telefono numeric(18,0),
	@codigo_postal int,
	@estado bit,
	@id int

as
begin try
	begin transaction
	
	Declare @ciudad_id int;
	
	set @ciudad_id = (select top 1 ciudad_id from CRISPI.Ciudad where ciudad_nombre = @ciudad_nombre);
		
	update CRISPI.Cliente set cliente_nombre=@nombre,cliente_apellido=@apellido,cliente_dni=@dni,cliente_mail=@mail,cliente_telefono=@telefono,
								cliente_direccion=@direccion,cliente_fechanac = @fecha_nacimiento,cliente_ciudad_id=@ciudad_id,cliente_codigo_postal=@codigo_postal,cliente_estado = @estado
	where cliente_id = @id

	commit transaction
end try
begin catch
	rollback transaction
end catch
GO


create  procedure CRISPI.proc_create_proveedor
	@cuit nvarchar(20),
	@razon_social nvarchar(100),
	@direccion nvarchar(255),
	@mail nvarchar(255),
	@ciudad_nombre nvarchar(255),
	@telefono numeric(18,0),
	@id int output
as
begin try
	begin transaction
	
	Declare @ciudad_id int;
	
	set @ciudad_id = (select top 1 ciudad_id from CRISPI.Ciudad where ciudad_nombre = @ciudad_nombre);
	
	INSERT INTO CRISPI.Proveedor(proveedor_cuit,proveedor_rs,proveedor_dom,proveedor_mail,proveedor_ciudad_id,proveedor_telefono,proveedor_estado)
	values(@cuit,@razon_social,@direccion,@mail,@ciudad_id,@telefono,1)
	SET @id=SCOPE_IDENTITY()
	
	commit transaction
	return @id;
end try
begin catch
	rollback transaction
    THROW;
end catch
GO



create  procedure CRISPI.proc_create_usuario_proveedor
	@razon_social nvarchar(100),
	@username nvarchar(255),
	@password nvarchar(255),
	@cuit nvarchar(20),
	@direccion nvarchar(255),
	@ciudad_nombre nvarchar(255),
	@telefono numeric(18,0),
	@mail nvarchar(255)
as
begin try
	begin transaction
	declare @id_proveedor int;
	declare @usuario_id int;

	set @id_proveedor = 0;
	
	exec CRISPI.proc_create_proveedor @cuit,@razon_social,@direccion,@mail,@ciudad_nombre,@telefono,@id = @id_proveedor output;
		
	INSERT INTO CRISPI.Usuario(usuario_username,usuario_password,usuario_proveedor_id,usuario_habilitado,usuario_estado,usuario_cantidad_errores)
	values(@username,HASHBYTES('SHA2_256', CONVERT(nvarchar(50), @password)),@id_proveedor,1,1,0);
	SET @usuario_id=SCOPE_IDENTITY();

	INSERT INTO CRISPI.Rol_Por_Usuario(usuario_id,rol_id)
	values(@usuario_id,3);
	
	commit transaction
end try
begin catch
	rollback transaction
	PRINT('Error al persistir usuario');
    THROW;
end catch
GO




create procedure CRISPI.proc_create_oferta
	@codigooferta nvarchar(50),
	@descripcion nvarchar(255),
	@precio numeric(18,2),
	@preciolista numeric(18,2),
	@fechainicio datetime,
	@fechafin  datetime,
	@cantidad numeric(18,0),
	@maximo int,
	@proveedor int,
	@usuario int,
	@rubro int
as

begin try

	begin transaction
	declare @r int
	select @r=rubro_proveedor_id from CRISPI.Rubro_Proveedor where rubro_id=@rubro and rubro_proveedor=@proveedor
	insert into CRISPI.Oferta (oferta_codigo,oferta_descripcion,oferta_precio,oferta_lista,oferta_cantidad,oferta_maxima,oferta_fecha_inicio,oferta_fecha_fin,oferta_rubro_proveedor_id,oferta_usuario_creador_id)

	values(@codigooferta,@descripcion,@precio,@preciolista,@cantidad,@maximo,@fechainicio,@fechafin,@r,@usuario);
	commit transaction
end try
begin catch

	rollback transaction

	throw;
end catch
GO	

create procedure CRISPI.proc_update_proveedor
	@cuit nvarchar(20),
	@razon_social nvarchar(100),
	@direccion nvarchar(255),
	@mail nvarchar(255),
	@ciudad_nombre nvarchar(255),
	@telefono numeric(18,0),
	@id int
as
begin try
	begin transaction
	
	Declare @ciudad_id int;
	
	set @ciudad_id = (select top 1 ciudad_id from CRISPI.Ciudad where ciudad_nombre = @ciudad_nombre);
	
	update CRISPI.Proveedor set proveedor_cuit = @cuit,proveedor_rs=@razon_social,proveedor_dom=@direccion,
		proveedor_mail=@mail,proveedor_ciudad_id=@ciudad_id,proveedor_telefono=@telefono
	where proveedor_id = @id;
end try	
begin catch
	rollback transaction
	throw;
end catch
go

create procedure CRISPI.proc_actualizar_oferta
@oferta int,
@codigooferta nvarchar(50),
@descripcion nvarchar(255),
@precio numeric(18,2),
@preciolista numeric(18,2),
@fechainicio datetime,
@fechafin  datetime,
@cantidad numeric(18,0),
@maximo int,
@proveedor int,
@usuario int,
@rubro int 
as 
begin try 
	begin transaction
	declare @r int 
	select @r=rubro_proveedor_id from CRISPI.Rubro_Proveedor where rubro_id=@rubro and rubro_proveedor=@proveedor
	update CRISPI.Oferta
	set oferta_codigo=@codigooferta,
	oferta_descripcion=@descripcion,
	oferta_precio=@precio,
	oferta_lista=@preciolista,
	oferta_cantidad=@cantidad,
	oferta_maxima=@maximo,
	oferta_fecha_inicio=@fechainicio,
	oferta_fecha_fin=@fechafin,
	oferta_rubro_proveedor_id=@r,
	oferta_usuario_creador_id=@usuario
	where oferta_id =@oferta

	commit transaction
end try
begin catch
	rollback transaction
	throw;
end catch
go

create procedure CRISPI.proc_eliminar_oferta
@oferta int
as
begin try 
	begin transaction
	update CRISPI.Oferta
	set oferta_eliminado=1
	where oferta_id=@oferta



	commit transaction
end try
begin catch
	rollback transaction
	throw;
end catch
go

create procedure CRISPI.proc_comprar_oferta
@oferta int,
@cliente int,
--@fecha datetime,
@cliente_destino numeric(18,0),
@cantidad int,
@credito numeric(18,2) 
as 
begin try
	begin transaction
	declare @c int 
	select @c=cliente_id from CRISPI.Cliente where cliente_dni=@cliente_destino
	 insert into CRISPI.Venta(venta_oferta_id,venta_cliente_id,venta_fecha,venta_cliente_destino_id,venta_cantidad)
	 values(@oferta,@cliente,GETDATE(),@c,@cantidad)
	 declare @precio numeric(18,2) ,@precio2 numeric(18,2)
	 select @precio=oferta_precio,@precio2=oferta_lista from CRISPI.Oferta where oferta_id=@oferta
	 insert into CRISPI.Cupones(cupones_oferta_id,cupones_precio_oferta,cupones_precio_lista,cupones_cliente_id,cupones_estado_id)
	 values(@oferta,@precio,@precio2,@cliente,1)
	 update CRISPI.Cliente
	 set cliente_credito=@credito
	 where cliente_id=@cliente

	commit transaction
end try
begin catch
	rollback transaction
	throw;
end catch
go

create procedure CRISPI.proc_cargar_credito
@cliente int,
@tipo int,
@credito numeric(18,2),
@a nvarchar(255),
@tarjeta numeric(18,0)
as 
begin try
	begin transaction
	
	 insert into CRISPI.Credito(credito_cliente_id,credito_monto,credito_tarjeta,credito_tipo_pago_id,credito_datos,credito_fecha)
	 values(@cliente,@credito,@tarjeta,@tipo,@a,GETDATE())
	 
	 update CRISPI.Cliente
	 set cliente_credito=cliente_credito+@credito
	 where cliente_id=@cliente

	commit transaction
end try
begin catch
	rollback transaction
	throw;
end catch
go

create procedure CRISPI.proc_cargar_credito_efectivo
@cliente int,
@tipo int,
@credito numeric(18,2),
@a nvarchar(255)

as 
begin try
	begin transaction
	
	 insert into CRISPI.Credito(credito_cliente_id,credito_monto,credito_tipo_pago_id,credito_datos,credito_fecha)
	 values(@cliente,@credito,@tipo,@a,GETDATE())
	 
	 update CRISPI.Cliente
	 set cliente_credito=cliente_credito+@credito
	 where cliente_id=@cliente

	commit transaction
end try
begin catch
	rollback transaction
	throw;
end catch
go

create procedure CRISPI.proc_mostrar_ofertas
as


	select oferta_id,oferta_descripcion from CRISPI.Oferta
	where YEAR(GETDATE())<=YEAR(oferta_fecha_inicio) and MONTH(GETDATE())<=MONTH(oferta_fecha_inicio) and oferta_eliminado=0  


go

create procedure CRISPI.proc_ofertas
@u int
as
	

	select oferta_id,oferta_codigo,oferta_descripcion,oferta_precio,oferta_lista,oferta_cantidad,oferta_maxima,oferta_fecha_inicio,oferta_fecha_fin,oferta_eliminado,oferta_rubro_proveedor_id from CRISPI.Oferta join CRISPI.Rubro_Proveedor on oferta_rubro_proveedor_id=rubro_proveedor_id 
	where rubro_proveedor=@u
	--where YEAR(GETDATE())<=YEAR(oferta_fecha_inicio) and MONTH(GETDATE())<=MONTH(oferta_fecha_inicio) and oferta_eliminado=0  


go


create procedure CRISPI.proc_mostrar_rubro
as
	select rubro_id,rubro_nombre from CRISPI.Rubro
	
go

create procedure CRISPI.proc_mostrar_proveedor
as
	select proveedor_id,proveedor_rs from CRISPI.Proveedor
	
go

create  procedure CRISPI.proc_insert_rol_proveedor(@rubro_id int,@proveedor_id int)
as
begin try
	begin transaction
	
	INSERT INTO CRISPI.Rubro_Proveedor(rubro_id,rubro_proveedor)
	VALUES(@rubro_id,@proveedor_id);
	
	commit transaction
end try
begin catch
	rollback transaction
end catch
go


create procedure CRISPI.mostrar_ofertas_vendidad(@proveedor_rs nvarchar(100),@fecha_inicio date,@fecha_fin date)
as
	declare @proveedor_id int;

	set @proveedor_id = (select top 1 proveedor_id from CRISPI.Proveedor where proveedor_rs = @proveedor_rs);

	select * from CRISPI.ofertas_facturas 
	where format(CONVERT(date,fecha_compra),'yyyy-MM-dd')>= @fecha_inicio and 
		format(CONVERT(date,fecha_compra),'yyyy-MM-dd') <= @fecha_fin and 
		proveedor_id = @proveedor_id;
	
go


create function CRISPI.func_monto_factura(@proveedor_rs nvarchar(100),@fecha_inicio date,@fecha_fin date)
returns decimal(18,2)
as
begin
	declare @monto decimal(18,2);

	select @monto = ISNULL(sum(o.oferta_precio * v.venta_cantidad),0)
	from CRISPI.Venta v
	join CRISPI.Oferta o on o.oferta_id = v.venta_oferta_id
	join CRISPI.Cliente c on c.cliente_id = v.venta_cliente_id
	join CRISPI.Rubro_Proveedor rp on rp.rubro_proveedor_id = o.oferta_rubro_proveedor_id
	join CRISPI.Proveedor p on p.proveedor_rs = @proveedor_rs
	where format(CONVERT(date,v.venta_fecha),'yyyy-MM-dd')>= @fecha_inicio and 
		format(CONVERT(date,v.venta_fecha),'yyyy-MM-dd') <= @fecha_fin and 
		p.proveedor_rs = @proveedor_rs;

		return @monto;
end
go



create procedure CRISPI.facturar
	@proveedor_rs nvarchar(100),
	@fecha_inicio date,
	@fecha_fin date
as
begin try
	
	declare @factura_id int;
	declare @proveedor_id int;

	set @proveedor_id = (select top 1 proveedor_id from CRISPI.Proveedor where proveedor_rs = @proveedor_rs);

	insert into CRISPI.Facturacion(facturacion_nro,facturacion_tipo,facturacion_proveedor_id,facturacion_fecha)
	values ((select max(facturacion_nro) + 1 from CRISPI.Facturacion),'A',@proveedor_id,GETDATE())
	SET @factura_id=SCOPE_IDENTITY();


	insert into CRISPI.Item_factura(facturacion_id,cliente_id,oferta_id,item_factura_cantidad)
	select @factura_id,c.cliente_id,o.oferta_id,v.venta_cantidad
	from CRISPI.Venta v
	join CRISPI.Oferta o on o.oferta_id = v.venta_oferta_id
	join CRISPI.Cliente c on c.cliente_id = v.venta_cliente_id
	join CRISPI.Rubro_Proveedor rp on rp.rubro_proveedor_id = o.oferta_rubro_proveedor_id
	where format(CONVERT(date,v.venta_fecha),'yyyy-MM-dd')>= @fecha_inicio and 
		format(CONVERT(date,v.venta_fecha),'yyyy-MM-dd') <= @fecha_fin and 
		rp.rubro_proveedor = @proveedor_id;

	update CRISPI.Facturacion set facturacion_monto = (
	select ISNULL(sum(o.oferta_precio * it.item_factura_cantidad),0) from CRISPI.Item_factura it
	join CRISPI.Oferta o on o.oferta_id = it.oferta_id)
	where facturacion_id = @factura_id

end try
begin catch
	rollback transaction
end catch
go

create procedure CRISPI.listado_estadistico_facturas(@semestre int,@anio int)
as
begin
	if(@semestre = 1)
	begin
		select top 5 p.proveedor_cuit,p.proveedor_rs from CRISPI.Facturacion f
		join CRISPI.Proveedor p on p.proveedor_id = f.facturacion_proveedor_id
		where Year(f.facturacion_fecha) = @anio and MONTH(f.facturacion_fecha) between 1 and 6
		group by p.proveedor_cuit,p.proveedor_rs
		order by count(1) desc,sum(f.facturacion_monto) desc
	end
	else
	begin
		select top 5 p.proveedor_cuit,p.proveedor_rs from CRISPI.Facturacion f
		join CRISPI.Proveedor p on p.proveedor_id = f.facturacion_proveedor_id
		where Year(f.facturacion_fecha) = @anio and MONTH(f.facturacion_fecha) between 7 and 12
		group by p.proveedor_cuit,p.proveedor_rs
		order by count(1) desc,sum(f.facturacion_monto) desc
	end
end
go

--trigger
create trigger CRISPI.tr_delete_cliente
on CRISPI.Cliente
instead of delete
as
begin try

	update CRISPI.Cliente set cliente_estado = 0 where cliente_id in (select cliente_id from deleted)
	
	commit;
end try
begin catch
	rollback;
end catch
GO




