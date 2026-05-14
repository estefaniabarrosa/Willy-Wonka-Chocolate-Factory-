CREATE DATABASE IF NOT EXISTS wonka_choc_factory;
USE wonka_choc_factory;

DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Factories;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Locations;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY
);

CREATE TABLE Locations (
    location_id INT PRIMARY KEY,
    country_region VARCHAR(100),
    region VARCHAR(100),
    state_province VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6)
);

CREATE TABLE Factories (
    factory_id INT PRIMARY KEY,
    factory_name VARCHAR(255)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    division VARCHAR(100),
    unit_cost DECIMAL(10,2),
    factory_id INT,

    FOREIGN KEY (factory_id)
    REFERENCES Factories(factory_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    location_id INT,
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(100),

    FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id),

    FOREIGN KEY (location_id)
    REFERENCES Locations(location_id)
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    sales DECIMAL(10,2),
    units INT,
    gross_profit DECIMAL(10,2),
    cost DECIMAL(10,2),

    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES Products(product_id)
);
