-- Consider the Travel data.
-- Bus (Bus_No, Source, Destination, Couch Type)
CREATE TABLE bus (
    bus_no INT PRIMARY KEY,
    source VARCHAR(255),
    destination VARCHAR(255),
    couch_type VARCHAR(255)
);
-- Reservation (PNR_No, Journey date, No-of-seats, Contact-no, Bus_No)
CREATE TABLE reservation (
    pnr_no INT PRIMARY KEY,
    journey_date DATE,
    no_of_seats INT,
    contact_no VARCHAR(255),
    bus_no INT,
    FOREIGN KEY (bus_no) REFERENCES bus(bus_no) ON DELETE CASCADE
);
-- Ticket (Ticket_No, Journey date, Dep-time, Arr-time, Bus_No)
CREATE TABLE ticket (
    ticket_no INT PRIMARY KEY,
    journey_date DATE,
    dept_time INT,
    arr_time INT,
    bus_no INT,
    FOREIGN KEY (bus_no) REFERENCES bus(bus_no) ON DELETE CASCADE
);
-- Passenger (PNR_No, Ticket No, Name, Age, Sex, Contact-no)
CREATE TABLE passenger (
    pnr_no INT,
    ticket_no INT,
    name VARCHAR(255),
    age INT,
    sex VARCHAR(255),
    contact_no VARCHAR(255),
    FOREIGN KEY (pnr_no) REFERENCES reservation(pnr_no) ON DELETE CASCADE,
    FOREIGN KEY (ticket_no) REFERENCES ticket(ticket_no) ON DELETE CASCADE
);


INSERT INTO bus VALUES
(1,'A','P','SL'),
(2,'B','Q','S'),
(3,'C','R','FC'),
(4,'D','S','SC');

INSERT INTO reservation VALUES
(1,"2002-11-01",4,"123456789",3),
(2,"2000-09-12",2,"987654321",2),
(3,"2004-07-08",1,"874593125",4),
(4,"2000-09-14",3,"328617392",1);

INSERT INTO ticket values
(1,"2002-11-01",1210,1705,4),
(2,"2000-09-12",0250,1322,2),
(3,"2004-07-08",0723,1520,1),
(4,"2000-09-14",1802,2345,3);

INSERT INTO passenger VALUES
(1,4,'AA',40,'M',"123456789"),
(2,3,'BB',12,'M',"987654321"),
(3,2,'CC',33,'F',"874593125"),
(4,1,'DD',26,'F',"328617392");




-- (i) Find the details of the Bus which spends maximum time in the travel. (Use Arrival time, Departure Time)
SELECT bus.*, MAX(arr_time-dept_time) FROM bus 
INNER JOIN ticket ON bus.bus_no=ticket.bus_no;


-- (ii) Create a view for Passenger based on Passenger name in descending order.
CREATE VIEW passengerView AS
SELECT name FROM passenger ORDER BY name DESC;

SELECT * FROM passengerView;


-- (iii) Find the passenger name in the database who reserves minimum number of tickets.
SELECT name FROM passenger INNER JOIN reservation
ON passenger.pnr_no=reservation.pnr_no WHERE no_of_seats=(
    SELECT MIN(no_of_seats) FROM reservation
);


-- (iv) Create a Function that returns the no-of-seats reserved when the contact number is given.
CREATE FUNCTION no_seats(contactNo VARCHAR(255)) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT no_of_seats INTO ans FROM reservation WHERE contact_no=contactNo;
    RETURN ans;
END;

SELECT no_seats("987654321");


-- (v) Create a trigger that whenever an insert, update, or delete operation occurs on the Passenger table, a row is added to the passenger log table recording the date, user, and action.
CREATE TABLE passengerLog(
   date_ DATE ,
   username VARCHAR (255) ,
   action_ VARCHAR (255)
);

CREATE TRIGGER insertTrigger
BEFORE INSERT
ON passenger
FOR EACH ROW
BEGIN
   INSERT INTO passengerLog
   VALUE(CURRENT_DATE(),CURRENT_USER(),"Insert");
END;
 
CREATE TRIGGER updateTrigger
BEFORE UPDATE 
ON passenger
FOR EACH ROW
BEGIN
   INSERT INTO passengerLog
   VALUE(CURRENT_DATE(),CURRENT_USER(),"Update");
END;
 
--Delete
CREATE TRIGGER deleteTrigger
BEFORE DELETE
ON passenger
FOR EACH ROW
BEGIN
   INSERT INTO passengerLog
   VALUE(CURRENT_DATE(),CURRENT_USER(),"Delete");
END;


-- (vi) Write a procedure which takes the Journey-date as input parameter and 
-- lists the names of all passengers who are travelling on that date.
CREATE PROCEDURE pas_name(IN date_ DATE)
BEGIN
    SELECT name FROM passenger INNER JOIN reservation ON passenger.pnr_no=reservation.pnr_no
    WHERE reservation.journey_date=date_;
END;


-- (vii) Create a trigger to raise an exception if the PNR_No is changed.
CREATE TRIGGER pnr_change
BEFORE UPDATE 
ON reservation
FOR EACH ROW BEGIN 
    IF NEW.pnr_no!=OLD.pnr_no THEN
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Can't change PNR NO";
    END IF;
END;


-- (viii) Write a function to display the passenger details given the Bus_No.
CREATE PROCEDURE pas_details(IN busNo INT)
BEGIN
    SELECT passenger.* FROM passenger INNER JOIN ticket ON passenger.ticket_no=ticket.ticket_no
    INNER JOIN bus ON bus.bus_no=ticket.bus_no WHERE bus.bus_no=busNo;
END;


-- (ix) Write a procedure to find the total number of tickets books for a given bus-no.
CREATE PROCEDURE no_tickets(IN busNo INT)
BEGIN
    SELECT COUNT(*) FROM bus INNER JOIN ticket ON 
    bus.bus_no=ticket.bus_no WHERE bus.bus_no=busNo;
END;


-- (x) Find all Passenger names with their journey dates and number of seats.
SELECT name,journey_date,no_of_seats FROM passenger INNER JOIN reservation 
ON passenger.pnr_no=reservation.pnr_no;