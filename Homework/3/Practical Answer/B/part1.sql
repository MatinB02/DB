create or replace function calculate_lateness(loan_return date, due date)
returns integer as $$
begin
    if loan_return is null then
        return (current_date - due) * 5000; 
    elsif loan_return <= due then
        return 0;
    else
        return (loan_return - due) * 5000;
    end if;
end;
$$ language plpgsql;

select
    m.member_id,
    m.first_name,
    m.last_name,
    sum(
        calculate_lateness(current_date, l.due_date)
    ) as total_penalty
from
    members m
join
    loans l on m.member_id = l.member_id
group by
    m.member_id, m.first_name, m.last_name
having
    sum(
        calculate_lateness(current_date, l.due_date)
    ) > 0
order by
    total_penalty desc;
