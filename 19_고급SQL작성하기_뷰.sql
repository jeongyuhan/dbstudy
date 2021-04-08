-- 뷰(VIEW)
-- 1. 기존 테이블을 이용해서 생성한 가상테이블이다.
-- 2. 디스크 대신 데이터사전에만 등록된다.

-- 뷰 생성
CREATE VIEW test_view 
    AS (SELECT emp_no
             , name 
          FROM employee);
          
CREATE VIEW test_view2
    AS (SELECT *
          FROM employee
         WHERE position = '과장'); 
         

-- 뷰 확인
SELECT /** HINT */
       emp_no
     , name
  FROM test_view;
  
SELECT /** HINT */
       *
  FROM test_view2;     
  

-- 뷰 생성(다중 테이블)

-- 부서가 없는 김미나 사원을 제외한 풀이 
CREATE VIEW depart_view 
    AS (SELECT e.emp_no
             , e.name
             , e.position
             , d.dept_name
          FROM department d INNER JOIN employee e
            ON d.dept_no = e.depart);
            
SELECT 
       emp_no
     , name
     , dept_name
     , position
  FROM depart_view;   
     
-- 부서가 없는 김미나 사원을 포함한 풀이            
CREATE VIEW depart_view2 
    AS (SELECT e.emp_no
             , e.name
             , e.position
             , d.dept_name
          FROM department d RIGHT OUTER JOIN employee e
            ON d.dept_no = e.depart);
            
SELECT 
       emp_no
     , name
     , dept_name
     , position
  FROM depart_view2;      