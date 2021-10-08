CREATE TABLE Car (
    serial_no INT PRIMARY KEY,
    model VARCHAR(20),
    manufacturer VARCHAR(50),
    price INT
);

CREATE TABLE Options_ (
    serial_no INT,
    option_name VARCHAR(50),
    price INT,
    FOREIGN KEY (serial_no) REFERENCES Car(serial_no)
);

CREATE TABLE Sales_Person (
    salesperson_id INT PRIMARY KEY,
    name_ VARCHAR(20),
    phone VARCHAR(15)
);

CREATE TABLE Sales (
    salesperson_id INT,
    serial_no INT,
    date_ DATE,
    sale_price INT,
    FOREIGN KEY (serial_no) REFERENCES Car(serial_no),
    FOREIGN KEY (salesperson_id) REFERENCES Sales_Person(salesperson_id)
);

-- Inserting values
INSERT INTO Car
VALUES
(1, 'Ford', 'Michael', 1000000),
(2, 'Volkswagen', 'Angela', 1500000),
(3, 'Tesla', 'David', 2000000),
(4, 'Toyota', 'Bernard', 1600000),
(5, 'Tata', 'Levinson', 1200000);

INSERT INTO Options_
VALUES
(1, 'Booster', 10000),
(2, 'Shield', 2000),
(5, 'Dynamic Color', 75000);

INSERT INTO Sales_Person
VALUES
(1, 'John', '4859294898'),
(2, 'Josh', '3565929898'),
(3, 'David', '5957829898');

INSERT INTO Sales
VALUES
(1, 1, '2020-01-12', 1000000),
(1, 2, '2020-03-30', 1400000),
(1, 5, '2020-10-18', 1100000),
(2, 3, '2020-02-10', 1950000),
(3, 3, '2020-05-20', 1980000),
(3, 5, '2020-12-01', 1200000),
(3, 4, '2020-02-27', 1575000);


-- Displaying tables
SELECT * FROM Car;
SELECT * FROM Options_;
SELECT * FROM Sales_Person;
SELECT * FROM Sales;


-- Queries:
-- 1: For the sales personnamed ‘John’ list the following information for all the cars sold :  serial no,  manufacturer, sale_price 
SELECT Car.serial_no, manufacturer, sale_price 
FROM Car INNER JOIN Sales ON Car.serial_no = Sales.serial_no
WHERE Sales.salesperson_id IN 
(SELECT salesperson_id FROM Sales_person WHERE name_='John');


-- 2: List the serial_no and model of cars that have no options 
SELECT serial_no, model FROM Car WHERE serial_no NOT IN
(SELECT serial_no FROM Options_);


-- 3: List the serial_no, model, sale_price for the cars that have optional parts. 
SELECT serial_no, model FROM Car WHERE serial_no IN
(SELECT serial_no FROM Options_);


-- 4: Modify the phone no of a particular sales person 
UPDATE Sales_person
SET phone = '345678256' WHERE salesperson_id = 3;

SELECT * FROM Sales_Person;