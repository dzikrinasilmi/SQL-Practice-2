-- create database
CREATE DATABASE techcomp;

-- create tables
create table products (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

create table Customers (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(200)
);

create table orders (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

create table orderdetalis (
	order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

create table employees (
	employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    department VARCHAR(50)
);

create table SupportTickets (
	ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    issue TEXT,
    status VARCHAR(20),
    created_at DATETIME,
    resolved_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- data input 
-- look at the data input file

-- 1. top 3 customers based on order
select
c.first_name,
c.last_name,
sum(o.total_amount) as total_order_amount
from Customers as c
join orders as o ON o.customer_id = c.customer_id
group by c.customer_id
order by total_order_amount desc
LIMIT 3;

-- 2. average order value for each customer
select
c.first_name,
c.last_name,
avg(total_amount) as average_order
from Customers as c
join orders as o ON c.customer_id = o.customer_id
group by c.customer_id
order by average_order desc;

-- 3. find all employees who have completed more than 4 support tickets
select
e.first_name,
e.last_name,
count(s.ticket_id) as total_amount_of_ticket_id
from employees as e
join SupportTickets as s ON e.employee_id = s.employee_id
where s.status = 'resolved'
group by e.employee_id
having total_amount_of_ticket_id>4;

-- 4. products have never been ordered
select
p.product_name
from products as p
left join orderdetalis as od ON od.product_id = p.product_id
where od.order_id is null;

-- 5. count total revenue
select
sum(quantity * unit_price) as total_revenue
from orderdetalis;

-- 6. find the average price of products for each category > 500
with cte_avg_price as (
select category,
	product_name,
	avg(price) as average_price
from products
group by category, product_name
)
select * from cte_avg_price
where average_price > 500
order by average_price desc;

-- 7. customers with order more than 1000
select * from customers
where customer_id in
(select customer_id
from orders
where total_amount > 1000);