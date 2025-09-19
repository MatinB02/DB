select b.book_id, b.title, b.author, count(l.book_id) as loan_count
from books b
join loans l on b.book_id = l.book_id
where extract(year from l.loan_date) = extract(year from current_date)
  and b.book_id not in (
      select book_id
      from loans
      where loan_date >= date_trunc('month', current_date - interval '30 days')
        -- and loan_date < date_trunc('month', current_date)
  )
group by b.book_id, b.title, b.author
having count(l.book_id) = (
    select max(sub.loan_count)
    from (
        select count(*) as loan_count
        from loans
        where extract(year from loan_date) = extract(year from current_date)
        group by book_id
    ) as sub
)
order by loan_count desc;
