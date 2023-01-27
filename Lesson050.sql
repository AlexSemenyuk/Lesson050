use phone_company;
-- Задание 1 - Запретить удаление и обновление данных в таблице PHONECALL - только вставка

-- на удаление записи
delimiter $
create trigger delete_phone_call_trigger
    before delete on phone_call
    for each row
begin
        signal SQLSTATE '45000'
        set message_text = 'Data must not delete';
end $
delimiter ;

-- на обновление записи
delimiter $
create trigger update_phone_call_trigger
    before update on phone_call
    for each row
begin
    signal SQLSTATE '45000'
    set message_text = 'Data must not update';
end $
delimiter ;
/*
Задание 2 - Напишите триггер, который автоматически обновляет счет (amount) за звонки в таблице Bill,
    в случае добавления записи в таблицу PHONECALL
    В таблице Bill будет только одна запись для каждого клиента на каждый месяц
*/


delimiter $$
create trigger insert_phone_call_trigger
    after insert on phone_call
    for each row
 begin
     -- declare @seconds int default 0;
     -- declare @connection_free int;         -- pricing_plan.connection_free
     -- declare @price_per_seconds;       -- pricing_plan.price_per_seconds
     -- declare @current_month;
     -- declare @delta;           -- @delta = (@seconds - @connection_free) * @price_per_seconds

     set @seconds = NEW.seconds;
     set @current_month = month(curdate());

     select connection_free
     into @connection_free
     from pricing_plan
     where NEW.customer_id = (select id from customer where customer.id = NEW.customer_id)
       and pricing_plan.id = (select plan_id from customer where customer.id = NEW.customer_id);

     select price_per_second
     into @price_per_second
     from pricing_plan
     where NEW.customer_id = (select id from customer where customer.id = NEW.customer_id)
       and pricing_plan.id = (select plan_id from customer where customer.id = NEW.customer_id);

     if @seconds > @connection_free then
         set @delta = (@seconds - @connection_free) * @price_per_second;
     else set @delta = 0;
     end if;

     if NEW.customer_id = (select customer_id from bill where bill.customer_id = NEW.customer_id)
         and @current_month = (select month from bill where bill.customer_id = NEW.customer_id) then
         update bill
         set amount = amount + @delta
         where customer_id = NEW.customer_id;
     else
         insert into bill (month, year, amount, customer_id)
         values (month(curdate()), year(curdate()), @delta, NEW.customer_id);
     end if;
 end $$
 delimiter ;

-- select @seconds, @connection_free, @price_per_second, @delta ;   -- для контроля

insert into phone_call (called_num, seconds, customer_id)
values ('095-879-55-44', 30, 4);

insert into phone_call (called_num, seconds, customer_id)
values ('067-325-53-24', 50, 5);
insert into phone_call (called_num, seconds, customer_id)
values ('067-325-53-24', 3, 5);

delete from phone_call;         -- все ок

update phone_call               -- все ок
set seconds = 5
where id = 5;



