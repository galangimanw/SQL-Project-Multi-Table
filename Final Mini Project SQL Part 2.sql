/*
Context
Our Business partner was recently approached by another local busines owner
who is interested in purchasing Maven Movies. He primarily owns restaurants and bars,
so he has lots of questions for you about our business and the rental business in general.
His offer seems very generous, so you are going to entertain his questions.

Objective
Leverage SQL skills to exteact and analyze data from various tables in the Maven Movies
database to answer the potential Acquirer's questions.
*/

-- Q1 Extracting data with left joins
select
	staff.first_name as manager_first_name,
    staff.last_name as manager_last_name,
    address.address,
    address.district,
    city.city,
    country.country
    
from store
	left join staff
		on staff.staff_id = store.manager_staff_id
	left join address
		on store.address_id = address.address_id
	left join city
		on address.city_id = city.city_id
	left join country
		on city.country_id = country.country_id;

-- Q2 Extracting inventory table by using joins function
select
	inventory.store_id,
    film.rating,
    count(inventory_id) as inventory_items
from inventory
	left join film
		on inventory.film_id = film.film_id
group by
	inventory.store_id,
    film.rating;

-- Q3 Extracting inventory table to get inventory items at each store
select
    inventory.store_id,
    film.rating,
    count(inventory_id) as inventory_items
from inventory
	left join film
		on inventory.film_id = film.film_id
group by
	inventory.store_id,
    film.rating;
    
-- Q4 Extracting inventory items to understand the diversit of inventory in terms of replacement cost
SELECT
    store.store_id,
    category.name AS film_genre,
    COUNT(film.film_id) AS film_count,
    AVG(film.replacement_cost) AS avg_cost,
    SUM(film.replacement_cost) AS sum_cost
FROM
    film
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
inner join inventory on film.film_id = inventory.film_id
inner join store on inventory.store_id = store.store_id

group by 
store.store_id,
category.name;

-- Q5 Extracting data from customer table to get a list off all customer names
select
	customer.first_name as customer_first_name,
    customer.last_name as customer_last_name,
    customer.active as status,
    store.store_id as store,
    address.address as street,
    city.city,
    country.country
from customer
left join address
	on customer.address_id = address.address_id
left join city
	on address.city_id = city.city_id
left join country
	on city.country_id = country.country_id
left join store
	on customer.store_id = store.store_id;
/*select
	customer.first_name as customer_first_name,
    customer.last_name as customer_last_name,
    customer.active as status,
    customer.store_id,
    address.address as street,
    city.city,
    country.country
from customer
left join address on customer.address_id = address.address_id
left join city on address.city_id = city.city_id
left join country on city.country_id = country.country_id */



-- Q6 Extracting customer data to get customer spending and valuable customer
select
	customer.first_name as "customer first name",
    customer.last_name as "customer last name",
    count(rental.rental_id),
    sum(payment.amount)
from customer
	left join payment
		on customer.customer_id = payment.customer_id
	left join rental
		on payment.rental_id = rental.rental_id
group by customer.first_name,
		customer.last_name
order by sum(payment.amount) desc;

-- Q7 Extracting data to get board of advisors and investors
select
	'advisor' as type,
    first_name,
    last_name,
    '-' as company_name
from advisor
union
select
	'investor' as type,
    first_name,
    last_name,
    company_name as company_name
from investor;

-- Q8 Extracting data to get the most awarded actors
select
	case
		when actor_award.awards = 'Emmy, Oscar, Tony' then '3 awards'
        when actor_award.awards in ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') then '2 awards'
        else '1 award'
	end as number_of_awards,
    avg(case when actor_award.actor_id is null then 0 else 1 end) as pct_w_one_film
    
    from actor_award
    
    group by
		case
			when actor_award.awards = 'Emmy, Oscar, Tony' then '3 awards'
            when actor_award.awards in ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') then '2 awards'
            else '1 award'
		end


