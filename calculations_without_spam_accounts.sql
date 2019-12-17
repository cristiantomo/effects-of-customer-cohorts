/* Remove spam accounts before calculating the NPS scores */
SELECT *, ROUND(((CAST(promoter AS DECIMAL) / total) - (CAST(detractor AS DECIMAL) / total)) * 100, 0) AS nps FROM
(SELECT week,
SUM(CASE WHEN nps_class = 'promoter' THEN 1 ELSE 0 END) AS "promoter",
SUM(CASE WHEN nps_class = 'passive' THEN 1 ELSE 0 END) AS "passive",
SUM(CASE WHEN nps_class = 'detractor' THEN 1 ELSE 0 END) AS "detractor",
    COUNT(*) AS "total" FROM
(SELECT CASE
    WHEN avg_week_score > 8 THEN 'promoter'
    WHEN avg_week_score > 6 THEN 'passive'
    ELSE 'detractor'
END AS nps_class, week FROM
(SELECT TO_CHAR(score.created_at, 'IYYY-IW') AS week, customer_id, AVG(score) as avg_week_score FROM score
 JOIN customer ON customer.id = score.customer_id
 WHERE customer.is_spam = false
GROUP BY week, customer_id) a) b
GROUP BY week
ORDER BY week) c
limit 100; 

/* Summarize the NPS results by month instead of by week */
SELECT *, ROUND(((CAST(promoter AS DECIMAL) / total) - (CAST(detractor AS DECIMAL) / total)) * 100, 0) AS nps FROM
(SELECT year_month,
SUM(CASE WHEN nps_class = 'promoter' THEN 1 ELSE 0 END) AS "promoter",
SUM(CASE WHEN nps_class = 'passive' THEN 1 ELSE 0 END) AS "passive",
SUM(CASE WHEN nps_class = 'detractor' THEN 1 ELSE 0 END) AS "detractor",
    COUNT(*) AS "total" FROM
(SELECT CASE
    WHEN avg_year_month_score > 8 THEN 'promoter'
    WHEN avg_year_month_score > 6 THEN 'passive'
    ELSE 'detractor'
END AS nps_class, year_month FROM
(SELECT TO_CHAR(score.created_at, 'IYYY-MM') AS year_month, customer_id, AVG(score) as avg_year_month_score FROM score
 JOIN customer ON customer.id = score.customer_id
 WHERE customer.is_spam = false
GROUP BY year_month, customer_id) a) b
GROUP BY year_month
ORDER BY year_month) c;

/* How much higher are scores in the first five weeks with spam accounts filtered out? */
SELECT *, ROUND(((CAST(promoter AS DECIMAL) / total) - (CAST(detractor AS DECIMAL) / total)) * 100, 0) AS nps FROM
(SELECT week,
SUM(CASE WHEN nps_class = 'promoter' THEN 1 ELSE 0 END) AS "promoter",
SUM(CASE WHEN nps_class = 'passive' THEN 1 ELSE 0 END) AS "passive",
SUM(CASE WHEN nps_class = 'detractor' THEN 1 ELSE 0 END) AS "detractor",
    COUNT(*) AS "total" FROM
(SELECT CASE
    WHEN avg_week_score > 8 THEN 'promoter'
    WHEN avg_week_score > 6 THEN 'passive'
    ELSE 'detractor'
END AS nps_class, week FROM
(SELECT TO_CHAR(score.created_at, 'IYYY-IW') AS week, customer_id, AVG(score) as avg_week_score FROM score
 JOIN customer ON customer.id = score.customer_id
 WHERE customer.is_spam = false
GROUP BY week, customer_id) a) b
GROUP BY week
ORDER BY week) c
limit 5;










