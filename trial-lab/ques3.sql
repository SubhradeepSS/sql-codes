CREATE TABLE SalesPerson (
    ssn INT PRIMARY KEY,
    name_ VARCHAR(50),
    start_year VARCHAR(4),
    dept_no INT
);

CREATE TABLE Trip (
    trip_id INT PRIMARY KEY,
    ssn INT,
    from_city VARCHAR(20),
    to_city VARCHAR(20),
    departure_date DATE,
    return_date DATE,
    FOREIGN KEY (ssn) REFERENCES SalesPerson(ssn),
    CHECK (return_date >= departure_date)
);

CREATE TABLE Salerep_Expense (
    trip_id INT,
    amount INT,
    expense_type VARCHAR(6),
    FOREIGN KEY (trip_id) REFERENCES Trip(trip_id),
    CHECK (expense_type IN ('TRAVEL', 'STAY', 'FOOD'))
);


-- Inserting values
INSERT INTO SalesPerson
VALUES
(1000, 'Jon', '2000', 1),
(1001, 'Dan', '2010', 2),
(1002, 'Josh', '1998', 3),
(1003, 'Brad', '2003', 4),
(1004, 'Aditya', '2015', 5);

INSERT INTO Trip
VALUES
(1, 1000, 'Bangalore', 'Chennai', '2020-01-15', '2020-01-22'),
(2, 1000, 'Chennai', 'Bangalore', '2020-02-15', '2020-02-15'),
(3, 1001, 'Jaipur', 'Delhi', '2020-10-01', '2020-10-07'),
(4, 1002, 'Mumbai', 'Pune', '2020-03-15', '2020-03-28'),
(5, 1003, 'Ooty', 'Coimbatore', '2020-12-15', '2020-12-25'),
(6, 1004, 'Delhi', 'Agra', '2020-06-10', '2020-06-10'),
(7, 1002, 'Hyderabad', 'Bangalore', '2020-02-23', '2020-02-26'),
(8, 1002, 'Hyderabad', 'Chennai', '2020-09-15', '2020-09-22'),
(9, 1000, 'Trichy', 'Chennai', '2020-01-10', '2020-01-10'),
(10, 1003, 'Trichy', 'Coimbatore', '2020-11-02', '2020-11-02');

INSERT INTO Salerep_Expense
VALUES
(1, 2300, 'TRAVEL'), (1, 300, 'FOOD'), (1, 2000, 'STAY'),
(2, 1000, 'STAY'),
(3, 2700, 'TRAVEL'), (3, 1000, 'FOOD'), (3, 2500, 'STAY'),
(4, 1500, 'TRAVEL'), (4, 3000, 'STAY'), (4, 1200, 'FOOD'),
(5, 800, 'TRAVEL'), (5, 1000, 'STAY'), (5, 500, 'FOOD'),
(6, 1000, 'TRAVEL'),
(7, 1700, 'FOOD'), (7, 2050, 'STAY'), (7, 2800, 'TRAVEL'),
(8, 2500, 'TRAVEL'), (8, 500, 'FOOD'), (8, 3000, 'STAY'),
(9, 700, 'TRAVEL'),
(10, 1200, 'TRAVEL');


-- Displaying tables
SELECT * FROM SalesPerson;
SELECT * FROM Trip;
SELECT * FROM Salerep_Expense;


-- Queries:
-- 1: Give the details (all attributes of trip relation) for trips thatexceed Rs2000. 
SELECT * FROM Trip WHERE trip_id IN 
(SELECT trip_id FROM Salerep_Expense 
GROUP BY trip_id HAVING SUM(amount) > 2000);


-- 2: Print the ssn of salesperson who took trips to chennai more than once 
SELECT ssn FROM SalesPerson WHERE ssn IN 
(SELECT DISTINCT ssn FROM Trip GROUP BY to_city 
HAVING COUNT(to_city) > 1 AND to_city = 'Chennai');


-- 3: Print the total trip expenses incurred by the salesperson with ssn = 1000
SELECT SUM(amount) AS Expense FROM Salerep_Expense WHERE trip_id IN 
(SELECT trip_id FROM Trip WHERE ssn = 1000);


-- 4: Display the salesperson details in the sorted order based on name.
SELECT * FROM SalesPerson ORDER BY name_;