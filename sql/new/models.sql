insert into models (make_id, name, year)
select m.id, t.model, t.year from temp_data t
join makes m on upper(trim(m.name)) = upper(trim(t.make))
group by m.id, t.model, t.year;