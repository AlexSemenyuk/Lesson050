DROP DATABASE IF EXISTS Phone_company;
CREATE DATABASE Phone_company DEFAULT CHAR SET UTF8;
USE Phone_company;
CREATE TABLE customer
(
    id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    phone_num varchar(50) not null,
    plan_id int
);

create table pricing_plan
(
    id int primary key auto_increment,
    connection_free int not null,
    price_per_second int not null
);

alter table customer
    add constraint customer_pricing_plan_fk
    foreign key (plan_id) references pricing_plan (id);


create table phone_call
(
    id int primary key auto_increment,
    start_call TIMESTAMP NOT NULL DEFAULT current_timestamp,
    called_num varchar(50) not null,
    seconds int not null,
    customer_id int not null
);


alter table phone_call
    add constraint phone_call_customer_fk
        foreign key (customer_id) references customer (id);

create table bill
(
    id int primary key auto_increment,
    month int not null,
    year int not null,
    amount int not null,
    customer_id int
);

alter table bill
    add constraint bill_customer_fk
        foreign key (customer_id) references customer (id);
