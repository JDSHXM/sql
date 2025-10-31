CREATE TABLE students (
      student_id SERIAL PRIMARY KEY,
      first_name VARCHAR(50) NOT NULL,
      last_name VARCHAR(50) NOT NULL,
      birth_date DATE NOT NULL,
      email VARCHAR(100) UNIQUE,
      group_id INT NOT NULL
);

--Задание
--Напишите INSERT для заполнения таблицы
INSERT INTO students (first_name, last_name, birth_date, email, group_id) VALUES
('Ali', 'Karimov', '2002-05-10', 'ali.karimov1@mail.com', 101),
('Ali', 'Karimov', '2002-05-10', 'ali.karimov2@mail.com', 101),
('Dilnoza', 'Xasanova', '2001-09-20', 'dilnoza@mail.com', 102),
('Javlon', 'Tursunov', '2003-03-11', 'javlon@mail.com', 103),
('Dilnoza', 'Xasanova', '2001-09-20', 'dilnoza2@mail.com', 102),
('Sardor', 'Abdullaev', '2000-12-05', 'sardor@mail.com', 104);
SELECT * FROM students;

--Найти дубликаты по имени и фамилии студента
SELECT first_name, last_name, COUNT(*) AS duplicates FROM students GROUP BY first_name, last_name HAVING COUNT(*) > 1;

--Удалить дубликаты, оставить только первую запись
DELETE FROM students WHERE student_id NOT IN (SELECT MIN(student_id) FROM students GROUP BY first_name, last_name);
SELECT * FROM students;