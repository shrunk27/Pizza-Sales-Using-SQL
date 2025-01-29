# 🍕 Pizza Sales Analysis using SQL  

## 📌 Project Overview  
This project analyzes pizza sales data using SQL, providing insights into customer orders, popular pizza types, and overall business performance. The structured database allows for efficient querying and data analysis, making it useful for understanding sales trends and optimizing business strategies.  

## 🗃️ Database Schema  
The database consists of the following tables:  

- **orders**: Contains information about customer orders, including order ID, date, and time.  
- **order_details**: Stores details of each order, including the pizzas ordered and their quantities.  
- **pizza_types**: Lists different pizza types along with their ingredients and category.  
- **pizzas**: Contains information on pizza sizes and prices.  

## 🛠️ Technologies Used  
- SQL (Structured Query Language)  
- MySQL

## 🔍 Key Features  
- Querying sales trends by date and time  
- Identifying best-selling pizzas  
- Analyzing revenue generation by pizza type and size  
- Understanding customer ordering patterns  

## 📂 Project Files  
- `Queery.sql`: Contains SQL queries for analyzing pizza sales data.  

## 🚀 How to Use  
1. Import the database into your preferred SQL environment.  
2. Run the provided SQL queries to extract insights.  
3. Modify or extend the queries to perform custom analysis.  

## 📊 Sample Queries  
```sql
-- Retrieve total sales per pizza type
SELECT pt.name, SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_sold DESC;

-- Calculate total revenue
SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;
```

## 💡 Future Enhancements  
- Visualizing sales trends using Python and Power BI  
- Integrating customer demographics for deeper insights  
- Implementing machine learning models for sales prediction  

## 📢 Contributing  
Feel free to fork this repository and suggest improvements!  

## 📜 License  
This project is open-source under the MIT License.  

