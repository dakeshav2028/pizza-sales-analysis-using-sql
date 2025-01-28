# pizza-sales-analysis-using-sql

# questions
#### Basic:
#### q1.Retrieve the total number of orders placed.
###### SELECT COUNT(order_id) AS total_orders
###### FROM orders;
#### output:
![Image](https://github.com/user-attachments/assets/97682fe5-f638-4e1d-81c3-befac6f3f5a5)

#### q2.Calculate the total revenue generated from pizza sales.
###### SELECT ROUND(SUM(order_details.quantity * pizza.price),2) AS total_revenue
###### FROM order_details JOIN pizza 
###### ON pizza.pizza_id = order_details.pizza_id;
#### output:
![Image](https://github.com/user-attachments/assets/ecb1eb7d-e418-437e-a0dd-f2ec67edcb30)

#### q3.Identify the highest-priced pizza.
###### SELECT pizza_type.pizza_name, pizza.price
###### FROM pizza_type JOIN pizza ON pizza_type.pizza_type_id = pizza.pizza_type
###### ORDER BY pizza.price DESC LIMIT 1;
#### output:
![Image](https://github.com/user-attachments/assets/1e92df0b-393a-43fa-a53e-bdc142b8ca90)

#### q4.Identify the most common pizza size ordered.
###### SELECT pizza.size, COUNT(order_details.order_details_id) AS order_count
###### FROM pizza JOIN order_details ON pizza.pizza_id = order_details.pizza_id
###### GROUP BY pizza.size
###### ORDER BY order_count DESC LIMIT 1;
#### output:
![Image](https://github.com/user-attachments/assets/325b658a-b3e3-4e2e-be40-e843e20778ed)

#### q5.List the top 5 most ordered pizza types along with their quantities.
###### SELECT pizza_type.pizza_name, SUM(order_details.quantity) AS quantity
###### FROM pizza_type JOIN pizza ON pizza_type.pizza_type_id = pizza.pizza_type
###### JOIN order_details ON order_details.pizza_id = pizza.pizza_id
###### GROUP BY pizza_type.pizza_name
###### ORDER BY quantity DESC LIMIT 5;
#### output:
![Image](https://github.com/user-attachments/assets/17852e48-6d43-422c-8be8-34dc2fc9224b)


#### INTERMEDIATE QUESTIONS
#### q1.Join the necessary tables to find the total quantity of each pizza category ordered.
###### SELECT pizza_type.category, SUM(order_details.quantity) AS quantity
###### FROM pizza_type JOIN pizza ON pizza_type.pizza_type_id = pizza.pizza_type
######  JOIN order_details ON order_details.pizza_id = pizza.pizza_id
###### GROUP BY pizza_type.category
###### ORDER BY quantity DESC;

##### output:
![Image](https://github.com/user-attachments/assets/c2010c2f-1851-46db-9e57-c5e03db07de8)
#### Q2. Determine the distribution of orders by hour of the day.
###### SELECT HOUR(order_time) AS hour, COUNT(order_id) AS order_count
###### FROM orders
###### GROUP BY HOUR(order_time);
#### output:
![Image](https://github.com/user-attachments/assets/ddc4c26c-90f1-48bb-81bb-cd7cd24e01a2)

#### Q3. Join relevant tables to find the category-wise distribution of pizzas.
###### SELECT category, COUNT(pizza_name) AS name_count
###### FROM pizza_type
###### GROUP BY category;
#### output:
![Image](https://github.com/user-attachments/assets/b1dd4673-7f28-439c-9c6b-12b33946fdc8)

#### Q4.Group the orders by date and calculate the average number of pizzas ordered per day.
###### SELECT ROUND(AVG(order_details.quantity), 4) AS avg_num_of_pizza_ordered_perday,orders.order_date
###### FROM order_details JOIN orders ON order_details.order_details_id = orders.order_id
###### GROUP BY order_date;
#### output:
![Image](https://github.com/user-attachments/assets/37d1e2f1-5547-4fe4-b671-dfd69ecc1d5e)

#### Q5. Determine the top 3 most ordered pizza types based on revenue.
###### SELECT ROUND(SUM(pizza.price * order_details.quantity),2) AS revenue,pizza.pizza_type AS pizza_type
###### FROM pizza JOIN pizza_type ON pizza_type.pizza_type_id = pizza.pizza_type
###### JOIN order_details ON order_details.pizza_id = pizza.pizza_id
###### GROUP BY pizza.pizza_type
###### ORDER BY revenue DESC LIMIT 3;
#### output:
![Image](https://github.com/user-attachments/assets/5c19d432-b19c-49c1-b6a2-a4cd649280f9)

### Advanced:
#### q1. Calculate the percentage contribution of each pizza type to total revenue.
###### SELECT pizza_type.category AS pizza_type,
###### (ROUND(SUM(pizza.price * order_details.quantity),2) / (SELECT ROUND(SUM(order_details.quantity * pizza.price),2) AS total_revenue
###### FROM order_details JOIN pizza ON pizza.pizza_id = order_details.pizza_id)) * 100 AS revenue
###### FROM pizza_type JOIN pizza ON pizza_type.pizza_type_id = pizza.pizza_type
###### JOIN order_details ON order_details.pizza_id = pizza.pizza_id
###### GROUP BY pizza_type.category
###### ORDER BY revenue DESC;
#### output:
![Image](https://github.com/user-attachments/assets/a6aca993-c749-4fdd-9c68-76b4e2893b0d)

#### q2. Analyze the cumulative revenue generated over time.
###### select order_date, round(sum(revenue) over (order by order_date),2)as cum_revenue
###### from 
###### (select orders.order_date,round(sum(order_details.quantity * pizza.price),2) as revenue
###### from order_details join pizza on order_details.pizza_id = pizza.pizza_id
###### join orders on orders.order_id = order_details.order_details_id group by orders.order_date) as sales;
#### output:
![Image](https://github.com/user-attachments/assets/b35a4358-1727-4b9d-a408-c9b0ed9fb82a)

#### q3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
###### select pizza_name, revenue
###### from
###### (select category,pizza_name,revenue,
###### rank()over(partition by category order by revenue desc) as rn
###### from
###### (SELECT  pizza_type.category,pizza_type.pizza_name,ROUND(SUM(pizza.price * order_details.quantity),2) as revenue
###### FROM pizza_type JOIN pizza ON pizza_type.pizza_type_id = pizza.pizza_type
###### JOIN order_details ON order_details.pizza_id = pizza.pizza_id
###### GROUP BY pizza_type.category,pizza_type.pizza_name)as a) as b
###### where rn<=3;
##### output:
![Image](https://github.com/user-attachments/assets/5f0a73b6-edb1-4f75-bcc2-3d7c3eb58db7)
