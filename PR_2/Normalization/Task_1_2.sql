--2
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    price NUMERIC(10,2)
);

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL REFERENCES products(id),
    quantity INT DEFAULT 1,
    PRIMARY KEY (order_id, product_id)
);
