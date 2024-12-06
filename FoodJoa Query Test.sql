SELECT c.*, m.profile, m.nickname 
FROM community_share c 
LEFT OUTER JOIN member m 
ON c.id = m.id 
WHERE c.type like IF('재료나눔' like '%가%', 0, IF('같이먹어요' like '%가%', 1, -1))
ORDER BY c.post_date DESC;