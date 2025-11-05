DataProject: LógicaConsultasSQL

/*1.Crea el esquema de la BBDD.*/

 
/*2.Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.*/
	select title
	from public.film
	where rating ='R'

/*3.Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.*/
	select first_name
	from public.actor
	where actor_id between 30 and 40

/*4.Obtén las películas cuyo idioma coincide con el idioma original.*/
	select title
	from public.film
	where language_id=original_language_id 
	/*no hay resultados en la consulta anterior porque todos los campos son null en original_language_id:
    select title
	from public.film
	where original_language_id is not null 
 	*/	
	
/*5.Ordena las películas por duración de forma ascendente.*/
	select title, length
	from public.film
	order by length asc
	
/*6.Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.*/
	select first_name, last_name
	from public.actor
	where upper(last_name) like upper('%Allen%')	 
	/* o tambien podía haber usado la consulta:
	select first_name, last_name
	from public.actor
	where last_name ilike '%Allen%'
	 */
	
/*7.Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.*/
	select rating, count(film_id)
	from public.film
	group by rating 
	
/*8.Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.*/
	select title
	from public.film
	where rating='PG-13' or length > 180
	
/*9.Encuentra la variabilidad de lo que costaría reemplazar las películas.*/
	select stddev(replacement_cost), variance(replacement_cost)
	from public.film

/*10.Encuentra la mayor y menor duración de una película de nuestra BBDD.*/
	
	select min(length), max(length)
	from public.film

/*11.Encuentra lo que costó el antepenúltimo alquiler ordenado por día.*/
	select amount
	from public.payment
	where rental_id = (select max(rental_id) from public.rental)-2
	/*se ha verificado antes que el el rental_id es un incremental correcto con respecto a las fechas*/
	
/*12.Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC- 17ʼ ni ‘Gʼ en cuanto a su clasificación.*/
	select title
	from public.film
	where rating not in ('NC-17','G')
	
/*13.Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.*/
	select rating,avg(length) as Promedio_duracion
	from public.film
	group by rating 

/*14.Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.*/
	select title
	from public.film
	where length > 180

/*15.¿Cuánto dinero ha generado en total la empresa?*/
	select sum(amount)
	from public.payment

/*16.Muestra los 10 clientes con mayor valor de id.*/
	select *
	from public.customer
	order by customer_id desc
	limit 10

/*17.Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.*/
	select a.first_name, a.last_name
	from public.actor a 
	left join public.film_actor b on a.actor_id = b.actor_id 
	left join public.film c on b.film_id = c.film_id 
	where upper(c.title) like upper('%Egg Igby%')

/*18.Selecciona todos los nombres de las películas únicos.*/
	select count (distinct(title))
	from public.film


/*19.Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.*/
	select f.title
	from public.film as f 
	left join public.film_category as fc	on f.film_id = fc.film_id
	left join public.category as c	on fc.category_id = c.category_id
	where c.name = 'Comedy' and f.length > 180
	
/*20.Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.*/
	select c.name, avg(a.length) as avg_length
	from public.film as a
	inner join public.film_category as b
	on a.film_id = b.film_id
	inner join public.category as c
	on b.category_id=c.category_id
	group by c.name
	having avg(a.length) > 110

/*21.¿Cuál es la media de duración del alquiler de las películas?*/
	select avg(rental_duration)
	from public.film

/*22.Crea una columna con el nombre y apellidos de todos los actores y actrices.*/
	select concat(first_name,' ',last_name) as Nombre_Apellidos
	from public.actor
	
/*23.Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.*/
	select cast(rental_date as date) as Fecha,count(*) as Alquileres
	from public.rental
	group by Fecha
	order by Alquileres desc

/*24.Encuentra las películas con una duración superior al promedio.*/
	select *
	from public.film
	where length > (select avg(length) from public.film)

/*25.Averigua el número de alquileres registrados por mes.*/
	select date_part('year',rental_date ) as Anio,
	date_part('month',rental_date ) as Mes,
	count(*) as Alquileres
	from public.rental
	group by Anio, Mes
	order by Anio asc, Mes asc
	
/*26.Encuentra el promedio, la desviación estándar y varianza del total pagado.*/
	select avg(amount), stddev(amount), var_samp(amount)
	from public.payment

/*27.¿Qué películas se alquilan por encima del precio medio?*/
	select title,rental_rate
	from public.film
	where rental_rate > (select avg(rental_rate) from public.film)

/*28.Muestra el id de los actores que hayan participado en más de 40 películas.*/
	 select actor_id
	 from public.film_actor
	 group by actor_id
	 having count(film_id) > 40


/*29.Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.*/
	 select a.title,count(b.inventory_id) as cantidad_en_inventario
	 from public.film as a
	 left join public.inventory as b
	 on a.film_id = b.film_id
	 group by a.title

/*30.Obtener los actores y el número de películas en las que ha actuado.*/
	 select a.actor_id, a.first_name, a.last_name, count( b.film_id) as num_peliculas
	 from public.actor as a
	 left join public.film_actor as b
	 on a.actor_id = b.actor_id
	 group by a.actor_id, a.first_name, a.last_name

/*31.Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.*/
	 select a.title, concat(b.first_name, ' ', b.last_name) as actor
	 from public.film a
	 left join public.film_actor c on a.film_id = c.film_id
	 left join public.actor b on c.actor_id = b.actor_id

	 
/*32.Obtener todos los actores y mostrar las películas en las que hanactuado, incluso si algunos actores no han actuado en ninguna película.*/
	 select a.first_name, a.last_name, c.title
	 from public.actor as a
	 left join public.film_actor as b on a.actor_id = b.actor_id
	 left join public.film as c  on b.film_id = c. film_id

/*33.Obtener todas las películas que tenemos y todos los registros de alquiler.*/
	select a.title, c.rental_id, c.rental_date
	from public.film a
	left join public.inventory b on a.film_id = b.film_id
	left join public.rental c on b.inventory_id = c.inventory_id

/*34.Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.*/
	select a.customer_id, a.first_name, a.last_name, sum(b.amount) as total_gastado
	from public.customer a
	join public.payment b on a.customer_id = b.customer_id
	group by a.customer_id
	order by total_gastado desc
	limit 5

/*35.Selecciona todos los actores cuyo primer nombre es 'Johnny'.*/
	select * from public.actor a where upper(a.first_name) = upper('Johnny')
	
/*36.Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.*/
	select first_name as nombre, last_name as apellido from public.actor

/*37.Encuentra el ID del actor más bajo y más alto en la tabla actor.*/
	select min(actor_id) as id_minimo, max(actor_id) as id_maximo from public.actor

/*38.Cuenta cuántos actores hay en la tabla “actorˮ.*/
	select count(*) as total_actores from public.actor

/*39.Selecciona todos los actores y ordénalos por apellido en orden ascendente.*/
	select * from public.actor order by last_name asc

/*40.Selecciona las primeras 5 películas de la tabla “filmˮ.*/
	select * from public.film limit 5

/*41.Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?*/
	select a.first_name, count(*) as cantidad
	from public.actor a
	group by a.first_name
	order by cantidad desc

/*42.Encuentra todos los alquileres y los nombres de los clientes que los realizaron.*/
	select a.rental_id, a.rental_date, b.first_name, b.last_name
	from public.rental a
	join customer b on a.customer_id = b.customer_id

/*43.Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.*/
	select a.first_name, a.last_name, b.rental_id, b.rental_date
	from public.customer a
	left join public.rental b on a.customer_id = b.customer_id

/*44.Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.*/
	select a.title, b.name as categoria
	from public.film a
	cross join public.category b
	/* esta consulta no aporta valor práctico porque genera todas las combinaciones posibles entre películas y categorías aunque no estén relacionadas. */
	
/*45.Encuentra los actores que han participado en películas de la categoría 'Action'.*/
	select distinct a.first_name, a.last_name
	from public.actor a
	join public.film_actor b on a.actor_id = b.actor_id
	join public.film_category c on b.film_id = c.film_id
	join public.category d on c.category_id = d.category_id
	where d.name = 'Action'

/*46.Encuentra todos los actores que no han participado en películas.*/
	select a.*
	from public.actor a
	left join public.film_actor b on a.actor_id = b.actor_id
	where b.film_id is null

/*47.Selecciona el nombre de los actores y la cantidad de películas en las que han participado.*/
	select a.first_name, a.last_name, count(b.actor_id) as num_peliculas
	from public.actor as a
	left join public.film_actor as b on a.actor_id = b.actor_id
	group by a.first_name, a.last_name

/*48.Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.*/
	create view public.actor_num_peliculas as
	select a.first_name, a.last_name, count(b.film_id) as num_peliculas
	from public.actor a
	left join public.film_actor b on a.actor_id = b.actor_id
	group by a.actor_id,a.first_name, a.last_name
	/*comprobación: select * from public.actor_num_peliculas*/

/*49.Calcula el número total de alquileres realizados por cada cliente.*/
	select a.customer_id, a.first_name, a.last_name, count(b.rental_id) as total_alquileres
	from public.customer a
	left join public.rental b on a.customer_id = b.customer_id
	group by a.customer_id

/*50.Calcula la duración total de las películas en la categoría 'Action'.*/
	select c.name as categoria, sum(a.length) as duracion_total
	from public.film a
	join public.film_category b on a.film_id = b.film_id
	join public.category c on b.category_id = c.category_id
	where c.name = 'Action'
	group by c.name

/*51.Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.*/
	create temporary table cliente_rentas_temporal as
	select a.customer_id, count(b.rental_id) as total_rentas
	from public.customer a
	join public.rental b on a.customer_id = b.customer_id
	group by a.customer_id
	/* comprobación: select * from cliente_rentas_temporal*/

/*52.Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.*/
	create temporary table peliculas_alquiladas_temporal as
	select a.film_id, a.title, count(c.rental_id) as num_alquileres
	from public.film a
	join public.inventory b on a.film_id = b.film_id
	join public.rental c on b.inventory_id = c.inventory_id
	group by a.film_id
	having count(c.rental_id) >= 10
	/* comprobación: select * from peliculas_alquiladas_temporal*/
	/* no me ha dejado hacer la consulta con having num_alquileres >= 10, ya que no permite alias pare el having ni para el where*/

/*53.Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.*/
	select distinct a.title
	from public.film a
	join public.inventory b on a.film_id = b.film_id
	join public.rental c on b.inventory_id = c.inventory_id
	join public.customer d on c.customer_id = d.customer_id
	where upper(d.first_name) = upper('tammy') and upper(d.last_name) = upper('sanders')
	and c.return_date is null
	order by a.title

/*54.Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido.*/
	select distinct a.first_name, a.last_name
	from public.actor a
	join public.film_actor b on a.actor_id = b.actor_id
	join public.film_category c on b.film_id = c.film_id
	join public.category d on c.category_id = d.category_id
	where d.name = 'Sci-Fi'
	order by a.last_name

/*55.Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez Ordena los resultados alfabéticamente por apellido.*/
	select distinct a.first_name, a.last_name
	from public.actor a
	join public.film_actor b on a.actor_id = b.actor_id
	join public.film c on b.film_id = c.film_id
	join public.inventory d on c.film_id = d.film_id
	join public.rental e on d.inventory_id = e.inventory_id
	where e.rental_date > (
	  select min(h.rental_date)
	  from public.rental h
	  join public.inventory g on h.inventory_id = g.inventory_id
	  join public.film f on g.film_id = f.film_id
	  where upper(f.title) = upper('spartacus cheaper')
	)
	order by a.last_name

/*56.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.*/
	select a.first_name, a.last_name
	from public.actor a
	where a.actor_id not in (
	  select distinct b.actor_id
	  from public.film_actor b
	  join public.film_category c on b.film_id = c.film_id
	  join public.category d on c.category_id = d.category_id
	  where d.name = 'Music'
	)

/*57.Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.*/
	select distinct a.title
	from public.film a
	join public.inventory b on a.film_id = b.film_id
	join public.rental c on b.inventory_id = c.inventory_id
	where c.return_date - c.rental_date > '8 days'
	
/*58.Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.*/
	select a.title
	from film a 
	left join public.film_category b on a.film_id = b.film_id 
	left join public.category c on b.category_id = c.category_id 
	where c.name = 'Animation'
	
/*59.Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados alfabéticamente por título de película.*/
	select a.title, a.length
	from public.film a
	where a.length = (
	  select b.length from public.film b where upper(b.title) = upper('dancing fever')
	)
	order by a.title asc

/*60.Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.*/
	select a.first_name, a.last_name, count(distinct d.film_id) as peliculas_distintas
	from public.customer a
	join public.rental b on a.customer_id = b.customer_id
	join public.inventory c on b.inventory_id = c.inventory_id
	join public.film d on c.film_id = d.film_id
	group by a.customer_id
	having count(distinct d.film_id) >= 7
	order by a.last_name asc

/*61.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.*/
	select a.name as categoria, count(e.rental_id) as total_alquileres
	from public.category a
	join public.film_category b on a.category_id = b.category_id
	join public.film c on b.film_id = c.film_id
	join public.inventory d on c.film_id = d.film_id
	join public.rental e on d.inventory_id = e.inventory_id
	group by a.category_id	

/*62.Encuentra el número de películas por categoría estrenadas en 2006.*/
	select a.name as categoria, count(b.film_id) as num_peliculas
	from public.category a
	join public.film_category b on a.category_id = b.category_id
	join public.film c on b.film_id = c.film_id
	where c.release_year = 2006
	group by a.category_id

/*63.Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.*/
	select a.staff_id, a.first_name, a.last_name, b.store_id
	from public.staff a
	cross join public.store b

/*64.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.*/
	select a.customer_id, a.first_name, a.last_name, count(b.rental_id) as total_peliculas
	from public.customer a
	join public.rental b on a.customer_id = b.customer_id
	group by a.customer_id
