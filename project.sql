-- Create a Database
CREATE DATABASE Restaurant;
USE Restaurant;

-- Table 1 (Orders)
CREATE TABLE ORDERS(
order_id INTEGER NOT NULL,
order_customer_id INTEGER NOT NULL,
order_employee_id INTEGER NOT NULL,
order_date DATE NOT NULL,
CONSTRAINT PK_order_id PRIMARY KEY(order_id)
);

-- Table 2 (Customer)
CREATE TABLE CUSTOMER(
customer_id INTEGER NOT NULL, 
first_name VARCHAR(55) NOT NULL,
last_name VARCHAR(55) NOT NULL,
phone_number VARCHAR(55) NOT NULL,
CONSTRAINT PK_customer PRIMARY KEY(customer_id)
);

-- Table 3 (Employee)
CREATE TABLE EMPLOYEE(
employee_id INTEGER NOT NULL,
employee_location_id INTEGER NOT NULL,
first_name VARCHAR(55) NOT NULL,
last_name VARCHAR(55) NOT NULL,
age INTEGER NOT NULL,
phone_number VARCHAR(55) NOT NULL,
CONSTRAINT PK_employee PRIMARY KEY(employee_id)
);  

-- Create a trigger (BEFORE INSERT - access new age)
SELECT * FROM EMPLOYEE;
DELIMITER //
CREATE TRIGGER age_verify
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
IF new.age < 0 then set new.age = 0;
END IF;//

-- Table 4 (Location)
CREATE TABLE LOCATION(
location_id INTEGER NOT NULL,
employee_location_id INTEGER NOT NULL,
city VARCHAR(55),
street VARCHAR(55) NOT NULL,
post_code VARCHAR(55) NOT NULL,
building_number VARCHAR(55) NOT NULL,
country VARCHAR(55),
CONSTRAINT PK_location PRIMARY KEY(location_id)
);

-- Table 5 (MAINMENU)
CREATE TABLE MAINMENU(
food_id INTEGER NOT NULL,
main_food VARCHAR(55) NOT NULL,
price DECIMAL(6,2) NOT NULL,
CONSTRAINT PK_food PRIMARY KEY(food_id)
);

-- Table 6 (DESSERTMENU)
CREATE TABLE DESSERTMENU(
food_id INTEGER NOT NULL,
dessert VARCHAR(55) NOT NULL,
price DECIMAL(6,2) NOT NULL,
CONSTRAINT PK_food_id PRIMARY KEY(food_id)
);

-- Add to ORDERS Table
INSERT INTO ORDERS
(order_id, order_customer_id, order_employee_id, order_date)
VALUES
(321, 1, 01, '2023-04-20'),
(332, 2, 02, '2023-04-21'),
(340, 3, 03, '2023-04-25'),
(349, 4, 04, '2023-05-04');

-- Check
SELECT * FROM ORDERS;

-- Add to CUSTOMER Table
INSERT INTO CUSTOMER
(customer_id, first_name, last_name, phone_number)
VALUES
(1, 'Lucy','Green', '073628593'),
(2, 'Ben','Renauld', '075029385'),
(3, 'Mary','New', '072674891'),
(4, 'Tom','Farry', '079877293'),
(5, 'Jules', 'Smith', '072998736');

-- Check
SELECT * FROM CUSTOMER;

-- Add to EMPLOYEE Table
INSERT INTO EMPLOYEE
(employee_id, employee_location_id, first_name, last_name, age, phone_number)
VALUES
(01, 1, 'Bea','Hughy', 27 ,  '0739829928'),
(02, 2, 'Neil','Leroy', 25 , '0729473631'),
(03, 2, 'Jim','Bloom', -2, '0725526373'),
(04, 1, 'Luke', 'Cream', 28, '075988374');

-- Check the age trigger worked
SELECT * FROM EMPLOYEE;

-- Add to LOCATION Table
INSERT INTO LOCATION
(location_id, employee_location_id, city, street, post_code, building_number, country)
VALUES
(001, 1, 'London', 'Liverpool Street', 'E1', '29', 'United Kingdom'),
(002, 2, 'Brighton', 'High Street', 'BR', '82', 'United Kingdom');

-- Check
SELECT * FROM LOCATION;

-- Add to MAINMENU Table
INSERT INTO MAINMENU 
(food_id, main_food, price)
VALUES
(0001, 'Chicken Skewers', 8.99),
(0002, 'Thai Basil Pork Mince',  10.90),
(0003, 'Tom Kha Gai Soup', 5.99),
(0004, 'Pork Spicy Salad',  9.50),
(0005, 'Lamb Massaman Curry', 12.99),
(0006, 'Morning Glory', 8.95);

-- Check
SELECT * FROM MAINMENU;

-- Add to DESSERTMENU Table
INSERT INTO DESSERTMENU
(food_id, dessert, price)
VALUES
(0001, 'Mango Sticky Rice',  7.60),
(0002, 'Fried Banana Slices', 6.50),
(0003, 'Coconut Cake', 4.99),
(0004, 'Banana and Chocolate Roti', 5.49);

-- Check
SELECT * FROM DESSERTMENU;

-- Create a view showing all items that are above average price in DESSERTMENU
CREATE VIEW above_average_price AS
SELECT dessert, price
FROM DESSERTMENU
WHERE price > (SELECT AVG(Price) FROM  DESSERTMENU);

SELECT * FROM above_average_price;

-- Find the desserts that are over 7 pounds from above average
SELECT DISTINCT dessert, Max(price)
FROM above_average_price 
WHERE Price > 7
GROUP BY dessert;

-- Create a cross join between menus
SELECT m1.*, m2.*
FROM MAINMENU m1
CROSS JOIN DESSERTMENU m2;

-- Add a Foreign Key
ALTER TABLE ORDERS
ADD CONSTRAINT FK_customer_id
FOREIGN KEY (order_customer_id)
REFERENCES CUSTOMER(customer_id);

SELECT * FROM MAINMENU;

-- Foreign Key employee_id
ALTER TABLE ORDERS
ADD CONSTRAINT FK_employee_id
FOREIGN KEY (order_employee_id)
REFERENCES EMPLOYEE(employee_id);

ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_employee
FOREIGN KEY (employee_location_id)
REFERENCES LOCATION (location_id);

-- Query with a subquery
SELECT food_id, dessert
FROM DESSERTMENU
WHERE price < (SELECT AVG(price) 
               FROM DESSERTMENU);
               
-- Create a function
CREATE FUNCTION check_age(first_name VARCHAR(50), age INT)
RETURNS VARCHAR(100) DETERMINISTIC
RETURN CONCAT_WS ( ' ', first_name, 'is', age, 'years old');

-- Use function
SELECT check_age(first_name, age)
FROM EMPLOYEE;
