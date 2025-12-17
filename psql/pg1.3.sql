

-- network & mac addresses

-- INET

-- it's native postgres dt for storing IP ADDRESSES (IPv4, IPv6)
-- can also store network mask

-- pg understands IPs semantically, not as string 
-- IPv4 validation, IPv6 support, network comparison, index optimization, subnet operations

create table user_sessions (
   id bigint generated always as identity primary key,
   ip_address inet
);


insert into user_sessions (ip_address)
values
('192.168.1.9/24'), -- host address with subnet mask
('10.0.0.10'), -- host address without subnet
('::1/128'), -- ipv6 loopback address
('2001:db8::/32'), -- ipv6 network
('2001:db8:85a3:8d3:1319:8a2e:370:7348'); -- ipv6 host address

select * from user_sessions;

select 
pg_column_size('2001:db8:85a3:8d3:1319:8a2e:370:7348'::inet), -- 22
pg_column_size('2001:db8:85a3:8d3:1319:8a2e:370:7348'::text); -- 40

select ip_address,
host(ip_address),
masklen(ip_address),
network(ip_address),
abbrev(ip_address)
from user_sessions;

-- cidr

-- it's pg data type for storing IP networks (subnets), not individual hosts.
-- it's deal when we care about network boundaries (firewall, allowlists, routing rules).

-- ! host bits must be zeros ! 

-- stores IPv4 or IPv6 network addresses 

-- inet vs cidr
-- inet represents hosts / cidr represents networks
-- cidr enforces network bits & firewall / routing rules | inet client ip storage

drop table if exists company;

create table company (
   id bigint generated always as identity primary key,
   network_address cidr
);

insert into company (network_address) 
values ('192.168.0.0/24'), 
('10.0.0.0/8'), 
('2001:db8::/48');

select * from company;

select 
network_address, 
network(network_address), 
masklen(network_address),
broadcast(network_address)
from company;

-- macaddr

-- macaddr type store MAC addresses.

select '08:00:2b:01:02:03'::macaddr, pg_column_size('08:00:2b:01:02:03'::macaddr); -- 6 bytes
select '08:00:2b:01:02:03'::macaddr8, pg_column_size('08:00:2b:01:02:03'::macaddr8); -- 8 bytes