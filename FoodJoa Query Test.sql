SELECT 
k.title, k.contents, k.category, k.price, k.stock, k.pictures, 
o.no AS order_no, o.address, o.quantity, o.delivered, o.refund, 
m.nickname, m.profile 
FROM mealkit k 
JOIN mealkit_order o 
ON k.no=o.mealkit_no 
JOIN member m 
ON o.id=m.id 
WHERE k.id='WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o'
ORDER BY o.post_date DESC;


SELECT COUNT(*) 
FROM mealkit k 
JOIN mealkit_order o
ON k.no=o.mealkit_no
WHERE k.id='WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o' AND o.delivered=0;

SELECT * FROM mealkit_order;
SELECT * FROM mealkit;
