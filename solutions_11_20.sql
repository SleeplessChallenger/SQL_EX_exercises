-- 11
select
	avg(speed)
from pc;

-- 12
select
	avg(speed)
from laptop
where  price > 1000;

-- 13
select
	avg(speed)
from pc
	inner join product
		on product.model=pc.model
where maker = 'A';

-- 14
select distinct
	ships.class,
	ships.name,
	classes.country
from ships
	inner join classes
		on classes.class=ships.class
where classes.numGuns >= 10;

-- 15
select
	hd
from pc
group by hd
having count(*) >= 2;

-- 16
select distinct
	pc_one.model,
	pc_two.model,
	pc_one.speed,
	pc_one.ram
from pc as pc_one,
	 pc as pc_two
where pc_one.model > pc_two.model
	and pc_one.speed = pc_two.speed
	and pc_one.ram = pc_two.ram;

-- 17
select distinct
	type,
	laptop.model,
	speed
from laptop
	inner join product
		on product.model=laptop.model
where speed < all (
	select
		speed
	from pc);

-- 18
select distinct
	product.maker,
	printer.price
from product
	inner join printer
		on printer.model=product.model
where price in 
	(
	 select
	 	min(price)
	 from printer
	 where color = 'y')
	and color = 'y';

-- 19
select
	product.maker,
	avg(screen)
from product
	inner join laptop
		on laptop.model=product.model
group by product.maker;

-- 20
select
	maker,
	count(*) as num_models
from product
where type = 'pc'
group by maker
having count(*) >= 3;
