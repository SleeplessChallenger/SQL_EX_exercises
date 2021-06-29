-- 1
select
	model,
	speed,
	hd
from pc
where price < 500;

-- 2
select distinct
	maker
from product
where type = 'Printer';

-- 3
select
	model,
	ram,
	screen
from laptop
where price > 1000;

-- 4
select *
from printer
where color = 'y';

-- 5
select
	model,
	speed,
	hd
from pc
where price < 600
	and cd in ('12x', '24x');


-- 6
select distinct
	product.maker,
	laptop.speed
from product
	inner join laptop
		on laptop.model=product.model
where hd >= 10;

-- 7

-- with JOIN and subquery
select
	product.model,
	inner_query.price
from product
	inner join 
	(
	select price, model from pc
	Union
	select price, model from laptop
	Union
	select price, model from printer
	) as inner_query
		on inner_query.model=product.model
where maker = 'B';

-- with CTE and JOIN
with inner_query as
(
select price, model from pc
Union
select price, model from laptop
Union
select price, model from printer
)
select
	product.model,
	inner_query.price
from product
	inner join inner_query
		on inner_query.model=product.model
where product.maker = 'B';

-- 8
select distinct
	maker
from product
where type = 'pc'
	and maker not in
	(select
		maker
	from product
	where type = 'laptop'
		);

-- 9
select distinct
	maker
from product
	inner join pc
		on pc.model=product.model
where speed >= 450;

-- 10
select distinct
	model,
	price
from printer
where price in
	(select
		max(price)
	from printer
		);
