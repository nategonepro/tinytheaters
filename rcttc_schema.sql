drop database if exists tiny_theaters;
create database tiny_theaters;
use tiny_theaters;

create table customer(
	customer_id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(100) null,
    phone varchar(20) null,
    address varchar(100) null
);

create table theater(
	theater_id int primary key auto_increment,
    `name` varchar(50) not null,
    address varchar(100) not null,
    phone varchar(20) not null,
    email varchar(50) not null
);

create table seat(
	seat_id int primary key auto_increment,
    signifier char(2) not null,
    theater_id int not null,
    constraint fk_seat_theater_id
		foreign key (theater_id)
        references theater(theater_id)
);

create table showing(
	showing_id int primary key auto_increment,
    title varchar(100) not null,
    price decimal(8,2) not null,
    `date` date not null,
    theater_id int not null,
    constraint fk_showing_theater_id
		foreign key (theater_id)
        references theater(theater_id)
);

create table reservation(
	reservation_id int primary key auto_increment,
    `date` date not null,
    customer_id int not null,
    showing_id int not null,
    seat_id int not null,
    constraint fk_reservation_customer_id
		foreign key (customer_id)
        references customer(customer_id),
	constraint fk_reservation_showing_id
		foreign key (showing_id)
        references showing(showing_id),
	constraint fk_reservation_seat_id
		foreign key (seat_id)
        references seat(seat_id)
);