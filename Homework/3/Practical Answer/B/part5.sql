create or replace function check_max_loans()
returns trigger as $$
declare
    active_loan_count int;
begin
    select count(*) into active_loan_count
    from loans
    where book_id = NEW.book_id
      and return_date is null;

    if active_loan_count >= 5 then
        raise exception 'Cannot loan book ID %: all 5 books are currently loaned.', NEW.book_id;
    end if;

    return NEW;
end;
$$ language plpgsql;

create trigger trg_max_loans
before insert on loans
for each row
execute function check_max_loans();
