
-- Create and use Amazon database -- 
create database Amazon;
use Amazon;

-- create another company table --
create table company(
brand varchar(50) ,
founder varchar(50),
founded date,
company_type varchar(20),
headquater varchar(20)
);

insert into company values('vivo','Shen wei','2009-05-22','Private','China'),
('Xiaomi','Lei jun , Lin bin','2010-04-06','public','China'),
('Infinix','Transsion heldings','2013-07-05','subsidiany','China'),
('OPPO','Tony chen','2004-10-10','public','China'),
('HTC','cher wonge , H.T.cho , Peter chou','1997-05-15','Public','Taiwan'),
('IQOO','shen wei','2019-01-30','Subsidiany','China'),
('Google Pixel','larry page , sergey brin','2013-02-21','Public','USA'),
('LG','Koo in hwoi','1958-10-01','Public','South Koria');

insert into company values('ASUS','Ted hsu , M.T. liao','1989-04-02','Public','Taiwan'),
('realme','Sky li','2018-05-04','Private','China'),
('GIONEE','Liu Lirong','2022-01-01','Private','China'),
('Nokia','Fredrik , Leo mechelin , E.Polon','1865-05-12','Public','Finland'),
('Apple','Steve Jobs','2007-06-29','Public','USA'),
('SAMSUNG','Lee Byung-chul','1938-03-01','Private','South Koria'),
('Lenovo','Liu Chuanzhi , Danny Lui','1984-11-09','Public','China'),
('Motorola','Paul Galvin and his brother , Joseph','2011-01-04','Subsidiary','USA'),
('POCO','Shen wei','2018-08-01','Private','China');

SELECT count(*) FROM amazon_mobiles;

-- Change the datatype in insert data
ALTER TABLE Amazon_mobiles 
MODIFY Brand varchar(50);
ALTER TABLE Amazon_mobiles
MODIFY Model varchar(60);
ALTER TABLE Amazon_mobiles
MODIFY Color varchar(60);
ALTER TABLE Amazon_mobiles
MODIFY memory varchar(50);
ALTER TABLE Amazon_mobiles
MODIFY Storage varchar(50);
ALTER TABLE Amazon_mobiles
MODIFY rating float(2,1);

-- Create primary key on company table --
 ALTER TABLE company
MODIFY Brand varchar(30) primary key;
 
 set autocommit=0;
 start transaction;
 commit;
 
 		-- SHOW --
show databases;
show tables;

      -- view data type --
DESC amazon;
DESC Company;

-- Retrive the brand in company and Amazon_mobiles table --
select distinct brand from company order by brand;
select distinct brand from amazon_mobiles order by brand;

-- create foreign key to amazon_mobiles table using primary key in company table --
 ALTER TABLE Amazon_mobiles
 ADD CONSTRAINT AZ_Brand FOREIGN KEY(Brand) REFERENCES company(Brand) on delete set null;
 commit;
-- update--
alter table company
add column pincode int after company_type;

 -- upadate pincodes for our requirment --
 update company set pincode=case
 when brand='oppo' then '234567'
 when brand='vivo' then '567887'
 else '396897'
 end;
 
 update company set pincode='743456'
 where brand in('samsung','poco','lg');
 
 -- drop column --
 alter table company
 drop pincode;
 
 delete from company
 where brand='oppo';
 
 truncate table amazon_mobiles;

-- rollback keyword is uesed to  rollback the quary upto commit --
rollback;

--  WHERE clause is used to Filter the row --
select * from amazon_mobiles
where brand='oppo' and rating>=4.5;

select * from amazon_mobiles
where brand='oppo' and model='a54';

-- LIKE - search specified patterm in a column --
select* from amazon_mobiles
where brand like 'o%';

select* from amazon_mobiles
where brand like '%o%';

select* from amazon_mobiles
where brand like '_o%';

-- BETWEEN --
select * from amazon_mobiles
where brand='oppo' and rating between 4.4 and 4.5;

-- IN and NOT IN --
select * from amazon_mobiles
where brand in('oppo','apple');

select * from amazon_mobiles
where brand not in('oppo','apple');

select brand from amazon_mobiles
where brand not like 'app%' and 'as%';

select brand from amazon_mobiles
where brand like 'app%' or 'as%';       -- get first one 

-- UPDATE the over view column based on rattind column --
alter table amazon_mobiles 
add over_view varchar(20) ;
update amazon_mobiles set over_view='good'
where rating between 4.0 and 4.5;

update amazon_mobiles set over_view=case
when rating between 4.5 and 5.0 then 'Excellent'
when rating between 4.0 and 4.5 then 'Very good'
when rating between 3.5 and 4.0 then 'Good'
when rating between 3.0 and 3.5 then 'Avarage'
when rating between 2.5 and 3.0 then 'fair'
else 'poor' end;

-- FUNCTION --
select avg(rating) from amazon_mobiles
where brand='apple';

select sum(original_price) from amazon_mobiles
where brand='samsung';

select min(selling_price) from amazon_mobiles
where brand='apple';

select max(selling_price) from amazon_mobiles
where brand='apple';

select distinct upper(left(brand,3)) from amazon_mobiles;

-- Create concat , format to selling and original price column --
alter table amazon_mobiles
modify original_price varchar(20),
modify selling_price varchar(20);
update amazon_mobiles set selling_price=concat('Rs ',format(selling_price,0)),
original_price=concat('Rs ',format(original_price,0));

select*from amazon_mobiles
where selling_price >'Rs 55,000'
order by selling_price;

-- LIMIT clause
select distinct brand from amazon_mobiles
limit 3 ;
select distinct brand from amazon_mobiles
limit 3 offset 2;
select distinct brand from amazon_mobiles
limit 2,3;

-- ORDER the data based on ratting (asc/desc) --
select*from amazon_mobiles
order by rating desc,selling_price asc;

-- GROUP BY --
select brand, count(model) from amazon_mobiles
group by brand;		

-- having - Filter the grouped rows --
select brand ,count(brand) from amazon_mobiles
where selling_price<'rs 20,000'	
group by brand
having count(brand)>100;						 		

-- INDEX - Improve the speed of data retrival --
show index from amazon_mobiles;
show index from company;

create index model_id on amazon_mobiles(model); 
-- drop index model_id on amazon_mobiles;
-- alter table amazon_mobiles drop index model_id;

       -- OR
alter table amazon_mobiles
add index(brand);
alter table amazon_mobiles
drop index brand;

-- REPLACE --
select replace(selling_price, 'Rs ','') from amazon_mobiles;
update amazon_mobiles set selling_price=replace(selling_price, 'Rs ','');
update amazon_mobiles set original_price=replace(original_price,'Rs ','');
update amazon_mobiles set selling_price=replace(selling_price, ',',''),
original_price=replace(original_price,',','');

ALTER TABLE Amazon_mobiles
MODIFY selling_price int,
modify original_price int;

-- JOIN --                    
select am.brand , am.model,am.rating,am.selling_price, cp.founder, cp.company_type from amazon_mobiles as am
inner join company as cp
on am.brand=cp.brand
where am.selling_price <= 20000
order by selling_price asc;

-- UNION --
select brand,model,rating,selling_price from amazon_mobiles
union
select founder,founded,brand,company_type from company;

-- SUNQUERIES , Exists , Any , All --
--  It is called nexted query --
select brand from company
where founded=(select min(founded) from company);

select * from amazon_mobiles
where brand=(select brand from company
where founded=(select min(founded) from company));

select count(distinct brand) from amazon_mobiles
where brand= any(select brand from company
where founded !='2000-01-01')
order by brand ;

select distinct brand from amazon_mobiles
where brand= any (select brand from company
where founded between '2010-01-01' and '2020-01-01');

select * from amazon_mobiles
where brand<>all(select brand selling_price from company
where headquater in ('china' ,'usa'));

select * from amazon_mobiles
where brand<>all(select brand from company
where headquater in ('china' ,'usa','south koria'));

select brand,founder from company
where exists ( select * from amazon_mobiles
where selling_price between 1000 and 2000 and amazon_mobiles.brand=company.brand );

select brand,founder from company
where brand = any( select brand from amazon_mobiles
where selling_price between 1000 and 2000 );

-- Create VIEW for our requirement --
create view am_qp as
select az.brand,az.model,az.memory,az.storage,az.selling_price,c.founded,c.headquater from amazon_mobiles as az
join company as c
on az.brand=c.brand
where rating>=4.5 and selling_price<=30000
;
select * from am_qp;
                                    
drop view am_qp;

-- RENAME --

alter table amazon_mobiles
rename az_mobiles;

alter table az_mobiles
rename amazon_mobiles;

-- Add and update the column -- 
alter table amazon_mobiles
add delivery_fee varchar(30) after rating;
update amazon_mobiles set delivery_fee=case 
when selling_price<19999 then 60
else 'Free_delivery'end;

alter table amazon_mobiles
add discount float(4,2) after rating;

alter table amazon_mobiles
rename column discount to discount_per;

alter table amazon_mobiles
modify discount int;
select*from amazon_mobiles;

update amazon_mobiles set discount_per=(original_price-selling_price)/original_price*100;

-- store procedures --
-- Stored in the Database and can be called by name --
delimiter $
create procedure price(in selling_price int)
begin
select * from amazon_mobiles
where amazon_mobiles.selling_price=selling_price;
end$
delimiter ;

call price(30000);

delimiter $
create procedure bw_price(in st int,in en int)
begin
select * from amazon_mobiles
where amazon_mobiles.selling_price between st and en
order by selling_price; 
end$
delimiter ;

call bw_price(40000,50000);

delimiter $
create procedure brand(in brd varchar(30))
begin
select * from amazon_mobiles
where amazon_mobiles.brand=brd;
end$
delimiter ;

call brand('apple');

delimiter $
create procedure brdmdl (in brd varchar(20),in mdl varchar(40))
begin
select * from amazon_mobiles
where amazon_mobiles.brand=brd and amazon_mobiles.model=mdl; 
end$
delimiter ;

call brdmdl('apple','iphone 12 mini ');


 -- TRIGGER --
-- A trigger is a set of instractions that are automatically Executed --
create trigger slp_update
before update on amazon_mobiles
for each row
set new.discount_per=((new.original_price-new.selling_price)/new.original_price*100);

drop trigger slp_update;

update amazon_mobiles set selling_price=10000
where model='a53' and original_price=13499;

select * from amazon_mobiles
where model='a53' and original_price=13499;

-- function --
delimiter $
create function get_full_address(g_brand varchar(50))
returns varchar(70) 
deterministic  # defult notderterministic
begin
   declare fulladdress varchar(70);
   select concat(founder,' -- ',founded,' -- ',headquater) into fulladdress from company 
   where brand=g_brand;
   return fulladdress;
end$
delimiter ;

select brand,get_full_address(brand) from company;

