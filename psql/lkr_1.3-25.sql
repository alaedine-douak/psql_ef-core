-- binary data

-- used to store raw binary data (a sequence of bytes). use it when the data is not text and should be treated as binary
-- -> bytea is?
-- stores arbitrary data (image, files, encrypted bytes, hashes, etc.)
-- length can be up to 1 GB (not recommended to store very large data directly in db)
-- data is stored and retrived as bytes, not characters


-- 1. storing small bunary files (user avatars, thumbnails / pdfs, small documents / audio snippets / binary configuration blobs) 
--- use bytea when files are small to medium-sized and tightly coupled to row.

-- 2. cryptographic data (hashes, digital signatures, encryption keys, salts)  

drop table if exists document;

create table document (
   file_name varchar(255),
   content bytea
);

select 'content'::bytea;

insert into document (file_name, content)
values ('exmple.txt', '\x636f6e74656e74');

show bytea_output;

set bytea_output = 'hex';

set bytea_output = 'escape';

select * from document;

select pg_typeof(content) 
from document;

select pg_column_size(content) 
from document; -- 8 bytes


select md5('ala'); -- e88e6128e26eeff4daf1f5db07372784 is less secure, or let's say not suitable for cryptographic purposes
select pg_typeof(md5('ala')); -- type is text

select sha256('ala'); -- 0x5D530613969FEAC08946E3...

select pg_typeof(sha256('ala')); -- type is bytea

select decode(md5('ala'), 'hex'),
pg_typeof(decode(md5('ala'), 'hex')); -- type is bytea

select pg_column_size(decode(md5('ala'), 'hex')), -- 20
pg_column_size(md5('ala'));  -- 36

select md5('ala')::uuid, -- e88e6128-e26e-eff4-daf1-f5db07372784
pg_typeof(md5('ala')::uuid), -- uuid
pg_column_size(md5('ala')::uuid); -- 16

select md5('ala'), -- e88e6128e26eeff4daf1f5db07372784
md5('ala')::uuid, -- e88e6128-e26e-eff4-daf1-f5db07372784
md5('ala')::bytea; -- e88e6128e26eeff4daf1f5db07372784

select pg_typeof(md5('ala')), -- text
pg_typeof(md5('ala')::uuid), -- uuid
pg_typeof(md5('ala')::bytea); -- bytea


select pg_column_size(md5('ala')), -- 36
pg_column_size(md5('ala')::uuid), -- 16
pg_column_size(md5('ala')::bytea); -- 36


--- 

-- uuid

-- uuid is a native data type in pg used to store universally Unique Identifiers.
-- stored more effeciently than text
-- 128-bits value (16 bytes)

-- uuid versions:

-- uuid v4 (random) -> gen_random_uuid()
-- uuid v7 (time-ordered) 

drop table if exists orders;

create table orders(
   product_id uuid
);

insert into orders(product_id) 
values ('550e8400-e29b-41d4-a716-446655440000');

select gen_random_uuid(); -- generate random uuid

insert into orders(product_id)
values (gen_random_uuid()),
(gen_random_uuid());


select
   product_id,
   pg_typeof(product_id),
   pg_column_size(product_id)
from orders;

select
   product_id,
   pg_column_size(product_id::text), -- 40
   pg_column_size(product_id) -- 16
from orders;


---

-- boolean

drop table if exists boolean_example;

create table boolean_example(
   status boolean
);

insert into boolean_example(status) values
(TRUE), 
(FALSE),
('true'),
('false'),
('1'),
('0'),
('t'),
('f'),
('on'),
('off'),
(NULL); -- null essentially means unknown / missing value


select * from boolean_example;

select 1::boolean;
select '1'::boolean;

select pg_typeof(1::boolean), pg_typeof(1::integer);

select pg_column_size(1::boolean),
pg_column_size(1::integer);

---

-- enum

-- stored as an interger.


create type mood as enum ('sad', 'ok', 'happy');

create table person (
   name text,
   current_mood mood
);

insert into person (name, current_mood) values
('Alice', 'happy'),
('Bob', 'sad'),
('Charlie', 'ok');

select * from person;

-- The ordering of the values in an enum type is the order in which the values were listed when the type was created

select * from person order by current_mood;

create type size_type as enum (
   'x-small',
   'small',
   'medium',
   'large',
   'x-large'
);

drop table if exists tshirts;

create table tshirts (
   size size_type,
   price numeric
);

insert into tshirts (size, price) values
('medium', 19.99),
('large', 21.99),
('small', 17.99),
('x-large', 23.99),
('x-small', 15.99);

select * from tshirts order by size;

insert into tshirts (size, price) values
('medium', 18.99);

insert into tshirts (size, price) values
('xx-large', 25.99); -- error: invalid input value for enum size_type: "xx-large"

alter type size_type add value 'xx-large';

alter type size_type add value 'medium-plus' before 'large';

insert into tshirts (size, price) values
('medium-plus', 20.99);

-- removing value from enum is not supported directly. 
-- need to create new type, migrate data, drop old type, rename new type.

create type size_type2 as enum (
   'xs',
   's',
   'm',
   'l',
   'xl',
   'xxl'
);

alter table tshirts 
alter column size type size_type2
using 
case size
   when 'x-small' then 'xs'::size_type2
   when 'small' then 's'::size_type2
   when 'medium' then 'm'::size_type2
   when 'large' then 'l'::size_type2
   when 'x-large' then 'xl'::size_type2
   when 'xx-large' then 'xxl'::size_type2
end;

drop type size_type;

alter type size_type2 rename to size_type;

alter type mood add value 'afraid' before 'ok';
alter type mood add value 'melancholic' before 'ok';
alter type mood add value 'anxious' after 'sad';

select * from pg_catalog.pg_enum;

select * from pg_catalog.pg_enum where enumtypid = '16553' order by enumsortorder;

alter type mood rename value 'ok' to 'neutral';

select enum_range(null::mood); -- {sad,anxious,afraid,melancholic,neutral,happy}

select enum_range('anxious'::mood, 'neutral'::mood); -- {anxious,afraid,melancholic,neutral}