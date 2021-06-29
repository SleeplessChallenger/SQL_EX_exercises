-- 31
select
	class,
	country
from classes
where bore >= 16;

-- 32

-- we need A & B as we use `Union`
-- probably, we need 4 columns when using `Union`
-- so as to eliminate all duplicates and pick from
-- solely unique rows

with all_ships as
	(
	select
		country,
		bore,
		classes.class, -- A
		ships.name -- A
	from classes
		inner join ships
			on ships.class=classes.class
	Union
	select
		country,
		bore,
		classes.class, -- B
		outcomes.ship -- B
	from classes
		inner join outcomes
			on outcomes.ship=classes.class
	)
select
	country,
	cast(avg((power(bore,3)/2)) as numeric(6,2)) as weight
from all_ships
group by country;

-- 33
select
	ship
from outcomes
where result = 'sunk'
	and battle = 'North Atlantic';

-- 34
select
	name
from ships
	inner join classes
		on classes.class=ships.class
	-- inner join outcomes
	-- 	on outcomes.ship=ships.class
where launched is not NULL
	and launched >= 1922
	and displacement > 35000
	and type = 'bb';

-- 35
select
	model,
	type
from product
where lower(model) not like '%[^A-Z]%'
	or lower(model) not like '%[^0-9]%';

-- 36
select
	classes.class as main_ship
from classes
	inner join ships
		on ships.name=classes.class
Union
select
	outcomes.ship
from outcomes
	inner join classes
		on classes.class=outcomes.ship;

-- 37

-- probably, we need 4 columns when using `Union`
-- so as to eliminate all duplicates and pick from
-- solely unique rows

--  with subquery
select
	class
from
	(
	select
		classes.class as class,
		ships.name
	from  classes
		inner join ships
			on ships.class=classes.class
	Union
	select
		outcomes.ship,
		classes.class
	from outcomes
		inner join classes
			on classes.class=outcomes.ship
	) as all_classes
group by class
having count(*) = 1;

-- with CTE
with all_classes as
	(
	 select
	 	classes.class as class,
	 	ships.name as secondary_column
	 from classes
	 	inner join ships
	 		on ships.class=classes.class
	 Union
	 select
	 	classes.class,
	 	outcomes.ship
	 from classes
	 	inner join outcomes
	 		on outcomes.ship=classes.class
	 )
select
	class
from all_classes
group by class
having count(*) = 1;

-- 38

-- using Intersect
select distinct
	country
from classes
where type = 'bb'
Intersect
select distinct
	country
from classes
where  type = 'bc';

-- using subqueries
select distinct
	country
from classes
where country in 
	(
	select distinct
		country
	from classes
	where type = 'bb'
	) 
and country in
	(
	 select distinct
		country
	from classes
	where  type = 'bc'
	);

-- 39
select distinct
	ship
from outcomes
	inner join battles as a
		on a.name=outcomes.battle
where outcomes.ship in
	(
	 select
	 	ship
	 from outcomes
	 	inner join battles as b
	 		on b.name=outcomes.battle
	 where result = 'damaged'
	 	and b.date < a.date
	);

-- 40
select distinct
	maker,
	type
from product
where maker in
	(
	  select
	  	maker
	  from product
	  group by maker
	  having count(distinct type) = 1
		and count(model) > 1
	);
