CREATE TABLE student (
    rollno INT,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    major VARCHAR(255),
    phoneno VARCHAR(255),
    classyear INT
);


INSERT INTO student values
(1, 'a', 'a_l', 'a@a.com', 'cse', '97768', 3);

-- 1. Create a trigger which will calculate the number of rows 
-- we have inserted till now.
SET @countrow = 0;
CREATE TRIGGER countRows
BEFORE INSERT
ON student
FOR EACH ROW
BEGIN
   SET @countrow = (SELECT COUNT(*) FROM student );
END;
SELECT @countrow;


-- 2. Create a trigger that displays a message prior to an 
-- insert operation on the students table
CREATE
TRIGGER bef_insert BEFORE INSERT
ON student
FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT="Entry inserting..";
END;


-- 3. Create a Trigger that adds “+91” to all Phone numbers in the students table.
-- Test and see if the Trigger works properly by inserting and updating 
-- some data in the table.
CREATE TRIGGER addNumber
BEFORE INSERT
ON student
FOR EACH ROW BEGIN
   SET NEW.phoneno = CONCAT("+91", NEW.phoneno);
END;


-- 4. Modify the structure/create new by splitting the column name to 
-- (First name and Last name) and copy the values appropriately into it.
ALTER TABLE student
ADD COLUMN firstname VARCHAR(100) AFTER Name_,
ADD COLUMN lastname VARCHAR(100) AFTER Name_ ;

UPDATE student
SET
    FirstName = SUBSTRING_INDEX(Name_, ' ', 1),
    LastName = SUBSTRING_INDEX(Name_, ' ', -1);

ALTER TABLE student
DROP COLUMN Name_ ;


-- 5. Create a trigger that whenever an insert, update, or delete operation 
-- occurs on the students table, a row is added to the studentlog table 
-- recording the date, user, and action.
CREATE TABLE studentlog(
   date_ DATE ,
   username VARCHAR (100) ,
   action_ VARCHAR (100)
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


-- 6. Create a trigger to insert student details into student table only 
-- if classyear<2015.
CREATE
TRIGGER no_greater_2015 BEFORE INSERT
ON student
FOR EACH ROW BEGIN
    IF NEW.classyear>=2015
    THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT="Class year less than 2015 allowed";
    END IF;
END;


-- 7. Create a trigger to prevent any student named John to be inserted into the table.
CREATE
TRIGGER no_JOHN BEFORE INSERT
ON student
FOR EACH ROW BEGIN
    IF NEW.firstname='John'
    THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT="Firstname John not allowed";
    END IF;
END;


-- 8. Create a trigger to raise an exception if the rollno is changed.
CREATE TRIGGER rollChanged
BEFORE UPDATE 
ON student
FOR EACH ROW BEGIN 
    IF NEW.rollno != OLD.rollno THEN
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Can't change roll number";
    END IF;
END;


-- 9. Create a trigger when someone tried to insert a value into a students table values are
-- inserted into views
