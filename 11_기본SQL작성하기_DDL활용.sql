-- 삭제 순서는 자식테이블부터 먼저 삭제하고 부모테이블 삭제한다.
DROP TABLE customer;
DROP TABLE bank;

--------------------------------------------------------------------------------

-- 제약 조건을 칼럼 생성에 함께 넣은 경우
--CREATE TABLE bank
--(
--    bank_code VARCHAR2(20) PRIMARY KEY,
--    bank_name VARCHAR2(30)
--);
--
--CREATE TABLE customer
--( 
--    no NUMBER PRIMARY KEY,
--    name VARCHAR2(30) NOT NULL,
--    phone VARCHAR2(30) UNIQUE,
--    age NUMBER CHECK (age >= 0 AND age <= 100), -- 0~100 사이를 지정하는 방법1
--    age2 NUMBER CHECK (age2 BETWEEN 0 AND 100), -- 0~100 사이를 지정하는 방법2
--    bank_code VARCHAR2(20) REFERENCES bank(bank_code)
--);    

--------------------------------------------------------------------------------

-- 제약 조건을 칼럼 밖에 따로 생성할 경우
--CREATE TABLE bank
--(
--    bank_code VARCHAR2(20),
--    bank_name VARCHAR2(30),
--    PRIMARY KEY(bank_code)
--);
--
-- CREATE TABLE customer
-- ( 
-- no NUMBER,
-- name VARCHAR2(30) NOT NULL,
-- phone VARCHAR2(30),
-- age NUMBER,
-- bank_code VARCHAR2(20),
-- PRIMARY KEY(no),
-- UNIQUE(phone),
-- CHECK(age BETWEEN 0 AND 100),
-- FOREIGN KEY(bank_code) REFERENCES bank(bank_code)
-- );    

--------------------------------------------------------------------------------

-- 제약 조건에 이름을 주는 방법 (CONSTRAINT 사용)
--CREATE TABLE bank
--(
--    bank_code VARCHAR2(20),
--    bank_name VARCHAR2(30),
--    CONSTRAINT bank_pk PRIMARY KEY(bank_code)
--);
-- 
-- CREATE TABLE customer
-- ( 
-- no NUMBER,
-- name VARCHAR2(30) NOT NULL,
-- phone VARCHAR2(30),
-- age NUMBER,
-- bank_code VARCHAR2(20),
-- CONSTRAINT customer_pk PRIMARY KEY(no),
-- CONSTRAINT customer_phone_uq UNIQUE(phone),
-- CONSTRAINT customer_age_ck CHECK(age BETWEEN 0 AND 100),
-- CONSTRAINT customer_bank_fk FOREIGN KEY(bank_code) REFERENCES bank(bank_code)
-- );    


--------------------------------------------------------------------------------

-- 테이블 변경작업
-- 제약 조건과 제약명을 따로 설정하지 않은 테이블을 설정한뒤
-- ALTER TABLE 테이블명 (ADD, DROP, MODIFY 등)

DROP TABLE customer;
DROP TABLE bank;


CREATE TABLE bank
(
    bank_code VARCHAR2(20),
    bank_name VARCHAR2(30)
);
 
 CREATE TABLE customer
 ( 
 no NUMBER,
 name VARCHAR2(30) NOT NULL,
 phone VARCHAR2(30),
 age NUMBER,
 bank_code VARCHAR2(20)
 );    

-- 테이블 구조 확인
DESC bank;
DESC customer;

 -- 칼럼의 추가
-- ALTER TABLE 테이블 ADD 칼럼명 타입 [제약조건]; 제약조건은 생략가능
-- 1. bank테이블에 bank_phone 칼럼을 추가한다.
ALTER TABLE bank ADD bank_phone VARCHAR2(15);
 
-- 칼럼의 수정
-- ALTER TABLE 테이블 MODIFY 칼럼명 타입 [제약조건]; 제약조건은 생략가능
-- 1. bank 테이블의 bank_name 칼럼을 varchar2(15)로 수정한다.
ALTER TABLE bank MODIFY bank_name VARCHAR2(15);

-- 2. customer 테이블의 age 칼럼을 NUMBER(3)으로 수정한다.
ALTER TABLE customer MODIFY age NUMBER(3);

-- 3. customer 테이블의 phone 칼럼을 NOT NULL로 수정한다.
ALTER TABLE customer MODIFY phone VARCHAR2(30) NOT NULL;

-- 4. customer 테이블의 phone 칼럼을 NULL로 수정한다.
ALTER TABLE customer MODIFY phone VARCHAR2(30) NULL;


-- 칼럼의 삭제
-- ALTER TABLE 테이블 DROP COLUMN 칼럼명;
-- 1. bank 테이블의 bank_phone 칼럼을 삭제한다.
ALTER TABLE bank DROP COLUMN bank_phone;

-- 칼럼의 이름 변경
-- ALTER TABLE 테이블 RENAME COLUMEN 기존칼럼명 TO 신규칼럼명;
-- 1. customer 테이블의 phone 칼럼명을 contact으로 수정한다.
ALTER TABLE customer RENAME COLUMN phone TO contact;

-- 제약조건의 추가
ALTER TABLE bank ADD CONSTRAINT bank_pk PRIMARY KEY (bank_code);
ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY (no);
ALTER TABLE customer ADD CONSTRAINT customer_phone_uq UNIQUE (phone);
ALTER TABLE customer ADD CONSTRAINT customer_age_ck CHECK (age BETWEEN 0 AND 100);
ALTER TABLE customer ADD CONSTRAINT customer_bank_fk FOREIGN KEY (bank_code) REFERENCES bank (bank_code);


-- 제약조건의 삭제
-- ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건이름;
-- 외래키를 먼저 찾아서 지우고 기본키를 삭제할 수 있다.