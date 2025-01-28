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
