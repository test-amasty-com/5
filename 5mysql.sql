/*А*/;
SELECT * FROM information_schema.columns 
	where table_name = 'persons' or table_name = 'transactions' OR table_name = 'cities'
/*Б*/;
SELECT ROUND(100 + q1.s_plus-q2.s_minus,2) as `cur_amount` FROM 
		(SELECT SUM(amount) as `s_plus`,to_person_id FROM transactions WHERE to_person_id=2) as q1
	LEFT JOIN 
	   (SELECT SUM(amount) as `s_minus`, from_person_id FROM transactions WHERE from_person_id=2) as q2
ON q1.to_person_id = q2.from_person_id
/*В*/;
SELECT p.fullname FROM `persons` p
INNER JOIN  (
	SELECT SUM(tbl.count_tmp) as `cont`,tbl.id_person as `tmp_id` FROM
		(SELECT COUNT(to_person_id) AS `count_tmp` ,from_person_id as `id_person`
			FROM `transactions` GROUP BY from_person_id UNION ALL
		SELECT count(from_person_id)  AS `count_tmp` ,to_person_id as `id_person`
			FROM `transactions` GROUP BY to_person_id) as tbl
		GROUP BY tbl.id_person ORDER BY cont DESC limit 1
		) mx ON mx.tmp_id=p.id
/*Г*/;
SELECT * FROM (
    SELECT transaction_id, tr.from_person_id, tr.to_person_id, p.city_id as `city_id_to`, pp.city_id as `city_id_from`, pp.fullname as `from fullname`, p.fullname as `to_fullname`, tr.amount
	FROM `transactions` AS tr
	JOIN  `persons` AS p ON  tr.to_person_id = p.id
	JOIN  `persons` AS pp ON  tr.from_person_id = pp.id
	)AS top  INNER JOIN `cities` as sit ON sit.id = city_id_to WHERE city_id_to = city_id_from