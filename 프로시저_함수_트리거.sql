SET SERVEROUTPUT ON;

-- 1. 프로시저
--  1) 한 번에 처리할 수 있는 쿼리문의 집합
--  2) 결과(반환)가 있을 수도 있고, 없을 수도 있다.
--  3) EXECUTE(EXEC)를 통해서 실행한다.

-- 1)
-- 프로시저 정의 
CREATE OR REPLACE PROCEDURE proc1 -- 프로시저명 : proc1
AS -- 변수 선언하는 곳. IS와 같다.
BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO PROCEDURE');
END proc1; -- END;도 가능

-- 프로시저 실행
EXECUTE proc1();


-- 2) 프로시저에서 변수를 선언하고 사용하기.
CREATE OR REPLACE PROCEDURE proc2
AS
    my_age NUMBER;
BEGIN
    my_age := 20;
    DBMS_OUTPUT.PUT_LINE('나는 ' || my_age || '살이다.');
END proc2;

EXEC proc2();


-- 3) 입력 파라미터
-- 프로시저에 전달하는 값 : 인수 
-- 문제 : employee_id를 입력 파라미터로 전달하면 해당 사원의 last_name 출력하기 
CREATE OR REPLACE PROCEDURE proc3(in_employee_id IN NUMBER) -- 타입 작성 시 크기 지정은 하지 않는다.(Ex) NUMBER(3) = X // NUMBER = O /VARCHAR2 타입 또한 마찬가지
IS 
    v_last_name EMPLOYEES.LAST_NAME%TYPE; -- v_last_name 의 타입은 EMPLOYEES테이블의 LAST_NAME칼럼의 타입과 같은 타입이라는 의미
BEGIN 
    SELECT last_name INTO v_last_name
      FROM employees
     WHERE employee_id = in_employee_id;
     DBMS_OUTPUT.PUT_LINE('결과 : ' || v_last_name);
END proc3;     

EXEC proc3(100); -- 입력 파라미터 100 전달 


-- 4) 출력 파라미터
-- 프로시저의 실행 결과를 저장하는 파라미터
-- 함수와 비교하면 함수의 반환값
CREATE OR REPLACE PROCEDURE proc4(out_result OUT NUMBER)
IS
BEGIN 
    SELECT MAX(salary) INTO out_result -- 최고연봉을 출력 파라미터 out_result에 저장
      FROM employees;
END proc4;

-- 프로시저를 호출할 때 
-- 프로시저에 결과를 저장할 변수를 넘겨준다.
DECLARE 
    max_salary NUMBER;
BEGIN 
    proc4(max_salary); -- max_salary에 최고연봉이 저장되기를 기대
    DBMS_OUTPUT.PUT_LINE('최고연봉 : ' || max_salary);
END;



-- 2. 사용자 함수




-- 3. 트리거 






















