SELECT
    us_state,
    argMax(cat_id, amount) AS max_category,
    max(amount) AS max_amount
FROM transactions_opt
GROUP BY us_state
ORDER BY us_state;
