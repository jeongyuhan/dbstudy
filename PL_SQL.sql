--HR 계정의 EMPLOYEES 테이블을 복사하기.
CREATE TABLE employees
    AS (SELECT * FROM hr.employees);
-- WHERE을 통해 조건을 주면 원하는것만 가져올 수 있다.    

-- 테이블 복사를 하면 PK, FK는 복사되지 않는다. 
DESC USER_CONSTRAINTS; -- 제약조건을 저장하고 있는 데이터 사전
SELECT *
  FROM USER_CONSTRAINTS
 WHERE table_name = 'employees';

-- 복사한 테이블에 기본키(PK) 지정하기.
ALTER TABLE employees ADD CONSTRAINT EMPLOYEES_PK PRIMARY KEY (employee_id);


--==============================================================================

-- PL/SQL

-- 접속마다 최초 1회만 하면 된다.
-- 결과를 화면에 출력하는 방법
-- 디폴트의 기본값은 SET SERVEROUTPUT ON OFF;
SET SERVEROUTPUT ON;


-- 기본 구성
/*
    DECLARE
        변수선언;
    BEGIN
        작업;
    END;    
*/


-- 화면 출력
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO PL/SQL');
  END;   



-- 변수 선언(스칼라 변수)
DECLARE
    my_name VARCHAR2(20);
    my_age NUMBER(3);
BEGIN
    -- 변수에 값을 대입
    my_name := '에밀리'; -- 대입연산자(:=)
    my_age := 30;
    DBMS_OUTPUT.PUT_LINE('내 이름은 ' || my_name || '입니다.');
    DBMS_OUTPUT.PUT_LINE('내 나이는 ' || my_age || '살입니다.');
END;
    


-- 변수 선언(참조 변수)
-- 기존의 칼럼의 타입을 그대로 사용한다.
-- 계정명.테이블명.칼럼%TYPE
-- 동일한 계정일 경우 계정명은 생략가능하다.

DECLARE 
    v_first_name employees.FIRST_NAME%TYPE;  -- v_first_name VARCHAR2(20);
    v_last_name employees.LAST_NAME%TYPE;  -- v_last_name VARCHAR2(25);
BEGIN
    -- 테이블의 데이터를 변수에 저장하기.
    -- SELECT 칼럼 INTO 변수 FROM 테이블명; 칼럼데이터 => 변수에저장
    /*
    SELECT FIRST_NAME INTO v_first_name 
      FROM employees 
     WHERE employee_id = 100;
    SELECT LAST_NAME INTO v_last_name
      FROM employees
     WHERE employee_id = 100;
    */
    SELECT FIRST_NAME, LAST_NAME
      INTO v_first_name, v_last_name
      FROM employees
     WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name);
END;    



-- IF문
DECLARE
    score NUMBER(3);
    grade CHAR(1);
BEGIN
    score := 50;
    IF score >= 90 THEN
        grade := 'A';
    ELSIF score >= 80 THEN
        grade := 'B';
    ELSIF score >= 70 THEN
        grade := 'C';
    ELSIF score >= 60 THEN
        grade := 'D';
    ELSE
        grade := 'F';
    END IF;    
    DBMS_OUTPUT.PUT_LINE('점수는 ' || score || '점이고, 학점은 ' || grade || '학점입니다.');
END;    



-- CASE문
DECLARE
    score NUMBER(3);
    grade CHAR(1);
BEGIN
    score := 90;
    CASE 
        WHEN score >= 90 THEN
            grade := 'A';
        WHEN score >= 80 THEN
            grade := 'B';
        WHEN score >= 70 THEN
            grade := 'C';
        WHEN score >= 60 THEN
            grade := 'D';
        ELSE 
            grade := 'F';
        END CASE;    
     DBMS_OUTPUT.PUT_LINE('점수는 ' || score || '점이고, 학점은 ' || grade || '학점입니다.');
END;    



-- 문제.
-- 사원번호가 100인 사원의 연봉(salary)을 가져와서, 5000이상이면 '고액연봉자', 아니면 공백을 출력하시오.

-- IF문을 이용한 풀이법
DECLARE
    v_salary EMPLOYEES.SALARY%TYPE;
    v_result VARCHAR2(20);
BEGIN
    SELECT SALARY INTO v_salary
      FROM EMPLOYEES
     WHERE employee_id = 100; 
    IF v_salary >= 5000 THEN
        v_result := '고액연봉자';
    ELSE 
        v_result := ' ';
    END IF;
    DBMS_OUTPUT.PUT_LINE('결과 : ' || v_result);
END;    
        
-- CASE문을 이용한 풀이법
DECLARE
    v_salary EMPLOYEES.SALARY%TYPE;
    v_result VARCHAR2(20); 
BEGIN
    SELECT SALARY INTO v_salary
      FROM EMPLOYEES
     WHERE employee_id = 100;
    CASE
        WHEN v_salary >= 5000 THEN
            v_result := '고액연봉자';
        ELSE
            v_result := ' ';
        END CASE;
  DBMS_OUTPUT.PUT_LINE('결과 : ' || v_result);
END;           
    


-- WHILE문
-- 1~100까지 모두 더하기
DECLARE
    n NUMBER(3);
    total NUMBER(4);
BEGIN
    total := 0;
    n := 1;
    WHILE n <= 100 LOOP
        total := total + n;
        n := n + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('합계 : ' || total);
END;    



-- FOR문
DECLARE
    n NUMBER(3);
    total NUMBER(4);
BEGIN
    total := 0;
    FOR n IN 1 .. 100 LOOP -- IN (서브쿼리) LOOP 의 방식으로도 사용가능하다.
        total := total + n;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('합계 : ' || total);
END;    



-- EXIT문 (java의 break문)
-- 문제.
-- 1 부터 누적합계를 구하다가 최초 누적합계가 3000 이상이 되는 경우 반복문 종료하고 해당 누적합계를 출력하시오.
-- 방법1
DECLARE
    n NUMBER(3);
    total NUMBER(4);
BEGIN 
    total := 0;
    n := 1;
    WHILE TRUE LOOP -- 무한루프
        total := total + n;
        IF total >= 3000 THEN
            EXIT;
        END IF;
        n := n + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('누적합계 : ' || total);
END;    
-- 방법2
DECLARE
    n NUMBER(3);
    total NUMBER(4);
BEGIN 
    total := 0;
    n := 1;
    WHILE TRUE LOOP -- 무한루프
        total := total + n;
        EXIT WHEN total >= 3000; -- IF를 사용하지않고 EXIT WHEN을 통해 코드를 줄인다.
        n := n + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('누적합계 : ' || total);
END;    



-- CONTINUE문
-- 1~100 사이 모든 짝수의 합계를 구하시오.
DECLARE
    n NUMBER(3);
    total NUMBER(4);
BEGIN
    total := 0;
    n := 0;
    WHILE n < 100 LOOP
        n := n + 1;
        IF MOD(n, 2) = 1 THEN -- 홀수 조건(n을 2로 나눈 나머지가 1인 수)
            CONTINUE; -- WHILE문으로 이동
        END IF;
        total := total + n;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('짝수합계 : ' || total);
END;



-- 테이블 타입
-- 테이블의 데이터를 가져와서 배열처럼 사용하는 타입
DECLARE
    i NUMBER; -- 인덱스
    -- first_name_type : EMPLOYEES 테이블의 FIRST_NAME 칼럼값을 배열처럼 사용할 수 있는 타입
    TYPE first_name_type IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE INDEX BY BINARY_INTEGER; -- 타입을 생성한 것이다.
    -- first_names : EMPLOYEES 테이블의 FIRST_NAME 칼럼값을 실제로 저장하는 변수(배열처럼 사용가능하다.)
    first_names first_name_type;
BEGIN
    i := 0;
    FOR v_row IN (SELECT first_name, last_name FROM employees) LOOP
        first_names(i) := v_row.first_name;
        DBMS_OUTPUT.PUT_LINE(first_names(i) || ' ' || v_row.last_name); -- v_row.last_name과 같이 따로 저장할 배열을 만들지 않고 처리할 수도 있다.(그 경우 DECLARE 부분이 필요가 없다.)
        i := i + 1;
    END LOOP;
END;    


-- 부서번호(department_id)가 50인 부서의 firsr_name, last_name을 가져와서 새로운 테이블 employees50에 삽입하시오.
CREATE TABLE employees50 
        AS (SELECT first_name, last_name FROM employees WHERE 1 = 0);

DECLARE
    v_first_name EMPLOYEES.FIRST_NAME%TYPE;
    v_last_name EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    FOR v_row IN (SELECT first_name, last_name FROM employees WHERE department_id = 50) LOOP
        v_first_name := v_row.first_name;
        v_last_name := v_row.last_name;
        INSERT INTO employees50 (first_name, last_name) VALUES (v_first_name, v_last_name);
    END LOOP;
    COMMIT;    
END;

SELECT first_name, last_name FROM employees50;



-- 레코드 타입
-- 여러 칼럼이 모여서 하나의 레코드(== 행, ROW)가 된다.
-- 쉽게말해 여러개의 데이터를 하나로 모으는 개념 : java에서는 객체(변수 + 함수)의 하위 개념 => 구조체(변수)
DECLARE
    TYPE person_type IS RECORD 
    (
        my_name VARCHAR2(20),
        my_age NUMBER(3)
    );   
    man person_type; -- person_type 의 man
    woman person_type; -- person_type 의 woman
BEGIN 
    man.my_name := '제임스';
    man.my_age := 20;
    woman.my_name := '엘리스';
    woman.my_age := 30;
    DBMS_OUTPUT.PUT_LINE(man.my_name || ' ' || man.my_age);
    DBMS_OUTPUT.PUT_LINE(woman.my_name || ' ' || woman.my_age);
END;



-- 테이블형 레코드 타입
-- 부서번호(department_id)가 50인 부서의 전체 칼럼을 가져와서
-- 새로운 테이블 employees2에 삽입하시오.
DROP TABLE employees2;

CREATE TABLE employees2 
    AS (SELECT * FROM employees WHERE 1 = 0);

DECLARE 
    row_data SPRING.EMPLOYEES%ROWTYPE; -- EMPLOYEES 테이블의 ROW전체를 저장할 수 있는 변수
    emp_id NUMBER(3);
BEGIN
    FOR emp_id IN 100 .. 206 LOOP
        SELECT *
          INTO row_data
          FROM EMPLOYEES
         WHERE employee_id = emp_id;
        INSERT INTO employees2 VALUES row_data;
        END LOOP;
END; 

SELECT first_name, last_name FROM employees2;



-- 예외 처리
DECLARE 
    v_last_name VARCHAR2(25); -- 칼럼의 타입보다 크거나 같으면 이상이 없다.
BEGIN 
    SELECT last_name INTO v_last_name 
      FROM employees
     WHERE employee_id = 100; -- 정상 작동
     -- WHERE employee_id = 1; -- 예외 발생 '없는 사원'
     -- WHERE department_id = 50; -- 예외 발생 '많은 사원' 
    DBMS_OUTPUT.PUT_LINE('결과 : ' || v_last_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('해당 사원이 없다.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 많다.');
END;



-- 모든 예외 처리
DECLARE 
    v_last_name VARCHAR2(25);
BEGIN 
    SELECT last_name INTO v_last_name 
      FROM employees
     WHERE employee_id = 1; -- 예외 발생 '없는 사원'
     -- WHERE department_id = 50; -- 예외 발생 '많은 사원' 
    DBMS_OUTPUT.PUT_LINE('결과 : ' || v_last_name);
EXCEPTION
    WHEN OTHERS THEN -- java의 Exception 과 유사한 역할을 한다.(특정 예외를 처리하는 것이 아닌 모든 예외를 처리)
        DBMS_OUTPUT.PUT_LINE('예외 코드 : ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('예외 메시지 : ' || SQLERRM);
END;
