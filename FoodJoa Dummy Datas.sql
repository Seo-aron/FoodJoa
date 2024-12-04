
-- member
insert into member
values('admin', '관리자', '고나리자', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
	('review1', '김리뷰', '리뷰어1', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review2', '이리뷰', '리뷰어2', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review3', '박리뷰', '리뷰어3', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('review4', '최리뷰', '리뷰어4', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    
    ('tQi32Qj0iONPLRZ16-5sX4-Gq_p8Jg_T33r-HdtLEFE', '이건용', '은익', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
    ('hanaId', '이하나', '하나', '01012345678', '47296 부산 부산진구 신천대로50번길 79 5층, 6층(부전동)', 'admin_image.png', CURRENT_TIMESTAMP),
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
('admin', '감을 하루에 1개만 먹으라니"…감 섭취 시 주의사항은?', '감은 아삭한 단감, 부드러운 홍시, 쫄깃한 곶감까지 취향에 따라 골라 먹는 재미가 있어 많은 사람들의 입맛을 사로잡는다. 비타민과 식이섬유가 풍부해 영양 면에서도 뛰어난 감은 숙취 해소, 뇌졸중 예방, 설사 완화 등 건강에 도움을 주는 자연식품으로 잘 알려져 있다. 하지만 체질이나 건강 상태에 따라 섭취에 주의가 필요하다.', 1, now()),
('review1', '캔 쉽게 따는 법 공유하는 자유게시판 게시글입니다', '아무리 힘을 세게 줘도 캔 뚜껑이 도저히 열리지 않을 때 너무 답답하시죠? 네 저도 답답해요 숟가락 하나만 있으면 안전하고 간편하게 캔 뚜껑을 딸 수 있어요.', 2, now()),
('aronId', '낙지 공동 구매해서 먹어보았는데요 시식 후기 작성글입니다', '우리집은 보통매운맛도 조금 맵싹해서 양배추 같이 볶아 먹고 있어요. 쭈꾸미 먹어보고 맛있어서 낙지도 시켜봤는데, 쭈꾸미가 더 오동통한 것 같아요! 350g짜리는 여러 반찬 중 하나로 내어 먹기 좋고, 500g짜리는 특별히 더 반찬 꺼내지 않아도 둘이 밥 다 먹을 정도예요.', 3, now()),
('hanaId', '요즘 김치 담글 줄 아는 사람도 있나요', '30대 요알못(요리를 알지 못하는) 주부 사이에선 이런 말이 심심찮게 나올 정도로 김치 만드는 법을 모르는 사람이 많다. 김장을 담가 주던 부모 세대 역시 김장을 포기하는 경우가 많다. 직접 담근 김치만큼 믿고 먹을 만한 게 없는데 겨울 가족 식탁에 올릴 김치를 어디서 구해야 할까. 이 같은 고민을 하는 요즘 도시 주부들이 선택하는 선택지가 바로 김장 체험이다.', 4, now()),
('hyewonId', '겨울 별미 과메기·보양식 복어 12월 이달의 수산물로 선정', '과메기, 심혈관계 질환 예방 좋은 음식…칼슘 함량 높아 영양식으로도 적합 복어, 감칠맛 뛰어난 고급 식재… 맹독 함유, 반드시 전문 자격 조리사가 요리해야 합니다', 5, now());

insert into community_share(id, thumbnail, title, contents, lat, lng, type, views, post_date)
values
('admin','test_thumbnail.png', '반찬, 국 등 품앗이 하실분', '직접 식재료를 골라 만드는데. 식재료는 대량으로 해야 싸고, 맛있게 만들려면 이재료 저재료 들어가서 한솥이 되고 소분해서 냉동해도 감당이 안되네요. 나눔 좌표는 아래에 찍어둘게요!', 37.3595704, 127.105399, 0, 12, now()),
('review1','test_thumbnail.png', '직접 만든빵 가져가실 분~', '학생들이 연습용으로 만든 빵이 너무 많이 남아서 좀 나눠드리려구요 나눔 희망하시는 분 여기 위치로 오시면 됩니다', 37.3595704, 127.105399, 0, 24, now()),
('hanaId','test_thumbnail.png', '알타리김치가 집에 너무 많아서 한 통만 나눠드릴게요', '시어머니가 김치를 많이 보내주셨는데 집에서 밥을 잘 해먹지 않고 냉장고 자리도 많이 차지해 나눔하려구요 위치는 여기입니다',37.3595704, 127.105399, 0, 3, now()),
('admin','test_thumbnail.png', '12월 2일 고나리자가 주최하는 밥 번개', '오후 8시쯤 다같이 삼겹살 먹어요! 만나는 장소는 지도로 찍어둘게요', 37.3595704, 127.105399, 1, 54, now()),
('review1','test_thumbnail.png', '푸드조아 와인 제 41회차 정기 모임', '01.18 목요일 오후 9시 서면 삼정타워 뒤 푸드조아 건물입니ㅏ. 회비 7,000원입니다', 37.3595704, 127.105399, 1, 90, now());