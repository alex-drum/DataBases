/*
Пример транзакции: 
1. Нанимает сотрудника, вносим данные о нем в таблицу "Сотрудники";
2. Назначаем сотрудника в отдел, вносим соответствующую запись в таблицу "Сотрудники отделов";
3. Назначаем сотруднику зарплату, заносим запись об этом таблицу "Зарплаты".
*/

begin;
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) 
	values (1, '2000-01-01', 'Maya', 'Mayeva', 'F', '2020-08-01');
select 
    @emp_id:=emp_no
from
    employees
where
    first_name like 'Maya'
        and last_name like 'Mayeva';
insert into dept_emp (emp_no, dept_no, from_date, to_date) values (@emp_id, 'd004', '2020-08-01', '2021-08-01');
insert into salaries (emp_no, salary, from_date, to_date) values (@emp_id, 1000, '2020-08-01', '2021-02-01');
commit;
