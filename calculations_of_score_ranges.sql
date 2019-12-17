/* Counts of score ranges for premier non spam account */
SELECT a.score_range, COUNT(a.score_range) AS ncustomers
FROM (SELECT customer_id, (MAX(score) - MIN(score)) AS score_range
    FROM score
    JOIN customer ON customer.id = score.customer_id
    WHERE customer.is_premier = true AND customer.is_spam = false
    GROUP BY customer_id
    ORDER BY score_range DESC) a
GROUP BY a.score_range
ORDER BY ncustomers DESC

/* Top 10 premier customers with largest score range and most responses */
SELECT customer_id, (MAX(score) - MIN(score)) AS score_range, COUNT(score) AS nresponses
    FROM score
    JOIN customer ON customer.id = score.customer_id
    WHERE customer.is_premier = true AND customer.is_spam = false
    GROUP BY customer_id
    ORDER BY score_range DESC, nresponses DESC
    LIMIT 10;

