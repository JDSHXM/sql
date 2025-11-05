--SQL. Lesson 05
--DDL использовать из урока 4.
--Задания для практики подзапросов:

--1 Вывести сотрудников с зарплатой выше средней по компании
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--2 Вывести продукты дороже среднего
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

--3 Вывести отделы, где есть хотя бы один сотрудник с зарплатой > 10 000
SELECT * FROM departments
WHERE id IN (
    SELECT department_id 
    FROM employees 
    WHERE salary > 10000
);

--4 Вывести продукты, которые чаще всего встречаются в заказах
SELECT product_id, COUNT(*) AS order_count
FROM order_items GROUP BY product_id
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM order_items
        GROUP BY product_id
    ) AS t
);

--5 Вывести для каждого клиента количество его заказов
SELECT c.id, c.name, 
       (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.id) AS order_count
FROM customers c;

--6 Вывести топ 3 отдела по средней зарплате
SELECT d.id, d.name, AVG(e.salary) AS avg_salary
FROM departments d
JOIN employees e ON e.department_id = d.id
GROUP BY d.id, d.name ORDER BY avg_salary DESC
LIMIT 3;

--7 Вывести клиентов без заказов
SELECT * FROM customers
WHERE id NOT IN (SELECT customer_id FROM orders WHERE customer_id IS NOT NULL);

--8 Вывести сотрудников, зарабатывающих больше, чем любой из менеджеров.
SELECT * FROM employees
WHERE salary > ALL (
    SELECT salary 
    FROM employees 
    WHERE position = 'Manager'
);

--9 Вывести отделы, где все сотрудники зарабатывают выше 5000.
SELECT * FROM departments
WHERE id NOT IN (
    SELECT department_id
    FROM employees
    WHERE salary <= 5000
);
