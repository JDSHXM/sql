--3
CREATE TABLE regions (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    region_id INT NOT NULL REFERENCES regions(id)
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    city_id INT NOT NULL REFERENCES cities(id)
);