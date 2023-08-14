use sakila;

-- 1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
select count(film_id) as copies
from inventory
Where inventory.film_id IN (
	select film.film_id 
    from film
Where title = 'Hunchback Impossible');

-- 2 List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT 
    title, length, avg(length) as avg_length
FROM
    film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            film);

-- 3 Use a subquery to display all actors who appear in the film "Alone Trip".
select first_name , last_name 
from actor
Where actor.actor_id IN (
	select actor_id 
    from film_actor
    where film_id IN (
	 select film_id
     from film
Where title = "Alone Trip" ))
;

-- 4 Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
select title from film
Where film.film_id IN (
	select film_id 
    from film_category
    where category_id IN (
	 select category_id
     from category
Where name = "family"))
;
-- 5 Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT first_name, last_name, email
FROM customer
JOIN address
USING (address_id)
JOIN city
USING (city_id)
JOIN country 
USING (country_id)
WHERE country = "Canada";

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id IN (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- 6 Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT title
FROM film
WHERE film_id in (
SELECT film_id
FROM film_actor
WHERE actor_id = (SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY count(film_id) DESC
LIMIT 1));
-- 7 Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT first_name, last_name
FROM customer
WHERE customer_id = (SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1);

SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1;

-- 8  Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id, SUM(amount) total_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT avg(sum) FROM(
SELECT sum(amount) AS sum
FROM payment
GROUP BY customer_id) sub1)
ORDER BY total_spent DESC;