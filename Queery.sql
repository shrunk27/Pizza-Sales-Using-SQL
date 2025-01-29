-- Basic:

-- Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;

-- Calculate the total revenue generated from pizza sales.
select 
sum(orders_details.quantity * pizzas.price) as total_revenue
from orders_details join pizzas
on orders_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.
select max(price) from pizzas;

-- Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(orders_details.order_details_id) AS total_orders
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY total_orders DESC
limit 1;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name,
    sum(orders_details.quantity) AS order_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.name
ORDER BY order_quantity DESC
LIMIT 5;


-- Intermediate:

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(orders_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(orders.order_time),
    COUNT(orders.order_id) AS order_count
FROM
    orders
GROUP BY HOUR(orders.order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    AVG(avg_pizza_order)
FROM
    (SELECT 
        DATE(orders.order_date),
            SUM(orders_details.quantity) AS avg_pizza_order
    FROM
        orders
    JOIN orders_details ON orders.order_id = orders_details.order_id
    GROUP BY DATE(orders.order_date)) AS order_quatity;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM(pizzas.price * orders_details.quantity) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- Advanced:

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    (SUM(pizzas.price * orders_details.quantity) / (SELECT 
            SUM(orders_details.quantity * pizzas.price) AS Total_scales
        FROM
            orders_details
                JOIN
            pizzas ON pizzas.pizza_id = orders_details.pizza_id)) * 100 as revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

-- Analyze the cumulative revenue generated over time.

select order_date ,
round(sum(revenue) over (order by order_date),2 )as Cum_revenue
from
(select orders.order_date,
sum(orders_details.quantity * pizzas.price) as revenue
from orders_details join pizzas
on orders_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = orders_details.order_id 
group by orders.order_date) as total_sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name, revenue from 
(select category, name, revenue,
rank() over (partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name ) as a ) as b
where rn<=3