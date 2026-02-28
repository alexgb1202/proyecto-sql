-- 2 Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.
SELECT title
FROM film
WHERE rating = 'R';

-- 3 Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.
SELECT CONCAT(first_name,' ',last_name) AS "Nombre Completo"
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- 4 Obtén las películas cuyo idioma coincide con el idioma original.
SELECT 
    f.title AS "Película",
    l.name  AS "Idioma"
FROM film f
JOIN language l 
    ON f.language_id = l.language_id
WHERE f.language_id = f.original_language_id;

-- 5 Ordena las películas por duración de forma ascendente.
SELECT title, length
FROM film
ORDER BY length ASC;

--6  Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido
SELECT first_name, last_name 
FROM actor
WHERE last_name ILIKE '%Allen%';

--7 Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
SELECT rating AS "Clasificacion",
       COUNT(film_id) AS "Recuento"
FROM film
GROUP BY rating
ORDER BY rating DESC;

--8 Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film
SELECT title, rating, length
FROM film
WHERE rating = 'PG-13' OR length > 180;

--9  Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT ROUND(STDDEV(replacement_cost),2) AS "Desviacion_estandar_USD"-- Desviacion estándar se entiende mejor que varianza para explicar la variabilidad
FROM film;


-- 10 Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT
	CONCAT(MIN(length), ' min') AS "Menor_duracion",
	CONCAT(MAX(length), ' min') AS "Mayor_duracion"
FROM film;

-- 11 Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT 
    r.rental_date,
    p.amount
FROM rental r
JOIN payment p
    ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC
LIMIT 1 OFFSET 2;


-- 12 Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.
SELECT title, rating
FROM film 
WHERE rating NOT IN ('NC-17', 'G');

-- 13  Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración
SELECT 
	rating,
	ROUND(AVG(length), 2) AS "promedio_duracion"
FROM film
GROUP BY rating;

-- 14 Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT title
FROM film
WHERE length > 180;

-- 15  ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(amount) AS "Total generado"
FROM payment;

-- 16 Muestra los 10 clientes con mayor valor de id
SELECT 
	customer_id,
	CONCAT(first_name, ' ', last_name) AS "Nombre_completo"
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- 17  Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ
SELECT 
	CONCAT(a.first_name, ' ', a.last_name) AS "Nombre Actor"
FROM film_actor fa 
JOIN film f  
	ON fa.film_id = f.film_id 
JOIN actor a  
	ON a.actor_id = fa.actor_id 
WHERE f.title ILIKE 'Egg Igby';

-- 18 Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT(title)
FROM film;

-- 19 Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
SELECT 
	f.title,
	c.name,
	f.length 
FROM film f
JOIN film_category fc 
	ON fc.film_id = f.film_id 
JOIN category c
	ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;

-- 20 Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración
SELECT 
	c.name,
	ROUND(AVG(length),2) AS "Promedio duracion"
FROM film_category fc
JOIN film f
	ON f.film_id = fc.film_id 
JOIN category c
	ON c.category_id = fc.category_id
GROUP BY c.name
HAVING AVG(length)>110;

-- 21 ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(rental_duration) AS "Duracion media de alquiler"
FROM film;

-- 22 Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT(first_name, ' ',last_name) AS "Nombre Completo"
FROM actor;


-- 23 Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT 
	CAST(rental_date AS date) AS "Fecha", -- Cast: Sirve cuando necesitas que un dato sea tratado como otro tipo.
	COUNT(rental_id) AS "nº alquileres"
FROM rental
GROUP BY CAST(rental_date AS date)
ORDER BY COUNT(rental_id) DESC;

-- 24  Encuentra las películas con una duración superior al promedio.
-- a) Con CTE
WITH duracion_promedio AS (
	SELECT AVG(length) AS duracion_media
	FROM film
)
SELECT film_id, title
FROM film f
JOIN duracion_promedio dp
	ON f.length > dp.duracion_media;

-- b) subconsulta
SELECT film_id, title
FROM film
WHERE length > (
	SELECT AVG(length)
	FROM film
);

-- 25 Averigua el número de alquileres registrados por mes.
SELECT 
	TO_CHAR(rental_date, 'YYYY-MM') AS "Mes",
    COUNT(rental_id) AS "Num_alquileres"
FROM rental
GROUP BY "Mes"
ORDER BY "Mes";

-- 26 Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT 
	ROUND(AVG(amount),2) AS promedio,
	ROUND(STDDEV(amount),2) AS desv_estandar,
	ROUND(VARIANCE(amount),2) AS total_pagado
FROM payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
-- a)
WITH precio_medio_pelicula AS (
	SELECT AVG(rental_rate) AS "Precio medio"
	FROM film
)
SELECT f.title
FROM film f
JOIN precio_medio_pelicula pm
	ON f.rental_rate > pm."Precio medio";

-- b)
SELECT title
FROM film
WHERE rental_rate > (
	SELECT AVG(rental_rate)
	FROM film
);

-- 28 Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT
	actor_id,
	COUNT(film_id) AS "Num_peliculas"
FROM film_actor
GROUP BY actor_id
HAVING COUNT(film_id) > 40;

-- 29 Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
WITH num_inventario AS(
	SELECT
		film_id,
		COUNT(film_id) AS "num_peliculas"
	FROM inventory
	GROUP BY film_id
)
SELECT f.title, COALESCE(ni.num_peliculas, 0) AS "num_peliculas" -- Coalesce devuelve el primer valor que no sea NULL
FROM film f
LEFT JOIN num_inventario ni
	ON f.film_id = ni.film_id;

-- 30 Obtener los actores y el número de películas en las que ha actuado.
WITH num_peliculas AS( 
	SELECT 
		actor_id,
		COUNT(film_id) AS "Num_peliculas"
	FROM film_actor
	GROUP BY actor_id
)
SELECT 
	CONCAT(a.first_name, ' ',a.last_name) AS "Nombre Completo",
	np."Num_peliculas" 
FROM actor a
LEFT JOIN num_peliculas np
	ON a.actor_id = np.actor_id;

-- 31 Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

SELECT
	f.title,
	CONCAT(a.first_name, ' ', a.last_name ) AS "Nombre Completo"
FROM film f
LEFT JOIN film_actor fa
	ON f.film_id = fa.film_id 
LEFT JOIN actor a
	ON fa.actor_id = a.actor_id



/* 32 Obtener todos los actores y mostrar las películas en las que han 
actuado, incluso si algunos actores no han actuado en ninguna película. */

SELECT
	CONCAT(a.first_name, ' ', a.last_name) AS "Nombre Completo",
	COALESCE(f.title, 'Sin pelicula') AS "Pelicula"
FROM actor a
LEFT JOIN film_actor fa
	ON a.actor_id = fa.actor_id
LEFT JOIN film f
	ON fa.film_id = f.film_id;

-- 33 Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT
	f.title,
	COUNT(r.rental_id) AS "N_alquileres"
FROM film f
LEFT JOIN inventory i 
	ON 	f.film_id = i.film_id
LEFT JOIN rental r
	ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY f.title;

-- 34 Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS "Nombre Completo",
	SUM(p.amount) AS "Total_gastado"
FROM customer c
JOIN payment p
	ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY "Total_gastado" DESC
LIMIT 5;

-- 35 Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT concat(first_name, ' ', last_name) AS "Nombre Completo"
FROM actor
WHERE first_name ILIKE 'Johnny';

-- 36 Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
SELECT 
	first_name AS "Nombre",
	last_name AS "Apellido"
FROM actor;

-- 37  Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT 
	MIN(actor_id),
	MAX(actor_id)
FROM actor;

-- 38 Cuenta cuántos actores hay en la tabla “actorˮ.
SELECT 
	COUNT(actor_id)
FROM actor;

-- 39 Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT first_name, last_name
FROM actor
ORDER BY last_name ASC; -- No es necesario especificar ASC, por defeto es Ascendente

-- 40 Selecciona las primeras 5 películas de la tabla “filmˮ.
SELECT *
FROM film
LIMIT 5;

-- 41 Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT
	first_name,
	count(first_name) AS "Cantidad"
FROM actor
GROUP BY first_name
ORDER BY "Cantidad" DESC; 
 
-- Los mas repetidos son Kenneth, Penelope y Julia (4 veces cada uno)

-- 42 Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT
	r.rental_id,
	r.rental_date,
	CONCAT(c.first_name, ' ', c.last_name) AS "Nombre Completo"
FROM rental r
JOIN customer c
	ON r.customer_id = c.customer_id;

-- 43 Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS "Nombre Completo",
	r.rental_id,
	r.rental_date 
FROM customer c
LEFT JOIN rental r 
	ON c.customer_id = r.customer_id;


-- 44 Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT *
FROM film f
CROSS JOIN category c;

/* El CROSS JOIN genera el producto cartesiano entre film y category,
 * combinando cada película con todas las categorías. En este caso no aporta valor porque no respeta la relación real entre películas y categorías,
 * que se encuentra en la tabla intermedia film_category. Solo genera combinaciones artificiales.*/


--  45 Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT DISTINCT -- Queremos mostrar los que hayan participado en peliculas de accion, no todas las veces
	CONCAT(a.first_name, ' ', a.last_name) AS "Nombre Completo",
	c."name"
FROM actor a
JOIN film_actor fa
	ON a.actor_id = fa.actor_id
JOIN film f
	ON fa.film_id = f.film_id
JOIN film_category fc 
	ON f.film_id = fc.film_id
JOIN category c
	ON fc.category_id = c.category_id
WHERE c."name" ILIKE 'Action';


-- 46 Encuentra todos los actores que no han participado en películas.
SELECT
	CONCAT(a.first_name, ' ', a.last_name) AS "Nombre Completo"
FROM actor a
LEFT JOIN film_actor fa
	ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL; -- Para buscar valores nulos en la columna film_id de fa
	

-- 47 Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS "Nombre Completo",
    COUNT(fa.film_id) AS "Numero de peliculas"
FROM actor a
LEFT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name -- Puede haber actores con el mismo nombre no queremos que se mezclen
ORDER BY "Numero de peliculas" DESC;

-- 48 Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres  de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS (
	SELECT
		CONCAT(a.first_name, ' ', a.last_name) AS "Nombre Completo",
		COUNT(fa.film_id) AS "Numero de peliculas"
	FROM actor a
	LEFT JOIN film_actor fa
		ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id, a.first_name, a.last_name
);

SELECT *
FROM actor_num_peliculas
ORDER BY "Nombre Completo";


-- 49 Calcula el número total de alquileres realizados por cada cliente.
SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS "Nombre Completo",
	COUNT(r.rental_id) AS "Número de alquileres"
FROM customer c
LEFT JOIN rental r
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name,c.last_name
ORDER BY "Número de alquileres" DESC;

-- 50 Calcula la duración total de las películas en la categoría 'Action'.
SELECT
	c.name,
	SUM(f.length) AS "Duracion total"
FROM film_category fc 
JOIN  film f
	ON fc.film_id = f.film_id 
JOIN category c
	ON c.category_id = fc.category_id
WHERE c.name ILIKE 'Action'
GROUP BY c.name;


-- 51 Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.
CREATE TEMPORARY TABLE cliente_rentas_temporal AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name) AS "Nombre Completo",
		COUNT(r.customer_id) AS "Numero de rentas"
	FROM customer c
	LEFT JOIN rental r
		ON c.customer_id = r.customer_id
	GROUP BY c.customer_id, c.first_name, c.last_name
);

SELECT *
FROM cliente_rentas_temporal
ORDER BY "Numero de rentas" DESC;


-- 52 Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.

CREATE TEMPORARY TABLE peliculas_alquiladas AS (
	SELECT 
		f.title,
		COUNT(f.film_id) AS "Num_peliculas_alquiladas"
	FROM rental r
	JOIN inventory i 
		ON i.inventory_id = r.inventory_id
	JOIN film f
		ON f.film_id = i.film_id
	GROUP BY f.film_id, f.title
	HAVING COUNT(f.film_id) >= 10
);

SELECT * FROM peliculas_alquiladas;

/* 53 Encuentra el título de las películas que han sido alquiladas por el cliente 
con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena 
los resultados alfabéticamente por título de película.*/

SELECT
	CONCAT(c.first_name,' ' ,c.last_name) AS "Nombre Completo",
	f.title,
	r.rental_date,
	r.return_date 
FROM customer c
JOIN rental r
	ON r.customer_id = c.customer_id 
JOIN inventory i
	ON r.inventory_id = i.inventory_id
JOIN film f
	ON f.film_id = i.film_id
WHERE CONCAT(c.first_name,' ' ,c.last_name) ILIKE 'Tammy Sanders'
	AND r.return_date IS NULL
ORDER BY f.title ASC;


/* 54  Encuentra los nombres de los actores que han actuado en al menos una 
película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados 
alfabéticamente por apellido. */

SELECT DISTINCT
	a.first_name,
	a.last_name 
FROM actor a
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
JOIN film f 
	ON f.film_id =fa.film_id 
JOIN film_category fc 
	ON fc.film_id = f.film_id 
JOIN category c
	ON c.category_id = fc.category_id 
WHERE c."name" ILIKE 'Sci-Fi'
ORDER BY a.last_name  ASC;


/* 55 Encuentra el nombre y apellido de los actores que han actuado en 
películas que se alquilaron después de que la película ‘Spartacus 
Cheaperʼ se alquilara por primera vez. Ordena los resultados 
alfabéticamente por apellido. */
WITH primera_pelicula AS (
    SELECT MIN(r.rental_date) AS primera_fecha
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON f.film_id = i.film_id
    WHERE f.title ILIKE 'Spartacus Cheaper'
) -- Esto recoge la fecha de la primera vez que se alquiló Spartacus cheaper, se podria usar cross join despues tambien
SELECT DISTINCT
    a.first_name,
    a.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN primera_pelicula pp ON r.rental_date > pp.primera_fecha
ORDER BY a.last_name ASC;


/* 56 Encuentra el nombre y apellido de los actores que no han actuado en 
ninguna película de la categoría ‘Musicʼ */

SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo
FROM actor a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film f ON f.film_id = fa.film_id
    JOIN film_category fc ON fc.film_id = f.film_id
    JOIN category c ON c.category_id = fc.category_id
    WHERE fa.actor_id = a.actor_id
      AND c.name ILIKE 'Music'
)
ORDER BY a.last_name, a.first_name;


/* 57  Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.*/
SELECT DISTINCT
	f.title,
	EXTRACT(DAY FROM (r.return_date - r.rental_date)) AS  n_dias
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id 
JOIN film f ON f.film_id = i.film_id
WHERE EXTRACT(DAY FROM (r.return_date - r.rental_date)) > 8 AND r.return_date IS NOT NULL;


/* 58 Encuentra el título de todas las películas que son de la misma categoría 
que ‘Animationʼ*/
SELECT
	f.title,
	c.name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.name ILIKE 'Animation';


/* 59 Encuentra los nombres de las películas que tienen la misma duración 
que la película con el título ‘Dancing Feverʼ. Ordena los resultados 
alfabéticamente por título de película. */
WITH duracion_peli AS (
	SELECT title, length AS "d_peli"
	FROM film
	WHERE title ILIKE 'Dancing Fever'
)
SELECT
	f.title, 
	f.length
FROM film f
JOIN duracion_peli dp ON f.length = dp.d_peli
WHERE f.title NOT ILIKE 'dancing fever'
ORDER BY f.title ASC;

/* 60 Encuentra los nombres de los clientes que han alquilado al menos 7 
 películas distintas. Ordena los resultados alfabéticamente por apellido.*/
SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS "Nombre Completo",
	COUNT(DISTINCT f.film_id) AS "Numero pelicula distintas"
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name  
HAVING COUNT(DISTINCT f.film_id) >= 7
ORDER BY c.last_name;

/* 61  Encuentra la cantidad total de películas alquiladas por categoría y 
muestra el nombre de la categoría junto con el recuento de alquileres. */
SELECT
    c.name AS categoria,
    COUNT(r.rental_id) AS numero_alquileres
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f  ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
ORDER BY numero_alquileres DESC;


/* 62 Encuentra el número de películas por categoría estrenadas en 2006. */
SELECT
	c.name,
	COUNT(f.film_id) AS "Numero"
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE release_year = 2006
GROUP BY c.category_id, c.name;


/* 63 Obtén todas las combinaciones posibles de trabajadores con las tiendas 
que tenemos. */

SELECT
	s.store_id,
	st.staff_id 
FROM staff st 
CROSS JOIN store s;

/* 64 Encuentra la cantidad total de películas alquiladas por cada cliente y 
muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
películas alquiladas. */
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS num_peliculas
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;





