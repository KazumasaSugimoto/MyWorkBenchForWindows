-- Web Browse History
SELECT
    datetime(u.last_visit_time / 1000000 - 11644473600, 'unixepoch', 'localtime')   AS  last_visit_time
,   u.title
,   u.url
FROM
    urls        u
LEFT OUTER JOIN
    ignore_urls i
ON
        u.url   LIKE    i.url
WHERE
        i.url   IS      NULL
ORDER BY
    u.last_visit_time   DESC
;
