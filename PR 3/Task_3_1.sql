CREATE TABLE sales (
   id SERIAL PRIMARY KEY,
   region VARCHAR(20),
   amount BIGINT,
   sale_date DATE
);

INSERT INTO sales (region, amount, sale_date) VALUES
('North', 1000, '2024-01-01'),
('South', 700, '2024-01-02'),
('North', 500, '2024-01-03'),
('West', NULL, '2024-01-04'),
('South', 900, '2024-01-05'),
('North', 1500, '2024-01-06');

--Задание
--Найди сумму продаж по каждому региону.
SELECT region, SUM(amount) FROM sales GROUP BY region;

--Покажи среднюю сумму продаж по регионам, где больше одной продажи.
SELECT region, AVG(amount) FROM sales GROUP BY region HAVING COUNT(*) > 1;

--Найди регион с максимальной суммой продаж.
SELECT region, SUM(amount) FROM sales GROUP BY region ORDER BY SUM(amount) DESC LIMIT 1;

--Выведи общее количество продаж и сколько из них имеют ненулевую сумму.
SELECT COUNT(*) AS jami, COUNT(amount) AS nol_bolmagan FROM sales;

--Покажи регионы, где продажи превышают среднюю по всем регионам.
SELECT region, SUM(amount) FROM sales GROUP BY region HAVING SUM(amount) > (SELECT AVG(amount) FROM sales);