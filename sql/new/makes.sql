insert into makes (name)
select make from temp_data group by make;