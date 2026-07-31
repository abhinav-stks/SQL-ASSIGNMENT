-- ============================================================
-- Oracle Database 11g: SQL Fundamentals I - Complete Lab Script
-- Run this whole file with SQL*Plus (see instructions) or
-- open in SQL Developer and run as a script (F5) to spool
-- every statement + its output into one file.
-- ============================================================

SET ECHO ON
SET FEEDBACK ON
SET LINESIZE 200
SET PAGESIZE 100
SET DEFINE OFF
SPOOL "C:\Users\Nehal Sahu\Desktop\labs\all_output.txt"

PROMPT ===================== CLEANUP (safe to ignore "does not exist" here) =====================
-- Drops leftover objects from a previous run of this script so it can be re-run cleanly.
-- These errors are EXPECTED and harmless on the very first run.

BEGIN EXECUTE IMMEDIATE 'DROP TABLE my_employee'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE emp'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE dept'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE employees2'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW employees_vu'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW dept50'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE dept_id_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SYNONYM emp_syn'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE job_grades'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- job_grades doesn't exist in this database, so create it with the standard sample data
CREATE TABLE job_grades (
  grade_level VARCHAR2(3),
  lowest_sal  NUMBER,
  highest_sal NUMBER
);
INSERT INTO job_grades VALUES ('A', 1000, 2999);
INSERT INTO job_grades VALUES ('B', 3000, 5999);
INSERT INTO job_grades VALUES ('C', 6000, 9999);
INSERT INTO job_grades VALUES ('D', 10000, 14999);
INSERT INTO job_grades VALUES ('E', 15000, 24999);
INSERT INTO job_grades VALUES ('F', 25000, 40000);
COMMIT;

PROMPT ===================== LAB 1: Retrieving Data =====================

-- Structure of DEPARTMENTS and EMPLOYEES tables
DESCRIBE departments;
DESCRIBE employees;

-- lab_01_05.sql
SELECT employee_id, last_name, job_id, hire_date AS startdate
FROM employees;

-- Unique job IDs
SELECT DISTINCT job_id FROM employees;

-- lab_01_08 (column headings)
SELECT employee_id "Emp #", last_name "Employee", job_id "Job", hire_date "Hire Date"
FROM employees;

-- Employee and Title
SELECT last_name || ', ' || job_id AS "Employee and Title"
FROM employees;

-- THE_OUTPUT (all columns comma separated, includes generated username)
SELECT employee_id || ',' || first_name || ',' || last_name || ',' ||
       UPPER(SUBSTR(first_name,1,1) || last_name) || ',' ||
       phone_number || ',' || job_id || ',' || manager_id || ',' ||
       hire_date || ',' || salary || ',' || commission_pct || ',' ||
       department_id AS THE_OUTPUT
FROM employees;


PROMPT ===================== LAB 2: Restricting and Sorting =====================

-- lab_02_01.sql
SELECT last_name, salary FROM employees WHERE salary > 12000;

-- Employee 176
SELECT last_name, department_id FROM employees WHERE employee_id = 176;

-- lab_02_03.sql
SELECT last_name, salary FROM employees WHERE salary NOT BETWEEN 5000 AND 12000;

-- Matos and Taylor, ordered by hire date
SELECT last_name, job_id, hire_date
FROM employees
WHERE last_name IN ('Matos','Taylor')
ORDER BY hire_date ASC;

-- Departments 20 or 50
SELECT last_name, department_id
FROM employees
WHERE department_id IN (20,50)
ORDER BY last_name ASC;

-- lab_02_06.sql
SELECT last_name AS "Employee", salary AS "Monthly Salary"
FROM employees
WHERE salary BETWEEN 5000 AND 12000
AND department_id IN (20,50);

-- Hired in 1994
SELECT last_name, hire_date FROM employees WHERE hire_date LIKE '%94';

-- No manager
SELECT last_name, job_id FROM employees WHERE manager_id IS NULL;

-- Commission, sorted by numeric position
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY 2 DESC, 3 DESC;

-- lab_02_10.sql (using the assignment's example value of 12000, no prompt)
SELECT last_name, salary FROM employees WHERE salary > 12000;

-- Manager-based report - the assignment's three test cases, run directly (no prompt)
-- manager_id = 103, sorted by last_name
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE manager_id = 103 ORDER BY last_name;

-- manager_id = 201, sorted by salary
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE manager_id = 201 ORDER BY salary;

-- manager_id = 124, sorted by employee_id
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE manager_id = 124 ORDER BY employee_id;

-- Third letter is 'a'
SELECT last_name FROM employees WHERE last_name LIKE '__a%';

-- Contains both 'a' and 'e'
SELECT last_name FROM employees WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';

-- SA_REP or ST_CLERK, salary not in set
SELECT last_name, job_id, salary
FROM employees
WHERE job_id IN ('SA_REP','ST_CLERK')
AND salary NOT IN (2500,3500,7000);

-- lab_02_15.sql
SELECT last_name AS "Employee", salary AS "Monthly Salary", commission_pct
FROM employees
WHERE commission_pct = 0.2;


PROMPT ===================== LAB 3: Single-Row Functions =====================

SELECT SYSDATE AS "Date" FROM dual;

-- lab_03_02.sql
SELECT employee_id, last_name, salary, ROUND(salary*1.155) AS "New Salary"
FROM employees;

-- lab_03_04.sql
SELECT employee_id, last_name, salary,
       ROUND(salary*1.155) AS "New Salary",
       ROUND(salary*1.155) - salary AS "Increase"
FROM employees;

-- Names starting with J, A, or M
SELECT INITCAP(last_name) AS "Name", LENGTH(last_name) AS "Length"
FROM employees
WHERE SUBSTR(last_name,1,1) IN ('J','A','M')
ORDER BY last_name;

-- Case-insensitive version, using the assignment's example letter 'H' (no prompt)
SELECT INITCAP(last_name) AS "Name", LENGTH(last_name) AS "Length"
FROM employees
WHERE UPPER(SUBSTR(last_name,1,1)) = UPPER('H')
ORDER BY last_name;

-- Months worked
SELECT last_name, CEIL(MONTHS_BETWEEN(SYSDATE, hire_date)) AS MONTHS_WORKED
FROM employees
ORDER BY MONTHS_WORKED;

-- Salary padded with $
SELECT last_name, LPAD(salary,15,'$') AS SALARY FROM employees;

-- Salary in asterisks
SELECT RPAD(SUBSTR(last_name,1,8), 10) ||
       RPAD('*', TRUNC(salary/1000), '*') AS EMPLOYEES_AND_THEIR_SALARIES
FROM employees
ORDER BY salary DESC;

-- Tenure in weeks, department 90
SELECT last_name, TRUNC((SYSDATE - hire_date)/7) AS TENURE
FROM employees
WHERE department_id = 90
ORDER BY TENURE DESC;


PROMPT ===================== LAB 4: Conversion & Conditional Expressions =====================

SELECT last_name || ' earns $' || TO_CHAR(salary,'999,999.00') ||
       ' monthly but wants $' || TO_CHAR(salary*3,'999,999.00') || '.' AS "Dream Salaries"
FROM employees;

SELECT last_name, hire_date,
       TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date,6),'MONDAY'),
       'fmDay, "the" Ddspth "of" Month, YYYY') AS REVIEW
FROM employees;

SELECT last_name, hire_date, TO_CHAR(hire_date,'DAY') AS DAY
FROM employees
ORDER BY TO_CHAR(hire_date,'D');

SELECT last_name, NVL(TO_CHAR(commission_pct),'No Commission') AS COMM
FROM employees;

-- DECODE version
SELECT job_id,
       DECODE(job_id,'AD_PRES','A','ST_MAN','B','IT_PROG','C',
                      'SA_REP','D','ST_CLERK','E','0') AS GRADE
FROM employees;

-- CASE version
SELECT job_id,
       CASE job_id
            WHEN 'AD_PRES' THEN 'A'
            WHEN 'ST_MAN'  THEN 'B'
            WHEN 'IT_PROG' THEN 'C'
            WHEN 'SA_REP'  THEN 'D'
            WHEN 'ST_CLERK' THEN 'E'
            ELSE '0'
       END AS GRADE
FROM employees;


PROMPT ===================== LAB 5: Group Functions =====================

-- True/False conceptual questions (not SQL - answer for your written submission):
-- 1) Group functions work across many rows to produce one result per group.  TRUE
-- 2) Group functions include nulls in calculations.                          FALSE (group functions ignore NULLs, except COUNT(*))
-- 3) The WHERE clause restricts rows before inclusion in a group calculation. TRUE

-- lab_05_04.sql
SELECT ROUND(MAX(salary)) AS Maximum, ROUND(MIN(salary)) AS Minimum,
       ROUND(SUM(salary)) AS Sum, ROUND(AVG(salary)) AS Average
FROM employees;

-- lab_05_05.sql
SELECT job_id, MAX(salary) AS Maximum, MIN(salary) AS Minimum,
       SUM(salary) AS Sum, AVG(salary) AS Average
FROM employees
GROUP BY job_id;

-- Count by job
SELECT job_id, COUNT(*) FROM employees GROUP BY job_id;

-- lab_05_06.sql, using the assignment's example job title 'IT_PROG' (no prompt)
SELECT job_id, COUNT(*)
FROM employees
WHERE job_id = 'IT_PROG'
GROUP BY job_id;

-- Number of managers
SELECT COUNT(DISTINCT manager_id) AS "Number of Managers" FROM employees;

-- Difference between highest and lowest salary
SELECT MAX(salary) - MIN(salary) AS DIFFERENCE FROM employees;

-- Lowest paid employee per manager
SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) > 6000
ORDER BY MIN(salary) DESC;

-- Total hired per year
SELECT COUNT(*) "TOTAL",
       SUM(DECODE(TO_CHAR(hire_date,'YYYY'),1995,1,0)) "1995",
       SUM(DECODE(TO_CHAR(hire_date,'YYYY'),1996,1,0)) "1996",
       SUM(DECODE(TO_CHAR(hire_date,'YYYY'),1997,1,0)) "1997",
       SUM(DECODE(TO_CHAR(hire_date,'YYYY'),1998,1,0)) "1998"
FROM employees;

-- Matrix query
SELECT job_id "Job",
       SUM(DECODE(department_id,20,salary)) "Dept 20",
       SUM(DECODE(department_id,50,salary)) "Dept 50",
       SUM(DECODE(department_id,80,salary)) "Dept 80",
       SUM(DECODE(department_id,90,salary)) "Dept 90",
       SUM(salary) "Total"
FROM employees
WHERE department_id IN (20,50,80,90)
GROUP BY job_id;


PROMPT ===================== LAB 6: Joins =====================

SELECT location_id, street_address, city, state_province, country_name
FROM locations NATURAL JOIN countries;

SELECT last_name, department_id, department_name
FROM employees JOIN departments USING (department_id);

SELECT last_name, job_id, department_id, department_name
FROM employees
JOIN departments USING (department_id)
JOIN locations USING (location_id)
WHERE city = 'Toronto';

-- lab_06_04.sql
SELECT e.last_name AS "Employee", e.employee_id AS "Emp#",
       m.last_name AS "Manager", m.employee_id AS "Mgr#"
FROM employees e JOIN employees m ON e.manager_id = m.employee_id;

-- lab_06_05.sql (include King)
SELECT e.last_name AS "Employee", e.employee_id AS "Emp#",
       m.last_name AS "Manager", m.employee_id AS "Mgr#"
FROM employees e LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;

-- lab_06_06.sql (colleagues)
SELECT e1.department_id AS DEPARTMENT, e1.last_name AS EMPLOYEE, e2.last_name AS COLLEAGUE
FROM employees e1 JOIN employees e2
     ON e1.department_id = e2.department_id AND e1.employee_id != e2.employee_id
ORDER BY e1.department_id;

-- Job grades report
DESCRIBE job_grades;

SELECT e.last_name, e.job_id, d.department_name, e.salary, j.grade_level
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN job_grades j ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;

-- Hired after Davies
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date FROM employees WHERE last_name = 'Davies');

-- lab_06_09.sql - hired before manager
SELECT e.last_name, e.hire_date, m.last_name, m.hire_date
FROM employees e JOIN employees m ON e.manager_id = m.employee_id
WHERE e.hire_date < m.hire_date;


PROMPT ===================== LAB 7: Subqueries =====================

-- Using the assignment's example name 'Zlotkey' (no prompt)
SELECT last_name, hire_date
FROM employees
WHERE department_id = (SELECT department_id FROM employees WHERE last_name = 'Zlotkey')
AND last_name != 'Zlotkey';

SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary ASC;

-- lab_07_03.sql
SELECT employee_id, last_name
FROM employees
WHERE department_id IN (SELECT department_id FROM employees WHERE last_name LIKE '%u%');

-- lab_07_04.sql (location_id hardcoded to 1700, no prompt)
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE location_id = 1700);

-- Reports to King (this schema has 2 employees named King, so filter by job to get the President)
SELECT last_name, salary
FROM employees
WHERE manager_id = (SELECT employee_id FROM employees WHERE last_name = 'King' AND job_id = 'AD_PRES');

-- Executive department
SELECT department_id, last_name, job_id
FROM employees
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Executive');

-- Salary more than any in department 60
SELECT last_name
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE department_id = 60);

-- lab_07_08.sql
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
AND department_id IN (SELECT department_id FROM employees WHERE last_name LIKE '%u%');


PROMPT ===================== LAB 8: Set Operators =====================

SELECT DISTINCT department_id FROM employees
MINUS
SELECT department_id FROM employees WHERE job_id = 'ST_CLERK';

SELECT country_id, country_name FROM countries
MINUS
SELECT c.country_id, c.country_name
FROM countries c
JOIN locations l ON c.country_id = l.country_id
JOIN departments d ON l.location_id = d.location_id;

SELECT job_id, department_id FROM employees WHERE department_id = 10
UNION ALL
SELECT job_id, department_id FROM employees WHERE department_id = 50
UNION ALL
SELECT job_id, department_id FROM employees WHERE department_id = 20;

SELECT employee_id, job_id FROM employees
INTERSECT
SELECT employee_id, job_id FROM job_history
WHERE (employee_id, start_date) IN
      (SELECT employee_id, MIN(start_date) FROM job_history GROUP BY employee_id);

SELECT last_name, department_id, TO_CHAR(NULL) FROM employees
UNION
SELECT TO_CHAR(NULL), department_id, department_name FROM departments;


PROMPT ===================== LAB 9: Manipulating Data (DML) =====================

-- lab_09_01.sql
CREATE TABLE my_employee (
  id         NUMBER(4)     NOT NULL,
  last_name  VARCHAR2(25),
  first_name VARCHAR2(25),
  userid     VARCHAR2(8),
  salary     NUMBER(9,2)
);

DESCRIBE my_employee;

-- First row, no column list
INSERT INTO my_employee VALUES (1,'Patel','Ralph','rpatel',895);

-- Second row, explicit columns
INSERT INTO my_employee (id, last_name, first_name, userid, salary)
VALUES (2,'Dancs','Betty','bdancs',860);

SELECT * FROM my_employee;

-- lab_09_06.sql equivalent - inserting rows 3 and 4 with literal values (no prompt)
INSERT INTO my_employee (id, last_name, first_name, userid, salary)
VALUES (3, 'Biri', 'Ben', 'bbiri', 1100);

INSERT INTO my_employee (id, last_name, first_name, userid, salary)
VALUES (4, 'Newman', 'Chad', 'cnewman', 750);

COMMIT;

UPDATE my_employee SET last_name = 'Drexler' WHERE id = 3;
UPDATE my_employee SET salary = 1000 WHERE salary < 900;

SELECT * FROM my_employee;

DELETE FROM my_employee WHERE last_name = 'Dancs';

SELECT * FROM my_employee;

COMMIT;

-- Row 5 (same reusable insert pattern, next literal row)
INSERT INTO my_employee (id, last_name, first_name, userid, salary)
VALUES (5, 'Ropeburn', 'Audrey', 'aropebur', 1550);

SAVEPOINT before_delete;
DELETE FROM my_employee;
SELECT * FROM my_employee;      -- should be empty
ROLLBACK TO before_delete;
SELECT * FROM my_employee;      -- row restored
COMMIT;

-- lab_09_24.sql equivalent - auto-generated userid, literal values (no prompt)
INSERT INTO my_employee (id, last_name, first_name, userid, salary)
VALUES (6, 'Anthony', 'Mark',
        LOWER(SUBSTR('Mark',1,1) || SUBSTR('Anthony',1,7)), 1230);

SELECT * FROM my_employee WHERE id = 6;


PROMPT ===================== LAB 10: DDL - Creating and Managing Tables =====================

-- lab_10_01.sql
CREATE TABLE dept (
  id   NUMBER(7)   NOT NULL PRIMARY KEY,
  name VARCHAR2(25)
);

INSERT INTO dept (id, name)
SELECT department_id, department_name FROM departments;

SELECT * FROM dept;

-- lab_10_03.sql
CREATE TABLE emp (
  id         NUMBER(7),
  last_name  VARCHAR2(25),
  first_name VARCHAR2(25),
  dept_id    NUMBER(7),
  CONSTRAINT emp_dept_fk FOREIGN KEY (dept_id) REFERENCES dept(id)
);

DESCRIBE emp;

-- EMPLOYEES2 table
CREATE TABLE employees2 AS
SELECT employee_id AS id, first_name, last_name, salary, department_id AS dept_id
FROM employees;

ALTER TABLE employees2 READ ONLY;

-- This insert is expected to FAIL (ORA-12081) because table is read-only
INSERT INTO employees2 VALUES (34,'Marcie','Grant',5678,10);

ALTER TABLE employees2 READ WRITE;

-- This insert should now succeed
INSERT INTO employees2 VALUES (34,'Marcie','Grant',5678,10);

DROP TABLE employees2;


PROMPT ===================== LAB 11: Other Schema Objects =====================

CREATE VIEW employees_vu AS
SELECT employee_id, last_name AS employee, department_id
FROM employees;

SELECT * FROM employees_vu;

SELECT employee, department_id FROM employees_vu;

CREATE OR REPLACE VIEW dept50 (empno, employee, deptno) AS
SELECT employee_id, last_name, department_id
FROM employees
WHERE department_id = 50
WITH CHECK OPTION;

DESCRIBE dept50;
SELECT * FROM dept50;

-- This update is expected to FAIL because of WITH CHECK OPTION
UPDATE dept50 SET deptno = 80 WHERE employee = 'Matos';

CREATE SEQUENCE dept_id_seq
START WITH 200
INCREMENT BY 10
MAXVALUE 1000;

-- lab_11_08.sql
INSERT INTO dept (id, name) VALUES (dept_id_seq.NEXTVAL, 'Education');
INSERT INTO dept (id, name) VALUES (dept_id_seq.NEXTVAL, 'Administration');
SELECT * FROM dept;

CREATE INDEX dept_name_idx ON dept(name);

CREATE SYNONYM emp_syn FOR employees;


PROMPT ===================== LAB F: Oracle Join Syntax (old-style joins) =====================

SELECT l.location_id, l.street_address, l.city, l.state_province, c.country_name
FROM locations l, countries c
WHERE l.country_id = c.country_id;

SELECT e.last_name, e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND l.city = 'Toronto';

-- lab_f_04.sql
SELECT e.last_name "Employee", e.employee_id "Emp#",
       m.last_name "Manager", m.employee_id "Mgr#"
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;

-- lab_f_05.sql (outer join, include King)
SELECT e.last_name "Employee", e.employee_id "Emp#",
       m.last_name "Manager", m.employee_id "Mgr#"
FROM employees e, employees m
WHERE e.manager_id = m.employee_id (+)
ORDER BY e.employee_id;

-- lab_f_06.sql
SELECT e1.department_id "Department", e1.last_name "Employee", e2.last_name "Colleague"
FROM employees e1, employees e2
WHERE e1.department_id = e2.department_id
AND e1.employee_id != e2.employee_id
ORDER BY e1.department_id;

DESCRIBE job_grades;

SELECT e.last_name, e.job_id, d.department_name, e.salary, j.grade_level
FROM employees e, departments d, job_grades j
WHERE e.department_id = d.department_id
AND e.salary BETWEEN j.lowest_sal AND j.highest_sal;

SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date FROM employees WHERE last_name = 'Davies');

-- lab_f_09.sql
SELECT e.last_name, e.hire_date, m.last_name, m.hire_date
FROM employees e, employees m
WHERE e.manager_id = m.employee_id
AND e.hire_date < m.hire_date;


SPOOL OFF
EXIT
