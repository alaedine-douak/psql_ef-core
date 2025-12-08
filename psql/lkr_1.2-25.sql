
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
   interest_rate NUMERIC -- decimal | numeric & decimal are the same
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


-- 

drop table temperature_sensor;

-- real - 4 bytes - 6 digits after decimal point of precision / alias float4 | float(1-24)
-- double precision - 8 bytes - 15 digits after decimal point of precision | alias float8 | float(25-53)

-- they're fast but less precise/they can loss precision (less precise than numeric/decimal)

create table temperature_sensor(
   sensor_name text,
   reading float(23)
);

select * from generate_series(1, 20) num;


select
   sum(num::double precision  / (num + 1))::double precision
from 
   generate_series(1, 5000000) num;

select
   sum(num::numeric / (num + 1))::numeric
from 
   generate_series(1, 5000000) num;


--

-- store meney in database
-- money data type not recommended
-- floating-points are not precise so they're out 
-- so,

-- 1. store money in integer (cents | lowest units in the currency)
select (100.99 * 100)::int4 as cents;
select (100.99 * 10000)::int4 as thousandth_cents;

-- 2. store money in numeric/decimal
select (100.99)::numeric as price;
select (100000.99)::numeric(10, 4) as price;
select (10000000.99)::numeric(10, 2) as price;

--

-- NaN
-- Infinity | Inf

-- 
-- casting

select 100::money;

select cast(100 as money);

select pg_typeof(100::int4);
select pg_typeof(100::float(43));

select pg_typeof(100::int8) as bigint, pg_typeof(cast(100 as int4)) as integer;

select integer '100';

select int8 '100';
select pg_typeof(int8 '100');

select 
   pg_column_size(100::int2),
   pg_column_size(100::int4),
   pg_column_size(100::int8),
   pg_column_size(1214321.21333::numeric);

--

-- character types

create table char_example(
   ch char(4) -- character | char -> fixed length, if input is less than defined length, it'll be padded with spaces
);

insert into char_example(ch) values ('ab');

select ch, char_length(ch) from char_example;

-- varchar | character varying -> variable length, no padding with spaces

create table varchar_example(
   username character varying
);

insert into varchar_example(username) values ('username_example');

select username, char_length(username) from varchar_example;

create table varchar_length_example(
   username character varying(10)
);

insert into varchar_length_example(username) values ('user1');

select username, char_length(username) from varchar_length_example;

-- text -> variable unlimited length

-- check constraint

drop table check_example;

create table check_example(
   -- column level constraints
   price numeric constraint price_must_be_positive check (price > 0),
   abbr text check (length(abbr) = 5)
);

create table check_example(
   price numeric check (price > 0),
   discount_price numeric check (discount_price > 0),
   abbr text,
   -- table level constraints 
   check (length(abbr) = 5),
   constraint valid_discount check (discount_price < price)
);

insert into check_example(price, discount_price, abbr) values (3, 1, 'foooo');

select * from check_example;

--

-- domain constraints
-- 02133
-- 09871-6543

drop table addr_example;
drop domain if exists us_postal_code;

create domain us_postal_code as text constraint format_check
check (
   value ~ '^\d{5}$'
   or value ~ '^\d{5}-\d{4}$'
);

create table addr_example(
   street text,
   postal_code us_postal_code
);

insert into addr_example(street, postal_code) values ('main st', '02133-9811');

select * from addr_example;

