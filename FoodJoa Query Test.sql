<<<<<<< HEAD
SELECT 
r.title, r.contents, r.category, r.thumbnail, 
m.nickname, m.profile, 
COALESCE(average_table.average_rating, 0) AS average_rating
FROM recent_view v 
LEFT JOIN recipe r ON v.item_no = r.no 
LEFT JOIN member m ON m.id = r.id 
LEFT JOIN (
SELECT recipe_no, AVG(rating) AS average_rating
FROM recipe_review
GROUP BY recipe_no
) average_table ON average_table.recipe_no = v.item_no 
WHERE v.id = 'tQi32Qj0iONPLRZ16-5sX4-Gq_p8Jg_T33r-HdtLEFE' AND v.type=0
ORDER BY v.view_date DESC LIMIT 20;



SELECT 
k.title, k.contents, k.category, k.price, k.pictures, 
m.nickname, m.profile, 
COALESCE(average_table.average_rating, 0) AS average_rating
FROM recent_view v 
LEFT JOIN mealkit k ON v.item_no = k.no 
LEFT JOIN member m ON m.id = k.id 
LEFT JOIN (
SELECT mealkit_no, AVG(rating) AS average_rating
FROM mealkit_review 
GROUP BY mealkit_no
) average_table ON average_table.mealkit_no = v.item_no 
WHERE v.id = 'tQi32Qj0iONPLRZ16-5sX4-Gq_p8Jg_T33r-HdtLEFE' AND v.type=1
ORDER BY v.view_date DESC LIMIT 20;

select * from member;

select * from mealkit;

select * from recipe_review;

select * from mealkit_review;

select * from recent_view;
=======
SELECT * FROM mealkit;
SELECT * FROM mealkit_review;

SELECT
k.*, coalesce(avg_table.avg_rating, 0) AS average_rating, m.nickname 
FROM mealkit k
JOIN (
	SELECT
		mr.mealkit_no, AVG(rating) as avg_rating
    FROM mealkit_review mr
    GROUP BY mr.mealkit_no
) avg_table ON k.no=avg_table.mealkit_no
JOIN member m 
ON k.id=m.id
WHERE no=1;
>>>>>>> 0945a78673293758c58920c14c2ae08fcfafb845
