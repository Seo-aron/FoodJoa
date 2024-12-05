
-- member
insert into member
values('admin', '관리자', '고나리자', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
	('review1', '김리뷰', '리뷰어1', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review2', '이리뷰', '리뷰어2', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review3', '박리뷰', '리뷰어3', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review4', '최리뷰', '리뷰어4', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    
    ('tQi32Qj0iONPLRZ16-5sX4-Gq_p8Jg_T33r-HdtLEFE', '이건용', '은익', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('hanaId', '이하나', '나리', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('aronId', '서아론', '아론', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('hyewonId', '이혜원', '혜원', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('minseokId', '최민석', '민석', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP);



-- recipe
insert into recipe(id, title, thumbnail, description, contents, category, views, ingredient, ingredient_amount, orders, post_date) 
values('admin', 'test title', 'test_thumbnail.png', 'test description',
	'eJyzKbB73Nr4uLX9cWsfiNGyBcRu2WmjX2AHAOteD+U=', 1, 0,
	'0016test ingredient10016test ingredient2','0012test amount10012test amount2',
	'0012test orders10012test orders2', CURRENT_TIMESTAMP),
	('admin', 'test title', 'test_thumbnail.png', 'test description',
	'eJyzKbB73Nr4uLX9cWsfiNGyBcRu2WmjX2AHAOteD+U=', 2, 0,
	'0016test ingredient10016test ingredient2','0012test amount10012test amount2',
	'0012test orders10012test orders2', CURRENT_TIMESTAMP),
	('admin', 'test title', 'test_thumbnail.png', 'test description',
	'eJyzKbB73Nr4uLX9cWsfiNGyBcRu2WmjX2AHAOteD+U=', 3, 0,
	'0016test ingredient10016test ingredient2','0012test amount10012test amount2',
	'0012test orders10012test orders2', CURRENT_TIMESTAMP),
	('admin', 'test title', 'test_thumbnail.png', 'test description',
	'eJyzKbB73Nr4uLX9cWsfiNGyBcRu2WmjX2AHAOteD+U=', 4, 0,
	'0016test ingredient10016test ingredient2','0012test amount10012test amount2',
	'0012test orders10012test orders2', CURRENT_TIMESTAMP),
	('admin', 'test title', 'test_thumbnail.png', 'test description',
	'eJyzKbB73Nr4uLX9cWsfiNGyBcRu2WmjX2AHAOteD+U=', 5, 0,
	'0016test ingredient10016test ingredient2','0012test amount10012test amount2',
	'0012test orders10012test orders2', CURRENT_TIMESTAMP);
	
insert into recipe_review(id, recipe_no, pictures, contents, rating, post_date)
values('review1', '1', '0018test_thumbnail.png', '리뷰 내용', 3, CURRENT_TIMESTAMP),
    ('review2', '1', '0018test_thumbnail.png', '리뷰 내용', 1, CURRENT_TIMESTAMP),
    ('review3', '1', '0018test_thumbnail.png', '리뷰 내용', 5, CURRENT_TIMESTAMP),
    ('review1', '2', '0018test_thumbnail.png', '리뷰 내용', 4, CURRENT_TIMESTAMP),
    ('review2', '2', '0018test_thumbnail.png', '리뷰 내용', 5, CURRENT_TIMESTAMP),
    ('review1', '3', '0018test_thumbnail.png', '리뷰 내용', 3, CURRENT_TIMESTAMP),
    ('review2', '3', '0018test_thumbnail.png', '리뷰 내용', 2, CURRENT_TIMESTAMP),
    ('review3', '3', '0018test_thumbnail.png', '리뷰 내용', 1, CURRENT_TIMESTAMP),
    ('review4', '3', '0018test_thumbnail.png', '리뷰 내용', 5, CURRENT_TIMESTAMP);
    
insert into recipe_wishlist(id, recipe_no, choice_date) 
values('admin', 1, CURRENT_TIMESTAMP),
('admin', 2, CURRENT_TIMESTAMP),
('admin', 3, CURRENT_TIMESTAMP),
('admin', 4, CURRENT_TIMESTAMP),
('admin', 5, CURRENT_TIMESTAMP);



-- mealkit
INSERT INTO mealkit (id, title, contents, category, price, stock, pictures, orders, origin, views, soldout, post_date) VALUES
('admin', '김치찌개 키트', '신선한 재료로 만든 김치찌개 키트입니다.', 2, '14500', 25, '0018test_thumbnail.png', '0003주문10003주문2', '한국', 0, 0, CURRENT_TIMESTAMP),
('admin', '불고기 키트', '맛있는 불고기를 집에서 쉽게 만들 수 있는 키트입니다.', 4, '17500', 15, '0018test_thumbnail.png', '0003주문10012주문2', '한국', 0, 0, CURRENT_TIMESTAMP),
('admin', '비빔밥 키트', '다양한 재료로 만든 비빔밥 키트입니다.', 1, '13000', 20, '0018test_thumbnail.png', '0003주문10003주문2', '한국', 0, 0, CURRENT_TIMESTAMP),
('admin', '떡볶이 키트', '매콤한 떡볶이를 집에서 즐길 수 있는 키트입니다.', 3, '12000', 200, '0018test_thumbnail.png', '0003주문10003주문2', '한국', 0, 0, CURRENT_TIMESTAMP),
('admin', '잡채 키트', '고소한 잡채를 쉽게 만들 수 있는 키트입니다.', 2, '16000', 150, '0018test_thumbnail.png', '0003주문10003주문2', '한국', 0, 0, CURRENT_TIMESTAMP);

INSERT INTO mealkit_order (id, mealkit_no, address, quantity, delivered, refund, post_date) VALUES
('review1', 1, '서울시 강남구 123-45', 20, 0, 0, CURRENT_TIMESTAMP),
('review2', 2, '부산시 해운대구 67-89', 10, 1, 0, CURRENT_TIMESTAMP),
('review3', 3, '대구시 중구 11-22', 15, 0, 1, CURRENT_TIMESTAMP),
('review4', 4, '인천시 남동구 33-44', 5, 2, 0, CURRENT_TIMESTAMP),
('review1', 5, '광주시 북구 55-66', 12, 0, 1, CURRENT_TIMESTAMP);

INSERT INTO mealkit_review (id, mealkit_no, pictures, contents, rating, post_date) VALUES
('review1', 1, '0018test_thumbnail.png', '정말 맛있어요! 재구매 의사 100%', 5, CURRENT_TIMESTAMP),
('review2', 1, '0018test_thumbnail.png', '좋은 재료로 만들어져서 만족합니다.', 4, CURRENT_TIMESTAMP),
('review3', 2, '0018test_thumbnail.png', '보통이에요. 기대보다 덜 맛있었어요.', 3, CURRENT_TIMESTAMP),
('review4', 2, '0018test_thumbnail.png', '양이 적은 것 같지만 맛은 좋았어요.', 4, CURRENT_TIMESTAMP),
('review1', 3, '0018test_thumbnail.png', '가족 모두가 좋아했어요!', 5, CURRENT_TIMESTAMP),
('review2', 4, '0018test_thumbnail.png', '재료가 신선하지 않았어요.', 2, CURRENT_TIMESTAMP),
('review3', 4, '0018test_thumbnail.png', '가격 대비 괜찮은 편입니다.', 3, CURRENT_TIMESTAMP),
('review4', 5, '0018test_thumbnail.png', '정말 훌륭한 맛! 추천합니다.', 5, CURRENT_TIMESTAMP),
('review1', 5, '0018test_thumbnail.png', '다음에도 또 구매할게요.', 4, CURRENT_TIMESTAMP);

INSERT INTO mealkit_wishlist (id, mealkit_no, choice_date) VALUES
('review1', 1, CURRENT_TIMESTAMP),
('review2', 2, CURRENT_TIMESTAMP),
('review3', 3, CURRENT_TIMESTAMP),
('review4', 4, CURRENT_TIMESTAMP),
('review1', 5, CURRENT_TIMESTAMP);



-- community
insert into community(id, title, contents, views, post_date)
values
('admin', 'seoul', 'eat', 3, now()),
('admin', 'busan', 'meet', 100, now()),
('admin', 'daegu', 'go', 500, now()),
('admin', 'ulsan', 'do', 70, now()),
('admin', 'gwangju', 'abcdefg', 90, now());

insert into community_share(id, thumbnail, title, contents, lat, lng, type, views, post_date)
values
('admin','test_thumbnail.png', 'seoul', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 0, 3, now()),
('admin','test_thumbnail.png', 'seoul1', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 1, 3, now()),
('admin','test_thumbnail.png', 'seoul2', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 1, 3, now()),
('admin','test_thumbnail.png', 'seoul3', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 1, 3, now()),
('admin','test_thumbnail.png', 'seoul4', 'eJyzKbB7O3XOm+65hgqvm7a8mbXSRr/ADgB7FQrX', 37.3595704, 127.105399, 0, 3, now());


insert into mealkit_cart(id, mealkit_no, quantity, choice_date)
values
('oTcuaqH712AhGERfeDDh7sKhFyWoPrKcNhIujhF73vk', '1', '3', current_time()),
('oTcuaqH712AhGERfeDDh7sKhFyWoPrKcNhIujhF73vk', '2','2', current_time());
('oTcuaqH712AhGERfeDDh7sKhFyWoPrKcNhIujhF73vk', '1', '3', current_time());