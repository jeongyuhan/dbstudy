-- 테이블 삭제 순서 : 자식(FK) -> 부모(PK)
DROP TABLE student;
DROP TABLE school;

-- 테이블 생성 순서 : 부모(PK) => 자식(FK)

CREATE TABLE school 
(
    school_code NUMBER(3) PRIMARY KEY,
    school_name VARCHAR2(10)
);    

CREATE TABLE student
(
    school_code NUMBER(3) REFERENCES school(school_code),
    student_name VARCHAR2(15)
);

--------------------------------------------------------------------------------

DROP TABLE enroll;
DROP TABLE subject;
DROP TABLE student;

-- 학생테이블
CREATE TABLE student
(
    student_no VARCHAR2(5) PRIMARY KEY,
    student_name VARCHAR2(15),
    student_age NUMBER(3)
);
-- 과목테이블
CREATE TABLE subject
(
    subject_code VARCHAR2(1) PRIMARY KEY,
    subject_name VARCHAR2(12),
    professor VARCHAR2(15)
);
-- 수강신청테이블
CREATE TABLE enroll
(
    enroll_no NUMBER PRIMARY KEY,
    student_no VARCHAR2(5) REFERENCES student(student_no),
    subject_code VARCHAR2(1) REFERENCES subject(subject_code)
);
 
--------------------------------------------------------------------------------
-- 제약조건추가(PK, FK)
-- 테이블 생성 순서 조정
-- 칼럼 수정(칼럼명, 타입)

-- 테이블 삭제 순서
-- 외래키를 가진 자식테이블을 먼저 삭제한다.
DROP TABLE product;
DROP TABLE orders;
DROP TABLE delivery;
DROP TABLE board;

-- 부모테이블을 나중에 삭제한다.
DROP TABLE member;
DROP TABLE delivery_service;
DROP TABLE manufacturer;
DROP TABLE warehouse;
 
-- 회원 테이블 
CREATE TABLE member
(
    member_no NUMBER, -- 회원번호(기본키)
    member_id VARCHAR2(30), -- 아이디
    member_pw VARCHAR2(30), -- 비밀번호
    member_name VARCHAR2(15), -- 이름
    member_email VARCHAR2(50), -- 이메일
    member_phone VARCHAR2(15), -- 전화번호
    member_date DATE, -- 가입일
    PRIMARY KEY(member_no)
);

-- 게시판 테이블
CREATE TABLE board
(
    board_no NUMBER, -- 게시글번호
    board_title VARCHAR2(1000), -- 제목
    board_content VARCHAR2(4000), -- 내용
    board_hit NUMBER, -- 조회수
    member_no NUMBER, -- 작성자 MEMBER 테이블의 member_no 참조하는 외래키
    board_date DATE, -- 작성일
    PRIMARY KEY(board_no),
    FOREIGN KEY(member_no) references member(member_no)
);

-- 제조사 테이블
CREATE TABLE manufacturer
( 
    manufacturer_no VARCHAR2(12), -- 사업자번호(기본키)
    manufacturer_name VARCHAR2(100), -- 제조사명
    manufacturer_phone VARCHAR2(15), -- 연락처
    PRIMARY KEY(manufacturer_no)
);

-- 창고 테이블
CREATE TABLE warehouse
(
    warehouse_no NUMBER, -- 창고번호(기본키)
    warehouse_name VARCHAR2(5), -- 창고이름
    warehouse_location VARCHAR2(100), -- 창고위치
    warehouse_used VARCHAR2(1), -- 창고사용여부
    PRIMARY KEY(warehouse_no)
);

-- 택배업체 테이블
CREATE TABLE delivery_service
( 
    delivery_service_no VARCHAR2(12), -- 택배업체사업자번호(기본키)
    delivery_service_name VARCHAR2(20), -- 택배업체명
    delivery_service_phone VARCHAR2(15), -- 택배업체연락처
    delivery_service_address VARCHAR2(100), -- 택배업체주소
    PRIMARY KEY(delivery_service_no)
);    

-- 배송테이블
CREATE TABLE delivery
(
    delivery_no NUMBER, -- 배송번호(기본키)
    delivery_service VARCHAR2(12), -- 배송업체(택배업체)delivery_service 테이블의 delivery_service_no 참조하는 외래키
    delivery_price NUMBER, -- 배송가격
    delivery_date DATE, -- 배송날짜
    PRIMARY KEY(delivery_no),
    FOREIGN KEY(delivery_service) REFERENCES delivery_service(delivery_service_no)
);

-- 주문 테이블
CREATE TABLE orders
(
    orders_no NUMBER, -- 주문번호(기본키)
    member_no NUMBER, -- 주문회원 member 테이블의 member_no 참조하는 외래키
    delivery_no NUMBER , -- 배송번호 delivery 테이블의 delivery_no 참조하는 외래키
    orders_pay VARCHAR2(10), -- 결제방식
    orders_date DATE, -- 주문일자
    PRIMARY KEY(orders_no),
    FOREIGN KEY(member_no) REFERENCES member(member_no),
    FOREIGN KEY(delivery_no) REFERENCES delivery(delivery_no)
);    
        
-- 제품 테이블
CREATE TABLE product 
( 
    product_code VARCHAR2(10), -- 제품코드 (기본키)
    product_name VARCHAR2(50), -- 제품명
    product_price NUMBER, -- 가격
    product_category VARCHAR2(15), -- 카테고리
    orders_no NUMBER, -- 주문번호 orders 테이블의 orders_no 참조하는 외래키
    manufacturer_no VARCHAR2(12), -- 제조사  manufacturer 테이블의  manufacturer_no 참조하는 외래키
    warehouse_no NUMBER, -- 창고번호 warehouse 테이블의 warehouse_no 참조하는 외래키
    PRIMARY KEY(product_code),
    FOREIGN KEY(orders_no) REFERENCES orders(orders_no),
    FOREIGN KEY(manufacturer_no) REFERENCES manufacturer(manufacturer_no), 
    FOREIGN KEY(warehouse_no) REFERENCES warehouse(warehouse_no) 
);    
 
  
 
 


 
 
 
 
 
 
 
 
 
    