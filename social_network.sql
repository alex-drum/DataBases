DROP DATABASE IF EXISTS `bastardgram`;
CREATE DATABASE IF NOT EXISTS `bastardgram`;
USE `bastardgram`;

DROP TABLE IF EXISTS roles, users, likes;

CREATE TABLE `bastardgram`.`roles` (
  `id` VARCHAR(10)NOT NULL,
  `role` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `role_UNIQUE` (`role` ASC) VISIBLE);

INSERT INTO `bastardgram`.`roles` (`id`, `role`) VALUES ('u' ,'user');
INSERT INTO `bastardgram`.`roles` (`id`, `role`) VALUES ('ph', 'photo');
INSERT INTO `bastardgram`.`roles` (`id`, `role`) VALUES ('phcmt', 'photo_comment');

CREATE TABLE `bastardgram`.`users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `role_id` SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  INDEX `fk_role_id_idx` (`role_id` ASC) VISIBLE,
  CONSTRAINT `fk_role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `bastardgram`.`roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

INSERT INTO `bastardgram`.`users` (`name`) VALUES ('A');
INSERT INTO `bastardgram`.`users` (`name`) VALUES ('B');
INSERT INTO `bastardgram`.`users` (`name`) VALUES ('C');
INSERT INTO `bastardgram`.`users` (`name`) VALUES ('D');
INSERT INTO `bastardgram`.`users` (`name`) VALUES ('E');

CREATE TABLE `bastardgram`.`likes_sent` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sent_from` INT UNSIGNED NOT NULL,
  `sent_from_role` VARCHAR(10) NOT NULL DEFAULT 'u',
  `sent_to` INT UNSIGNED NOT NULL,
  `sent_to_role` VARCHAR(10) NOT NULL,
  `match` VARCHAR(100) GENERATED ALWAYS AS (CONCAT(sent_from_role, sent_from, sent_to_role, sent_to)) VIRTUAL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `match_UNIQUE` (`match` ASC) VISIBLE,
  INDEX `fk_sent_from_idx` (`sent_from` ASC) VISIBLE,
  INDEX `fk_sent_from_role_idx` (`sent_from_role` ASC) VISIBLE,
  INDEX `fk_sent_to_idx` (`sent_to` ASC) VISIBLE,
  INDEX `fk_sent_to_role_idx` (`sent_to_role` ASC) VISIBLE,
  CONSTRAINT `fk_sent_from`
    FOREIGN KEY (`sent_from`)
    REFERENCES `bastardgram`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sent_from_role`
    FOREIGN KEY (`sent_from_role`)
    REFERENCES `bastardgram`.`users` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sent_to`
    FOREIGN KEY (`sent_to`)
    REFERENCES `bastardgram`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sent_to_role`
    FOREIGN KEY (`sent_to_role`)
    REFERENCES `bastardgram`.`users` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('1', '2', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('1', '3', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('1', '4', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('1', '5', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('2', '1', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('2', '5', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('3', '1', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('3', '4', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('4', '2', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('4', '3', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('5', '1', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('5', '2', 'u');
INSERT INTO `bastardgram`.`likes_sent` (`sent_from`, `sent_to`, `sent_to_role`) VALUES ('5', '4', 'u');

ALTER TABLE `bastardgram`.`likes_sent` 
CHANGE COLUMN `sent_from` `sent_by` INT UNSIGNED NOT NULL ,
CHANGE COLUMN `sent_from_role` `sent_by_role` VARCHAR(10) NOT NULL DEFAULT 'u' ,
CHANGE COLUMN `match` `match` VARCHAR(100) GENERATED ALWAYS AS (concat(`sent_by_role`,`sent_by`,`sent_to_role`,`sent_to`)) VIRTUAL ,
DROP INDEX `fk_sent_from_role_idx` ,
DROP INDEX `fk_sent_from_idx` ;
;

ALTER TABLE `bastardgram`.`likes_sent` 
ADD INDEX `fk_sent_by_idx` (`sent_by` ASC) VISIBLE,
ADD INDEX `fk_sent_by_role_idx` (`sent_by_role` ASC) VISIBLE;
;
ALTER TABLE `bastardgram`.`likes_sent` 
ADD CONSTRAINT `fk_sent_by`
  FOREIGN KEY (`sent_by`)
  REFERENCES `bastardgram`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_sent_by_role`
  FOREIGN KEY (`sent_by_role`)
  REFERENCES `bastardgram`.`users` (`role_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `bastardgram`.`likes_sent` 
CHANGE COLUMN `match` `match` VARCHAR(100) GENERATED ALWAYS AS (concat(`sent_by_role`,`sent_by`,`sent_to_role`,`sent_to`)) VIRTUAL ;

CREATE TABLE `bastardgram`.`likes_received` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `received_by` INT UNSIGNED NOT NULL,
  `received_from` INT UNSIGNED NOT NULL,
  `match` VARCHAR(100) GENERATED ALWAYS AS (CONCAT(received_by_role, received_by, received_from_role, received_from)) VIRTUAL,
  `received_by_role` VARCHAR(10) NOT NULL,
  `received_from_role` VARCHAR(10) NOT NULL DEFAULT 'u',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `match_UNIQUE` (`match` ASC) VISIBLE,
  INDEX `fk_received_by_idx` (`received_by` ASC) VISIBLE,
  INDEX `fk_received_by_role_idx` (`received_by_role` ASC) VISIBLE,
  INDEX `fk_received_from_idx` (`received_from` ASC) VISIBLE,
  INDEX `fk_received_from_role_idx` (`received_from_role` ASC) VISIBLE,
  CONSTRAINT `fk_received_by`
    FOREIGN KEY (`received_by`)
    REFERENCES `bastardgram`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_received_by_role`
    FOREIGN KEY (`received_by_role`)
    REFERENCES `bastardgram`.`users` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_received_from`
    FOREIGN KEY (`received_from`)
    REFERENCES `bastardgram`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_received_from_role`
    FOREIGN KEY (`received_from_role`)
    REFERENCES `bastardgram`.`users` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `bastardgram`.`likes_received` 
CHANGE COLUMN `received_by_role` `received_by_role` VARCHAR(10) NOT NULL AFTER `received_by`,
CHANGE COLUMN `received_from_role` `received_from_role` VARCHAR(10) NOT NULL DEFAULT 'u' AFTER `received_from`;


INSERT INTO likes_received (received_by, received_by_role, received_from, received_from_role) 
SELECT sent_to, sent_to_role, sent_by, sent_by_role FROM likes_sent;


CREATE TABLE `bastardgram`.`photos` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `role_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_role_id_idx` (`role_id` ASC) VISIBLE,
  CONSTRAINT `fk_photo_role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `bastardgram`.`roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `bastardgram`.`photos` 
DROP FOREIGN KEY `fk_Photo_role_id`;
ALTER TABLE `bastardgram`.`photos` 
CHANGE COLUMN `role_id` `role_id` VARCHAR(45) NOT NULL DEFAULT 'ph' ;
ALTER TABLE `bastardgram`.`photos` 
ADD CONSTRAINT `fk_Photo_role_id`
  FOREIGN KEY (`role_id`)
  REFERENCES `bastardgram`.`roles` (`id`);

INSERT INTO `bastardgram`.`photos` (`id`) VALUES ('1');
INSERT INTO `bastardgram`.`photos` (`id`) VALUES ('2');
INSERT INTO `bastardgram`.`photos` (`id`) VALUES ('3');
INSERT INTO `bastardgram`.`photos` (`id`) VALUES ('4');
INSERT INTO `bastardgram`.`photos` (`id`) VALUES ('5');



