-- Приводим таблицу с городами в соответствие с ТЗ

INSERT INTO `geodata`.`_countries` (`id`, `title`) VALUES ('236', 'Unknown country');

INSERT INTO `geodata`.`_regions` (`id`, `country_id`, `title`) VALUES ('0', '236', 'No region');

-- автоматически для 'No region' присваевается id - 5468688; 

ALTER TABLE `geodata`.`_regions` 
DROP FOREIGN KEY `fk_countries`;
ALTER TABLE `geodata`.`_regions` 
;
ALTER TABLE `geodata`.`_regions` ALTER INDEX `fk_countries_idx` VISIBLE;
ALTER TABLE `geodata`.`_regions` 
ADD CONSTRAINT `fk_countries`
  FOREIGN KEY (`country_id`)
  REFERENCES `geodata`.`_countries` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

UPDATE `geodata`.`_cities` SET `region_id` = '5468688' WHERE (`region_id` is NULL);

ALTER TABLE `geodata`.`_cities` 
CHANGE COLUMN `region_id` `region_id` INT NOT NULL ;

ALTER TABLE `geodata`.`_cities` 
ADD INDEX `fk_regions_idx` (`region_id` ASC) VISIBLE;
;
ALTER TABLE `geodata`.`_cities` 
ADD CONSTRAINT `fk_regions`
  FOREIGN KEY (`region_id`)
  REFERENCES `geodata`.`_regions` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


/*
 1. Сделать запрос, в котором мы выберем все данные о
 городе – регион, страна.
*/
SELECT ct.title, r.title, ctr.title FROM geodata._cities AS ct
JOIN (geodata._regions AS r, geodata._countries AS ctr)
ON ct.region_id = r.id and ct.country_id = ctr.id;

/*
2. Выбрать все города из Московской области.
*/
SELECT ct.title, r.title, ctr.title FROM geodata._cities AS ct
JOIN (geodata._regions AS r, geodata._countries AS ctr)
ON ct.region_id = r.id and ct.country_id = ctr.id
WHERE r.title like 'Моск%';

/*
База данных «Сотрудники»:
1. Выбрать среднюю зарплату по отделам.
*/
SELECT avg(s.salary), de.dept_no FROM employees.salaries AS s
JOIN dept_emp AS de
ON s.emp_no = de.emp_no
GROUP BY dept_no;

/*
2. Выбрать максимальную зарплату у сотрудника.
*/
SELECT max(s.salary), e.first_name, e.last_name FROM employees.salaries AS s
JOIN employees.employees as e
ON s.emp_no = e.emp_no;

/*
3. Удалить одного сотрудника, у которого максимальная зарплата.
*/
DELETE employees, dept_emp
FROM salaries
JOIN employees ON employees.emp_no = salaries.emp_no 
JOIN dept_emp ON dept_emp.emp_no = salaries.emp_no
WHERE salaries.emp_no = (SELECT emp_no FROM salaries
where salary = (SELECT max(salary) from salaries));


/*
4. Посчитать количество сотрудников во всех отделах.
*/
SELECT count(emp_no) FROM dept_emp;


/*
5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
*/
SELECT d.dept_no, count(d.emp_no), sum(s.salary) FROM dept_emp AS d
JOIN salaries AS s
ON d.emp_no = s.emp_no
GROUP BY dept_no;
















