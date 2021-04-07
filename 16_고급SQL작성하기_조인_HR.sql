-- 1. 부서의 위치(location_id)가 1700 인 사원들의 employee_id, last_name, department_id, salary 를 조회한다.
-- 사용할 테이블 (departments, employees)
SELECT 
       e.employee_id
     , e.last_name
     , e.department_id
     , salary 
  FROM employees e INNER JOIN departments d -- employees 테이블이 driving 테이블, departments 테이블이 driven테이블
    ON e.department_id = d.department_id -- 조인 조건 -- 인덱스가 없는 e.department_id를 기준으로 검색하므로 좋지 않다.(e.department_id는 FK이므로 인덱스가 존재하지 않는다.)
 WHERE d.location_id = 1700; -- 일반 조건

SELECT 
       e.employee_id
     , e.last_name
     , e.department_id
     , salary 
  FROM employees e, departments d
 WHERE e.department_id = d.department_id -- 조인 조건
   AND d.location_id = 1700; -- 일반 조건


-- 2. 부서명(department_name)이 'Executive' 인 부서에 근무하는 모든 사원들의 department_id, last_name, job_id 를 조회한다.
-- 사용할 테이블 (departments, employees)
SELECT
       d.department_id
     , e.last_name
     , e.job_id
  FROM departments d INNER JOIN employees e -- departments 테이블이 driving 테이블, employees 테이블이 driven테이블
    ON d.department_id = e.department_id -- 조건절의 등호(=) 왼쪽은 PK 또는 인덱스를 가진 칼럼이 좋다. (d.department_id는 PK이므로 인덱스가 존재한다.)
 WHERE d.department_name = 'Executive';
 
 SELECT
       d.department_id
     , e.last_name
     , e.job_id
  FROM departments d, employees e
 WHERE d.department_id = e.department_id
   AND d.department_name = 'Executive';


-- 3. 기존의 직업(job_id)을 여전히 가지고 있는 사원들의 employee_id, job_id 를 조회한다.
-- 사용할 테이블 (employees, job_history)
SELECT
       e.employee_id
     , e.job_id
  FROM employees e INNER JOIN job_history j 
    ON e.employee_id = j.employee_id -- 조인 조건
 WHERE e.job_id = j.job_id; -- 일반 조건 : 기존의 직업을 여전히 가지고 있다. employees 테이블의 job_id(현재 job)와 job_history테이블의 job_id(과거 job)가 같다.
    
SELECT
       e.employee_id
     , e.job_id
  FROM employees e, job_history j
 WHERE e.employee_id = j.employee_id
   AND e.job_id = j.job_id;

-- 4. 각 부서별 사원수와 평균연봉을 department_name, location_id 와 함께 조회한다.
-- 평균연봉은 소수점 2 자리까지 반올림하여 표현하고, 각 부서별 사원수의 오름차순으로 조회한다.
-- 사용할 테이블 (departments, employees)
SELECT        
       d.department_name
     , d.location_id  
     , COUNT(*) AS 사원수
     , ROUND(AVG(salary), 2) AS 평균연봉
  FROM departments d, employees e
 WHERE d.department_id = e.department_id 
 GROUP BY d.department_name, d.location_id
 ORDER BY COUNT(*);

SELECT        
       d.department_name
     , d.location_id  
     , COUNT(*) AS 사원수
     , ROUND(AVG(salary), 2) AS 평균연봉
  FROM departments d INNER JOIN employees e
    ON d.department_id = e.department_id
 GROUP BY d.department_name, d.location_id
 ORDER BY 사원수;


-- 5. 도시이름(city)이 T 로 시작하는 지역에서 근무하는 사원들의 employee_id, last_name, department_id, city 를 조회한다.
-- 사용할 테이블 (employees, departments, locations)
SELECT 
       e.employee_id
     , e.last_name
     , e.department_id
     , l.city
  FROM locations l INNER JOIN departments d
    ON l.location_id = d.location_id INNER JOIN employees e
    ON d.department_id = e.department_id
 WHERE l.city LIKE 'T%';
   
SELECT 
       e.employee_id
     , e.last_name
     , e.department_id
     , l.city
  FROM locations l, departments d, employees e
 WHERE l.location_id = d.location_id 
   AND d.department_id = e.department_id
   AND l.city LIKE 'T%';   
   

-- 6. 자신의 상사(manager_id)의 고용일(hire_date)보다 빨리 입사한 사원을 찾아서 last_name, hire_date, manager_id 를 조회한다. 
-- 사용할 테이블 (employees)

-- SELF JOIN
-- manager_id 담당 테이블 : m
-- employee_id 담당 테이블 : e
-- manager_id의 고용일 : m.hire_date 
-- employee_id의 고용일 : e.hire_date
-- 조인 조건 : e.manager_id = m.employee_id (나의 상사번호 = 상사의 사원번호)
-- 일반 조건 : e.hire_dete < m.hire_date

SELECT 
       e.last_name AS 내이름
     , e.hire_date AS 내입사일
     , e.manager_id AS 상사사원번호
     , m.last_name AS 상사이름
     , m.hire_date AS 상사입사일
  FROM employees e JOIN employees m
    ON e.manager_id = m.employee_id
 WHERE e.hire_date < m.hire_date;   
 
SELECT 
       e.last_name AS 내이름
     , e.hire_date AS 내입사일
     , e.manager_id AS 상사사원번호
     , m.last_name AS 상사이름
     , m.hire_date AS 상사입사일
  FROM employees e, employees m
 WHERE e.manager_id = m.employee_id
   AND e.hire_date < m.hire_date;


-- 7. 같은 소속부서(department_id)에서 나보다 늦게 입사(hire_date)하였으나 나보다 높은 연봉(salary)을 받는 사원이 존재하는 사원들의
-- department_id, full_name(first_name 과 last_name 사이에 공백을 포함하여 연결), salary, hire_date 를 full_name 순으로 정렬하여 조회한다.
-- 사용할 테이블 (employees)
-- 나 : me
-- 남 : you
SELECT 
       me.department_id AS 부서번호
     , me.first_name || ' ' || me.last_name AS 내이름
     , me.salary AS 내급여
     , you.first_name || ' ' || you.last_name AS 네이름
     , you.salary AS 네급여
  FROM employees me JOIN employees you
    ON me.department_id = you.department_id
 WHERE me.hire_date < you.hire_date
   AND me.salary < you.salary
 ORDER BY 부서번호, 내이름;  

SELECT 
       me.department_id AS 부서번호
     , me.first_name || ' ' || me.last_name AS 내이름
     , me.salary AS 내급여
     , you.first_name || ' ' || you.last_name AS 네이름
     , you.salary AS 네급여
  FROM employees me, employees you
 WHERE me.department_id = you.department_id
   AND me.hire_date < you.hire_date
   AND me.salary < you.salary
 ORDER BY 부서번호, 내이름;  


-- 8. 같은 소속부서(department_id)의 다른 사원보다 늦게 입사(hire_date)하였으나 현재 더 높은 연봉(salary)을 받는 사원들의
-- department_id, full_name(first_name 과 last_name 사이에 공백을 포함하여 연결), salary, hire_date 를 full_name 순으로 정렬하여 조회한다.
-- 사용할 테이블 (employees)
-- 나 : me
-- 남 : you
SELECT 
       me.department_id AS 부서번호
     , me.first_name || ' ' || me.last_name AS 내이름
     , me.salary AS 내급여
     , me.hire_date AS 내입사일
     , you.first_name || ' ' || you.last_name AS 네이름
     , you.salary AS 네급여
     , you.hire_date AS 네입사일
  FROM employees me JOIN employees you
    ON me.department_id = you.department_id
 WHERE me.hire_date > you.hire_date
   AND me.salary > you.salary
 ORDER BY 부서번호, 내이름;   

SELECT 
       me.department_id AS 부서번호
     , me.first_name || ' ' || me.last_name AS 내이름
     , me.salary AS 내급여
     , me.hire_date AS 내입사일
     , you.first_name || ' ' || you.last_name AS 네이름
     , you.salary AS 네급여
     , you.hire_date AS 네입사일
  FROM employees me, employees you
 WHERE me.department_id = you.department_id
   AND me.hire_date > you.hire_date
   AND me.salary > you.salary
 ORDER BY 부서번호, 내이름;   

















