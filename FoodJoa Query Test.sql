SELECT * FROM mealkit_order;

SELECT 
o.address, o.quantity, o.delivered, o.refund, 
k.title, k.contents, k.category, k.price, k.pictures, 
m.nickname, m.profile 
FROM mealkit_order o 
LEFT JOIN mealkit k 
ON o.mealkit_no=k.no 
LEFT JOIN member m 
ON k.id=m.id 
WHERE o.id='admin' 
ORDER BY o.post_date DESC;

select * from mealkit;
select * from mealkit_order;

SELECT 
k.title, k.contents, k.category, k.price, k.stock, k.pictures, 
o.address, o.quantity, o.refund, 
m.nickname, m.profile 
FROM mealkit k 
INNER JOIN mealkit_order o 
ON k.no=o.mealkit_no 
LEFT JOIN member m 
ON o.id=m.id 
WHERE k.id='admin' AND o.delivered=0 
ORDER BY o.post_date DESC;

SELECT
r.title, r.category, 
rv.no AS rv_no, rv.pictures, rv.contents, rv.rating, rv.post_date,
m.nickname
FROM recipe_review rv
JOIN recipe r
ON rv.recipe_no=r.no
JOIN member m
ON r.id=m.id
WHERE rv.id='review1'
ORDER BY rv.post_date DESC;

SELECT 
k.title, k.contents, k.pictures, k.category, 
mr.post_date,
m.nickname 
FROM mealkit_review mr
JOIN mealkit k 
ON mr.mealkit_no=k.no
JOIN member m 
ON k.id=m.id
WHERE mr.id='review1';