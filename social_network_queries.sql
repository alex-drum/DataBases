-- id пользователя; имя; лайков получено.

SELECT 
    u.id, u.name, COUNT(ls.sent_by) sent
FROM
    users u
        JOIN
    likes_sent ls ON u.id = ls.sent_by
WHERE
    u.id = 1;


-- id пользователя; имя; лайков поставлено.

SELECT 
    u.id, u.name sent, COUNT(lr.received_by)
FROM
    users u
        JOIN
    likes_received lr ON u.id = lr.received_by
WHERE
    u.id = 1;



-- id пользователя; имя; взаимные лайки.

SELECT 
    u.id, u.name, lr.match
FROM
    likes_received lr
        JOIN
    users u ON u.id = lr.received_by
        JOIN
    likes_sent ls ON lr.match LIKE ls.match
WHERE
    ls.sent_by = 1;


/*
список всех пользователей, которые поставили лайк пользователям A и B (id задайте произвольно), но при этом не поставили лайк пользователю C
*/

SELECT 
    sent_by
FROM
    likes_sent
WHERE
    sent_by IN (SELECT 
            sent_by
        FROM
            likes_sent
        WHERE
            sent_by IN (SELECT 
                    sent_by
                FROM
                    likes_sent
                WHERE
                    sent_to = 1)
                AND sent_to = 2)
        AND sent_by NOT IN (SELECT 
            sent_by
        FROM
            likes_sent
        WHERE
            sent_to = 3)
GROUP BY sent_by


/*
пользователь не может дважды лайкнуть одну и ту же сущность

Для этого в таблицах лайков создаем поле "match", которое формируется из данных о пользователе, поставившем лайк, и сущности, получившей лайк, и делаем это поле уникальным
*/

-- пользователь имеет право отозвать лайк;

BEGIN;
DELETE FROM `bastardgram`.`likes_sent` WHERE (`id` = '1');
DELETE FROM `bastardgram`.`likes_received` WHERE (`id` = '1');
COMMIT;

/*
необходимо иметь возможность считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки;
*/



