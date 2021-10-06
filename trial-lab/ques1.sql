CREATE TABLE Employee (
    EmpId INT PRIMARY KEY,
    EmpName VARCHAR(20),
    Address VARCHAR(100),
    Salary INT,
    Doj VARCHAR(20)
);

CREATE TABLE Project (
    ProjectNo INT PRIMARY KEY,
    Duration DECIMAL,
    ProjectName VARCHAR(50)
);

CREATE TABLE WorksOn (
    EmpId INT,
    ProjectNo INT,
    FOREIGN KEY (EmpId) REFERENCES Employee(EmpId),
    FOREIGN KEY (ProjectNo) REFERENCES Project(ProjectNo)
);


-- INSERTING VALUES :
INSERT INTO Employee
VALUES
(1, 'David', 'Mumbai', 250000, 'Doj_1'),
(2, 'Jan', 'Chennai', 110000, 'Doj_2'),
(3, 'Michale', 'Kolkata', 580000, 'Doj_3'),
(4, 'Kelly', 'Delhi', 780000, 'Doj_4'),
(5, 'Josh', 'Bangalore', 630000, 'Doj_5'),
(6, 'Bob', 'Guwahati', 100000, 'Doj_6'),
(7, 'Bernard', 'Gurgaon', 280000, 'Doj_7');

INSERT INTO Project
VALUES
(1, 10000, 'Database Design'),
(2, 27000, 'Backend Dev'),
(3, 25000, 'Frontend Dev'),
(4, 30000, 'Devops');

INSERT INTO WorksOn
VALUES
(1, 4), (2, 1), (2, 2), (3, 3), (4, 4), (5, 4), (6, 1), (7, 2);


-- Displaying existing tables :
SELECT * FROM Employee;
SELECT * FROM Project;
SELECT * FROM WorksOn;


-- Queries :
-- 1: Display the Employee details in the descending order based on name.
SELECT * FROM Employee ORDER BY EmpName DESC;


-- 2: Display the project details if project id is given.
SELECT * FROM Project WHERE ProjectNo = 4;


-- 3: Display the employee names starting with ‘B' 
SELECT * FROM Employee WHERE EmpName LIKE 'B%';


-- 4: Display the employee ID's working in a particular project if project no is given.
SELECT EmpId FROM WorksOn WHERE ProjectNo = 2;