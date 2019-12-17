/* Query to count the number of spam accounts: */
SELECT COUNT(*)
FROM customer
WHERE is_spam = true;

/* Query to check if spam accounts are giving artificially low scores: */
SELECT ROUND(AVG(s.score),2) AS avg_score_spam
FROM score s
JOIN customer c ON s.customer_id = c.id
WHERE c.is_spam = true

