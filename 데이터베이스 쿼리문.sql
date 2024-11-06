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
    post_date			timestamp,
    
    FOREIGN KEY (id) REFERENCES member(id)
);

desc recipe;

select * from recipe;



-- -------------------------------------------------------------------------------------


-- mealkit ------------------------------------------------------------------------------




-- -------------------------------------------------------------------------------------


-- community ------------------------------------------------------------------------------




-- -------------------------------------------------------------------------------------
