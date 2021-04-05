DROP TABLE lecture;
DROP TABLE enroll;
DROP TABLE student;
DROP TABLE course;
DROP TABLE professor;




CREATE TABLE course
(
    course_no NUMBER,
    course_name VARCHAR2(30),
    course_pass CHAR(1)
);

CREATE TABLE professor
(
    professor_no NUMBER,
    professor_name VARCHAR2(10),
    professor_type VARCHAR2(10)
);

CREATE TABLE student
(
    student_no NUMBER,
    student_name VARCHAR2(10),
    student_address VARCHAR2(30),
    student_grade NUMBER,
    professor_no NUMBER
);    

CREATE TABLE enroll
(
    enroll_no NUMBER,
    student_no NUMBER,
    course_no NUMBER,
    hire_date DATE
);    

CREATE TABLE lecture
(
    lecture_no NUMBER,
    professor_no NUMBER,
    enroll_no NUMBER,
    lecture_name VARCHAR2(20),
    lecturea_room VARCHAR2(10)
);

ALTER TABLE course ADD CONSTRAINT course_pk PRIMARY KEY (course_no);
ALTER TABLE professor ADD CONSTRAINT professor_pk PRIMARY KEY (professor_no);
ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY (student_no);
ALTER TABLE student ADD CONSTRAINT student_professor_fk FOREIGN KEY (professor_no) REFERENCES professor(professor_no);
ALTER TABLE enroll ADD CONSTRAINT enroll_pk PRIMARY KEY (enroll_no);
ALTER TABLE enroll ADD CONSTRAINT enroll_course_fk FOREIGN KEY (course_no) REFERENCES course(course_no);
ALTER TABLE enroll ADD CONSTRAINT enroll_student_fk FOREIGN KEY (student_no) REFERENCES student(student_no);
ALTER TABLE lecture ADD CONSTRAINT lecture_pk PRIMARY KEY (lecture_no);
ALTER TABLE lecture ADD CONSTRAINT lecture_professor_fk FOREIGN KEY (professor_no) REFERENCES professor(professor_no);
ALTER TABLE lecture ADD CONSTRAINT lecture_enroll_fk FOREIGN KEY (enroll_no) REFERENCES enroll(enroll_no);

INSERT INTO course (course_no, course_name, course_pass) VALUES (1, 'MATH', 'C');
INSERT INTO course (course_no, course_name, course_pass) VALUES (2, 'ENG', 'B');
INSERT INTO course (course_no, course_name, course_pass) VALUES (3, 'KOR', 'D');

INSERT INTO professor VALUES (101, 'BROWN', 'MATH');
INSERT INTO professor VALUES (102, 'ALICE', 'ENG');
INSERT INTO professor VALUES (103, 'KIM', 'KOR');

INSERT INTO student VALUES (10101, 'PARK', 'SEOUL', 3, 101);
INSERT INTO student VALUES (10102, 'CHOI', 'BUSAN', 4, 102);
INSERT INTO student VALUES (10103, 'JEONG', 'INCHON', 2, 103);

INSERT INTO enroll VALUES (3333, 10102, 2, '2021/04/02');
INSERT INTO enroll VALUES (5555, 10101, 3, '2021/04/01');
INSERT INTO enroll VALUES (7777, 10103, 1, '2021/03/30');

INSERT INTO lecture VALUES (11, 101, 3333, 'MATHCLASS', 'E-101');
INSERT INTO lecture VALUES (22, 102, 5555, 'ENGCLASS', 'Q-101');
INSERT INTO lecture VALUES (33, 103, 7777, 'KORCLASS', 'Z-101');


-------------------------------------------------------------------------------
-- 선생님 풀이
-- 외래키를 가진 테이블을 먼저 삭제
DROP TABLE lecture;
DROP TABLE enroll;
DROP TABLE student;

-- 외래키가 없는 테이블을 나중에 삭제
DROP TABLE course;
DROP TABLE professor;


-- 1. professor 테이블
CREATE TABLE professor (
    professor_no VARCHAR2(5),  -- 기본키
    professor_name VARCHAR2(30),
    professor_major VARCHAR2(30)
);


-- 2. course 테이블
CREATE TABLE course (
    course_no VARCHAR2(10),  -- 기본키
    course_name VARCHAR2(30),
    course_unit NUMBER(1)
);


-- 3. student 테이블
CREATE TABLE student (
    student_no VARCHAR2(10),  -- 기본키
    student_name VARCHAR2(30),
    student_address VARCHAR2(100),
    student_grade NUMBER(1),
    professor_no VARCHAR2(5)  -- professor 테이블의 professor_no를 참조하는 외래키
);


-- 4. enroll 테이블
CREATE TABLE enroll (
    enroll_no NUMBER,
    student_no VARCHAR2(10),  -- student 테이블의 student_no를 참조하는 외래키
    course_no VARCHAR2(10),  -- course 테이블의 course_no를 참조하는 외래키
    enroll_date DATE
);


-- 5. lecture 테이블
CREATE TABLE lecture (
    lecture_no NUMBER,  -- 기본키
    professor_no VARCHAR2(5),  -- professor 테이블의 professor_no를 참조하는 외래키
    enroll_no NUMBER,  -- enroll 테이블의 enroll_no를 참조하는 외래키
    lecture_name VARCHAR2(100),
    lecture_lab VARCHAR2(30)
);


-- 6. 기본키 제약조건 추가
ALTER TABLE professor ADD CONSTRAINT professor_pk PRIMARY KEY(professor_no);
ALTER TABLE course ADD CONSTRAINT course_pk PRIMARY KEY(course_no);
ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY(student_no);
ALTER TABLE enroll ADD CONSTRAINT enroll_pk PRIMARY KEY(enroll_no);
ALTER TABLE lecture ADD CONSTRAINT lecture_pk PRIMARY KEY(lecture_no);


-- 7. 외래키 제약조건 추가
ALTER TABLE student ADD CONSTRAINT student_professor_fk FOREIGN KEY(professor_no) REFERENCES professor(professor_no);
ALTER TABLE enroll ADD CONSTRAINT enroll_student_fk FOREIGN KEY(student_no) REFERENCES student(student_no);
ALTER TABLE enroll ADD CONSTRAINT enroll_course_fk FOREIGN KEY(course_no) REFERENCES course(course_no);
ALTER TABLE lecture ADD CONSTRAINT lecture_professor_fk FOREIGN KEY(professor_no) REFERENCES professor(professor_no);
ALTER TABLE lecture ADD CONSTRAINT lecture_enroll_fk FOREIGN KEY(enroll_no) REFERENCES enroll(enroll_no);


-- 8. professor 테이블 데이터 입력
INSERT INTO professor VALUES ('AB000', '제임스', '전산');
INSERT INTO professor VALUES ('AB200', '앨리스', '회계');
INSERT INTO professor VALUES ('JJ100', '스미스', '영화');

-- 9. course 테이블 데이터 입력
INSERT INTO course VALUES ('11', '자바', 3);
INSERT INTO course VALUES ('22', '데이터베이스', 3);
INSERT INTO course VALUES ('33', '서버프로그램', 3);

-- 10. student 테이블 데이터 입력
INSERT INTO student VALUES ('10101', '김학생', '서울', 1, 'AB000');
INSERT INTO student VALUES ('10102', '이학생', '서울', 1, 'AB000');
INSERT INTO student VALUES ('10103', '박학생', '서울', 1, 'AB200');

-- 11. enroll 테이블 데이터 입력
INSERT INTO enroll VALUES (100, '10101', '11', SYSDATE);
INSERT INTO enroll VALUES (101, '10101', '22', SYSDATE);
INSERT INTO enroll VALUES (102, '10101', '33', SYSDATE);

-- 12. lecture 테이블 데이터 입력
INSERT INTO lecture VALUES (11, 'AB000', 100, '자바완전정복', 'A101');
INSERT INTO lecture VALUES (12, 'AB000', 101, '데이터베이스완전정복', 'B101');
INSERT INTO lecture VALUES (13, 'AB000', 102, '서버프로그래밍완전정복', 'C104');


-- 13. 변경된 내용을 DB에 저장한다.
COMMIT;  -- INSERT, UPDATE, DELETE 문은 필요