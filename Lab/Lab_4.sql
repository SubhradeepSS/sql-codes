-- Patient (P_ID, Pat_Name, Sex, Age, Address, H_ID)
-- Test_Results (T_ID, P_ID, H_ID, Reporting_date, Test_result, Discharge_date)
-- Hospital (H_ID, Hosp_Name, Location, State, T_ID)


CREATE TABLE patient (
    p_id INT PRIMARY KEY,
    pat_name VARCHAR(255),
    sex VARCHAR(255),
    age INT,
    address VARCHAR(255),
    h_id INT 
);

CREATE TABLE hospital (
    h_id INT PRIMARY KEY,
    hosp_name VARCHAR(255),
    location VARCHAR(255),
    state VARCHAR(255),
    t_id INT 
);

CREATE TABLE test_results (
    t_id INT PRIMARY KEY,
    p_id INT,
    h_id INT,
    reporting_date DATE,
    test_result VARCHAR(255),
    discharge_date DATE,
    FOREIGN KEY (p_id) REFERENCES patient(p_id) ON DELETE CASCADE,
    FOREIGN KEY (h_id) REFERENCES hospital(h_id) ON DELETE CASCADE
);


INSERT INTO patient VALUES 
(1,"A","Male",25,"XYZ",1),
(2,"B","Female",35,"XZ",3),
(3,"C","Male",45,"YZ",2),
(4,"D","Female",55,"XY",1),
(5,"E","Male",65,"XYZabc",2),
(6,"F","Female",75,"abcd",3);

INSERT INTO hospital VALUES
(1,"ABC","PQ","RS",1),
(2,"DEF","PQ","RS",3),
(3,"GHI","PQ","RS",5);

INSERT INTO test_results VALUES
(1,1,1,"2020/06/12","Positive","2020/06/27"),
(2,2,3,"2020/06/27","Negative","2020/06/27"),
(3,3,2,"2020/06/12","Positive","2020/06/27"),
(4,4,1,"2020/06/27","Negative","2020/06/27"),
(5,5,2,"2020/06/12","Positive","2020/06/27"),
(6,6,3,"2020/06/27","Negative","2020/06/27");

ALTER TABLE patient
ADD FOREIGN KEY (h_id) REFERENCES hospital(h_id) ON DELETE CASCADE;

ALTER TABLE hospital
ADD FOREIGN KEY (t_id) REFERENCES test_results(t_id) ON DELETE CASCADE;



-- 1: Create a procedure to display the details of a patient 
-- record for a given Patient ID
CREATE PROCEDURE patient_details (IN pid INT)
BEGIN
    SELECT * FROM patient WHERE p_id=pid;
END;


-- 2: Create a procedure to add details of a new patient record 
-- into Patient table.
CREATE PROCEDURE add_patient (
    IN p_id INT, IN pat_name VARCHAR(255), IN sex VARCHAR(255), 
    IN age INT, IN address VARCHAR(255), IN h_id INT
    )
BEGIN 
    INSERT INTO patient VALUES
    (p_id, pat_name, sex, age, address, h_id);
    SELECT * FROM patient;
END;


-- 3: Write a procedure that lists the highest cases reported in a 
-- district of any particular state.
-- Use the procedure named Find_highest which finds the highest cases 
-- for the given State
CREATE PROCEDURE find_highest (IN state_ VARCHAR(255))
BEGIN
    SELECT Location, COUNT(*) FROM Hospital
    NATURAL JOIN test_results WHERE state=state_ AND test_result="Positive"
    GROUP BY Location ORDER BY COUNT(*) DESC LIMIT 1;
END;


-- 4: Write a procedure to list the hospital, which has fastest recovery.
CREATE PROCEDURE fastest_recovery()
BEGIN
    SELECT h_id, hosp_name FROM test_results
    NATURAL JOIN Hospital WHERE
    test_result="Positive" AND DATEDIFF(discharge_date, reporting_date) = (
        SELECT MIN(DATEDIFF(discharge_date, reporting_date)) 
        FROM test_results WHERE test_result="Positive"
    );
END;


-- 5. Create a procedure to delete a record from Patient table, 
-- if the Test result is NEG. 
-- It uses the Hospital ID of a patient for delete a record in 
-- Test_Results and Patient table.
CREATE PROCEDURE del_patient (IN pid INT)
BEGIN
    DELETE FROM patient WHERE p_id IN (
        SELECT p_id FROM test_results 
        WHERE p_id=pid AND test_result="Negative"
    );
END;


-- 6. Write a function to display the patient details from 
-- the Patient table.
CREATE FUNCTION show_patients(pid INT) RETURNS 
VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE ans VARCHAR(255);
    SELECT pat_name FROM patient WHERE p_id=pid INTO ans;
    RETURN ans;
END;


-- 7. Write a function to list the state, which has reported 
-- with maximum child COVID cases.
CREATE FUNCTION max_child_cases() RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE name VARCHAR(255);
    SELECT hospital.state INTO name FROM hospital h 
    INNER JOIN test_results t ON h.h_id=t.h_id
    WHERE COUNT(h.h_id) IN (
            SELECT COUNT(h_id) FROM test_results DESC LIMIT 1
        );
    RETURN name;
END;


-- 8. Write a function to find the hotpot area in a district 
-- based on the Test results.
CREATE FUNCTION hotspot(state_ VARCHAR(255)) RETURNS
VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE ans VARCHAR(255);
    SELECT DISTINCT hospital.location INTO ans FROM hospital h 
    NATURAL JOIN test_results t
    WHERE h.state=state_ AND COUNT(h.h_id) IN (
            SELECT COUNT(DISTINCT(h_id)) FROM test_results 
            NATURAL JOIN hospital h2
            WHERE h2.state = state_ ORDER BY DESC LIMIT 1 
        );
    RETURN ans;
END;


-- 9. Write a function to display total number of male and 
-- female patients tested for COVID 
-- of which how many are reported with positive in a particular state.
CREATE FUNCTION show_positive_count(gender VARCHAR(255))
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT;
    SELECT COUNT(*) FROM test_results 
    WHERE test_result="Positive" AND p_id IN (
        SELECT p_id FROM patient WHERE sex=gender
    ) INTO ans;
    RETURN ans;
END;


-- 10. Write a function to display the average days 
-- for the recovery of child, adults and 
-- senior citizen of a particular hospital.
CREATE FUNCTION avg_days(age_group VARCHAR(30))
RETURNS DATETIME DETERMINISTIC
BEGIN
    DECLARE ans DATETIME ;
    IF age_group='child' THEN
        SELECT AVG(discharge_date)-AVG(reporting_date) INTO ans
        FROM hospital h INNER JOIN test_results t 
        ON h.h_id=t.h_id WHERE t.t_id IN (
                SELECT T.t_id FROM test_results T
                INNER JOIN patient p ON p.t_id=T.t_id
                WHERE p.Age<18
            );
    ELSE IF age_group='senior citizen' THEN
        SELECT AVG(discharge_date)-AVG(reporting_date) INTO ans 
        FROM hospital h
        INNER JOIN test_results t ON h.h_id=t.h_id WHERE t.t_id IN (
                SELECT T.t_id FROM test_results T
                INNER JOIN patient p ON p.t_id=T.t_id
                WHERE p.Age>60
            );
    ELSE
        SELECT AVG(discharge_date)-AVG(reporting_date) INTO ans
        FROM hospital h INNER JOIN test_results t 
        ON h.h_id=t.h_id WHERE t.t_id IN (
                SELECT T.t_id FROM test_results T
                INNER JOIN patient p ON p.t_id=T.t_id
                WHERE p.Age>18 AND p.Age<60
            );
    END IF;
    RETURN ans;
END;