-- Web Browse History
SELECT
    datetime(last_visit_time / 1000000 - 11644473600, 'unixepoch', 'localtime') AS  last_visit_time
,   title
,   url
FROM
    urls
ORDER BY
    last_visit_time DESC
;
