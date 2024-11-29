
SELECT r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating 
FROM recipe r 
LEFT JOIN ( 
	SELECT recipe_no, AVG(rating) AS average_rating 
    FROM recipe_review 
    GROUP BY recipe_no 
) avg_rating ON r.no = avg_rating.recipe_no 
WHERE r.id='admin';

SELECT 
	r.*, 
    COALESCE(rr.average_rating, 0) AS average_rating, 
    COALESCE(rr.review_count, 0) AS review_count, 
    m.nickname AS nickname 
FROM recipe r 
LEFT JOIN ( 
	SELECT recipe_no, AVG(rating) AS average_rating, COUNT(rating) AS review_count 
    FROM recipe_review 
    GROUP BY recipe_no 
)rr ON r.no = rr.recipe_no 
LEFT JOIN member m ON r.id=m.id 
ORDER BY r.post_date DESC;


select r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating, m.nickname as nickname 
from recipe r
left join (
	select recipe_no, avg(rating) as average_rating
    from recipe_review
    group by recipe_no
) avg_rating on r.no = avg_rating.recipe_no
left join member m on r.id=m.id 
where r.title like '%33%'
and category=2 
order by r.post_date desc;

select
	r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating,
    m.nickname as nickname, m.profile as profile 
from recipe r
left join (
	select recipe_no, avg(rating) as average_rating
    from recipe_review
    group by recipe_no
) avg_rating on r.no = avg_rating.recipe_no
left join member m on r.id=m.id 
where r.no=59;

-- 리뷰 별 멤버의 닉네임을 같이 조회
SELECT r.*, m.nickname
FROM recipe_review r 
LEFT JOIN member m ON r.id=m.id
WHERE recipe_no=28;



SELECT 
    recipeWithAvg.*,
    m.nickname
FROM recipe_wishlist wish
LEFT JOIN (
	SELECT r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating 
	FROM recipe r
	LEFT JOIN (
		SELECT review.recipe_no, AVG(rating) AS average_rating
		FROM recipe_review review
		GROUP BY recipe_no
	) avg_rating ON r.no = avg_rating.recipe_no
) recipeWithAvg ON wish.recipe_no = recipeWithAvg.no
LEFT JOIN member m ON wish.id=m.id 
WHERE wish.id='admin';

select r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating, m.nickname as nickname 
from recipe r
left join (
	select recipe_no, avg(rating) as average_rating
    from recipe_review
    group by recipe_no
) avg_rating on r.no = avg_rating.recipe_no
left join member m on r.id=m.id 
where r.category=1 
order by r.post_date desc;



select c.*, m.profile, m.nickname 
from community_share c 
LEFT OUTER JOIN member m 
ON c.id = m.id
ORDER BY c.post_date DESC;

SELECT c.*, m.profile, m.nickname 
FROM community_share c 
LEFT OUTER JOIN member m 
ON c.id = m.id 
WHERE c.title like '%eo%' 
ORDER BY c.post_date DESC;

SELECT c.*, m.profile, m.nickname 
FROM community_share c 
LEFT OUTER JOIN member m 
ON c.id = m.id 
WHERE m.nickname like '%나리%'
ORDER BY c.post_date DESC;

SELECT c.*, m.nickname 
FROM community_share c 
LEFT OUTER JOIN member m 
ON c.id = m.id 
WHERE c.type = IF('재료나눔' LIKE '%이먹%', 0, IF('같이먹어요' LIKE '%이먹%',  1, -1)) 
ORDER BY c.post_date DESC; 

select * from mealkit;
select * from mealkit_review;
select * from member;
SELECT mk.*, mem.nickname FROM mealkit mk JOIN member mem ON mk.id = mem.id WHERE mk.category=1;

SELECT mk.*, mem.nickname FROM mealkit mk JOIN member mem ON mk.id = mem.id;
SELECT mr.*, mem.nickname FROM mealkit_review mr JOIN member mem ON mr.id = mem.id WHERE mealkit_no = 2;