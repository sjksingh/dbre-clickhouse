INSERT INTO dbre.test_stp (a, b, c)
SELECT
    number,
    randomPrintableASCII(128),
    (now() - toIntervalDay(1)) - toIntervalDay(arrayJoin(array(0,1,2,3,4,5,6,7,8,9)))
FROM numbers(50000);
