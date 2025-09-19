create or replace function check_loan_constraints()
returns trigger as $$
declare
    book_available boolean;
    member_active boolean;
begin
    select availability_status into book_available
    from books
    where book_id = NEW.book_id;

    if book_available is not true then
        raise exception 'Book with ID % is not available for loan.', NEW.book_id;
    end if;

    select membership_status into member_active
    from members
    where member_id = NEW.member_id;

    if member_active is not true then
        raise exception 'Member with ID % does not have an active membership.', NEW.member_id;
    end if;

    return NEW;
end;
$$ language plpgsql;

create trigger trg_check_loan
before insert on loans
for each row
execute function check_loan_constraints();
