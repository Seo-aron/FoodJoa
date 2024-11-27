
-- member
insert into member
values('admin', '관리자', '고나리자', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
	('review1', '리뷰자1', '리1', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review2', '리뷰자2', '리2', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review3', '리뷰자3', '리3', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review4', '리뷰자4', '리4', '01012345678', '부산시 부산진구', 'admin_image.png', CURRENT_TIMESTAMP);



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



-- community
insert into community(id, title, contents, views, post_date)
values
('admin', 'seoul', 'eat', 3, now()),
('admin', 'busan', 'meet', 100, now()),
('admin', 'daegu', 'go', 500, now()),
('admin', 'ulsan', 'do', 70, now()),
('admin', 'gwangju', 'abcdefg', 90, now());