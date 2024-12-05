SELECT 
k.no, k.id, k.title, k.contents, k.category, k.price, k.stock, k.pictures, 
o.no AS order_no, o.address, o.quantity, o.delivered, o.refund, 
m.nickname, m.profile 
FROM mealkit k 
INNER JOIN mealkit_order o ON k.no = o.mealkit_no 
INNER JOIN member m ON o.id = m.id 
WHERE k.id = 'tQi32Qj0iONPLRZ16-5sX4-Gq_p8Jg_T33r-HdtLEFE' AND o.delivered = ? 
ORDER BY o.post_date DESC