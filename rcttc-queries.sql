use tiny_theaters;

-- all performances between july 1, 2021, and sept 30, 2021
select * from showing
where `date` between '2021-07-01' and '2021-09-30';

-- list all customers
select * from customer;

-- all customers without a .com email
select * from customer
where email not like '%.com';

-- three cheapest shows
select * from showing
order by price
limit 3;

-- customers + show they're attending
select distinct concat(c.first_name, ' ', c.last_name) customer, sh.title
from reservation r
inner join customer c on c.customer_id = r.customer_id
inner join showing sh on sh.showing_id = r.showing_id;

-- customer, show, theater, seat number
select concat(c.first_name, ' ', c.last_name) customer, sh.title, th.`name`, se.signifier seat_name
from reservation r
inner join customer c on c.customer_id = r.customer_id
inner join showing sh on sh.showing_id = r.showing_id
inner join seat se on se.seat_id = r.seat_id
inner join theater th on th.theater_id = se.theater_id;

-- customers without an address
select * from customer
where address is null or address = '';

-- recreate spreadsheet data
select
	c.first_name customer_first,
    c.last_name customer_last,
    c.email customer_email,
    c.phone customer_phone,
    c.address customer_address,
    se.signifier seat,
    sh.title `show`,
    sh.price ticket_price,
	r.`date`,
    t.`name` theater,
    t.address theater_address,
    t.phone theater_phone,
    t.email theater_email
from reservation r
inner join customer c on c.customer_id = r.customer_id
inner join seat se on se.seat_id = r.seat_id
inner join showing sh on sh.showing_id = r.showing_id
inner join theater t on se.theater_id = t.theater_id;

-- total tickets per customer
select concat(c.first_name, ' ', c.last_name) customer, count(r.customer_id) total_tickets_purchased
from reservation r
inner join customer c on c.customer_id = r.customer_id
group by customer;

-- total revenue by show
select sh.title, sum(sh.price) total_revenue
from reservation r
inner join showing sh on sh.showing_id = r.showing_id
group by sh.title;

-- total revenue by theater
select th.`name`, sum(sh.price) total_revenue
from reservation r
inner join seat se on se.seat_id = r.seat_id
inner join theater th on th.theater_id = se.theater_id
inner join showing sh on sh.showing_id = r.showing_id
group by th.`name`;

-- biggest supporter
select concat(c.first_name, ' ', c.last_name) customer, sum(sh.price) total_spent
from reservation r
inner join customer c on c.customer_id = r.customer_id
inner join showing sh on sh.showing_id = r.showing_id
group by c.customer_id
order by total_spent desc
limit 1;
