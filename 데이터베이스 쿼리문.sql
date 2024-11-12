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

insert into member
values('admin', '관리자', '고나리자', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP);

insert into member
values ('review1', '리뷰자1', '리1', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review2', '리뷰자2', '리2', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review3', '리뷰자3', '리3', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review4', '리뷰자4', '리4', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP);


-- -------------------------------------------------------------------------------------


-- recipe ------------------------------------------------------------------------------
DROP TABLE IF EXISTS recipe;
CREATE TABLE recipe(
	no 					int primary key auto_increment,
    id 					varchar(20) not null,
    title 				varchar(50) not null,
    thumbnail 			varchar(50) not null,
    description			varchar(100) not null,
    contents 			longtext not null,
    category 			tinyint not null,
    views 				int not null,
    ingredient 			varchar(255) not null,
    ingredient_amount 	varchar(255) not null,
    orders 				varchar(255) not null,
    empathy 			int not null,
    post_date			timestamp not null,
    
    FOREIGN KEY (id) REFERENCES member(id)
);

insert into recipe(id, title, thumbnail, 
	description, contents, category, views, 
	ingredient, ingredient_amount, 
	orders, empathy, post_date) 
select id, title, thumbnail, 
	description, contents, category, views, 
	ingredient, ingredient_amount, 
	orders, empathy, CURRENT_TIMESTAMP
from recipe;


desc recipe;
select * from recipe;

SELECT no FROM recipe ORDER BY no DESC LIMIT 1;

drop table if exists recipe_review;
create table recipe_review(
	no 				int primary key auto_increment,
    id 				varchar(20) not null,
    recipe_no 		int not null,
    pictures 		text not null,
    contents 		text not null,
    rating 			int not null,
    empathy 		int not null,
    post_date		timestamp,
    
    FOREIGN KEY (id) REFERENCES member(id),
    FOREIGN KEY (recipe_no) REFERENCES recipe(no)
);

insert into recipe_review(id, recipe_no, pictures, contents, rating, empathy, post_date)
values('review1', '1', 'thumbnailImage.png', '리뷰 내용', 3, 0, CURRENT_TIMESTAMP),
    ('review2', '1', 'thumbnailImage.png', '리뷰 내용', 1, 0, CURRENT_TIMESTAMP),
    ('review3', '1', 'thumbnailImage.png', '리뷰 내용', 5, 0, CURRENT_TIMESTAMP),
    ('review1', '2', 'thumbnailImage.png', '리뷰 내용', 4, 0, CURRENT_TIMESTAMP),
    ('review2', '2', 'thumbnailImage.png', '리뷰 내용', 5, 0, CURRENT_TIMESTAMP),
    ('review1', '3', 'thumbnailImage.png', '리뷰 내용', 3, 0, CURRENT_TIMESTAMP),
    ('review2', '3', 'thumbnailImage.png', '리뷰 내용', 2, 0, CURRENT_TIMESTAMP),
    ('review3', '3', 'thumbnailImage.png', '리뷰 내용', 1, 0, CURRENT_TIMESTAMP),
    ('review4', '3', 'thumbnailImage.png', '리뷰 내용', 5, 0, CURRENT_TIMESTAMP);

desc recipe_review;
select * from recipe_review;

drop table if exists recipe_wishlist;
create table recipe_wishlist(
	no 			int primary key auto_increment,
    id 			varchar(20) not null,
    recipe_no 	int not null, 
    
    FOREIGN KEY (id) REFERENCES member(id),
    FOREIGN KEY (recipe_no) REFERENCES recipe(no)
);

insert into recipe_wishlist(id, recipe_no) 
values('admin', 1),
	('admin', 2),
    ('admin', 3);

desc recipe_wishlist;
select * from recipe_wishlist;

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
    stock		  int not null,
	pictures      text not null,
	orders        varchar(255) not null,
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
    address		varchar(5) not null,
    amount		int not null,
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


INSERT INTO mealkit (id, title, content, category, price, pictures, orders, origin, rating, views, soldout, post_date)
VALUES
('user1', 'Spicy Chicken Stir-fry', 'A delicious spicy chicken stir-fry with fresh vegetables.', 1, '15.99', 'chicken_stirfry.jpg', 'user1, user3', 'Korea', 4.5, 120, 0, NOW()),
('user2', 'Beef Bulgogi', 'Tender beef bulgogi marinated in a savory sauce.', 2, '18.99', 'beef_bulgogi.jpg', 'user2, user4', 'Korea', 4.7, 250, 0, NOW()),
('user3', 'Kimchi Stew', 'Traditional kimchi stew with pork and tofu.', 3, '12.50', 'kimchi_stew.jpg', 'user5, user7', 'Korea', 4.2, 95, 0, NOW()),
('user4', 'Fried Dumplings', 'Crispy fried dumplings filled with a savory pork filling.', 1, '8.99', 'fried_dumplings.jpg', 'user6, user8', 'China', 4.0, 50, 0, NOW()),
('user5', 'Japchae', 'Sweet potato noodles stir-fried with vegetables and beef.', 2, '13.50', 'japchae.jpg', 'user2, user4', 'Korea', 4.6, 110, 0, NOW());



-- -------------------------------------------------------------------------------------


-- community ------------------------------------------------------------------------------




-- -------------------------------------------------------------------------------------
