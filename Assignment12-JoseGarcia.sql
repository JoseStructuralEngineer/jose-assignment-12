create database pizza_orders;

-- Q2: Create your database based on your design in MySQ
-- Q3: Populate your database with three orders
create table users (
	users_id int,
    username varchar(100),
    password varchar(32),
    first_name varchar(50),
    last_name varchar(50),
    phone varchar(15),
    primary key (`users_id`)
);

insert into `users` (users_id, username,password,first_name,last_name,phone)
values(1,'trevorPage','pass1','Trevor','Page','226-555-4982');

insert into `users` (users_id, username,password,first_name,last_name,phone)
values(2,'johnDoe','pass2','John','Doe','555-555-9498');


create table menu (
	menu_id int,
    `type` varchar(100),
    cost decimal(5,2),
    primary key (`menu_id`)
);

insert into `menu` (menu_id, `type`,cost)
values(1,'Pepperoni & Cheese',7.99);

insert into `menu` (menu_id, `type`,cost)
values(2,'Vegetarian',9.99);

insert into `menu` (menu_id, `type`,cost)
values(3,'Meat Lovers',14.99);

insert into `menu` (menu_id, `type`,cost)
values(4,'Hawaiian',12.99);

create table `order` (
	order_id int,
    `order_date` datetime,
    quantity int,
    order_num int,
    primary key (`order_id`)
);

insert into `order` (order_id, `order_date`,quantity,order_num)
values(1,'2014-09-10 09:47:00',1,1);
insert into `order` (order_id, `order_date`,quantity,order_num)
values(2,'2014-09-10 09:47:00',1,1);

insert into `order` (order_id, `order_date`,quantity,order_num)
values(3,'2014-09-10 13:20:00',1,2);
insert into `order` (order_id, `order_date`,quantity,order_num)
values(4,'2014-09-10 13:20:00',2,2);

insert into `order` (order_id, `order_date`,quantity,order_num)
values(5,'2014-09-10 09:47:00',1,3);
insert into `order` (order_id, `order_date`,quantity,order_num)
values(6,'2014-09-10 09:47:00',1,3);

select * from user; 
select * from menu; 
select * from `order`; 


-- Create Joint Tables for Many-to-Many Relationships
CREATE TABLE `customer_order` (
	`users_id`	INT NOT NULL,
    `order_id` INT NOT NULL,
    FOREIGN KEY (users_id) REFERENCES `users` (users_id),
    FOREIGN KEY (order_id) REFERENCES `order` (order_id)
);

insert into `customer_order` (`users_id`, `order_id`)
values(1,1);
insert into `customer_order` (`users_id`, `order_id`)
values(1,2);

insert into `customer_order` (`users_id`, `order_id`)
values(2,3);
insert into `customer_order` (`users_id`, `order_id`)
values(2,4);

insert into `customer_order` (`users_id`, `order_id`)
values(1,5);
insert into `customer_order` (`users_id`, `order_id`)
values(1,6);

CREATE TABLE `order_menu` (
	`order_id`	INT NOT NULL,
    `menu_id` INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `order` (order_id),
    FOREIGN KEY (menu_id) REFERENCES `menu` (menu_id)
);
insert into `order_menu` (`order_id`, `menu_id`)
values(1,1);
insert into `order_menu` (`order_id`, `menu_id`)
values(2,3);

insert into `order_menu` (`order_id`, `menu_id`)
values(3,2);
insert into `order_menu` (`order_id`, `menu_id`)
values(4,3);

insert into `order_menu` (`order_id`, `menu_id`)
values(5,3);
insert into `order_menu` (`order_id`, `menu_id`)
values(6,4);


select * from `users` u
join `customer_order` co on u.users_id = co.users_id
join `order` o on co.order_id = o.order_id
join `order_menu` om on co.order_id = om.order_id
join `menu` m on om.menu_id = m.menu_id;


-- Q4: Now the restaurant would like to know which customers
--  are spending the most money at their establishment. Write 
-- a SQL query which will tell them how much money each individual
-- customer has spent at their restaurant

select u.users_id, u.username, sum(cost*ANY_VALUE(o.quantity)) from `users` u
join `customer_order` co on u.users_id = co.users_id
join `order` o on co.order_id = o.order_id
join `order_menu` om on co.order_id = om.order_id
join `menu` m on om.menu_id = m.menu_id
group by u.users_id;

-- Q5: Modify the query from Q4 to separate the orders
-- not just by customer, but also by date so they can 
-- see how much each customer is ordering on which date.

select  o.`order_date`, ANY_VALUE(username),sum(cost*ANY_VALUE(o.quantity)) from `users` u
join `customer_order` co on u.users_id = co.users_id
join `order` o on co.order_id = o.order_id
join `order_menu` om on co.order_id = om.order_id
join `menu` m on om.menu_id = m.menu_id
group by o.`order_date`;

