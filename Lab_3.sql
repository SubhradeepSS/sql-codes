-- QUESTION 1:-
-- Customer(Cust id : integer, cust_name: string)
-- Item(item_id: integer, item_name: string, price: integer)
-- Sales(bill_no: integer, bill_date: date, cust_id: integer, item_id: integer, qty_sold: integer)


-- 1: Create the tables with the appropriate integrity constraints 
-- and insert around 5 records in each of the tables. 
CREATE TABLE Customer (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(255)
);

CREATE TABLE Item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(255),
    price INT
);

CREATE TABLE Sales (
    bill_no INT PRIMARY KEY,
    bill_date DATE,
    cust_id INT,
    item_id INT,
    qty_sold INT,
    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);


INSERT INTO Customer VALUES
(1,'A'), (2,'B'), (3,'C'), (4,'D'), (5,'E');

INSERT INTO Item VALUES
(1,'i1',100), (2,'i2',200), (3,'i3',310), (4,'i4',50), (5,'i5',105);

INSERT INTO Sales VALUES
(1, '2020-09-29', 1, 1, 2),
(2, '2020-09-17', 2, 3, 10),
(3, '2020-08-20', 3, 4, 1),
(4, '2020-09-01', 1, 2, 6),
(5, '2020-09-02', 1, 5, 4);


-- 2: List all the bills for the current date with the customer names and item_id.
SELECT Sales.item_id, Customer.cust_name FROM
Sales INNER JOIN Customer ON Sales.cust_id=Customer.cust_id
WHERE Sales.bill_date=CURRENT_DATE();


-- 3: List the details of the customer who have bought a product 
-- which has a price>200.
SELECT * FROM Customer WHERE cust_id IN (
    SELECT Sales.cust_id FROM Sales INNER JOIN Item ON 
    Item.item_id=Sales.item_id WHERE price>200
);


-- 4: Give a count of how many products have been bought by 
-- each customer.
SELECT cust_id, COUNT(*) FROM Sales GROUP BY cust_id;


-- 5: Give a list of products bought by a customer having cust_id as 5
SELECT Item.* FROM Item INNER JOIN Sales 
ON Item.item_id=Sales.item_id WHERE cust_id=5;


-- 6: List the item details which are sold as of today
SELECT Item.* FROM Item INNER JOIN Sales
ON Item.item_id=Sales.item_id WHERE bill_date=CURRENT_DATE();


-- 7: Create a view which lists out the bill_no, bill_date, 
-- cust_id, item_id, price, qty_sold, amount. 
CREATE VIEW myView AS SELECT Sales.*,price FROM 
Sales INNER JOIN Item on Sales.item_id=Item.item_id;
SELECT * FROM myView;

-- Create a view which lists the daily sales date wise 
-- for the last one week.
CREATE VIEW SalesView AS SELECT * FROM Sales
WHERE bill_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE();
SELECT * FROM SalesView;


--------------------------------------------------------------------------

-- QUESTION 2:-
-- Student(stud_no: integer, stud_name: string, class: string)
-- Class(class: string, descrip: string)
-- Lab(mach_no: integer, Lab_no: integer, description: String)
-- Allotment(stud_no: integer, mach_no: integer, day_of_week: string)

-- 1: Create the tables with the appropriate integrity constraints 
-- and insert around 5 records in each of the tables
CREATE TABLE Class (
    class VARCHAR(255) PRIMARY KEY,
    descrip VARCHAR(255)
);

CREATE TABLE Student (
    stud_no INT PRIMARY KEY,
    stud_name VARCHAR(255),
    class VARCHAR(255),
    FOREIGN KEY (class) REFERENCES Class(class)
);

CREATE TABLE Lab (
    mach_no INT PRIMARY KEY,
    lab_no INT,
    description_ VARCHAR(255)
);

CREATE TABLE Allotment (
    stud_no INT,
    mach_no INT,
    day_of_week VARCHAR(255),
    FOREIGN KEY (stud_no) REFERENCES Student(stud_no),
    FOREIGN KEY (mach_no) REFERENCES Lab(mach_no)
);

INSERT INTO Class VALUES
('c_1', 'dbms'), ('c_2','os'), ('c_3','ds'), ('c_4','csit'), ('c_5','ip');

INSERT INTO Student VALUES
(1,'A','c_1'), (2,'B','c_2'), (3,'C','c_3'), (4,'D','c_4'), (5,'E','c_5');

INSERT INTO Lab VALUES
(1,1,'dbms'), (2,2,'os'),(3,3,'ds'),(4,4,'csit'), (5,5,'ip');

INSERT INTO Allotment VALUES
(1,1,'Mon'), (2,2,'Tue'), (3,3,'Wed'), (4,4,'Thurs');


-- 2: List all the machine allotments with the student names,lab and machine numbers.
SELECT Student.stud_name,lab_no,Allotment.mach_no FROM Allotment INNER JOIN Lab ON 
Allotment.mach_no=Lab.mach_no INNER JOIN Student ON Allotment.stud_no=Student.stud_no;


-- 3: Display list of student who has not given any machine.
SELECT * FROM Student WHERE stud_no NOT IN (
    SELECT stud_no FROM Allotment
);

-- 4: Give a count of how many machines have been allocated to the 'CSIT' class.
SELECT COUNT(*) FROM Allotment INNER JOIN Student ON 
Allotment.stud_no=Student.stud_no INNER JOIN Class ON 
Student.class=Class.class WHERE Class.descrip="csit";


-- 5: Count for how many machines have been allocated in Lab_no 1 
-- for the day of the week as “Monday”.
SELECT COUNT(*) FROM Allotment INNER JOIN Lab ON Lab.mach_no=Allotment.mach_no
WHERE day_of_week='Mon' AND Lab.lab_no=1;


-- 6: Create a view which lists out the stud_no, stud_name, mach_no, lab_no, dayofweek
CREATE VIEW ClassView as SELECT
Student.stud_no,stud_name,lab_no,Lab.mach_no,day_of_week FROM Allotment INNER JOIN Lab ON 
Allotment.mach_no=Lab.mach_no INNER JOIN Student ON Allotment.stud_no=Student.stud_no;

SELECT * FROM ClassView;