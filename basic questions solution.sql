-- BASIC QUESTION

-- q1. Retrieve the total number of orders placed.

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

