CREATE TABLE students (
   student_id INT PRIMARY KEY,
   full_name VARCHAR(100),
   age INT,
   group_id INT
);

CREATE TABLE groups (
   group_id INT PRIMARY KEY,
   group_name VARCHAR(50)
);

CREATE TABLE subjects (
   subject_id INT PRIMARY KEY,
   subject_name VARCHAR(50)
);

CREATE TABLE grades (
   grade_id INT PRIMARY KEY,
   student_id INT,
   subject_id INT,
   grade INT,
   FOREIGN KEY (student_id) REFERENCES students(student_id),
   FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

--Задание
--Напишите INSERT для заполнения таблиц
INSERT INTO groups (group_id, group_name) VALUES
(1, 'Java Developers'),
(2, 'Python Developers'),
(3, 'Web Designers');

INSERT INTO students (student_id, full_name, age, group_id) VALUES
(1, 'Dilmurod Jumanazarov', 20, 1),
(2, 'Oybek Xasanova', 21, 1),
(3, 'Sardor Abdullaev', 22, 2),
(4, 'Dilnura Dilmurodov', 20, 2),
(5, 'Javlon Shonazaorv', 19, 3);
SELECT * from students;

INSERT INTO subjects (subject_id, subject_name) VALUES
(1, 'Algorithmics'),
(2, 'Mathematics'),
(3, 'Mobile_programming');
SELECT * FROM subjects;

INSERT INTO grades (grade_id, student_id, subject_id, grade) VALUES
(1, 1, 1, 9),
(2, 1, 2, 8),
(3, 2, 1, 10),
(4, 2, 2, 9),
(5, 3, 1, 7),
(6, 3, 2, 8),
(7, 4, 2, 9),
(8, 4, 3, 10),
(9, 5, 3, 9);
SELECT * FROM grades;

--Подсчитайте количество студентов в университете.
SELECT COUNT(*) AS student_count FROM students;

--Найдите средний возраст студентов.
SELECT AVG(age) AS avg_age FROM students;

--Определите минимальный и максимальный возраст студентов.
SELECT MIN(age) AS min_age, MAX(age) AS max_age FROM students;

--Подсчитайте, сколько всего оценок выставлено.
SELECT COUNT(*) AS total_grades FROM grades;

--Подсчитайте, сколько студентов учится в каждой группе.
SELECT g.group_name, COUNT(s.student_id) AS student_count
FROM groups g JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_name;

--Найдите средний возраст студентов по каждой группе.
SELECT g.group_name, AVG(s.age) AS avg_age
FROM groups g JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_name;

--Определите средний балл по каждому предмету.
SELECT sub.subject_name, AVG(gd.grade) AS avg_grade
FROM subjects sub JOIN grades gd ON sub.subject_id = gd.subject_id
GROUP BY sub.subject_name;

--Найдите количество студентов, у которых есть оценки по каждому предмету.
SELECT sub.subject_name, COUNT(DISTINCT gd.student_id) AS students_with_grade
FROM subjects sub JOIN grades gd ON sub.subject_id = gd.subject_id
GROUP BY sub.subject_name;

--Выведите только те группы, где учится больше 1 студента.
SELECT g.group_name, COUNT(s.student_id) AS student_count
FROM groups g JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_name HAVING COUNT(s.student_id) > 1;

--Покажите предметы, где средний балл выше 8.
SELECT sub.subject_name, AVG(gd.grade) AS avg_grade
FROM subjects sub JOIN grades gd ON sub.subject_id = gd.subject_id
GROUP BY sub.subject_name HAVING AVG(gd.grade) > 8;

--Найдите студентов, у которых средний балл по всем предметам выше 8.5.
SELECT s.full_name, AVG(gd.grade) AS avg_grade
FROM students s JOIN grades gd ON s.student_id = gd.student_id
GROUP BY s.full_name HAVING AVG(gd.grade) > 8.5;

