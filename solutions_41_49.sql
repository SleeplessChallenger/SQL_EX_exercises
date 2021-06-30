-- 41
select distinct
	maker,
	case
		-- to track `NULL` we need it to be `1`
		-- otherwise it'll be difficult to get it
		when max(case
					when inner_query.price is NULL then 1
					else 0
				 end) = 0
		then max(inner_query.price)
		else NULL
	end as price
from
	(
	 select model, price
	 from pc
	 Union
	 select model, price
	 from laptop
	 Union
	 select model, price
	 from printer
	 ) as inner_query
	inner join product
		on product.model=inner_query.model
group by maker;

-- 42
select
	ship,
	battle
from outcomes
where result = 'sunk';

-- 43

-- `is not NULL` is critical
-- as it cuts the ones with `NULL`
select
	name
from battles
where year(date) not in 
	(		
	 select
	 	ships.launched
	 from ships
	 where launched is not NULL
	)

-- 44
select
	name
from ships
where lower(name) like 'r%'
Union
select
	ship
from outcomes
where lower(ship) like 'r%'

-- 45
select
	name
from ships
where lower(name) like '% % %'
Union
select
	ship
from outcomes
where lower(ship) like '% % %'

-- 46
-- Hint: A ship engaged in this battle should be
-- listed even if its class is not known
-- => we need to pick `not NULL` value between
-- `outcomes`/`ships`
-- + here main item is `ship` in `outcomes` table
--  hence we left join to others from `outcomes`

-- first
select
	ship,
	displacement,
	numGuns
from outcomes
	left join ships
		on ships.name=outcomes.ship
	left join classes
		on (classes.class=outcomes.ship
			or
			classes.class=ships.class
			)
where battle = 'Guadalcanal';

-- second
select
	outcomes.ship as ship,
	classes.displacement as displacement,
	classes.numGuns as guns
from outcomes
	left join ships
		on ships.name=outcomes.ship
	left join classes
		on classes.class=coalesce(ships.class, outcomes.ship) 
where battle = 'Guadalcanal';

-- 48

-- here main item is class
-- hence we need left join from classes/ships
-- to outcomes
select
	ships.class as ship_class
from ships
	left join outcomes
		on outcomes.ship=ships.name
		-- .name because all possible classes
		-- are shown in join after Union
where result = 'sunk'
Union
select
	classes.class
from classes
	left join outcomes
		on outcomes.ship=classes.class
where result = 'sunk';

-- 49
select
	ships.name as name
from ships
	left join classes
		on classes.class=ships.class
where bore = 16
Union
select
	outcomes.ship
from outcomes
	left join classes
		on classes.class=outcomes.ship
where bore = 16;
