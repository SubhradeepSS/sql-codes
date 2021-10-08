-- QUESTION 1
-- Hostel (hno, hname, type [boys/girls])
-- Menu (hno, day, breakfast, lunch, dinner)
-- Warden (wname, qual, hno)
-- Student (sid, sname, gender, year, hno)


-- 1 : Implement the above schema enforcing primary key, check constraints and foreign key constraints
CREATE TABLE IF NOT EXISTS Hostel (
    hno INT PRIMARY KEY,
    hname VARCHAR(255) NOT NULL,
    type_ VARCHAR(5),
    CHECK (type_ IN ("boys", "girls"))
);

CREATE TABLE IF NOT EXISTS Menu (
    hno INT,
    day_ VARCHAR(255),
    breakfast VARCHAR(255),
    lunch VARCHAR(255),
    dinner VARCHAR(255),
    CHECK (day_ IN ("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")),
    FOREIGN KEY (hno) REFERENCES Hostel(hno)
);

CREATE TABLE IF NOT EXISTS Warden (
    wname VARCHAR(255),
    qual VARCHAR(255),
    hno INT,
    FOREIGN KEY (hno) REFERENCES Hostel(hno)
);

CREATE TABLE IF NOT EXISTS Student (
    sid_ INT PRIMARY KEY,
    sname VARCHAR(255),
    gender VARCHAR(10),
    year_ INT,
    hno INT,
    FOREIGN KEY (hno) REFERENCES Hostel(hno)
);

-- INSERTING VALUES 
INSERT INTO Hostel VALUES
(1, "Opal", "girls"),
(2, "Jade", "boys"),
(3, "Diamond", "boys"),
(4, "Coral", "boys"),
(5, "Agate", "boys");

INSERT INTO Menu VALUES 
(1, "Sunday", "Aloo Paratha", "Rice", "Chapathi Dhal"),
(1, "Monday", "Dosa", "Rotis", "Fried Rice"),
(2, "Sunday", "Idli", "Channa", "Dosa"),
(3, "Tuesday", "Ghee Dosa", "Paneer", "Pulao"),
(5, "Thursday", "Masala Dosa", "Paneer", "Pulao"),
(5, "Wednesday", "Masala Dosa", "Chicken", "Fried rice");

INSERT INTO Warden VALUES 
("Rema", "Dr", 1),
("Hari", "B.Com", 4),
("Ram", "Dr", 2),
("Jerome", "B.Com", 3);

INSERT INTO Student VALUES 
(1, "Rahi", "female", 3, 1),
(2, "Jon", "male", 1, 2),
(3, "Bernard", "male", 2, 3),
(4, "Adi", "male", 3, 3);

-- QUERIES
-- 2: Display the total number of girls and boys hostel in the college.
SELECT COUNT(*) FROM Hostel WHERE type_="Boys";
SELECT COUNT(*) FROM Hostel WHERE type_="Girls";


-- 3: Display the menu in the hostel ‘x’ on Tuesday
SELECT * FROM Menu WHERE hno=3 AND day_="Tuesday";


-- 4: Display the number of wardens for each hostel
SELECT hno,COUNT(*) FROM Warden GROUP BY hno;


-- 5: Display the total number of students in the particular hostel
SELECT COUNT(*) FROM Student WHERE hno=2;


-- 6: Change the breakfast of the hostel 5 on Thursday to ‘Noodles'
UPDATE Menu
SET breakfast="Noodles" WHERE hno=5 and day_="Thursday";
SELECT breakfast,day_ from Menu WHERE hno=5;


-- 7: Display the Wardens for each hostel with the qualification ‘B.Com’.
SELECT * FROM Warden WHERE qual="B.Com";


-- 8: Display the total number of students in the particular hostel whose name starts with 'A'.
SELECT COUNT(*) FROM Student WHERE hno=3 AND sname LIKE "A%";


-- 9: Display total number of boys in hostel year wise.
SELECT year_,COUNT(*) FROM Student GROUP BY year_;


-- 10: Display the names of the warden and hostel name for girl’s hostel.
SELECT * FROM Hostel WHERE type_="Girls";
SELECT wname FROM Warden WHERE hno IN (
    SELECT hno FROM Hostel WHERE type_="Girls"
);


-- 11: Display warden name and hostel name for third year students.
SELECT wname FROM Warden WHERE hno IN (
    SELECT hno FROM Student WHERE year_=3
);
SELECT hname FROM Hostel WHERE hno IN (
    SELECT hno FROM Student WHERE year_=3
);


-- 12: Display the warden name and total number of students in hostel wise.
SELECT hno,wname FROM Warden GROUP BY hno;
SELECT hno,COUNT(*) AS Total FROM Student GROUP BY hno;


-- 13: Create a view with name of the student, gender, hostel number and their warden name.
CREATE VIEW Student_View AS
SELECT sname, gender, Student.hno, wname 
FROM Student INNER JOIN Warden ON Student.hno = Warden.hno;

SELECT * FROM Student_View;


-- QUESTION 2
-- Department (dept id, dept name)
-- Student (rollno, name, gender, mark1, mark2, mar3, total, average, dept id)
-- Staff (staff id, name, designation, qualification, dept id)
-- Tutor (rollno, staff id)


CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(255)
);

CREATE TABLE Student_ (
    roll_no INT PRIMARY KEY,
    name_ VARCHAR(255),
    gender VARCHAR(10),
    mark1 INT,
    mark2 INT,
    mark3 INT,
    total INT,
    average INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    name_ VARCHAR(255),
    designation VARCHAR(255),
    qualification VARCHAR(255),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Tutor (
    roll_no INT,
    staff_id INT,
    FOREIGN KEY (roll_no) REFERENCES Student_(roll_no),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Inserting values
INSERT INTO Department VALUES
(1, "CSE"),
(2, "ECE"),
(3, "ICE");

INSERT INTO Student_ (roll_no, name_, gender, mark1, mark2, mark3, dept_id) VALUES
(1, "A", "F", 100, 100, 100, 1),
(2, "B", "M", 98, 99, 100, 1),
(3, "C", "M", 60, 60, 60, 2),
(4, "R1", "M", 60, 60, 80, 2),
(5, "R2", "F", 72, 69, 89, 3),
(6, "D", "M", 90, 97, 100, 3);

SELECT * FROM student_;

INSERT INTO Staff VALUES
(1, "x", "professor", "Dr", 1),
(2, "y", "hod", "Dr", 1),
(3, "z", "professor", "Dr", 2),
(4, "w", "hod", "Dr", 3);

INSERT INTO Tutor VALUES 
(1, 1), (2, 1), (3, 3), (4, 2), (5, 2), (6, 3);


-- QUERIES
-- 1: Calculate the total and average mark of each student while entering the marks to insert the tuple in student table
UPDATE Student_
SET total = (mark1+mark2+mark3);
UPDATE Student_
SET average = (total)/3;


-- 1: Display the number of student under the department ‘cse’.
SELECT COUNT(*) FROM Student_ WHERE dept_id = (
    SELECT dept_id FROM Department WHERE dept_name="CSE"
);


-- 2: Display the student details who got average >85.
SELECT * FROM Student_ WHERE average > 85;


-- 3: How many students are under the tutor ‘x’
SELECT COUNT(*) FROM Student_ WHERE roll_no IN (
    SELECT roll_no FROM Tutor WHERE staff_id IN (
        SELECT staff_id FROM Staff WHERE name_="x"
    )
);


-- 4: Display the staff details who work in CSE department.
SELECT * FROM Staff WHERE dept_id = (
    SELECT dept_id FROM Department WHERE dept_name="CSE"
);


-- 5: How many designations and departments are there?
SELECT COUNT(*) FROM Department;
SELECT COUNT(DISTINCT Designation) FROM Staff;


-- 6: Display the student details whose name start with ‘R’.
SELECT * FROM Student_ WHERE Student_.name_ LIKE "R%";


-- 7: Display the name of the department, tutor details for the particular student
SELECT dept_name, staff_id,name_, designation, qualification
FROM Department INNER JOIN staff ON Department.dept_id=Staff.dept_id
WHERE staff_id IN (
    SELECT staff_id FROM Tutor WHERE roll_no=1
);


-- 8: Display the total number of male and female students in department wise.
SELECT dept_id,COUNT(*) FROM Student_  WHERE gender="M" GROUP BY dept_id;
SELECT dept_id,COUNT(*) FROM Student_  WHERE gender="F" GROUP BY dept_id;


-- 9: Display the student name in department wise who got first mark.
SELECT name_,dept_id,average FROM Student_ WHERE average IN (
    SELECT MAX(average) FROM Student_ GROUP BY dept_id
); 


-- 10: Display tutor details for toppers in department wise
SELECT * FROM Staff WHERE staff_id IN (
    SELECT staff_id FROM Tutor WHERE roll_no IN (
        SELECT roll_no FROM Student_ WHERE average IN (
            SELECT MAX(average) FROM Student_ GROUP BY dept_id
        )
    )
);


-- 11: Display the staff details who is the tutor for female students.
SELECT * FROM Staff WHERE staff_id IN (
    SELECT staff_id FROM Tutor WHERE roll_no IN (
        SELECT roll_no FROM Student_ WHERE gender="F"
    )
);


-- 12:Create a view to staff details and their department name whose designation is professor
CREATE VIEW Staff_View AS
SELECT staff_id,name_,designation,qualification,dept_name 
FROM Staff INNER JOIN Department ON Staff.dept_id=Department.dept_id
WHERE Staff.designation="professor";

SELECT * FROM Staff_view;