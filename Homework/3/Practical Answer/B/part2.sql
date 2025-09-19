create or replace procedure membership_renewal(p_member_id integer)
language plpgsql
as $$
declare
    total_penalty integer := 0;
begin
    select
        coalesce(sum(calculate_lateness(l.return_date, l.due_date)), 0)
    into total_penalty
    from loans l
    where l.member_id = p_member_id;

    if total_penalty < 10000 then
        update members
        set membership_status = true
        where member_id = p_member_id;

        raise notice 'Membership renewed successfully.';
    else
        raise notice 'Membership cannot be renewed due to unpaid penalties.';
    end if;
end;
$$;
