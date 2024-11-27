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
SELECT A.id, A.nickname, B.pictures, C.address, C.amount, C.delivered, C.refund  
FROM MEMBER A	
JOIN MEALKIT B 
ON A.ID = B.ID 
JOIN MEALKIT_ORDER C 
ON B.ID = C.ID  
WHERE A.id='WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o'; 

insert mealkit_order(id,mealkit_no,address,amount,delivered,refund,post_date)values
('WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o',1,'부산시',1,1,1,20241125),
('WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o',2,'부산시',1,1,1,20241125),
('WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o',3,'부산시',1,1,1,20241125);

insert mealkit(no,id,title,contents,category,price,stock,pictures,orders,origin,views,soldout,post_date)values
(1,'WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o','국밥','맛있어요',1,'3000','3','bob.png','1..어쩌구....2......','국산',3029,1,'2024-11-27 15:30:45'),
(2,'WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o','국밥','맛있어요',1,'3000','3','bob.png','1..어쩌구....2......','국산',3029,1,'2024-11-27 15:30:45'),
(3,'WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o','국밥','맛있어요',1,'3000','3','bob.png','1..어쩌구....2......','국산',3029,1,'2024-11-27 15:30:45');

select * from member;
select * from mealkit;
select * from mealkit_order;

SELECT * FROM member;

select id from member;

DESC member;

insert into member
values('admin', '관리자', '고나리자', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP);

insert into member
values ('review1', '리뷰자1', '리1', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review2', '리뷰자2', '리2', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review3', '리뷰자3', '리3', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review4', '리뷰자4', '리4', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP);
select * from member;

UPDATE member SET profile="test.png", name="관리자", nickname="고나리자1234", phone="01012341234", address="부산진구" WHERE id="admin";

SELECT A.id, A.nickname, B.pictures, C.address, C.amount, C.delivered, C.refund
FROM MEMBER A
JOIN MEALKIT B
ON A.ID = B.ID
JOIN MEALKIT_ORDER C 
ON B.ID = C.ID
WHERE A.id='WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o';

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
    
    FOREIGN KEY (id) REFERENCES member(id) ON DELETE CASCADE
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


desc recipe;
select * from recipe;

SELECT no FROM recipe ORDER BY no DESC LIMIT 1;

drop table if exists recipe_review;
create table recipe_review(
	no 				int primary key auto_increment,
    id 				varchar(50) not null,
    recipe_no 		int not null,
    pictures 		text not null,
    contents 		text not null,
    rating 			int not null,
    post_date		timestamp,
    
    FOREIGN KEY (id) REFERENCES member(id) ON DELETE CASCADE, 
    FOREIGN KEY (recipe_no) REFERENCES recipe(no)
);

insert into recipe_review(id, recipe_no, pictures, contents, rating, post_date)
values('review1', '1', 'thumbnailImage.png', '리뷰 내용', 3, CURRENT_TIMESTAMP),
    ('review2', '1', 'thumbnailImage.png', '리뷰 내용', 1, CURRENT_TIMESTAMP),
    ('review3', '1', 'thumbnailImage.png', '리뷰 내용', 5, CURRENT_TIMESTAMP),
    ('review1', '2', 'thumbnailImage.png', '리뷰 내용', 4, CURRENT_TIMESTAMP),
    ('review2', '2', 'thumbnailImage.png', '리뷰 내용', 5, CURRENT_TIMESTAMP),
    ('review1', '3', 'thumbnailImage.png', '리뷰 내용', 3, CURRENT_TIMESTAMP),
    ('review2', '3', 'thumbnailImage.png', '리뷰 내용', 2, CURRENT_TIMESTAMP),
    ('review3', '3', 'thumbnailImage.png', '리뷰 내용', 1, CURRENT_TIMESTAMP),
    ('review4', '3', 'thumbnailImage.png', '리뷰 내용', 5, CURRENT_TIMESTAMP);

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
    
    FOREIGN KEY (id) REFERENCES member(id) ON DELETE CASCADE,
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


-- mealkit ----------------------------------------------------------
DROP TABLE IF EXISTS mealkit;--------------------
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

    foreign key (id) references member(id) ON DELETE CASCADE
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
    quantity		int not null,
    delivered	tinyint not null,
    refund		tinyint not null,
    post_date	timestamp not null,
    
    foreign key (id) references member(id) ON DELETE CASCADE,
    foreign key (mealkit_no) references mealkit(no)
);
insert mealkit_order(id,mealkit_no,address,amount,delivered,refund,post_date)
values('wonvoo',1,'경주시',1,1,1,24/11/25),
	   ('wonvoo1',1,'성남시',2,1,1,24/11/25),
       ('wonvoo2',1,'화성시',3,1,1,24/11/25),
       ('wonvoo3',1,'부산시',4,1,1,24/11/25),
       ('wonvoo4',1,'서울시',5,1,1,24/11/25),
       ('wonvoo5',1,'제주시',6,1,1,24/11/25),
       ('wonvoo6',1,'시흥시',7,1,1,24/11/25);
SELECT * FROM mealkit_order;
DESC mealkit_order;

SELECT *
FROM mealkit mmealkitmealkitmember
LEFT JOIN mealkit_order o
ON m.no = o.mealkit_no
WHERE m.id='admin';

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
    
    foreign key (id) references member(id) ON DELETE CASCADE,
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
    
    foreign key (id) references member(id) ON DELETE CASCADE,
    foreign key (mealkit_no) references mealkit(no)
);

SELECT * FROM mealkit_wishlist;

DESC mealkit_wishlist;


INSERT INTO mealkit (id, title, contents, category, price, pictures, orders, origin, views, soldout, post_date)
VALUES
('user1', 'Spicy Chicken Stir-fry', 'A delicious spicy chicken stir-fry with fresh vegetables.', 1, '15.99', 'chicken_stirfry.jpg', 'user1, user3', 'Korea', 120, 0, NOW()),
('user2', 'Beef Bulgogi', 'Tender beef bulgogi marinated in a savory sauce.', 2, '18.99', 'beef_bulgogi.jpg', 'user2, user4', 'Korea',  250, 0, NOW()),
('user3', 'Kimchi Stew', 'Traditional kimchi stew with pork and tofu.', 3, '12.50', 'kimchi_stew.jpg', 'user5, user7', 'Korea',  95, 0, NOW()),
('user4', 'Fried Dumplings', 'Crispy fried dumplings filled with a savory pork filling.', 1, '8.99', 'fried_dumplings.jpg', 'user6, user8', 'China',  50, 0, NOW()),
('user5', 'Japchae', 'Sweet potato noodles stir-fried with vegetables and beef.', 2, '13.50', 'japchae.jpg', 'user2, user4', 'Korea',  110, 0, NOW());


SELECT
m.nickname, m.id, mk.title, mk.contents, mk.category, mk.price, mk.pictures, mk.post_date, 
AVG(r.rating) AS avr_rating 
FROM mealkit_wishlist mw 
JOIN mealkit mk ON mw.mealkit_no = mk.no 
JOIN member m ON mk.id = m.id 
LEFT JOIN mealkit_review r ON mk.no = r.mealkit_no 
WHERE mw.id = 'oTcuaqH712AhGERfeDDh7sKhFyWoPrKcNhIujhF73vk' AND mw.type = 0 
GROUP BY m.nickname, m.id, mk.title, mk.contents, mk.category, mk.price, mk.pictures, mk.post_date;

SELECT 
mk.pictures, mk.title, mk.contents, mk.price, m.nickname, mr.average_rating 
FROM mealkit_wishlist mw 
JOIN mealkit mk ON mw.mealkit_no = mk.no 
JOIN member m ON mk.id = m.id 
LEFT JOIN ( 
SELECT mealkit_no, AVG(rating) AS average_rating 
FROM mealkit_review 
GROUP BY rating 
) mr ON mw.mealkit_no = mr.mealkit_no 
WHERE mw.id = 'oTcuaqH712AhGERfeDDh7sKhFyWoPrKcNhIujhF73vk' AND mw.type = 0;


-- -------------------------------------------------------------------------------------


-- community ------------------------------------------------------------------------------

DROP TABLE IF EXISTS community;
create table community(
	no 			int primary key auto_increment,
    id 			varchar(50) not null, 
	title 		varchar(50) not null,
    contents	text not null,
    views		int not null,
    post_date	timestamp not null,
    
    foreign key(id) references member(id) ON DELETE CASCADE
);

select * from community;

desc community;

insert into community(id, title, contents, views, post_date)
values
('admin', 'seoul', 'eat', 3, now()),
('admin', 'busan', 'meet', 100, now()),
('admin', 'daegu', 'go', 500, now()),
('admin', 'ulsan', 'do', 70, now()),
('admin', 'gwangju', 'abcdefg', 90, now());
-- --------------------------
drop table community_share;

create table community_share(
	no int primary key auto_increment,
    id varchar(50) not null,
    thumbnail varchar(255) not null,
    title varchar(50) not null,
    contents longtext not null,
    lat double not null,
    lng double not null,
    type tinyint not null,
    views int not null,
	post_date timestamp not null,

	FOREIGN KEY (id) REFERENCES member(id) ON DELETE CASCADE
);

select * from community_share;

insert into community_share(id, thumbnail, title, contents, lat, lng, type, views, post_date)
values
('admin','test_thumbnail.png', 'seoul', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 0, 3, now()),
('admin','test_thumbnail.png', 'seoul1', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 0, 3, now()),
('admin','test_thumbnail.png', 'seoul2', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 0, 3, now()),
('admin','test_thumbnail.png', 'seoul3', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 0, 3, now()),
('admin','test_thumbnail.png', 'seoul4', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 0, 3, now());

select c.*, m.profile, m.nickname 
from community_share c 
LEFT OUTER JOIN member m 
ON c.id = m.id
ORDER BY c.post_date DESC;

SELECT c.*, m.profile, m.nickname 
FROM community_share c 
LEFT OUTER JOIN member m 
ON c.id = m.id 
WHERE c.title like '%eo%' 
ORDER BY c.post_date DESC;

SELECT c.*, m.profile, m.nickname 
FROM community_share c 
LEFT OUTER JOIN member m 
ON c.id = m.id 
WHERE m.nickname like '%나리%'
ORDER BY c.post_date DESC;
-- -------------------------------------------------------------------------------------


-- recent_view  ----------------------------------------------------------
DROP TABLE IF EXISTS recent_view;
create table recent_view(
	no			int primary key auto_increment,
    id			varchar(50) not null,
    item_no     int not null, 
    type		tinyint not null,
    viewed_at   TIMESTAMP not null,

    foreign key(id) references member(id) ON DELETE CASCADE
);

select * from recent_view;

commit;