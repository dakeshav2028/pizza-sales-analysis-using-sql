
-- INTERMEDIATE QUESTIONS
-- q1.Join the necessary tables to find the total quantity of each pizza category ordered.
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