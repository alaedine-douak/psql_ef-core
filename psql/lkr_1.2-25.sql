
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS file_system;

-- INTERGER DATA TYPES

-- SMALLINT -32768 to +32767  | 2 bytes alias int2
-- INTEGER -2,147,483,648 to +2,147,483,647 | 4 bytes alias int4
-- BIGINT -9,223,372,036,854,775,808 to +9,223,372,036,854,775,807 | 8 bytes alias int8

CREATE TABLE person(
   person_name TEXT,
   age SMALLINT -- int2 
);


CREATE TABLE item(
   item_name TEXT,
   stock int4 -- integer
);

CREATE TABLE file_system(
   file_name TEXT,
   file_size BIGINT -- int8
);

INSERT INTO person(person_name, age) VALUES
('Alice', 30),
('Bob', 42),
('Charlie', 19);

INSERT INTO person(person_name, age) VALUES 
('Robot', 44000); -- This will cause an error because 44000 is out of range for SMALLINT


SELECT * FROM person;


--

CREATE TABLE post(
   description TEXT,
   interest_rate NUMERIC -- DECIMAL | numeric & decimal are the same
);

SELECT 123456798123456798123456798::BIGINT; -- This will cause an error because the number is out of range for BIGINT
 
SELECT 123456798123456798123456798::NUMERIC;
SELECT 123456798123456798123456798.2165432::NUMERIC;


-- 12.345 / precision 5, scale 3

SELECT 12.345::NUMERIC(5, 3); -- total 5 digits, 3 after decimal point
SELECT 121.345::NUMERIC(5, 3); -- This will cause an error because total digits exceed precision 
SELECT 12.345::NUMERIC(5, 2); -- 12.35 
SELECT 12122.345::NUMERIC(5); -- 12122
SELECT 121221.345::NUMERIC(5, -2); -- 121200
