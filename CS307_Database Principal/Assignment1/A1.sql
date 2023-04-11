--P1
SELECT station_id, chinese_name
FROM stations
WHERE english_name LIKE '%Shenzhen%'
  AND district IN ('Nanshan', 'Futian')
ORDER BY latitude ASC;


--P2
SELECT *
FROM color_names
ORDER BY hex DESC
LIMIT 10 OFFSET 12;


--P3
SELECT station_id, count(*) AS cnt
FROM bus_lines
GROUP BY station_id
HAVING count(*) = (SELECT min(cnt)
                   FROM (SELECT count(*) AS cnt
                         FROM bus_lines
                         GROUP BY station_id) t)
ORDER BY station_id DESC;


--P4
SELECT concat(
               round((SELECT count(*) AS cnt1
                      FROM (SELECT *
                            FROM (SELECT station_id FROM line_detail WHERE line_id = '2') a1
                                     INNER JOIN (SELECT station_id FROM line_detail WHERE line_id = '5') a2
                                                ON a1.station_id = a2.station_id) sub) /
                     (SELECT count(*) AS cnt2
                      FROM (SELECT *
                            FROM (SELECT station_id FROM line_detail WHERE line_id = '5') a2) sub2) * 100.0, 2)
           , '%') AS percentage;


--P5
SELECT CASE
           WHEN s.longitude IS NULL THEN 'no info'
           ELSE concat('longitude=', s.longitude)
           END AS longitude_information
FROM line_detail ld
         LEFT JOIN stations s ON ld.station_id = s.station_id
WHERE ld.line_id = '9';


--P6
SELECT s.station_id, s.english_name
FROM line_detail ld
         LEFT JOIN stations s ON ld.station_id = s.station_id
WHERE (ld.line_id = '4')
  AND (ld.station_id NOT IN (SELECT station_id FROM line_detail WHERE line_id = '1'))
  AND s.district = 'Futian'
order by s.station_id;


--P7
WITH station_cnt AS (SELECT ld.line_id, count(*) AS cnt
                     FROM line_detail ld
                              LEFT JOIN lines l ON ld.line_id = l.line_id
                     WHERE l.opening < '2015'
                     GROUP BY ld.line_id)
SELECT station_cnt.line_id, ls.line_color, station_cnt.cnt
FROM station_cnt
         LEFT JOIN lines ls ON station_cnt.line_id = ls.line_id
WHERE station_cnt.cnt = (SELECT min(cnt) FROM station_cnt)
ORDER BY ls.line_color;


--P8
WITH line_cnt AS (SELECT line_id, count(*) AS cn
                  FROM line_detail
                  GROUP BY line_id)
SELECT ld.line_id, s.station_id, s.chinese_name
FROM line_detail ld
         LEFT JOIN line_cnt lc ON ld.line_id = lc.line_id
         LEFT JOIN stations s ON ld.station_id = s.station_id
WHERE lc.cn = (SELECT (max(cn)) FROM line_cnt)
  AND ld.num = '3'
ORDER BY s.chinese_name;

