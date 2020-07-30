/* 
1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3: делаю представление для количества сотрудников по каждому отделу и суммы всех зарплат отдела
*/ 

USE `employees`;
CREATE  OR REPLACE VIEW `deps_count_and_sum_salary` AS
SELECT d.dept_no, count(d.emp_no), sum(s.salary) FROM dept_emp AS d
JOIN salaries AS s
ON d.emp_no = s.emp_no
GROUP BY dept_no;;


-- Исполнение запроса с использованием представления
SELECT * FROM deps_count_and_sum_salary;

/* 
2. Создать функцию, которая найдет менеджера по имени и фамилии.
*/

CREATE DEFINER=`root`@`localhost` FUNCTION `find_manager`(f_name varchar(25), l_name varchar (25)) RETURNS char(10) CHARSET utf8mb4
    READS SQL DATA
BEGIN
RETURN (
SELECT 
    dm.emp_no
FROM
    employees.dept_manager AS dm
        JOIN
    employees.employees AS e ON dm.emp_no = e.emp_no
WHERE
    e.first_name LIKE f_name
        AND e.last_name LIKE l_name
        AND e.emp_no = dm.emp_no
);
return 1;
END

-- Исполнение запроса с использованием функции
SELECT find_manager('Margareta', 'Markovitch')

/* 
3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.
*/

DROP TRIGGER IF EXISTS `employees`.`employees_AFTER_INSERT`;

DELIMITER $$
USE `employees`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `employees_AFTER_INSERT` AFTER INSERT ON `employees` FOR EACH ROW BEGIN
INSERT INTO `employees`.`salaries` (`emp_no`, `salary`, `from_date`, `to_date`) VALUES (NEW.emp_no, '1500', '2020-07-01', '2020-07-10');
END$$
DELIMITER ;


-- Проверка исполнения триггера

INSERT INTO `employees`.`employees` (`emp_no`, `birth_date`, `first_name`, `last_name`, `gender`, `hire_date`) VALUES ('1', '1000-01-01', 'Ivan', 'Ivanov', 'M', '2020-07-01');
	