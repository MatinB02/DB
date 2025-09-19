create or replace view active_loans as
select
    m.first_name,
    m.last_name,
    b.title as book_title,
    b.author as book_author
from loans l
join members m on l.member_id = m.member_id
join books b on l.book_id = b.book_id
where l.return_date is null;




create or replace view popular_books as
select
    b.title as book_title,
    b.author as book_author,
    count(l.book_id) as total_loans
from books b
left join loans l on b.book_id = l.book_id
group by b.book_id, b.title, b.author
order by total_loans desc;
