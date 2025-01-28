create database pizzahub;
use pizzahub;

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE pizza (
    pizza_id TEXT NOT NULL,
    pizza_type TEXT NOT NULL,
    size TEXT NOT NULL,
    price FLOAT NOT NULL
);

CREATE TABLE pizza_type (
    pizza_type_id TEXT NOT NULL,
    pizza_name TEXT NOT NULL,
    category TEXT NOT NULL,
    ingredients TEXT NOT NULL
);


-- BASIC QUESTION

SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;
-- q2.Calculate the total revenue generated from pizza sales
SELECT 
    ROUND(SUM(order_details.quantity * pizza.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizza ON pizza.pizza_id = order_details.pizza_id;

-- q3. Identify the highest-priced pizza.

SELECT 
    pizza_type.pizza_name, pizza.price
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type
ORDER BY pizza.price DESC
LIMIT 1;

-- q4. Identify the most common pizza size ordered.

SELECT 
    pizza.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizza
        JOIN
    order_details ON pizza.pizza_id = order_details.pizza_id
GROUP BY pizza.size
ORDER BY order_count DESC
LIMIT 1;

-- q5. List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_type.pizza_name,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type
        JOIN
    order_details ON order_details.pizza_id = pizza.pizza_id
GROUP BY pizza_type.pizza_name
ORDER BY quantity DESC
LIMIT 5;


-- INTERMEDIATE QUESTIONS

SELECT 
    pizza_type.category, SUM(order_details.quantity) AS quantity
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type
        JOIN
    order_details ON order_details.pizza_id = pizza.pizza_id
GROUP BY pizza_type.category
ORDER BY quantity DESC;

-- Q2. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);

-- Q3. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(pizza_name) AS name_count
FROM
    pizza_type
GROUP BY category;

-- Q4.Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(order_details.quantity), 4) AS avg_num_of_pizza_ordered_perday,
    orders.order_date
FROM
    order_details
        JOIN
    orders ON order_details.order_details_id = orders.order_id
GROUP BY order_date;

-- Q5. Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    ROUND(SUM(pizza.price * order_details.quantity),
            2) AS revenue,
    pizza.pizza_type AS pizza_type
FROM
    pizza
        JOIN
    pizza_type ON pizza_type.pizza_type_id = pizza.pizza_type
        JOIN
    order_details ON order_details.pizza_id = pizza.pizza_id
GROUP BY pizza.pizza_type
ORDER BY revenue DESC
LIMIT 3;

-- Advanced:

SELECT 
    pizza_type.category AS pizza_type,
    (ROUND(SUM(pizza.price * order_details.quantity),
            2) / (SELECT 
            ROUND(SUM(order_details.quantity * pizza.price),
                        2) AS total_revenue
        FROM
            order_details
                JOIN
            pizza ON pizza.pizza_id = order_details.pizza_id)) * 100 AS revenue
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type
        JOIN
    order_details ON order_details.pizza_id = pizza.pizza_id
GROUP BY pizza_type.category
ORDER BY revenue DESC;

-- q2. Analyze the cumulative revenue generated over time.

select order_date, round(sum(revenue) over (order by order_date),2)as cum_revenue
from 
(select orders.order_date,
round(sum(order_details.quantity * pizza.price),2) as revenue
from order_details join pizza
on order_details.pizza_id = pizza.pizza_id
join orders
on orders.order_id = order_details.order_details_id
group by orders.order_date) as sales;


-- q3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select pizza_name, revenue
from
(select category,pizza_name,revenue,
rank()over(partition by category order by revenue desc) as rn
from
(SELECT 
    pizza_type.category,pizza_type.pizza_name,
    ROUND(SUM(pizza.price * order_details.quantity),
            2) as revenue
FROM
    pizza_type
        JOIN
    pizza ON pizza_type.pizza_type_id = pizza.pizza_type
        JOIN
    order_details ON order_details.pizza_id = pizza.pizza_id
GROUP BY pizza_type.category,pizza_type.pizza_name)as a) as b
where rn<=3;

