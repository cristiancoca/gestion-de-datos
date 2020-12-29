USE GD2015C1
--ejercicio 1
select clie_codigo,clie_razon_social 
from Cliente
where clie_limite_credito>=1000
order by clie_codigo

--ejercicio 2
select prod_codigo,prod_detalle 
from Producto join Item_Factura on prod_codigo=item_producto join Factura on item_numero=fact_numero and item_sucursal=fact_sucursal and item_tipo=fact_tipo 
where year(fact_fecha)=2012
group by prod_codigo,prod_detalle
order by sum (item_cantidad)

--ejercicio 4
select prod_codigo,prod_detalle,count(comp_componente)cant 
from Producto left join Composicion on prod_codigo=comp_producto 
where (select avg(stoc_cantidad) from STOCK where stoc_producto=prod_codigo )>100 
group by prod_codigo,prod_detalle


--ejercicio3
select prod_codigo,prod_detalle,sum(ISNULL( stoc_cantidad,0)) stock_total
from Producto left join STOCK on prod_codigo=stoc_producto
group by prod_codigo,prod_detalle
order by prod_detalle

--ejercicio5
select prod_codigo,prod_detalle,sum (item_cantidad) 
from Producto join Item_Factura on prod_codigo=item_producto join Factura on item_numero=fact_numero and item_sucursal=fact_sucursal and item_tipo=fact_tipo
where YEAR(fact_fecha)=2012
group by prod_codigo,prod_detalle
having sum(item_cantidad)> (select sum (item_cantidad) 
from Item_Factura join Factura on item_numero=fact_numero
where YEAR(fact_fecha)=2011 and prod_codigo=item_producto)

--ejercicio10
select top 10 prod_codigo,prod_detalle,sum (item_cantidad) cant,(
select top 1 fact_cliente    
from Item_Factura join Factura on item_numero=fact_numero and item_sucursal=fact_sucursal and item_tipo=fact_tipo join Cliente on fact_cliente=clie_codigo
where prod_codigo=item_producto         
group by fact_cliente
order by sum(item_cantidad) desc) cliente   
from Producto join Item_Factura on prod_codigo=item_producto         
group by prod_codigo,prod_detalle
order by cant desc

--ejercicio7
select prod_codigo,prod_detalle,max(item_precio),min(item_precio),(max(item_precio)-min(item_precio))*100/min(item_precio)    
from Producto join Item_Factura on prod_codigo=item_producto           
group by prod_codigo
having (select sum(stoc_cantidad) 
from STOCK
where prod_codigo=stoc_producto)>0

--ejercicio11
select fami_id, fami_detalle,count(distinct (prod_codigo)) cant,sum(item_cantidad*item_precio) total
from Familia join Producto on fami_id=prod_familia join Item_Factura on prod_codigo=item_producto  
group by fami_detalle,fami_id
having (select sum(item_cantidad*item_precio)     
from Producto join Item_Factura on prod_codigo=item_producto join Factura on item_numero=fact_numero 
where fami_id=prod_familia and year(fact_fecha)=2012 )>20000 
order by cant desc 


--ejercicio12
select  prod_codigo,prod_detalle,count(distinct (fact_cliente)) cant_clientes,avg(item_precio) precio_promedio,sum(item_precio*item_cantidad) total,
count(distinct (stoc_deposito)) cant_depositos,sum(distinct (stoc_cantidad)) cant
from Producto join Item_Factura on prod_codigo=item_producto join Factura on item_numero=fact_numero join STOCK on prod_codigo=stoc_producto
where year(fact_fecha)=2012         
group by prod_codigo,prod_detalle
order by sum(item_precio*item_cantidad)  desc

--ejercicio9
select e1.empl_codigo AS codigoJefe,
	e2.empl_codigo AS codigoEmpleado,
	e2.empl_nombre AS nombreEmpleado,
	COUNT(*) AS depositosEnConjnto
	from Empleado e1 
	join Empleado e2  on e1.empl_codigo=e2.empl_jefe    
	join DEPOSITO depo on depo.depo_encargado=e1.empl_codigo OR depo.depo_encargado=e2.empl_codigo
    group by e1.empl_codigo, e2.empl_codigo, e2.empl_nombre 



--ejercicio15
select a1.prod_codigo,a1.prod_detalle,a2.prod_codigo,a2.prod_detalle,(select count(*) 
from Item_Factura item1,Item_Factura item2 
where item1.item_producto=a1.prod_codigo and item2.item_producto=a2.prod_codigo and item1.item_numero=item2.item_numero) cant
from Producto a1, Producto a2  
where a1.prod_codigo<a2.prod_codigo 
group by a1.prod_codigo,a1.prod_detalle,a2.prod_codigo,a2.prod_detalle
having (select count(*) 
from Item_Factura item1,Item_Factura item2 
where item1.item_producto=a1.prod_codigo and item2.item_producto=a2.prod_codigo and item1.item_numero=item2.item_numero
) >500
order by cant 

select clie_codigo,count(distinct (fact_numero))cant,avg(fact_total),count(distinct (item_producto)),max(fact_total)
from Cliente join Factura on clie_codigo=fact_cliente join Item_Factura on fact_numero=item_numero
where year(fact_fecha)=2012
group by  clie_codigo
order by cant







select comp.comp_producto,prod.prod_detalle ,comp.comp_componente, prod1.prod_detalle from Composicion comp
	join Producto prod on comp.comp_producto = prod.prod_codigo 
	join Producto prod1 on comp.comp_componente=prod1.prod_codigo



	

select fami_id, fami_detalle,count(distinct (prod_codigo)) cant_productos,(select top 1 prod_detalle
		from Producto join Composicion on comp_producto=prod_codigo join Item_Factura on item_producto=prod_codigo join Factura on fact_numero=item_numero
		where prod_familia=fami_id and year(fact_fecha)=2012
		group by prod_codigo,prod_detalle
		order by sum(item_cantidad) desc)producto_compuesto,sum (item_cantidad)unidades_vendidas,
		count (distinct (fact_numero))cantidad_facturas,sum(item_cantidad*item_precio) total_año_2012
from Familia join Producto on fami_id=prod_familia --join Composicion on comp_producto=prod_codigo 
			 join Item_Factura on prod_codigo = item_producto 
			 join Factura on item_numero=fact_numero
where (select count(distinct (prod_codigo))
		from Producto  join Composicion on comp_producto=prod_codigo 
		where prod_familia=fami_id
		) >=5 and year(fact_fecha)=2012--filtro las familias q tienen al menos 5 productos q son composicion
group by fami_detalle,fami_id
order by total_año_2012 desc

/*considera que tener al menos 5 productos con composicion es solo un filtro para descartar las familias q no tienen esa cantidad,
pero al pedir cantidad de productos considero que se refiere a todos los productos ya sean compuestos o no 
la cantidad de unidades vendidas considero que se refiere a todos los productos no me aclara q tiene q ser solo de los compuestos 
como cuando me pide el producto con composicion mas vendido*/
go 

