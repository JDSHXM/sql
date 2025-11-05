--Таблицы для ДЗ

CREATE TABLE departments (
 id     SERIAL PRIMARY KEY,
 name   VARCHAR(50) NOT NULL,
 location VARCHAR(50)
);

CREATE TABLE employees (
 id           SERIAL PRIMARY KEY,
 name         VARCHAR(50) NOT NULL,
 position     VARCHAR(50),
 salary       NUMERIC(10,2),
 department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
 manager_id   INTEGER REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE customers (
 id   SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 city VARCHAR(50)
);

CREATE TABLE orders (
 id          SERIAL PRIMARY KEY,
 order_date  DATE NOT NULL,
 amount      NUMERIC(10,2),
 employee_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
 customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL
);

CREATE TABLE products (
 id    SERIAL PRIMARY KEY,
 name  VARCHAR(100) NOT NULL,
 price NUMERIC(10,2)
);

CREATE TABLE order_items (
 id         SERIAL PRIMARY KEY,
 order_id   INTEGER REFERENCES orders(id) ON DELETE CASCADE,
 product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
 quantity   INTEGER NOT NULL
);

--1 Вывести employee.id, employee.name, department.name — сотрудники без отдела должны показать No Department.
SELECT 
    e.id AS employee_id,    e.name AS employee_name,
    COALESCE(d.name, 'No Department') AS department_name
FROM employees e LEFT JOIN departments d ON e.department_id = d.id;

--2 Сотрудники, у которых есть менеджер (показать имя сотрудника и имя менеджера).
SELECT 
    e.name AS employee_name,    m.name AS manager_name
FROM employees e JOIN employees m ON e.manager_id = m.id;

--3 Отделы без сотрудников.
SELECT 
    d.id,	d.name
FROM departments d LEFT JOIN employees e ON e.department_id = d.idWHERE e.id IS NULL;

--4 Все заказы с именем сотрудника и именем клиента — если employee или customer отсутствует, показывать No Employee / No Customer.
SELECT 
    o.id AS order_id,
    COALESCE(e.name, 'No Employee') AS employee_name,
    COALESCE(c.name, 'No Customer') AS customer_name,
    o.amount
FROM orders o
LEFT JOIN employees e ON o.employee_id = e.id
LEFT JOIN customers c ON o.customer_id = c.id;

--5 Список заказов с товарами: для каждого заказа вывести order_id, product_name, quantity. Показать также заказы без позиций.
SELECT 
    o.id AS order_id,     p.name AS product_name,     oi.quantity
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id;

--6 Для каждого отдела — все заказы (через сотрудников этого отдела); включать отделы с нулём заказов.
SELECT 
    d.name AS department_name,     o.id AS order_id
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
LEFT JOIN orders o ON o.employee_id = e.id;

--7 Найти пары клиентов и продуктов, которые этот клиент никогда не покупал (т.е. построить Cartesian клиент×продукт и исключить реальные покупки).
SELECT 
    c.id AS customer_id,     c.name AS customer_name,     p.id AS product_id,     p.name AS product_name
FROM customers c CROSS JOIN products p
WHERE NOT EXISTS (
    SELECT 1     FROM orders o     JOIN order_items oi ON o.id = oi.order_id
    WHERE o.customer_id = c.id AND oi.product_id = p.id
);

--8 Показать, какие продукты никогда не продавались.
SELECT 
    p.id,     p.name
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE oi.id IS NULL;

--9 Для каждого менеджера — показать суммарную сумму заказов, оформленных его подчинёнными.
SELECT 
    m.name AS manager_name,     SUM(o.amount) AS total_sales
FROM employees m
JOIN employees e ON e.manager_id = m.id
JOIN orders o ON o.employee_id = e.id
GROUP BY m.name;

--10 Общее количество заказов и суммарная выручка (amount).
SELECT 
    COUNT(*) AS total_orders,     SUM(amount) AS total_revenue
FROM orders;

--11 Средняя и максимальная зарплата по отделам.
SELECT 
    d.name AS department_name,     AVG(e.salary) AS avg_salary,     MAX(e.salary) AS max_salary
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
GROUP BY d.name;

--12 Для каждого заказа — общее количество товаров (sum quantity) и уникальных позиций (count distinct product_id).
SELECT 
    o.id AS order_id,     SUM(oi.quantity) AS total_quantity,
    COUNT(DISTINCT oi.product_id) AS unique_products
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;

--13 Топ-3 продукта по суммарной выручке (price*quantity).
SELECT 
    p.name AS product_name,     SUM(p.price * oi.quantity) AS total_revenue
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.name ORDER BY total_revenue DESC
LIMIT 3;

--14 Количество клиентов, у которых есть хотя бы один заказ.
SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
FROM orders WHERE customer_id IS NOT NULL;

--15 Для каждого отдела — количество сотрудников, средняя зарплата, суммарная сумма заказов (через сотрудников этого отдела).
SELECT 
    d.name AS department_name,     COUNT(e.id) AS employees_count,     AVG(e.salary) AS avg_salary,     SUM(o.amount) AS total_sales
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
LEFT JOIN orders o ON o.employee_id = e.id
GROUP BY d.name;

--16 Найти клиентов, чья средняя сумма заказа выше средней по всем заказам.
SELECT 
    c.name AS customer_name,
    AVG(o.amount) AS avg_order
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.name
HAVING AVG(o.amount) > (SELECT AVG(amount) FROM orders);

--17 Сформировать полное имя сотрудника
SELECT CONCAT(name, ' ', surname) AS full_name
FROM employees;

--18 Вывести дату заказа в формате DD.MM.YYYY HH24:MI.
SELECT 
    TO_CHAR(order_date, 'DD.MM.YYYY HH24:MI') AS formatted_date
FROM orders;

--19 Найти заказы старше N дней (параметр) 
SELECT * FROM orders
WHERE order_date < CURRENT_DATE - INTERVAL '30 days';

--20 Для таблицы employees: заменить NULL в salary на 0 в вычислениях и вывести salary + bonus (bonus = 10% для определённой позиции).
SELECT 
    name,     COALESCE(salary, 0) +  
	CASE 
        WHEN position = 'Manager' THEN COALESCE(salary, 0) * 0.10
        ELSE 0 
    END AS total_with_bonus
FROM employees;

