CREATE TABLE department (
    deptno INT PRIMARY KEY,
    deptname VARCHAR(255),
    location VARCHAR(255)
);

CREATE TABLE employee (
    empno INT PRIMARY KEY,
    empname VARCHAR(255),
    sex VARCHAR(255),
    salary INT,
    address VARCHAR(255),
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES department (deptno) ON DELETE CASCADE
);


INSERT INTO department VALUES
(1,'a','l1'), (2,'b','l2'), (3,'c','l3');

INSERT INTO employee VALUES 
(1,'A','M','1000000','L1',1),
(2,'B','F','500000','L2',2),
(3,'C','M','1200000','L3',3),
(4,'D','F','1800000','L4',1);


-- 1: Create a procedure to display the details of an employee record form 
-- employee table for a given employee number
CREATE PROCEDURE show_emp (IN emp_no INT)
BEGIN
    SELECT * FROM employee WHERE empno=emp_no;
END;


-- 2: Create a procedure to add details of a new employee into employee table
CREATE PROCEDURE add_emp (
    IN emp_no INT, IN emp_name VARCHAR(255), IN sex_ VARCHAR(255),
    IN salary_ INT, IN address_ VARCHAR(255), IN dept_no INT 
    )
BEGIN
    INSERT INTO employee VALUES
    (emp_no, emp_name, sex_, salary_, address_, dept_no);
    SELECT * FROM employee;
END;


-- 3: Write a procedure raise_sal which increases the salary of an employee. 
-- It accepts an employee number and salary increase amount. It uses the employee number 
-- to find the current salary from the EMPLOYEE table and update the salary
CREATE PROCEDURE raise_sal (IN emp_no INT, IN increase INT)
BEGIN
    DECLARE old_salary INT;
    SELECT salary FROM employee WHERE empno=emp_no INTO old_salary;
    UPDATE employee
    SET salary=old_salary+increase WHERE empno=emp_no;
    CALL show_emp(emp_no);
END;


-- 4: Create a procedure to delete a record form employee table for a given employee name.
CREATE PROCEDURE del_emp (IN emp_no INT)
BEGIN
    DELETE FROM employee WHERE empno=emp_no;
    SELECT * FROM employee;
END;


-- 5. Write a function to display maximum salary of employees from the employee table.
CREATE FUNCTION max_salary() RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT MAX(salary) FROM employee INTO ans;
    RETURN ans;
END;


-- 6. Write a function to display the number of employees working in the Organization.
CREATE FUNCTION no_employees() RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT COUNT(*) FROM employee INTO ans;
    RETURN ans;
END;


-- 7. Write a function to display salary of an employee with the given employee number.
CREATE FUNCTION show_salary(emp_no INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT salary FROM employee WHERE empno=emp_no INTO ans;
    RETURN ans;
END;


-- 8. Write a function average which takes DeptNo as input argument and 
-- returns the average salary received by the employee in the given department.
CREATE FUNCTION avg_sal_dept(dept_no INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT AVG(salary) FROM employee WHERE deptno=dept_no INTO ans;
    RETURN ans;
END;


-- 9. Write a procedure which takes the DeptNo as input parameter and 
-- lists the names of all employees belonging to that department.
CREATE PROCEDURE show_dept_names (IN dept_no INT)
BEGIN
    SELECT empname FROM employee WHERE deptno=dept_no;
END;


-- 10. Write procedure that lists the highest salary drawn by an employee 
-- in each of the departments.It should make use of a named procedure 
-- dept_highest which finds the highest salary drawn by an employee for the given department.
CREATE FUNCTION dept_highest(dept_no INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT MAX(salary) FROM employee WHERE deptno=dept_no INTO ans;
    RETURN ans;
END;

CREATE PROCEDURE dept_high_salary()
BEGIN
    SELECT deptno,dept_highest(deptno) FROM department;
END;


-- 11. Write a function that will display the number of employees with salary more than 50k.
CREATE FUNCTION no_50() RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT COUNT(*) FROM employee WHERE salary>50000 INTO ans;
    RETURN ans;
END;


-- 12. Write a function that will display the count of the number of employees working in Chennai.
CREATE FUNCTION emp_Chennai() RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT COUNT(*) FROM employee WHERE deptno IN (
        SELECT deptno FROM department WHERE location="Chennai"
    ) INTO ans;
    RETURN ans;
END;