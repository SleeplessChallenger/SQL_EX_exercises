-- 50
select
	battle
from outcomes
	inner join ships
		on ships.name=outcomes.ship
where ships.class = 'Kongo'

-- 51

-- using subqueries and JOIN on displacement & numGuns
select
	name
from 
	(
	select
		ships.name as name,
		displacement,
		numGuns as guns
	from ships
		inner join classes
			on classes.class=ships.class
	Union
	select
		outcomes.ship,
		displacement,
		numGuns
	from outcomes
		inner join classes
			on classes.class=outcomes.ship
	) as main_data
	inner join 
		(
		select
			displacement,
			max(numGuns) as guns
		from (
		select displacement, numGuns
		from ships
			inner join classes
				on classes.class=ships.class
		Union
		select displacement, numGuns
		from outcomes
			inner join classes
				on classes.class=outcomes.ship
			) as inner_query
		group by displacement
		) as other_data
		on other_data.guns=main_data.guns
			and other_data.displacement=main_data.displacement

-- with CTE
with all_data as
	(
	select class, name
	from ships
	Union
	select ship, ship
	from outcomes)
select
	name
from all_data
	inner join classes as cl
		on cl.class=all_data.class
where cl.numGuns >= all (
						select
							numGuns
						from classes
						where  classes.displacement=cl.displacement
							and classes.class in
								(
								 select
								 	class
								 from all_data));

-- 52
-- In Russian version there is 'may be' addition
-- which means that some of the conditions may
-- may be missing and we need to include it
-- by implementing `NULL`

select
	case
		when ships.name is NULL
		then ships.class
		else ships.name
	end as name
from ships
	inner join classes
		on classes.class=ships.class
where country = 'Japan'
	and (bore < 19 or bore is NULL)
	and (displacement <= 65000 or displacement is NULL)
	and  type = 'bb'
	and (numGuns >= 9 or numGuns is NULL);

-- 53
select
	cast(avg(numGuns*1.0) as dec(6,2)) as avg_numGuns
from classes
where type = 'bb';

-- 54
-- In this task we need to return `battleships`
-- and not `class`, that's why we're at first
-- to unite all the data and only after that
-- apply conditions
select
	cast(avg(numGuns*1.0) as dec(6,2)) as numGuns
from (
		select numGuns, type, name
		from classes
			inner join ships
				on ships.class=classes.class
		Union
		select numGuns, type, ship
		from classes
			inner join outcomes
				on outcomes.ship=classes.class
	) as all_ships
where all_ships.type = 'bb';

-- 55
select
	classes.class as class,
	min(launched) as date
from classes
	left join ships
		on ships.class=classes.class
group by classes.class;

-- 56
select
	classes.class as class,
	count(all_data.ships_data) as numShips
from classes
	left join 
		(
		 select
		 	coalesce(ships.class,
		 			 outcomes_inner.ship)
		 	as ships_data
		 from (
		 		select
		 			ship
		 		from outcomes
		 		where result = 'sunk'
		 	  ) as outcomes_inner
		 left join ships
		 	on ships.name=outcomes_inner.ship
		) as all_data
		on all_data.ships_data=classes.class
group by classes.class;

-- 57
select
	classes.class as class,
	sum(all_data.sunked) as sunked_ships
from classes
	left join
		(
		select
			all_ships.class as all_classes,
			all_ships.name as all_names,
			case
				when result = 'sunk'
				then 1
				else 0
			end as sunked
		from (
				select class, name from ships
				Union
			 	select ship, ship from outcomes
			) as all_ships
		left join outcomes
			on outcomes.ship=all_ships.name
		) as all_data
		on all_data.all_classes=classes.class
group by class
having count(distinct all_data.all_names) >= 3
	and sum(all_data.sunked) > 0;

-- 58
select
	main_maker,
	main_type,
	CONVERT(NUMERIC(6,2),((sub1*100.00)/(total_num*100.00)*100.00))  
from 
	(
		select
			count(p5.model) total_num,
			p5.maker main_maker 
		from product p5
		group by p5.maker) p6 
			JOIN (select p3.maker sub_maker,
						 p3.type main_type,
						 count(p4.model) sub1
				  	from (select
				  			p1.maker maker,
				  			p2.type type
				  		  from product p1
				  		  	cross join product p2
				  		  group by p1.maker, p2.type) p3 
					Left join product p4
						on p3.maker = p4.maker
							and p3.type = p4.type
					group by p3.maker,p3.type) p7 
				ON p7.sub_maker = p6.main_maker
