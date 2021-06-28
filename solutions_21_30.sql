-- 21
select
	maker,
	max(price) as maxPrice
from product
	inner join pc
		on pc.model=product.model
group by maker;

-- 22

-- using two tables
select distinct
	pc_one.speed,
	avg(pc_one.price)
from pc as pc_one,
	 pc as pc_two
where pc_one.speed > 600
	and pc_two.speed > 600
	and pc_one.speed = pc_two.speed
group by pc_one.speed;

-- without two tables
select
	speed,
	avg(price) as avgPrice
from pc
where speed > 600
group by speed;

-- 23
select
	maker
from product
where model in (
	select
		model
	from pc
	where speed >= 750
				)
Intersect
select
	maker
from product
where model in (
	select
		model
	from laptop
	where speed >= 750
				);

-- 24
with all_tables as
	(
	 select price, model from laptop
	 Union
	 select price, model from pc
	 Union
	 select price, model from printer
	 )
select
	model
from all_tables
where price in
	(
	 select
	 	max(price)
	 from all_tables);

-- 25
select distinct
	maker
from product
	inner join 
			(
			select
				model
			from pc
			where speed in
			(
			  select
			  	max(speed)
			  from pc
			  where ram in
				(
				 select
				 	min(ram)
				 from pc
				 ))
				and ram in
				(
				 select
				 	min(ram)
				 from pc)
			) as minRamModel
		on minRamModel.model=product.model
where maker in
	(
	 select
	 	maker
	 from product
	 where type = 'printer');

-- 26

-- using subquery as JOIN
select
	avg(price) as avg_price
from product
	inner join
	(
	 select model, price from pc
	 Union all
	 select model, price from laptop
	 ) as modPr
		on modPr.model=product.model
where maker = 'A';

-- using subquery
select
	avg(price)
from
	(
	 select
	 	price
	 from pc
	 	inner join product
	 		on product.model=pc.model
	 where maker = 'A'
	 Union all
	 select
	 	price
	 from laptop
	 	inner join product
	 		on product.model=laptop.model
	 where maker = 'A') as all_price;

-- 27
select
	maker,
	avg(hd)
from product
	inner join pc
		on pc.model=product.model
where maker in
	(
	 select
	 	maker
	 from product
	 where type in ('printer'))
group by maker;

-- 28

-- at first in subquery group by every
-- maker and take only the ones where
-- 1 model is produced. Then calculate
-- those with 1 model in outer query
select distinct
	count(maker) as makerAmount
from (
	select maker
	from product
	group by maker
	having count(*) = 1
	) as makers;

-- 29

-- using FULL JOIN
select
	case
		when income.point is NULL then outcome.point
		else income.point
	end as point,
	case
		when income.date is NULL then outcome.date
		else income.date
	end as date,
	income.inc as income,
	outcome.out as outcome
from
(
select
	point,
	date,
	sum(inc) as inc
from income_o
group by point, date
) as income
full join
(
select
	point,
	date,
	sum(out) as out
from outcome_o
group by point, date
) as outcome
	on outcome.point=income.point
		and outcome.date=income.date;

-- using LEFT JOIN
select
	income.point as point,
	income.date as date,
	income.inc as income,
	outcome.out as outcome
from income_o as income
	left join outcome_o as outcome
		on outcome.point=income.point
		and outcome.date=income.date
Union
select
	outcome.point as point,
	outcome.date as date,
	income.inc as income,
	outcome.out as outcome
from outcome_o as outcome
	left join income_o as income
		on income.point=outcome.point
		and income.date=outcome.date;
	
-- 30
select
	case
		when income.point is NULL then outcome.point
		else  income.point
	end as point,
	case
		when income.date is NULL then outcome.date
		else  income.date
	end as date,
	outcome.out as outcome,
	income.inc as income
from
(
select
	point,
	date,
	sum(inc) as inc
from income
group by point, date
) as income
full join
(
select
	point,
	date,
	sum(out) as out
from outcome
group by point, date
) as outcome
on outcome.point=income.point
and outcome.date=income.date;
