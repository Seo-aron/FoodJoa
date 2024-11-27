SELECT * FROM recent_view;
SELECT * FROM mealkit;

SELECT 
r.title, r.thumbnail, r.description, r.category,
m.nickname, m.profile
FROM recent_view v
LEFT JOIN recipe r 
ON v.item_no = r.no
LEFT JOIN member m
ON r.id=m.id
WHERE v.id='tQi32Qj0iONPLRZ16-5sX4-Gq_p8Jg_T33r-HdtLEFE' 
ORDER BY r.post_date DESC LIMIT 20;

