/* Monthly growth rate */
SELECT year_month, 
ROUND(CAST((ncustomers-previous_month_users)*100 AS DECIMAL) / previous_month_users, 2) AS growth_rate_per_cent
FROM(SELECT *, LAG(ncustomers, 1) OVER () AS previous_month_users
FROM(SELECT TO_CHAR(customer.created_at, 'IYYY-MM') AS year_month, 
    COUNT(customer.id) AS ncustomers
    FROM customer
    GROUP BY year_month
    ORDER BY year_month) a) b

/* Monthly growth rate and NPS */

CREATE VIEW growth AS
SELECT year_month, 
ROUND(CAST((ncustomers-previous_month_users)*100 AS DECIMAL) / previous_month_users, 2) AS growth_rate_per_cent
FROM(SELECT *, LAG(ncustomers, 1) OVER () AS previous_month_users
FROM(SELECT TO_CHAR(customer.created_at, 'IYYY-MM') AS year_month, 
    COUNT(customer.id) AS ncustomers
    FROM customer
    GROUP BY year_month
    ORDER BY year_month) a) b;

CREATE VIEW nps AS
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

SELECT g.year_month, g.growth_rate_per_cent, n.nps
FROM growth g
JOIN nps n ON n.year_month = g.year_month;
