-- 1
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    amount NUMERIC(10,2),
    order_date DATE,
    customer_id INT REFERENCES customers(id)
);