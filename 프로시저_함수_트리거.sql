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


-- 5) 입출력 파라미터
-- 입력 : 사원번호 (전달하는 값)
-- 출력 : 연봉 (받아오는 값)
CREATE OR REPLACE PROCEDURE proc5(in_out_param IN OUT NUMBER)
IS
    v_salary NUMBER;
BEGIN
    SELECT salary INTO v_salary
      FROM employees
     WHERE employee_id = in_out_param; -- 입력된 인수(사원번호)를 조건으로 사용
    in_out_param := v_salary; -- 결과를 출력 파라미터에 저장
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외 코드 : ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('예외 메세지 : ' || SQLERRM);
END proc5;

-- 변수를 전달할 때는 사원번호를 저장해서 보내고,
-- 프로시저 실행 후에는 해당 변수에 연봉이 저장되어 있다.
DECLARE 
    result NUMBER;
BEGIN 
    result := 100; -- 사원번호를 의미
    proc5(result); -- EXEC 없이 실행
    DBMS_OUTPUT.PUT_LINE('실행 후 결과 : ' || result);
END;    

-- 문제 세팅
-- BOOK, CUSTOMER, ORDERS 테이블 (DQL_연습문제.sql 참조)
ALTER TABLE BOOK ADD stock NUMBER;
ALTER TABLE CUSTOMER ADD point NUMBER;
ALTER TABLE ORDERS ADD amount NUMBER;
UPDATE BOOK SET stock = 10;
UPDATE CUSTOMER SET point = 1000;
UPDATE ORDERS SET amount = 1;
COMMIT;

-- 1. ORDERS 테이블에 주문 기록이 삽입된다. (order_id 는 시퀀스로 처리, sales_price는 BOOK 테이블의 price의 90%)
-- 2. CUSTOMER 테이블에 주문 총액(구매수량 * 책가격)의 10%를 point에 더해 준다.
-- 3. BOOK 테이블의 재고를 조절한다. 
-- EXEC proc_order(회원번호, 책번호, 구매수량);

DROP SEQUENCE ORDERS_SEQ;
CREATE SEQUENCE ORDERS_SEQ INCREMENT BY 1 START WITH 11 NOMAXVALUE NOMINVALUE NOCYCLE NOCACHE;

CREATE OR REPLACE PROCEDURE proc_order(in_customer_id IN NUMBER, in_book_id IN NUMBER, in_amount IN NUMBER)
IS
BEGIN
    INSERT INTO ORDERS 
        (order_id, customer_id, book_id, sales_price, order_date, amount) 
    VALUES 
        (ORDERS_SEQ.NEXTVAL, in_customer_id, in_book_id, (SELECT FLOOR(price * 0.9) FROM BOOK WHERE book_id = in_book_id), SYSDATE, in_amount);
    UPDATE CUSTOMER 
        SET point = point + FLOOR(in_amount * (SELECT sales_price FROM ORDERS WHERE order_id = (SELECT MAX(order_id) FROM ORDERS)) * 0.1)
      WHERE customer_id = in_customer_id;
    UPDATE BOOK
        SET stock = stock - in_amount
      WHERE book_id = in_book_id;
      COMMIT; -- 작업의 성공
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외 코드 : ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('예외 메세지 : ' || SQLERRM);
        ROLLBACK; -- 작업의 취소
END proc_order;

EXEC proc_order(1, 1, 2); -- 1번 구매자가 1번 책을 2권 구매한다.



-- 2. 사용자 함수
--  1) 하나의 결과값이 있다. (RETURN이 존재한다.)
--  2) 주로 쿼리문에 포함된다.
CREATE OR REPLACE FUNCTION get_total(n NUMBER) -- 1부터 n까지의 합계를 반환하는 함수
RETURN NUMBER -- 반환값이 NUMBER타입이다.
AS -- IS 와같다. 변수 선언
    i NUMBER; -- 1~n 
    total NUMBER; -- 합계
BEGIN 
    total := 0;
    FOR i IN 1 .. n LOOP -- 1 .. n 최소1, 최대n
        total := total + i;
    END LOOP;
    RETURN total; -- 반환값
END get_total;

-- 함수의 확인 
-- 함수는 EXEC로 확인 할 수 없다. 
-- 함수는 SELECT를 이용하여 확인한다.
SELECT get_total(100) FROM dual;


-- 문제.
-- SELECT get_grade(90) FROM dual; -- 결과 A
CREATE OR REPLACE FUNCTION get_grade(score NUMBER)
RETURN CHAR
AS
    grade CHAR(1);
BEGIN
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
    RETURN grade;
END get_grade;

SELECT get_grade(90) FROM dual;



-- 3. 트리거 
--  1) INSERT, UPDATE, DELETE 작업을 수행하면 자동으로 실행되는 작업을 의미한다.
--  2) BEFORE, AFTER 트리거를 많이 사용한다.

CREATE OR REPLACE TRIGGER trig1
    BEFORE -- 수행 이전에 자동으로 실행된다.
    INSERT OR UPDATE OR DELETE -- 트리거가 동작할 작업을 고른다.
    ON employees -- 트리거가 동작할 테이블이다.
    FOR EACH ROW -- 한 행씩 적용된다.
BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO TRIGGER');
END trig1;

-- 트리거 동작 확인
UPDATE employees SET salary = 25000 WHERE employee_id = 100;
DELETE FROM employees WHERE employee_id = 206;


CREATE OR REPLACE TRIGGER trig2
    AFTER -- 수행 이후에 자동으로 실행된다.
    INSERT OR UPDATE OR DELETE
    ON employees
    FOR EACH ROW
BEGIN
    IF INSERTING THEN -- 삽입 작업이었다면,
        DBMS_OUTPUT.PUT_LINE('INSERT 했군요.');
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('UPDATE 했군요.');
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('DELETE 했군요.');
    END IF;
END trig2;

UPDATE employees SET salary = 25000 WHERE employee_id = 100;

-- 트리거 삭제
DROP TRIGGER trig1;
DROP TRIGGER trig2;



-- 문제.
-- employees 테이블에서 삭제된 데이터는 퇴사자(retire) 테이블에 자동으로 저장되는 
-- 트리거를 작성하시오.

--         INSERT     UPDATE    DELETE
-- :OLD    NULL       수정전값   삭제전값
-- :NEW    추가된값    수정후값   NULL

-- 1. 퇴사자 테이블을 생성한다.
-- retire_id, employee_id, last_name, department_id, hire_date, retire_date
CREATE TABLE retire
(
    retire_id NUMBER,
    employee_id NUMBER,
    last_name VARCHAR2(25),
    department_id NUMBER,
    hire_date DATE,
    retire_date DATE
);
ALTER TABLE retire ADD CONSTRAINT retire_pk PRIMARY KEY(retire_id);

-- 2. retire_seq 생성한다.
CREATE SEQUENCE retire_seq NOCACHE;

-- 3. 트리거를 생성한다.
CREATE OR REPLACE TRIGGER retire_trig
    AFTER -- 이후에 동작하므로 삭제 이전의 데이터는 :OLD에 있다.
    DELETE
    ON employees
    FOR EACH ROW
BEGIN 
    INSERT INTO retire 
        (retire_id, employee_id, last_name, department_id, hire_date, retire_date)
    VALUES 
        (retire_seq.nextval, :OLD.employee_id, :OLD.last_name, :OLD.department_id, :OLD.hire_date, SYSDATE);
END retire_trig;

-- 4. 삭제를 통해 트리거 동작을 확인한다.
DELETE FROM employees WHERE department_id = 50;

SELECT retire_id
     , employee_id
     , last_name
     , department_id
     , hire_date
     , retire_date
  FROM retire;






