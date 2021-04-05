-- << employees 테이블 >> --

DESC employees;

-- 1. 전체 사원의 모든 칼럼을 조회한다.
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
  FROM employees;
  
SELECT *
  FROM employees; -- *는 성능이 안좋다.
  
SELECT employees.employee_id, employees.first_name, employees.last_name, employees.email, employees.phone_number, employees.hire_date, employees.job_id, employees.salary, employees.commission_pct, employees.manager_id, employees.department_id
  FROM employees;  -- OWNER(칼럼의 테이블)를 명시하여 표시하는 방법

SELECT e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, e.hire_date, e.job_id, e.salary, e.commission_pct, e.manager_id, e.department_id
  FROM employees e; -- employees 테이블의 별명(alias) 지정. e를 별명으로 지정
  
-- 2. 전체 사원의 first_name, last_name, job_id 를 조회한다.
SELECT first_name, last_name, job_id 
  FROM employees;

SELECT emp.first_name, emp.last_name, emp.job_id 
  FROM employees emp; -- 별명은 마음대로 지정한다.

-- 3. 연봉(salary)이 12000 이상되는 사원들의 last_name, salary 를 조회한다.
SELECT last_name, salary
  FROM employees
 WHERE salary >= 12000;

SELECT e.last_name, e.salary
  FROM employees e
 WHERE e.salary >= 12000;
 
--               실행순서 
-- SELECT 칼럼      3
--   FROM 테이블    1 
--  WHERE 조건식    2
 
-- 4. 사원번호(employee_id)가 150 인 사원의 last_name, department_id 를 조회한다.
-- 사원번호의 타입이 NUMBER   : employee_id = 150
-- 사원번호의 타입이 VARCHAR2 : employee_id = '150'

-- 1) 사원번호 타입이 NUMBER
SELECT last_name, department_id
  FROM employees
  WHERE employee_id = 150; -- 정상비교, WHERE절에서 사용되는 =는 '같다'의미이다.

SELECT last_name, department_id
  FROM employees
  WHERE employee_id = '150'; -- 실무에서는 전혀 문제 없는 쿼리문 (자동으로 employee_id = TO_NUMBER('150');)

-- 2) 사원번호 타입이 VARCHAR2
SELECT last_name, department_id
  FROM employees
  WHERE employee_id = 150; -- 성능이 떨어지는 쿼리. (자동으로 WHERE TO_NUMBER(employee_id) = 150;이 작용된다.)
                           -- PRIMARY KEY에 함수를 씌울경우 인덱스를 사용하지못하게 되어 속도가 느려진다.
  
SELECT last_name, department_id
  FROM employees
  WHERE employee_id = '150'; -- 정상비교
  
-- 5. 커미션(commission_pct)을 받는 모든 사원들의 last_name, salary, commission_pct 를 조회한다.


-- 6. 모든 사원들의 last_name, commission_pct 를 조회하되 커미션(commission_pct)이 없는 사원은 0으로 처리하여 조회한다.


-- 7. 커미션(commission_pct)이 없는 사원들은 0으로 처리하고, 커미션이 있는 사원들은 기존 커미션보다 10% 인상된 상태로 조회한다.


-- 8. 연봉(salary)이 5000 에서 12000 인 범위의 사원들의 first_name, last_name, salary 를 조회한다.


-- 9. 연봉(salary)이 5000 에서 12000 사이의 범위가 아닌 사원들의 first_name, last_name, salary 를 조회한다.


-- 10. 직업(job_id)이 SA_REP 이나 ST_CLERK 인 사원들의 전체 칼럼을 조회한다.


-- 11. 연봉(salary)이 2500, 3500, 7000 이 아니며 직업(job_id) 이 SA_REP 이나 ST_CLERK 인 사람들을 조회한다.


-- 12. 상사(manager_id)가 없는 사람들의 last_name, job_id 를 조회한다.


-- 13. 성(last_name)에 u 가 포함되는 사원들의 employee_id, last_name 을 조회한다.


-- 14. 전화번호(phone_number)가 650 으로 시작하는 사원들의 last_name, phone_number 를 조회한다.


-- 15. 성(last_name)의 네 번째 글자가 a 인 사원들의 last_name 을 조회한다.


-- 16. 성(last_name) 에 a 또는 e 가 포함된 사원들의 last_name 을 조회한다.


-- 17. 성(last_name) 에 a 와 e 가 모두 포함된 사원들의 last_name 을 조회한다.


-- 18. 2008/02/20 ~ 2008/05/01 사이에 고용된(hire_date) 사원들의 last_name, employee_id, hire_date 를 조회한다.


-- 19. 2004년도에 고용된(hire_date) 모든 사원들의 last_name, employee_id, hire_date 를 조회한다.


-- 20. 부서(department_id)를 조회하되 중복을 제거하여 조회한다.


-- 21. 직업(job_id)이 ST_CLERK 가 아닌 사원들의 부서번호(department_id)를 조회한다.
-- 단, 부서번호가 NULL인 값은 제외하고 부서번호의 중복을 제거한다.


-- 22. 커미션(commission_pct)을 받는 사원들의 실제 커미션(commission = salary * commission_pct)을 구하고,
-- employee_id, first_name, job_id 와 함께 조회한다.


-- 23. 가장 오래 전에 입사(hire_date)한 직원부터 최근에 입사한 직원 순으로 last_name, hire_date 를 조회한다.


-- 24. 부서번호(department_id)가 20, 50 인 부서에서 근무하는 모든 사원들의 부서번호의 오름차순으로 조회하되,
-- 같은 부서번호 내에서는 last_name 의 알파벳순으로 조회한다.


-- 25. 커미션(commission_pct)을 받는 모든 사원들의 last_name, salary, commission_pct 을 조회한다.
-- 연봉이 높은 사원을 먼저 조회하고 같은 연봉의 사원들은 커미션이 높은 사원을 먼저 조회한다.
