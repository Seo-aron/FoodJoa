DROP DATABASE IF EXISTS foodjoa;
CREATE DATABASE foodjoa;

USE foodjoa;

-- member ------------------------------------------------------------------------------
DROP TABLE IF EXISTS member;
CREATE TABLE member(
    id 			varchar(50) primary key not null,
    name 		varchar(20) not null,
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


UPDATE member SET profile="test.png", name="관리자", nickname="고나리자1234", phone="01012341234", address="부산진구" WHERE id="admin";

-- -------------------------------------------------------------------------------------


-- recipe ------------------------------------------------------------------------------
DROP TABLE IF EXISTS recipe;
CREATE TABLE recipe(
	no 					int primary key auto_increment,
    id 					varchar(50) not null,
    title 				varchar(50) not null,
    thumbnail 			varchar(50) not null,
    description			varchar(100) not null,
    contents 			longtext not null,
    category 			tinyint not null,
    views 				int not null,
    ingredient 			varchar(255) not null,
    ingredient_amount 	varchar(255) not null,
    orders 				varchar(255) not null,
    post_date			timestamp not null,
    
    FOREIGN KEY (id) REFERENCES member(id)
);

insert into recipe(id, title, thumbnail, 
	description, contents, category, views, 
	ingredient, ingredient_amount, 
	orders, post_date) 
select id, title, thumbnail, 
	description, contents, category, views, 
	ingredient, ingredient_amount, 
	orders, CURRENT_TIMESTAMP
from recipe;

insert into recipe(
	id, title, thumbnail, description, 
    contents, category, views,
    ingredient, ingredient_amount,
    orders, post_date
)
values
	('admin', '한식1', 'test_thumbnail.png', '한식소개1', 
    'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 1, 0,
    '0008한식1 재료이름0008한식1 재료이름', '0008한식1 재료수량0008한식1 재료수량', 
    '0008한식1 조리순서0008한식1 조리순서', current_timestamp),
    ('admin', '일식1', 'test_thumbnail.png', '일식소개1', 
    'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 2, 0,
    '0008한식1 재료이름0008한식1 재료이름', '0008한식1 재료수량0008한식1 재료수량', 
    '0008한식1 조리순서0008한식1 조리순서', current_timestamp),
    ('admin', '중식1', 'test_thumbnail.png', '중식소개1', 
    'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 3, 0,
    '0008한식1 재료이름0008한식1 재료이름', '0008한식1 재료수량0008한식1 재료수량', 
    '0008한식1 조리순서0008한식1 조리순서', current_timestamp),
    ('admin', '양식1', 'test_thumbnail.png', '양식소개1', 
    'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 4, 0,
    '0008한식1 재료이름0008한식1 재료이름', '0008한식1 재료수량0008한식1 재료수량', 
    '0008한식1 조리순서0008한식1 조리순서', current_timestamp),
    ('admin', '자취1', 'test_thumbnail.png', '자취소개1', 
    'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 5, 0,
    '0008한식1 재료이름0008한식1 재료이름', '0008한식1 재료수량0008한식1 재료수량', 
    '0008한식1 조리순서0008한식1 조리순서', current_timestamp);

desc recipe;
select * from recipe;

drop table if exists recipe_review;
create table recipe_review(
	no 				int primary key auto_increment,
    id 				varchar(50) not null,
    recipe_no 		int not null,
    pictures 		text not null,
    contents 		text not null,
    rating 			int not null,
    post_date		timestamp,
    
    FOREIGN KEY (id) REFERENCES member(id),
    FOREIGN KEY (recipe_no) REFERENCES recipe(no)
);

insert into recipe_review(id, recipe_no, pictures, contents, rating, post_date)
values('review1', '1', '0018thumbnailImage.png', '리뷰 내용', 3, CURRENT_TIMESTAMP),
    ('review2', '1', '0018thumbnailImage.png', '리뷰 내용', 1, CURRENT_TIMESTAMP),
    ('review3', '1', '0018thumbnailImage.png', '리뷰 내용', 5, CURRENT_TIMESTAMP),
    ('review1', '2', '0018thumbnailImage.png', '리뷰 내용', 4, CURRENT_TIMESTAMP),
    ('review2', '2', '0018thumbnailImage.png', '리뷰 내용', 5, CURRENT_TIMESTAMP),
    ('review1', '3', '0018thumbnailImage.png', '리뷰 내용', 3, CURRENT_TIMESTAMP),
    ('review2', '3', '0018thumbnailImage.png', '리뷰 내용', 2, CURRENT_TIMESTAMP),
    ('review3', '3', '0018thumbnailImage.png', '리뷰 내용', 1, CURRENT_TIMESTAMP),
    ('review4', '3', '0018thumbnailImage.png', '리뷰 내용', 5, CURRENT_TIMESTAMP);

desc recipe_review;
select * from recipe_review;

select r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating, m.nickname as nickname 
from recipe r
left join (
	select recipe_no, avg(rating) as average_rating
    from recipe_review
    group by recipe_no
) avg_rating on r.no = avg_rating.recipe_no
left join member m on r.id=m.id 
where r.category=1 
order by r.post_date desc;

select
	r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating,
    m.nickname as nickname, m.profile as profile 
from recipe r
left join (
	select recipe_no, avg(rating) as average_rating
    from recipe_review
    group by recipe_no
) avg_rating on r.no = avg_rating.recipe_no
left join member m on r.id=m.id 
where r.no=59;

-- 리뷰 별 멤버의 닉네임을 같이 조회
SELECT r.*, m.nickname
FROM recipe_review r 
LEFT JOIN member m ON r.id=m.id
WHERE recipe_no=28;

drop table if exists recipe_wishlist;
create table recipe_wishlist(
	no 				int primary key auto_increment,
    id 				varchar(50) not null,
    recipe_no 		int not null, 
    choice_date		timestamp not null, 
    
    FOREIGN KEY (id) REFERENCES member(id),
    FOREIGN KEY (recipe_no) REFERENCES recipe(no)
);

insert into recipe_wishlist(id, recipe_no, choice_date) 
values('admin', 1, CURRENT_TIMESTAMP),
('admin', 2, CURRENT_TIMESTAMP),
('admin', 3, CURRENT_TIMESTAMP),
('admin', 4, CURRENT_TIMESTAMP),
('admin', 5, CURRENT_TIMESTAMP),
('admin', 47, CURRENT_TIMESTAMP);

desc recipe_wishlist;
select * from recipe_wishlist;

SELECT 
    recipeWithAvg.*,
    m.nickname
FROM recipe_wishlist wish
LEFT JOIN (
	SELECT r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating 
	FROM recipe r
	LEFT JOIN (
		SELECT review.recipe_no, AVG(rating) AS average_rating
		FROM recipe_review review
		GROUP BY recipe_no
	) avg_rating ON r.no = avg_rating.recipe_no
) recipeWithAvg ON wish.recipe_no = recipeWithAvg.no
LEFT JOIN member m ON wish.id=m.id 
WHERE wish.id='admin';

select r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating, m.nickname as nickname 
from recipe r
left join (
	select recipe_no, avg(rating) as average_rating
    from recipe_review
    group by recipe_no
) avg_rating on r.no = avg_rating.recipe_no
left join member m on r.id=m.id 
where r.category=1 
order by r.post_date desc;


-- -------------------------------------------------------------------------------------


-- mealkit ------------------------------------------------------------------------------
DROP TABLE IF EXISTS mealkit;
CREATE TABLE mealkit(
    no            int primary key auto_increment,
	id            varchar(50) not null,
	title         varchar(50) not null,
	contents       text not null,
	category      tinyint not null,
	price         varchar(10) not null,
    stock		  int not null,
	pictures      text not null,
	orders        varchar(255) not null,
	origin        varchar(255) not null,
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
    id			varchar(50) not null,
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
    id			varchar(50) not null,
    mealkit_no	int not null,
    pictures	text not null,
    contents	text not null,
    rating		int not null,
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
    id			varchar(50) not null,
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

DROP TABLE IF EXISTS community;
create table community(
	no 			int primary key auto_increment,
    id 			varchar(50) not null, 
	title 		varchar(50) not null,
    contents	text not null,
    views		int not null,
    post_date	timestamp not null
);

select * from community;
select * from member;

desc community;
