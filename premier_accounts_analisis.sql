/* Query to count the number of premier accounts: */
SELECT COUNT(*)
FROM customer
WHERE is_premier = true;

/* Query to check if premier accounts give higher scores: */
SELECT ROUND(AVG(s.score),2) AS avg_score_premier
FROM score s
JOIN customer c ON s.customer_id = c.id
WHERE c.is_premier = true;

/* Query to obtain the average score of all accounts (without spam accounts): */
SELECT ROUND(AVG(s.score),2) AS avg_score_all
FROM score s
JOIN customer c ON s.customer_id = c.id
WHERE c.is_spam = false;
