SELECT * FROM mealkit_cart;

DELETE FROM mealkit_cart WHERE mealkit_no=1 OR mealkit_no=2;


INSERT INTO mealkit_order (id, mealkit_no, address, quantity, delivered, refund, post_date) 
VALUES ('3796760927', '1', '49122부산 영도구 태종로 69012213', 3, 0, 0, NOW()), 
('3796760927', '2', '49122부산 영도구 태종로 69012213', 2, 0, 0, NOW()), 
('3796760927', '3', '49122부산 영도구 태종로 69012213', 3, 0, 0, NOW()), 
('3796760927', '4', '49122부산 영도구 태종로 69012213', 3, 0, 0, NOW()), 
('3796760927', '5', '49122부산 영도구 태종로 69012213', 1, 0, 0, NOW());