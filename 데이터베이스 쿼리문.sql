DROP DATABASE IF EXISTS foodjoa;
CREATE DATABASE foodjoa;

USE foodjoa;

-- member ------------------------------------------------------------------------------
DROP TABLE IF EXISTS member;
CREATE TABLE member(
    id 			varchar(20) primary key not null,
    name 		varchar(10) not null,
    nickname 	varchar(10) not null,
    phone 		varchar(15) not null,
    address 	varchar(50) not null,
    profile 	varchar(50) not null,
    join_date 	timestamp not null
);

SELECT * FROM member;

DESC member;



-- -------------------------------------------------------------------------------------


-- recipe ------------------------------------------------------------------------------
DROP TABLE IF EXISTS recipe;
CREATE TABLE recipe(
	no 					int primary key auto_increment,
    id 					varchar(20) not null,
    title 				varchar(50),
    thumbnail 			varchar(50),
    description			varchar(100),
    contents 			text,
    category 			tinyint,
    views 				int,
    rating 				float,
    ingredient 			varchar(20),
    ingredient_amount 	varchar(10),
    orders 				varchar(20),
    empathy 			int,
    post_date			timestamp
);

desc recipe;

select * from recipe;



-- -------------------------------------------------------------------------------------


-- mealkit ------------------------------------------------------------------------------
DROP TABLE IF EXISTS mealkit;
CREATE TABLE mealkit(
    no            int primary key auto_increment,
	id            varchar(20) not null,
	title         varchar(50) not null,
	content       text not null,
	category      tinyint not null,
	price         varchar(10) not null,
	pictures      text not null,
	orders        varchar(20) not null,
	origin        varchar(255) not null,
	rating        float not null,
	views         int not null,
	soldout       tinyint not null,
	post_date     timestamp not null,

    foreign key (id) references member(id)
);
SELECT * FROM mealkit;

DESC mealkit;

-- mealkit_order
DROP TABLE IF EXISTS mealkit_order;
CREATE TABLE mealkit_order(
	no			int primary key auto_increment,
    id			varchar(20) not null,
    mealkit_no	int not null,
    amount		int not null,
    address		varchar(5) not null,
    delivered	tinyint not null,
    refund		tinyint not null,
    post_date	timestamp not null,
    
    foreign key (id) references member(id),
    foreign key (mealkit_no) references mealkit(no)
);

SELECT * FROM mealkit_order;

DESC mealkit_order;

-- mealkit_review
DROP TABLE IF EXISTS mealkit_review;
CREATE TABLE mealkit_review(
	no			int primary key auto_increment,
    id			varchar(20) not null,
    mealkit_no	int not null,
    pictures	text not null,
    contents	text not null,
    rating		float not null,
    empathy		int not null,
    post_date	timestamp not null,
    
    foreign key (id) references member(id),
    foreign key (mealkit_no) references mealkit(no)
);

SELECT * FROM mealkit_review;

DESC mealkit_review;

-- mealkit_wishlist
DROP TABLE IF EXISTS mealkit_wishlist;
CREATE TABLE mealkit_wishlist(
	no			int primary key auto_increment,
    id			varchar(20) not null,
    mealkit_no	int not null,
    type		tinyint not null,
    
    foreign key (id) references member(id),
    foreign key (mealkit_no) references mealkit(no)
);

SELECT * FROM mealkit_wishlist;

DESC mealkit_wishlist;


-- -------------------------------------------------------------------------------------


-- community ------------------------------------------------------------------------------




-- -------------------------------------------------------------------------------------
