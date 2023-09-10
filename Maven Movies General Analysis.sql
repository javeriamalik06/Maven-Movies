#Using Group By
SELECT
	rating,
    COUNT(film_id)
FROM film
GROUP BY rating;

#Comments and Aliases

SELECT rating,
	COUNT(film_id) AS count_of_films_with_this_rating
FROM film
GROUP BY rating;

#ASSIGNMENT
SELECT
	rental_duration,
    COUNT(title) AS films_with_this_rental_duration
FROM film
GROUP BY rental_duration
ORDER BY rental_duration; #i did this myself

#MULTIPLE GROUP BY
SELECT
	rental_duration,
    rating,
    COUNT(title) AS films_with_this_rental_duration
FROM film
GROUP BY 
	rental_duration,
    rating
ORDER BY rating, rental_duration; #added by me

#AGGREGATE FUNCTION
SELECT 
	rating, 
	COUNT(film_id) AS count_of_films,
    MIN(length) AS shortest_film,
    MAX(length) AS longest_film,
    AVG(length) AS average_length_of_film,
    AVG(rental_duration) AS avg_rental_duration
FROM film
GROUP BY rating;

#ASSIGNMENT
SELECT 
	replacement_cost,
    COUNT(film_id),
    AVG(rental_rate),
    MIN(rental_rate),
    MAX(rental_rate)
FROM film
GROUP BY replacement_cost
ORDER BY replacement_cost DESC; #done by me

#HAVING 
SELECT
	customer_id,
    COUNT(*) AS total_rental
FROM rental
GROUP BY 
		customer_id
HAVING COUNT(*) >= 30;

#ASSIGNMENT
SELECT	
    customer_id,
    COUNT(rental_id) AS total_rentals
FROM rental
GROUP BY 
		customer_id
HAVING COUNT(*) < 15;

#ORDER BY
SELECT 
	customer_id,
    rental_id,
    amount,
    payment_date
FROM payment
ORDER BY amount DESC, customer_id;

#ASSIGNMENT
SELECT 
	title,
    length,
    rental_rate
FROM film
ORDER BY length DESC;

#CASE (it always excutes in the order)
SELECT DISTINCT length, 
	CASE 
		WHEN length < 60 THEN 'under 1 hr'
		WHEN length BETWEEN 60 and 90 THEN '1-1.5 hrs'
        WHEN length > 90 THEN 'over 1.5 hrs'
        ELSE 'uh oh... check logic'
	END AS length_bucket
FROM film;

#CASE WITH OPERATORS
SELECT DISTINCT title,
	CASE
		WHEN rental_duration <= 4 THEN 'rental_too_short'
        WHEN rental_rate >=3.99 THEN 'too_expensive'
        WHEN rating IN ('NC-17','R') THEN 'too_adult'
        WHEN length NOT BETWEEN 60 AND 90 THEN 'too_short_or_too_long'
        WHEN description LIKE '%Sharks%' THEN 'nope_has_sharks'
        ELSE 'lets_watch'
	END AS 'fit_for_recommendation'
FROM film;
    
#ASSIGNMENT
SELECT 
	first_name, 
    last_name,
	CASE
		WHEN store_id = 1 AND active = 1 THEN 'store 1 active'
        WHEN store_id = 1 AND active = 0 THEN 'store 1 inactive'
        WHEN store_id = 2 AND active = 1 THEN 'store 2 active'
        WHEN store_id=2 AND active = 0 THEN 'store 1 inactive'
        ELSE 'oops...check logic'
	END AS 'store_activity'
FROM customer;

#PIVOTING DATA WITH COUNT AND CASE
SELECT film_id,
	COUNT(CASE WHEN store_id=1 THEN inventory_id ELSE NULL END) AS count_store_1,
    COUNT(CASE WHEN store_id=2 THEN inventory_id ELSE NULL END) AS count_store_1,
    COUNT(inventory_id) AS total_copies
FROM inventory
GROUP BY film_id
ORDER BY film_id;

#ASSIGNMENT 
SELECT store_id,
	COUNT(CASE WHEN active=0 THEN customer_id ELSE NULL END) AS inactive_customers,
    COUNT(CASE WHEN active=1 THEN customer_id ELSE NULL END) AS active_customers
FROM customer
GROUP BY store_id;


###FROM MID TILL FINAL###

#INNER JOIN
#ASSIGNMENT
SELECT 
    inventory.inventory_id,
    inventory.store_id,
	film.title,
    film.description
FROM film
	INNER JOIN inventory
		ON inventory.film_id = film.film_id;

#LEFT JOIN
SELECT
	actor.first_name,
    actor.last_name,
    COUNT(film_actor.film_id) AS number_of_films
FROM actor
	LEFT JOIN film_actor
		ON actor.actor_id=film_actor.actor_id
GROUP BY 
	actor.first_name,
    actor.last_name;

#ASSIGNMENT
SELECT 
	film.title,
    COUNT(film_actor.actor_id) AS number_of_actors
FROM 
	film
    LEFT JOIN film_actor
		ON film.film_id = film_actor.film_id
GROUP BY film.title
ORDER BY number_of_actors DESC; #notice how the last 3 movies are still there despite no actor

#BRIDGING UNRELATED TABLES
#Connecting film to category when they do not have any matching key but can be related through film_category
SELECT 
	film.film_id,
    film.title,
    category.name AS category_name
FROM film 
	INNER JOIN film_category
		ON film.film_id=film_category.film_id
	INNER JOIN category
		ON film_category.category_id=category.category_id;

#ASSIGNMENT
SELECT 
	actor.first_name AS actor_first_name,
    actor.last_name AS actor_last_name,
    film.title AS film_title
FROM actor
	INNER JOIN film_actor
		ON actor.actor_id=film_actor.actor_id
	INNER JOIN film
		ON film_actor.film_id=film.film_id;
    
#MULTICONDITION JOINS
SELECT 
	film.film_id,
	film.title,
    film.rating,
    category.name
FROM film
	INNER JOIN film_category
		ON film.film_id=film_category.film_id
	INNER JOIN category
		ON film_category.category_id=category.category_id
        AND category.name='horror'
	ORDER BY film_id;
#THE ABOVE IS THE SAME AS;
SELECT 
	film.film_id,
	film.title,
    film.rating,
    category.name
FROM film
	INNER JOIN film_category
		ON film.film_id=film_category.film_id
	INNER JOIN category
		ON film_category.category_id=category.category_id
WHERE category.name='horror'
ORDER BY film_id;

#ASSIGNMENT
SELECT DISTINCT
	film.title,
    film.description
FROM film
	INNER JOIN inventory
		ON film.film_id=inventory.film_id
        AND inventory.store_id = 2;

#UNION
SELECT 
	'advisor' AS type,
    first_name,
    last_name
FROM advisor
UNION
SELECT
	'investor' AS type,
    first_name,
    last_name
FROM investor;

#ASSIGNMENT
SELECT 
	'staff' AS member_type,
    first_name,
    last_name
FROM staff
UNION
SELECT 
	'advisor' AS member_type,
    first_name,
    last_name
FROM advisor;
