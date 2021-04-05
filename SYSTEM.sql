 -- 1. student�� school

-- ���̺� ���� ���� : �ڽ�(FK) -> �θ�(PK)
DROP TABLE student;
DROP TABLE school;

-- ���̺� ���� ���� : �θ�(PK) -> �ڽ�(FK)
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



-- 2. student�� subject�� enroll

DROP TABLE enroll;
DROP TABLE subject;
DROP TABLE student;

-- �л����̺�
CREATE TABLE student
(
    student_no VARCHAR2(5) PRIMARY KEY,
    student_name VARCHAR2(15),
    student_age NUMBER(3)
);
-- �������̺�
CREATE TABLE subject
(
    subject_code VARCHAR2(1) PRIMARY KEY,
    subject_name VARCHAR2(12),
    professor VARCHAR2(15)
);
-- ������û���̺�
CREATE TABLE enroll
(
    enroll_no NUMBER PRIMARY KEY,
    student_no VARCHAR2(5) REFERENCES student(student_no),
    subject_code VARCHAR2(1) REFERENCES subject(subject_code)
);


-- 3. ��������
-- ���������߰�(PK, FK)
-- ���̺� ���� ���� ����
-- Į�� ����(Į����, Ÿ��)
-- ���̺� ���� ����

-- �ܷ�Ű�� ���� �ڽ����̺��� ���� �����Ѵ�.
DROP TABLE product;
DROP TABLE orders;
DROP TABLE delivery;
DROP TABLE board;

-- �θ����̺��� ���߿� �����Ѵ�.
DROP TABLE member;
DROP TABLE delivery_service;
DROP TABLE manufacturer;
DROP TABLE warehouse;


-- ȸ�����̺�
CREATE TABLE member
(
    member_no NUMBER,  -- ȸ����ȣ(�⺻Ű)
    member_id VARCHAR2(30),  -- ���̵�
    member_pw VARCHAR2(30),  -- ��й�ȣ
    member_name VARCHAR2(15),  -- �̸�
    member_email VARCHAR2(50),  -- �̸���
    member_phone VARCHAR2(15),  -- ��ȭ
    member_date DATE,  -- ������
    PRIMARY KEY(member_no)
);

-- �Խ������̺�
CREATE TABLE board
(
    board_no NUMBER,  -- �Խñ۹�ȣ(�⺻Ű)
    board_title VARCHAR2(1000),  -- ����
    board_content VARCHAR2(4000),  -- ����
    board_hit NUMBER,  -- ��ȸ��
    member_no NUMBER,  -- �ۼ���(member���̺� member_no�����ϴ� �ܷ�Ű)
    board_date DATE,  -- �ۼ�����
    PRIMARY KEY(board_no),
    FOREIGN KEY(member_no) REFERENCES member(member_no)
);

-- ���������̺�
CREATE TABLE manufacturer
(
    manufacturer_no VARCHAR2(12),  -- ����ڹ�ȣ(�⺻Ű)
    manufacturer_name VARCHAR2(100),  -- �������
    manufacturer_phone VARCHAR2(15),  -- ����ó
    PRIMARY KEY(manufacturer_no)
);

-- â�����̺�
CREATE TABLE warehouse
(
    warehouse_no NUMBER,  -- â���ȣ(�⺻Ű)
    warehouse_name VARCHAR2(5),  -- â���̸�
    warehouse_location VARCHAR2(100),  -- â����ġ
    warehouse_used VARCHAR2(1),  -- ��뿩��
    PRIMARY KEY(warehouse_no)
);

-- �ù��ü���̺�
CREATE TABLE delivery_service
(
    delivery_service_no VARCHAR2(12),  -- �ù��ü����ڹ�ȣ(�⺻Ű)
    delivery_service_name VARCHAR2(20),  -- �ù��ü��
    delivery_service_phone VARCHAR2(15),  -- �ù��ü����ó
    delivery_service_address VARCHAR2(100),  -- �ù��ü�ּ�
    PRIMARY KEY(delivery_service_no)
);

-- ������̺�
CREATE TABLE delivery
(
    delivery_no NUMBER,  -- ��۹�ȣ(�⺻Ű)
    delivery_service VARCHAR2(12),  -- ��۾�ü(�ù��ü)(delivery_service���̺� delivery_service_no�����ϴ� �ܷ�Ű)
    delivery_price NUMBER,  -- ��۰���
    delivery_date DATE,  -- ��۳�¥
    PRIMARY KEY(delivery_no),
    FOREIGN KEY(delivery_service) REFERENCES delivery_service(delivery_service_no)
);

-- �ֹ����̺�
CREATE TABLE orders
(
    orders_no NUMBER,  -- �ֹ���ȣ(�⺻Ű)
    member_no NUMBER,  -- �ֹ�ȸ��(member���̺� member_no�����ϴ� �ܷ�Ű)
    delivery_no NUMBER,  -- ��۹�ȣ(delivery���̺� delivery_no�����ϴ� �ܷ�Ű)
    orders_pay VARCHAR2(10),  -- �������
    orders_date DATE,  -- �ֹ�����
    PRIMARY KEY(orders_no),
    FOREIGN KEY(member_no) REFERENCES member(member_no),
    FOREIGN KEY(delivery_no) REFERENCES delivery(delivery_no)
);
    
-- ��ǰ���̺�
CREATE TABLE product
(
    product_code VARCHAR2(10),  -- ��ǰ�ڵ�(�⺻Ű)
    product_name VARCHAR2(50),  -- ��ǰ��
    product_price NUMBER,  -- ����
    product_category VARCHAR2(15),  -- ī�װ�
    orders_no NUMBER,  -- �ֹ���ȣ(orders���̺� orders_no�����ϴ� �ܷ�Ű)
    manufacturer_no VARCHAR2(12),  -- ������(manufacturer���̺� manufacturer_no�����ϴ� �ܷ�Ű)
    warehouse_no NUMBER,  -- â���ȣ(warehouse���̺� warehouse_no�����ϴ� �ܷ�Ű)
    PRIMARY KEY(product_code),
    FOREIGN KEY(orders_no) REFERENCES orders(orders_no),
    FOREIGN KEY(manufacturer_no) REFERENCES manufacturer(manufacturer_no),
    FOREIGN KEY(warehouse_no) REFERENCES warehouse(warehouse_no)
);

