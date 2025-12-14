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

