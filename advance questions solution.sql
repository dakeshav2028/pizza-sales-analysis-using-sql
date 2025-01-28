-- Advanced:
-- q1. Calculate the percentage contribution of each pizza type to total revenue.

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

