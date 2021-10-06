-- Creating Tables
CREATE TABLE Department (
    Dno INT PRIMARY KEY,
    Dname VARCHAR (255),
    Managername VARCHAR(255)
);

CREATE TABLE Emp (
    Empno INT PRIMARY KEY,
    Ename VARCHAR(255),
    Address_ VARCHAR(255),
    Sex VARCHAR(10),
    DOB DATE,
    Dateofjoining DATE,
    Deptno INT,
    Division VARCHAR(255),
    Desig VARCHAR(255),
    Salary INT,
    FOREIGN KEY (Deptno) REFERENCES Department(Dno)
);

-- Inserting Values
INSERT INTO Department
VALUES 
(1, 'admin', 'mgr 1'),
(2, 'sales', 'mgr 2'),
(3, 'marketing', 'mgr 3'),
(4, 'finance', 'mgr 4'),
(5, 'testing', '');


INSERT INTO Emp
VALUES
(1, 'Jon', 'address 1', 'M', '1970-11-23', '1980-10-10', 1, 'ne', 'manager', 1000000),
(2, 'Dan', 'address 2', 'M', '1970-12-23', '2019-10-10', 1, 'ne', 'employee', 100000),
(3, 'Josh', 'address 3', 'F', '1975-01-25', '2010-10-10', 2, 'se', 'part-time', 9000),
(4, 'Yoshi', 'address 4', 'F', '1979-11-03', '2000-10-10', 3, 'ne', 'hr', 2000000),
(5, 'Mario', 'address 5', 'M', '1981-12-10', '2004-10-10', NULL, 'se', 'intern', 4000),
(6, 'Bernard', 'address 6', 'F', '1985-11-23', '2011-10-10', 3, 'ee', 'dev-intern', 45000),
(7, 'Allen', 'address 7', 'M', '1960-02-15', '2016-10-10', NULL, 'ne', 'intern', 4500),
(8, 'Harry', 'address 8', 'M', '1990-11-23', '1989-10-10', 1, 'se', 'manager', 50000),
(9, 'Laaryy', 'address 9', 'F', '1990-11-20', '2000-02-23', 4, 'ee', 'senior engg', 200000);

DELETE FROM Emp WHERE Empno In (5,7);

-- Displaying tables
SELECT * FROM Emp;
SELECT * FROM Department;

-- Queries
-- 1
SELECT Ename, Division FROM Emp
WHERE Salary NOT BETWEEN 3000 AND 5000;

-- 2
SELECT Ename, Salary FROM Emp 
INNER JOIN Department ON Emp.Deptno = Department.Dno 
WHERE Department.Dname IN ('admin', 'finance', 'sales');

-- 3
SELECT Ename FROM Emp
INNER JOIN Department ON Emp.Deptno=Department.Dno
WHERE Department.Dname='sales' 
UNION
SELECT Ename FROM Emp
INNER JOIN Department ON Emp.Deptno=Department.Dno
WHERE Department.Dname='marketing';

-- 4
SELECT Ename FROM Emp WHERE Division IN ('ne', 'se');

-- 5
SELECT Ename FROM Emp WHERE Salary = (
    SELECT MAX(Salary) FROM Emp
);

-- 6
SELECT t1.Desig, t1.Salary FROM Emp t1
WHERE t1.Salary = (
    SELECT AVG(t2.Salary) FROM Emp t2
);

-- 7
SELECT Ename FROM Emp t1 WHERE t1.Salary = (
    SELECT MIN(t2.Salary) FROM Emp t2
    WHERE t2.Deptno=t1.Deptno
);

-- 8
SELECT * FROM Emp t1 WHERE t1.Salary >= (
    SELECT AVG(t2.Salary) FROM Emp t2
    WHERE t1.Deptno=t2.Deptno 
);

-- 9
SELECT * FROM Emp WHERE Deptno IS NULL;

-- 10
SELECT * FROM Emp WHERE Salary > (
    SELECT MIN(Salary) FROM Emp WHERE Desig='manager'
);

-- 11
SELECT Dname FROM Department WHERE Dno NOT IN (
    SELECT Deptno FROM emp
);

-- 12
SELECT * FROM Emp WHERE Salary > (
SELECT MAX(Salary) FROM Emp WHERE Desig='manager'
);

-- 13
SELECT Ename, FLOOR(DATEDIFF(CURRENT_DATE, DOB)/365) AS age FROM Emp;

-- 14
SELECT Ename FROM Emp WHERE DATEDIFF(CURRENT_DATE, Dateofjoining)/365 > 10;

-- 15
-- Employee View
CREATE VIEW EmployeeView AS
SELECT Empno, Ename, Address_, Sex, Deptno, Division, Desig FROM Emp;

-- Employee Nested View
CREATE VIEW Employee AS
SELECT Empno, Ename, Address_, Sex FROM EmployeeView;