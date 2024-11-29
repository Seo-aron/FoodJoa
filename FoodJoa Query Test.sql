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

select * from community;
select * from member;

select c.*, m.nickname, m.profile
FROM community c
LEFT OUTER JOIN member m
ON c.id = m.id
order by post_date desc;

select count(*) from community_share;