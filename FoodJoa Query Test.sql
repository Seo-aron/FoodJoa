SELECT * FROM mealkit_order;
select * from mealkit;
select * from member;

SELECT 
o.address, o.quantity, o.delivered, o.refund, 
k.title, k.contents, k.category, k.price, k.pictures, 
m.nickname, m.profile 
FROM mealkit_order o 
LEFT JOIN mealkit k 
ON o.mealkit_no=k.no 
LEFT JOIN member m 
ON k.id=m.id 
WHERE o.id='WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o' 
ORDER BY o.post_date DESC;

select * from mealkit;
select * from mealkit_order;

SELECT 
k.title, k.contents, k.category, k.price, k.stock, k.pictures, 
o.address, o.quantity, o.delivered, o.refund,
m.nickname, m.profile 
FROM mealkit k 
INNER JOIN mealkit_order o 
ON k.no=o.mealkit_no 
LEFT JOIN member m 
ON o.id=m.id 
WHERE k.id='WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o' AND o.delivered=0
ORDER BY o.post_date DESC;  

SELECT COUNT(*)
FROM mealkit_order o
WHERE o.delivered=0 AND o.id='WR1ZpRIM2ktSXjEzf0nI5NMU9JU_ASY6UXjh6ROLA4o';


SELECT COUNT(*)
FROM mealkit k
LEFT JOIN mealkit_order o
ON k.no=o.mealkit_no
WHERE k.id='admin' AND o.delivered=2;