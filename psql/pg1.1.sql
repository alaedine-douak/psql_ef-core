

-- timestamp 

-- timestamp is equivalent to timestamptz without time zone 

create table tm_example (
   id serial primary key,
   created_at timestamp
   -- created_at timestamptz
);

insert into 
   tm_example (created_at)
values 
   (now()::timestamp),
   (now()::timestamp);

--  1 | 2025-12-17 05:01:26.973015
--  2 | 2025-12-17 05:01:26.973015

insert into 
   tm_example (created_at)
values 
   (now());

-- 3 | 2025-12-17 05:09:53.343682


-- timestamp precision (0 - 6)
-- timestamp accetps optional precision value which specifies the number of fractional digits retained in the seconds field.

select now()::timestamp(2); -- 2025-12-17 04:47:52.28

select now()::timestamp(3); -- 2025-12-17 04:47:52.287

select now()::timestamp;  -- 2025-12-17 04:47:52.287622

select 
   now()::timestamp, -- 2025-12-17 04:56:01.811289
   now()::timestamp(0), -- 2025-12-17 04:56:02
   now()::timestamp(1), -- 2025-12-17 04:56:01.8
   date_trunc('second', now()::timestamp); -- 2025-12-17 04:56:01


-- date_trunc function with timestamp

-- it removes the smaller time units and returns the timestamp truncated to the specified precision.

select
   date_trunc('second', now()::timestamp), -- 2025-12-17 05:14:09
   date_trunc('minute', now()::timestamp), -- 2025-12-17 05:14:00
   date_trunc('hour', now()::timestamp), -- 2025-12-17 05:00:00
   date_trunc('day', now()::timestamp), -- 2025-12-17 00:00:00
   date_trunc('year', now()::timestamp); -- 2025-01-01 00:00:00


-- ISO 8601 format

show DateStyle; -- ISO, MDY(month-Day-Year)

select '1-1-2026'::date; -- 2026-01-01

select '2026-1-1'::date; -- 2026-01-01

select '1/3/2026'::date; -- 2026-01-03  

set datestyle = 'ISO, DMY';

select '1/3/2026'::date; -- 2026-03-01 

set datestyle = 'SQL, DMY'; -- (sql is the output format)

select '1-2-2012'::date; -- 01/02/2012

set datestyle = 'German, DMY'; 

select '1-2-2012'::date; -- 01.02.2012


select to_timestamp(1694793600), pg_typeof(to_timestamp(1694793600)); -- 15.09.2023 16:00:00 UTC | timestamp with time zone


-- timezones

show time zone;

set time zone 'America/Chicago'; -- set time zone for this session, whenever restart session time zone will set database time zone

alter database demos set time zone 'America/Chicago';

show config_file; -- set time zone in configuration file



set time zone 'UTC';
show time zone; -- UTC

select now(); -- 2025-12-17 06:23:00.886409+00

select '2024-01-31 11:30:08'::timestamptz; -- 2024-01-31 11:30:08+00 (+00 timezone utc)

-- pg always stores the value internally in UTC
-- converts on input from your time zone to UTC
-- converts on putput to the session time zone

set time zone 'Africa/Algiers';

select now(); -- 2025-12-17 07:24:54.830054+01


set time zone 'America/Chicago';

select '2025-12-17 07:24:54.830054+01'::timestamptz -- 2025-12-17 00:24:54.830054-06

select pg_timezone_abbrevs();

select pg_timezone_names();

select * from pg_timezone_names() where name like '%Algiers'; -- Africa/Algiers / posix/Africa/Algiers

select 
   '2025-12-17 07:24:54'::timestamptz as utc, -- 2025-12-17 07:24:54+00
   '2025-12-17 07:24:54'::timestamptz at time zone 'America/Chicago' as usa_chicago, -- 2025-12-17 01:24:54
   '2025-12-17 07:24:54'::timestamptz at time zone '-06:00' as hour_offset, -- NOTE: use opposite +06.00 or use interval 
   '2025-12-17 07:24:54'::timestamptz at time zone interval '-06:00' as interval_offset, -- 
   pg_typeof('2025-12-17 07:24:54'::timestamptz at time zone 'America/Chicago'); -- timestamp without time zone


-- date / time

create table date_ex ( 
   date_x date 
);

show datestyle; 'iso, mdy' 

select '3/1/2021'::date; -- 2021-03-01

show time zone; -- America/Chicago

select now()::time; -- 01:21:56.149018
select now()::timetz(0); -- 01:19:54-06 - The time zone is set to 'America/Chicago'

select current_date - 1;  -- yesterday

select current_date + 2; -- after tomorrow

select localtime; -- 01:32:42.652291

select localtime::timetz; -- 01:36:09.395214-06

select localtimestamp; -- 2025-12-17 01:34:42.450813

select current_time(0) at time zone 'Africa/Algiers'; -- 08:32:57+01

select current_timestamp at time zone 'Africa/Algiers'; -- 2025-12-17 08:33:13.947168


-- intervals

-- interval represnts a duration of time (not a point in time) -> How much time? not when?
-- interval stores a timespan (3 days, 2 hours 30 minutes, etc.)

-- use inteval to:
--- add or substract time from timespams
--- measure durations
--- define expiration times, delays, retnetion periods
--- perform date arithmetic safely

set time zone 'UTC';


show intervalstyle;

select interval '3 days';

select '1 year'::interval; -- 1 year
select '1 year 2 months'::interval; -- 1 year 2 months 
select '1 year 2 months 3 days 07:23:12'::interval; -- 1 year 2 months 7 hours 23 minutes 12 seconds

select 'P0001-02-04T03:12:11'::interval -- 1 year 2 mons 4 days 03:12:11

select '124441'::interval;

select interval '124441' second to day;

select interval '1' year; -- 1 year

select interval '1-5' year to month; -- 1 year 5 month

set intervalstyle = 'iso_8601'; -- convert the output style

select '1 year'::interval; -- P1Y
select '1 year 2 days'::interval; -- P1Y2D
select '1 year 2 days'::interval; -- P1Y2D

select '1 year 2 days 08:46:21'::interval; -- P 1Y2D T 8H46M21S

select 
now() as current_time, -- 2025-12-17 08:12:59.291973+00
now() + interval '7 days' as next_week; -- 2025-12-24 08:12:59.291973+00

select current_date + interval '30 days'; -- 2026-01-16 00:00:00

select (current_date + interval '30 days')::date; -- 2026-01-16

select interval '2 days' + interval '1 month 3 days'; -- 1 months 5 days