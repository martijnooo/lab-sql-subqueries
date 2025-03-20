# Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
use sakila;

SELECT count(*) from inventory
WHERE film_id IN 
	(SELECT film_id 
    FROM film
	WHERE title = "Hunchback Impossible");

# List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title 
FROM film
WHERE length > 
	(SELECT avg(length)
    FROM film);
# Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT * 
FROM actor
WHERE actor_id IN 
    (SELECT actor_id
     FROM film_actor
     WHERE film_id = 
        (SELECT film_id
         FROM film
         WHERE title = "Alone Trip"));

#Bonus:

/*Sales have been lagging among young families, and you want to target family movies for a promotion. 
Identify all movies categorized as family films. */
SELECT * 
FROM film
WHERE film_id IN
    (SELECT film_id
    FROM film_category
    WHERE category_ID IN
		(SELECT category_id FROM category
		WHERE name = "Family"));
/*
Retrieve the name and email of customers from Canada using both subqueries and joins. 
To use joins, you will need to identify the relevant tables and their primary and foreign keys. */
SELECT first_name, last_name, email, concat(first_name," ", last_name) as full_name FROM customer
LEFT JOIN address
ON customer.address_id = address.address_id
LEFT JOIN city
ON address.city_id = city.city_id 
JOIN country 
ON country.country_id = city.country_id AND country.country_id =
(select country.country_id from country
WHERE country.country = "Canada");

/*
Determine which films were starred by the most prolific actor in the Sakila database. 
A prolific actor is defined as the actor who has acted in the most number of films. */     
SELECT * 
FROM film
WHERE film_id IN (
    SELECT film_id 
    FROM film_actor
    WHERE actor_id = (
        SELECT actor_id 
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1
    )
);

/*
Find the films rented by the most profitable customer in the Sakila database. 
You can use the customer and payment tables to find the most profitable customer, 
i.e., the customer who has made the largest sum of payments. */
SELECT *
FROM film
WHERE film_id IN
	(SELECT film_id
    FROM inventory
    WHERE inventory_id IN
		(SELECT inventory_id 
        FROM rental
        WHERE customer_id =
			(select customer_id from payment
			GROUP BY customer_id
			ORDER BY sum(amount) DESC
			LIMIT 1)));

/*
Retrieve the client_id and the total_amount_spent of those clients who spent more than 
the average of the total_amount spent by each client. You can use subqueries to accomplish this. */
SELECT customer_id, sum(amount) as total_spending
	from payment
	GROUP BY customer_id
    HAVING sum(amount) > (
		select avg(total_spending) 
		from 
			(SELECT customer_id, sum(amount) as total_spending
			from payment
			GROUP BY customer_id) 
			AS grouped_data);