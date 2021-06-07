use tiny_theaters;

select distinct customer_first, customer_last, customer_email, customer_phone, customer_address
from rcttc_denormalized;

insert into customer(first_name, last_name, email, phone, address)
	select distinct customer_first, customer_last, customer_email, customer_phone, customer_address
	from rcttc_denormalized;
    
select * from customer;

select distinct theater, theater_address, theater_phone, theater_email from rcttc_denormalized;

insert into theater (`name`, address, phone, email)
	select distinct theater, theater_address, theater_phone, theater_email 
    from rcttc_denormalized;
    
select * from theater;

select distinct dn.seat, t.theater_id
	from rcttc_denormalized dn
    inner join theater t on dn.theater = t.`name`;
    
insert into seat (signifier, theater_id)
	select distinct dn.seat, t.theater_id
	from rcttc_denormalized dn
    inner join theater t on dn.theater = t.`name`;
    
select * from seat;

select distinct dn.show, dn.ticket_price, dn.`date`, t.theater_id
	from rcttc_denormalized dn
    inner join theater t on dn.theater = t.`name`;
    
insert into showing (title, price, `date`, theater_id)
	select distinct dn.show, dn.ticket_price, dn.`date`, t.theater_id
	from rcttc_denormalized dn
    inner join theater t on dn.theater = t.`name`;

select * from showing;

select
	dn.`date`,
    c.customer_id,
    sh.showing_id,
    se.seat_id
from rcttc_denormalized dn
inner join customer c on concat(dn.customer_first, dn.customer_last) = concat(c.first_name, c.last_name)
inner join showing sh on dn.`show` = sh.title and sh.`date` = dn.`date`
inner join seat se on dn.seat = se.signifier and se.theater_id = sh.theater_id
order by c.customer_id, sh.showing_id, se.seat_id;

insert into reservation(`date`, customer_id, showing_id, seat_id)
	select
		dn.`date`,
		c.customer_id,
		sh.showing_id,
		se.seat_id
	from rcttc_denormalized dn
	inner join customer c on concat(dn.customer_first, dn.customer_last) = concat(c.first_name, c.last_name)
	inner join showing sh on dn.`show` = sh.title and sh.`date` = dn.`date`
	inner join seat se on dn.seat = se.signifier and se.theater_id = sh.theater_id
	order by c.customer_id, sh.showing_id, se.seat_id;
    
select * from reservation;

drop table rcttc_denormalized;

-- change price of 2021-03-01 the sky lit up performance
update showing set
	price = 22.25
    where `date` = '2021-03-01' and theater_id = 2;
    
select * from showing
where theater_id = 2;

-- update seating configuration for the sky lit up on 2021-03-01
update reservation r set seat_id = 33
where r.customer_id = 37 and seat_id = 29;

update reservation r set seat_id = 35
where r.customer_id = 38 and seat_id = 33;

update reservation r set seat_id = 29
where r.customer_id = 39 and seat_id = 35;

select se.seat_id, se.signifier, c.customer_id, concat(c.first_name,' ', c.last_name) customer_name
from reservation r
inner join customer c on r.customer_id = c.customer_id
inner join seat se on r.seat_id = se.seat_id
where r.`date` = '2021-03-01' and se.theater_id = 2
order by customer_name;

select customer_id, count(customer_id) from reservation
where reservation.showing_id = 6
group by customer_id;

-- delete single ticket reservations for 2021-09-24 performance of the sky lit up
delete from reservation
where showing_id = 6 and 
	customer_id = 43;
    
delete from reservation
where showing_id = 6 and 
	customer_id = 45;
    
delete from reservation
where showing_id = 6 and 
	customer_id = 46;

-- delete shannah ramsell
delete from reservation
where customer_id = 42;

delete from customer
where customer_id = 42;

select * from customer
where concat(first_name,last_name) = 'ShannahRamsell';