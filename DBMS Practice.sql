create database if not exists LPG;
use LPG;

create table if not exists cust_details(
Id int primary key auto_increment, Name varchar(50), Gender char(1),Address varchar(100),
Phone_No bigint, 
Connection_Type decimal(3,1), No_Of_Cyclinders int
);
	
create table if not exists orders(
Id int primary key auto_increment, Date date, Cust_id int references cust_details(Id), Quantity int,
Payment_type varchar(30), Status varchar(30)
);

create table if not exists cancelled_orders(
Order_id int references orders(Id), Date date, Reason varchar(50)
);

create table if not exists billing_details(
Inv_id int primary key auto_increment , Date date , Order_id int references orders(Id) , Delivery_Status varchar(30)
);



create table if not exists cancelled_bills(
Inv_id int references billing_details(Inv_id) , Date date , Reason varchar(50)
);

create table if not exists pricing(
Type decimal(3,1), Month varchar(10), Year int, Price int
);

insert into cust_details (Name, Gender, Address, Phone_No, Connection_Type, No_Of_Cyclinders) values ('Harish', 'M', '1-2, bglr', 1987654322, 14.2, 1);
insert into cust_details (Name, Gender, Address, Phone_No, Connection_Type, No_Of_Cyclinders) values ('Amisha', 'F', '32-12, bglr', 1614322387, 14.2, 1);
insert into cust_details (Name, Gender, Address, Phone_No, Connection_Type, No_Of_Cyclinders) values ('Ujjawal', 'M', '19-0, gurgaon', 1871614322, 14.2, 1);
insert into cust_details (Name, Gender, Address, Phone_No, Connection_Type, No_Of_Cyclinders) values ('Anu', 'F', '2-10, hyd', 1000614322, 19.0, 5);
insert into cust_details (Name, Gender, Address, Phone_No, Connection_Type, No_Of_Cyclinders) values ('Rakshitha', 'F', '3-1-3, chennai', 1614322551, 19.0, 10);
insert into cust_details (Name, Gender, Address, Phone_No, Connection_Type, No_Of_Cyclinders) values ('Varuni', 'F', '10-4, gurgaon', 1432245789, 14.2, 1);
insert into cust_details (Name, Gender, Address, Phone_No, Connection_Type, No_Of_Cyclinders) values ('Vamshi','M', '31-14, hyd',1443324578,19.0,6);

insert into orders (Date, Cust_id, Quantity, Payment_type, Status) values ('2021-10-01',6,1,'online','cancelled');
insert into orders (Date, Cust_id, Quantity, Payment_type, Status) values ('2021-10-01',3,1,'POD','Ordered');
insert into orders (Date, Cust_id, Quantity, Payment_type, Status) values ('2021-10-02',5,4,'POD','cancelled');
insert into orders (Date, Cust_id, Quantity, Payment_type, Status) values ('2021-10-03',6,1,'POD','Ordered');
insert into orders (Date, Cust_id, Quantity, Payment_type, Status) values ('2021-10-04',3,1,'online','Ordered');
insert into orders (Date, Cust_id, Quantity, Payment_type, Status) values ('2021-11-05',6,1,'online','Ordered');
insert into orders (Date, Cust_id, Quantity, Payment_type, Status) values ('2021-11-06',4,4,'online','Ordered');
insert into orders (Date, Cust_id, Quantity, Payment_type, Status) values ('2021-11-07',5,9,'POD','Ordered');
insert into orders (Date, Cust_id, Quantity, Payment_type, Status) values ('2021-11-09',7,5,'online','Ordered');

insert into cancelled_orders values(1, '2021-10-02', 'Out of Station');
insert into cancelled_orders values(3, '2021-10-03', 'Mistakenly Ordered');

insert into billing_details(Date, Order_Id, Delivery_Status) values ('2021-10-03', 1, 'Delivered');
insert into billing_details(Date, Order_Id, Delivery_Status) values ('2021-10-03', 2, 'Undelivered');
insert into billing_details(Date, Order_Id, Delivery_Status) values ('2021-10-04', 4, 'Delivered');
insert into billing_details(Date, Order_Id, Delivery_Status) values ('2021-10-06', 5, 'Delivered');
insert into billing_details(Date, Order_Id, Delivery_Status) values ('2021-11-06', 6, 'Delivered');
insert into billing_details(Date, Order_Id, Delivery_Status) values ('2021-11-06', 7, 'Delivered');
insert into billing_details(Date, Order_Id, Delivery_Status) values ('2021-11-08', 8, 'Delivered');


insert into cancelled_bills values(2, '2021-10-04', 'Insufficient Amount');

insert into pricing values(14.2, 'January', 2021, 925);
insert into pricing values(19.0, 'November', 2021, 925);
insert into pricing values(5.0, 'September', 2021, 340);
insert into pricing values(14.2, 'October', 2021, 960);
insert into pricing values(19.0, 'October', 2021, 1310);
insert into pricing values(5.0, 'October', 2021, 347);
insert into pricing values(14.2, 'November', 2021, 970);
insert into pricing values(19.0, 'November', 2021, 1313);
insert into pricing values(5.0, 'November', 2021, 350);
insert into pricing values(14.2, 'December', 2021, 974);
insert into pricing values(19.0, 'December', 2021, 1320);
insert into pricing values(5.0, 'December', 2021, 362);
insert into pricing values(14.2,'January', 2022, 999);
insert into pricing values(19.0, 'January', 2022, 1309);
insert into pricing values(5.0, 'January', 2022, 359);
insert into pricing values(14.2,'May','2023',1337);

-- question 1-
-- Write a query to display a table with customer Id, Name, Connection_Type and No_Of Cylinders 
-- ordered from orders table.
-- apporach 1 for question 1
select c.Id as Customer_id , Name, Connection_Type, o.No_Of_Cyclinders from cust_details as c
inner join (select Cust_id, sum(Quantity) as No_Of_Cyclinders from orders where Status = 'Ordered' group by Cust_id ) as o 
on c.Id = o.Cust_id ;

-- apporach 2 for question 1
select c.Id as Customer_id , Name, Connection_Type, sum(o.Quantity) as No_Of_Cyclinders
from cust_details as c
inner join orders as o on c.Id = o.Cust_id where Status = 'Ordered' group by Cust_id ;


-- question 2-
-- Display one customer from each product category who purchased maximum no of cylinders with
-- Connection_Type, Cust_Id, Name and Quantity purchased

-- rank utility
select * from(
select c.Id as Customer_id , Name, Connection_Type, sum(o.Quantity) as No_Of_Cyclinders, 
rank() over(partition by Connection_Type order by No_Of_Cyclinders ,c.Id desc ) as conn_rank
from cust_details as c
inner join orders as o on c.Id = o.Cust_id where Status = 'Ordered' group by Cust_id )
as R where conn_rank=1;

-- question 3-
-- Display Customer Id, Successfully_Delivered  and value of customer based on purchase of cylinders 
-- using SQL Case Statement.
-- 	when Successfully_Delivered >= 8 then 'Highly Valued'
--     when Successfully_Delivered between 5 and 7 then 'Moderately Valued'
--     Else 'Low Valued'

select Order_id from billing_details where Delivery_Status = 'Delivered';

select Cust_id, sum(Quantity) as Successfully_Delivered,
case
when sum(Quantity) >=8 then 'Highly Valued'
when sum(Quantity) between 4 and 7 then 'Moderately Valued'
else 'Low Valued'
end as value 
 from
(select Cust_id,Quantity,Status from orders o inner join 
(select Order_id from billing_details where Delivery_Status = 'Delivered') as b
on o.Id = b.Order_id) as f where Status = 'Ordered' group by Cust_id ;

-- question 4-
-- Display Customer Id, Name, Order_Id, Inv_Id, Delivery Date of all deliveries
-- received by customer for all customers 	
select d.Cust_id as Customer_Id ,Name,d.Order_Id, d.Inv_Id,d.Date as Delivery_Date
from cust_details c
inner join (select Cust_id,Order_Id, b.Inv_Id,b.Date from orders o inner join 
(select Order_id,Inv_id,Date from billing_details where Delivery_Status = 'Delivered') as b 
on o.Id = b.Order_id where o.Status = 'Ordered') as d on c.Id = d.Cust_id;

-- question 5-
-- Find the amount paid by the customer for every delivery taken for all customers with following
-- details Customer_Id, Name, Order_Id, Order_Date, Inv_Id, Delivery_Date,

select f.*,p.Price from pricing as p inner join
(select d.Cust_id as Customer_Id ,Name,d.Order_Id, d.Inv_Id,d.Date as Delivery_Date,Connection_Type
from cust_details c
inner join (select Cust_id,Order_Id, b.Inv_Id,b.Date from orders o inner join 
(select Order_id,Inv_id,Date from billing_details where Delivery_Status = 'Delivered') as b 
on o.Id = b.Order_id where o.Status = 'Ordered') as d on c.Id = d.Cust_id) as f
on f.Connection_Type = p.Type and p.Month = monthname(f.Delivery_Date) and p.Year = year(f.Delivery_Date);



-- question 6-
-- Create an SQL Stored Procedure “PriceOfCurrentMonth” to Identify the Price of all Products in the
--  Current Month with Product_Type, Month, Year and Price in table

-- CREATE PROCEDURE `new_procedure` ()
-- BEGIN
-- select * from pricing where Month = monthname(curdate()) and Year = year(curdate());
call new_procedure();

-- question 7 -
-- Find Last Delivery Date from billing_details table of every customer and display customer Id and
--  Name, Last_Delivery_Date and Quantity using Joins.(Note that the date in billing_details will
--  act as last delivery date

select X.Id as Customer_Id,X.Name,X.Date as Last_Delivery_date,X.Quantity from (
select c.Id,c.Name,F.Date ,F.Quantity , rank() over(partition by c.Id order by F.Date desc)as del_rank from cust_details as c inner join(
select o.Cust_id,o.Quantity,b.* from orders as o inner join (
select Order_id,Date from billing_details where Delivery_status = 'Delivered') as b 
on o.Id = b.Order_id where Status ='Ordered')as F
on c.Id =F.Cust_id) as X
where X.del_rank = 1;  




