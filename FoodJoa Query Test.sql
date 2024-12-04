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