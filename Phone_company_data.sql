use phone_company;
insert into customer (first_name, last_name, phone_num, plan_id)
values ('Вася', 'Пупкин', '095-857-41-14', 4),
       ('Маша', 'Девяткина', '095-758-41-95', 5),
       ('Миша', 'Галушко', '095-632-48-95', 6);

insert into pricing_plan (connection_free, price_per_second)
values (5, 1), (10, 2), (20, 1);

delete from pricing_plan;