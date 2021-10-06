-- a. Consider the University data.
-- Student (student-id, student-name, gender, DoB, city, dept-no)
-- Department (dept-no, dept.name)
-- Faculty (faculty-id, faculty-name, designation, salary, city, dept-no)
-- Course (course-id, course-name, credits, dept-no)
-- Registers (student-id, course-id, semester )
-- Teaching (faculty-id, course-id, semester)
CREATE TABLE department (
    dept_no INT PRIMARY KEY,
    dept_name VARCHAR(255)
);

CREATE TABLE student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255),
    gender VARCHAR(255),
    dob DATE,
    city VARCHAR(255),
    dept_no INT,
    FOREIGN KEY (dept_no) REFERENCES department(dept_no) ON DELETE CASCADE
);

CREATE TABLE faculty (
    faculty_id INT PRIMARY KEY,
    faculty_name VARCHAR(255),
    designation VARCHAR(255),
    salary INT,
    city VARCHAR(255),
    dept_no INT,
    FOREIGN KEY (dept_no) REFERENCES department(dept_no) ON DELETE CASCADE
);

CREATE TABLE course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(255),
    credits INT,
    dept_no INT,
    FOREIGN KEY (dept_no) REFERENCES department(dept_no) ON DELETE CASCADE
);

CREATE TABLE register (
    student_id INT ,
    course_id INT ,
    semester INT ,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE
);

CREATE TABLE teaching (
    faculty_id INT ,
    course_id INT ,
    semester INT ,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE
);

insert into department values
(1,'CSE'),
(2,'EEE'),
(3,'ECE'),
(4,'Mathematics');

INSERT INTO student VALUES
(1,'AA','M','2002-01-12','XX',4),
(2,'BB','M','2000-09-12','YY',2),
(3,'CC','F','2004-08-07','ZZ',1),
(4,'DD','F','2000-09-14','TT',3);

INSERT INTO faculty values
(1,'AB','P',20000,'XY',4),
(2,'CD','AP',10000,'YZ',2),
(3,'EF','AP',12000,'ZT',1),
(4,'GH','P',30000,'PQ',3);

INSERT INTO course VALUES
(1,'DS',4,4),
(2,'OS',3,1),
(3,'CO',2,3),
(4,'CA',4,2);

use database lab;

INSERT INTO register VALUES
(2,1,7),
(4,3,8),
(3,4,5),
(1,2,4);

INSERT INTO teaching VALUES 
(4,1,7),
(3,3,8),
(2,2,4),
(1,4,5);


-- (i) Find the name of all Faculty who work in the Department of Mathematics.
SELECT faculty_name FROM faculty where dept_no IN (
    SELECT dept_no FROM department WHERE dept_name="Mathematics"
);

-- (ii) Find the names and cities of residence of all Faculty who handle seventh semester course.
SELECT faculty_name, city FROM faculty WHERE faculty_id IN (
    SELECT faculty_id FROM teaching WHERE semester=7
);

-- (iii) Create a view for faculty based on dept-name in ascending order.
CREATE VIEW fac_name AS
SELECT faculty_name FROM faculty ORDER BY faculty_name ASC;

SELECT * FROM fac_name;

-- (iv) Find the faculty in the database who teaches maximum number of courses in EEE Department
select f.faculty_id,count(*) from teaching t inner join faculty f
on f.faculty_id= t.faculty_id inner join department d on
f.dept_no = d.dept_no where d.dept_name="EEE" order by count(*)
desc limit 1;

-- (v) Create a Function that displays the student who are in eighth semester.
CREATE FUNCTION stud_8() RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT COUNT(*) INTO ans FROM student WHERE student_id IN (
        SELECT student_id FROM register WHERE semester=8
    );
    RETURN ans;
END;


-- (vi) Create a trigger that whenever an insert, update, or delete operation occurs on the student table, a row is added to the student log table recording the date, user, and action.
CREATE TABLE studentlog(
   date_ DATE ,
   username VARCHAR (255) ,
   action_ VARCHAR (255)
);

CREATE TRIGGER insertTrigger
BEFORE INSERT
ON student
FOR EACH ROW
BEGIN
   INSERT INTO studentlog
   VALUE(CURRENT_DATE(),CURRENT_USER(),"Insert");
END;
 
CREATE TRIGGER updateTrigger
BEFORE UPDATE 
ON student
FOR EACH ROW
BEGIN
   INSERT INTO studentlog
   VALUE(CURRENT_DATE(),CURRENT_USER(),"Update");
END;
 
--Delete
CREATE TRIGGER deleteTrigger
BEFORE DELETE
ON student
FOR EACH ROW
BEGIN
   INSERT INTO studentlog
   VALUE(CURRENT_DATE(),CURRENT_USER(),"Delete");
END;


-- (vii) Write a procedure which takes the city as input parameter and lists the names of all courses handled by the faculty belonging to that city.
CREATE PROCEDURE fac_name (IN city_ VARCHAR(255))
BEGIN 
    SELECT course_name FROM course INNER JOIN department ON course.dept_no=department.dept_no
    INNER JOIN faculty ON faculty.dept_no=department.dept_no WHERE faculty.city=city_;
END;


-- (viii) Create a trigger to raise an exception if the faculty-id is changed.
CREATE TRIGGER faculty_id_change
BEFORE UPDATE 
ON faculty
FOR EACH ROW BEGIN 
    IF NEW.faculty_id != OLD.faculty_id THEN
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Can't change faculty id";
    END IF;
END;


-- (ix) Create a trigger to insert details into student table only if department name is CSE.
CREATE TRIGGER dept_cse
BEFORE INSERT 
ON student
FOR EACH ROW BEGIN 
    IF NEW.dept_no NOT IN (SELECT dept_no FROM department WHERE dept_name="CSE") THEN
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Can't insert non-cse students";
    END IF;
END;


-- (x) Write a function that will display the number of faculty who handle more than two courses.
CREATE FUNCTION faculty_2() RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT count(distinct faculty.faculty_id) into ans from faculty inner join teaching on faculty.faculty_id=teaching.faculty_id group by faculty.faculty_id having count(*)>2;
    RETURN ans;
END;


-- (xi) Write a procedure raise_sal which increases the salary of a faculty. It accepts a faculty_id and salary increase amount.
CREATE PROCEDURE raise_sal (IN facultyid INT, IN increase INT)
BEGIN
    DECLARE old_salary INT;
    SELECT salary FROM faculty WHERE faculty_id=facultyid INTO old_salary;
    UPDATE faculty
    SET salary=old_salary+increase WHERE empno=facultyid;
END;


-- (xii). Find all the students in the database who belong to the same cities as that of their Faculty members.
SELECT * FROM student INNER JOIN department ON student.dept_no=department.dept_no INNER JOIN faculty
ON faculty.dept_no=department.dept_no WHERE student.city=faculty.city;


-- (xiii) Find all faculty names with their corresponding course names.
SELECT faculty.faculty_name, course.course_name FROM faculty
INNER JOIN department ON faculty.dept_no=department.dept_no INNER JOIN 
course ON course.dept_no=department.dept_no;