--P1
SELECT s.station_id, s.english_name
FROM line_detail ld
         JOIN stations s ON s.station_id = ld.station_id
WHERE ld.line_id = '1'
  AND s.district NOT IN ('Futian', 'Nanshan', 'Luohu')
ORDER BY s.station_id;


--P2
SELECT ld1.station_id, s.chinese_name, ld1.line_id AS line_id1, ld2.line_id AS line_id2
FROM line_detail ld1
         JOIN line_detail ld2 ON ld1.station_id = ld2.station_id
         JOIN stations s ON s.station_id = ld1.station_id
WHERE ld1.line_id < ld2.line_id
ORDER BY ld1.station_id, ld1.line_id, ld2.line_id;

--P3
WITH m AS (SELECT line_id, min(ld.station_id) AS starting, max(ld.station_id) AS terminal
           FROM line_detail ld
           GROUP BY ld.line_id)
SELECT m.line_id,
       s1.chinese_name AS starting_station,
       s2.chinese_name AS terminal_station,
       l.line_color,
       cn.hex          AS hex
FROM m
         JOIN stations s1 ON s1.station_id = m.starting
         JOIN stations s2 ON s2.station_id = m.terminal
         LEFT JOIN lines l ON m.line_id = l.line_id
         LEFT JOIN color_names cn ON l.line_color = cn.name
ORDER BY l.line_id;


--P4
WITH open_rank AS (SELECT dense_rank() OVER (ORDER BY l.opening) AS rank, l.line_id
                   FROM lines l
                   WHERE opening IS NOT NULL),
     sum AS (SELECT ld.line_id,
                    row_number() OVER (PARTITION BY ld.line_id ORDER BY (s.latitude + s.longitude) DESC ) AS row_n,
                    s.station_id
             FROM line_detail ld
                      LEFT JOIN stations s ON s.station_id = ld.station_id
             WHERE s.latitude IS NOT NULL
               AND s.longitude IS NOT NULL)
SELECT op.line_id, sum.station_id
FROM open_rank op
         LEFT JOIN sum ON op.line_id = sum.line_id
WHERE sum.row_n = 5
  AND (op.rank BETWEEN 3 AND 5);


--P5
WITH s_cnt AS (SELECT row_number() OVER (ORDER BY ld.line_id) AS row_id, count(ld.line_id) AS cnt, ld.line_id
               FROM line_detail ld
               GROUP BY ld.line_id)
SELECT sc1.line_id,
       (round(sc1.cnt * 100.00 / (SELECT count(*) FROM line_detail), 2) || '%') AS total_rate,
       CASE sc1.row_id
           WHEN '1' THEN null
           ELSE ((round(sc1.cnt * 100.00 / (SELECT sc2.cnt), 2)) || '%') END    AS last_rate
FROM s_cnt sc1
         LEFT JOIN s_cnt sc2 ON sc1.row_id - 1 = sc2.row_id;