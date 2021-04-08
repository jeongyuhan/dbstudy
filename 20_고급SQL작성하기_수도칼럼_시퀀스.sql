-- 시퀀스
-- 1. 일련번호 생성 객체이다.
-- 2. 주로 기본키(인공키)에서 사용한다.
-- 3. currval : 시퀀스가 생성해서 사용한 현재 번호
-- 4. nextval : 시퀀스가 생성해야 할 다음 번호

-- 시퀀스 생성
CREATE SEQUENCE employee_seq
INCREMENT BY 1 -- 번호가 1씩 증가한다는 의미
START WITH 1000 -- 번호 시작이 1000이라는 의미
NOMAXVALUE -- 최대값 없다는 의미 (지정을 하고 싶으면 MAXVALUE 최댓값n)
NOMINVALUE -- 최소값 없다는 의미
NOCYCLE -- 사이클은 설정한 번호의 순환이기 때문에 최대값이 없으면 사용할 수 없다.
NOCACHE; -- 메모리에 캐시하지 않겠다는 의미이다. 항상 NOCACHE를 유지한다.

-- employee3 테이블에 행 삽입
-- emp_no는 시퀀스로 입력
INSERT INTO employee3(emp_no, name, depart, position, gender, hire_date, salary)
VALUES
     (employee_seq.nextval, '구창민', 1, '과장', 'M', '95-05-01', 5000000);

-- 시퀀스 값 확인
SELECT employee_seq.currval -- currval를 통해 현재 사용된 즉, 가장 최근에 추가된 시퀀스를 확인한다.
  FROM dual;

-- 시퀀스 목록 확인
SELECT *
  FROM user_sequences;


-- ROWNUM : 가상 행 번호
-- ROWID  : 데이터가 저장된 물리적 위치 정보

SELECT rownum
     , rowid
     , emp_no
     , name
  FROM employee;
  
-- 가장 빠른 검색 : ROWID를 이용한 검색 (오라클의 검색 방식)
SELECT emp_no
     , name
  FROM employee
 WHERE ROWID = 'AAAFAPAABAAALCxAAC';
 
-- 2번째로 빠른 검색 : INDEX를 이용한 검색 (휴먼의 검색 방식)
SELECT emp_no
     , name
  FROM employee
 WHERE emp_no = 1003;

-- ROWNUM의 WHERE절 사용
-- 주의. 
-- 1. 1을 포함하는 검색만 가능하다.(무조건 1을 포함해야한다.)
-- 2. 나열된 순서대로 몇 건을 추출하기 위한 목적이다.
-- 3. 특정 위치를 지정한 검색은 불가능 하다.(부분 선택이 불가능하다.)
SELECT emp_no
     , name
  FROM employee
 WHERE ROWNUM = 1; 

SELECT emp_no
     , name
  FROM employee
 WHERE ROWNUM = 2; -- 1을 포함하지 않았기 때문에 불가능하다. (검색이 안된다.)
 
SELECT emp_no
     , name
  FROM employee
 WHERE ROWNUM BETWEEN 1 AND 3; -- 1을 포함하였기 때문에 1부터 3까지 순서대로 검색이된다.

SELECT emp_no
     , name
  FROM employee
 WHERE ROWNUM BETWEEN 3 AND 5; -- 1을 포함하지 않기 때문에 검색이 불가능하다.

-- 1 이외의 번호로 시작하는 모든 ROWNUM을 사용하기 위해서는 
-- ROWNUM에 별명을 주고 별명을 사용하면 된다.

-- 실행 순서에 의해 rn을 WHERE절에서 인식하지 못하므로 오류가 발생한다.
SELECT t.ROWNUM AS rn -- 실행 순서 3
     , t.emp_no
     , t.name
  FROM employee -- 실행 순서 1
 WHERE rn = 2; -- 실행 순서 2

-- 해결방안. 실행 순서가 가장 빠른 FROM절에서 서브쿼리를 사용하여 별명rn을 만들어주어 실행순서를 바꿔준다.
SELECT e.emp_no
     , e.name
  FROM (SELECT ROWNUM AS rn
             , emp_no
             , name
          FROM employee) e -- 실행 순서 1 (여기서 rn이 만들어진다.)   
 WHERE e.rn = 2; -- 실행 순서 2
 
-- ROWNUM을 사용하기위해서는 필연적으로 INLINEVIEW(서브쿼리)를 사용해야한다.

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- 연습문제.
-- 1. 다음 테이블을 생성한다.
-- 게시판(글번호, 글제목, 글내용, 글작성자, 작성일자)
-- 회원(회원번호, 아이디, 이름, 가입일자)
CREATE TABLE members
(
    member_no NUMBER,
    member_id VARCHAR2(15) NOT NULL UNIQUE,
    member_name VARCHAR2(15),
    hire_date DATE
);    

CREATE TABLE board 
(
    board_no NUMBER,
    board_title VARCHAR2(30),
    board_content VARCHAR2(500),
    member_id VARCHAR2(10),
    board_date DATE
);

        
-- 2. 각 테이블에서 사용할 시퀀스를 생성한다.
-- 게시판 시퀀스(1~무제한)
-- 회원 시퀀스(100000~999999)
CREATE SEQUENCE members_seq
INCREMENT BY 1
START WITH 100000
MAXVALUE 999999 
MINVALUE 100000
CYCLE
NOCACHE;

CREATE SEQUENCE board_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


-- 3. 각 테이블에 적절한 기본키, 외래키, 데이터(테이블당 5개)를 추가한다.
ALTER TABLE members ADD CONSTRAINT member_pk PRIMARY KEY(member_no);
ALTER TABLE board ADD CONSTRAINT board_pk PRIMARY KEY(board_no);
ALTER TABLE board ADD CONSTRAINT board_members_fk FOREIGN KEY (member_id) REFERENCES members(member_id);

INSERT INTO members (member_no, member_id, member_name, hire_date)
           VALUES (members_seq.NEXTVAL, 'admin', '관리자', '21/04/08');
INSERT INTO members (member_no, member_id, member_name, hire_date)
           VALUES (members_seq.NEXTVAL, 'alice', '엘리스', '21/02/22');
INSERT INTO members (member_no, member_id, member_name, hire_date)
           VALUES (members_seq.NEXTVAL, 'brown', '브라운', '21/03/03');
INSERT INTO members (member_no, member_id, member_name, hire_date)
           VALUES (members_seq.NEXTVAL, 'black', '김검정', '21/01/05');
INSERT INTO members (member_no, member_id, member_name, hire_date)
           VALUES (members_seq.NEXTVAL, 'green', '박초록', '21/02/28');      

INSERT INTO board (board_no, board_title, board_content, member_id, board_date)
           VALUES (board_seq.NEXTVAL, '공지사항', '공지입니다.', 'admin', SYSDATE);
INSERT INTO board (board_no, board_title, board_content, member_id, board_date)
           VALUES (board_seq.NEXTVAL, '안내사항', '안내입니다.', 'alice', '21/04/06');
INSERT INTO board (board_no, board_title, board_content, member_id, board_date)
           VALUES (board_seq.NEXTVAL, '경고사항', '경고입니다.', 'brown', '19/05/05');
INSERT INTO board (board_no, board_title, board_content, member_id, board_date)
           VALUES (board_seq.NEXTVAL, '주의사항', '주의입니다.', 'black', SYSDATE);
INSERT INTO board (board_no, board_title, board_content, member_id, board_date)
           VALUES (board_seq.NEXTVAL, '필수사항', '필수입니다.', 'green', '21/03/03');


-- 4. 게시판을 글제목의 가나다순으로 정렬하고 첫번째 글을 조회한다.
SELECT board_no
     , board_title
     , board_content
     , member_id
     , board_date
  FROM (SELECT board_no
             , board_title
             , board_content
             , member_id
             , board_date
          FROM board
         ORDER BY board_title)
 WHERE ROWNUM = 1;

-- 5. 게시판을 글번호의 가나다순으로 정렬하고 1~3번째 글을 조회한다.
SELECT b.board_no
     , b.board_title
     , b.board_content
     , b.member_id
     , b.board_date
  FROM (SELECT board_no
             , board_title
             , board_content
             , member_id
             , board_date
          FROM board 
         ORDER BY board_no) b
 WHERE ROWNUM <= 3;


-- 6. 게시판을 최근작성일자순으로 정렬하고 3~5번째 글을 조회한다.
-- b.* 은 b테이블에 있는 모든 칼럼을 의미한다.
SELECT a.board_no
     , a.board_title
     , a.board_content
     , a.member_id
     , a.board_date
  FROM (SELECT b.board_no
             , b.board_title
             , b.board_content
             , b.member_id
             , b.board_date
             , ROWNUM AS rn
          FROM (SELECT board_no
                     , board_title
                     , board_content
                     , member_id
                     , board_date
                  FROM board    
                ORDER BY board_date DESC) b) a
         WHERE a.rn BETWEEN 3 AND 5;

-- 실행된 순서.
-- 1) b => ORDER BY
-- 2) a => ROWNUM AS rn
-- 3) main => a.rn BETWEEN x AND y


-- 7. 가장 먼저 가입한 회원을 조회한다.
-- 가입일을 기준으로 오름차순 정렬하고, 첫 번째 항목을 조회한다.
SELECT m.member_no
     , m.member_id
     , m.member_name
     , m.hire_date
  FROM (SELECT member_no
             , member_id
             , member_name
             , hire_date
          FROM members
         ORDER BY hire_date) m
 WHERE ROWNUM = 1; 
 
-- 8. 3번째로 가입한 회원을 조회한다.
SELECT m2.member_no
     , m2.member_id
     , m2.member_name
     , m2.hire_date
  FROM (SELECT m1.member_no
             , m1.member_id
             , m1.member_name
             , m1.hire_date 
             , ROWNUM AS rn
          FROM (SELECT member_no
                     , member_id
                     , member_name
                     , hire_date
                  FROM members
                 ORDER BY hire_date) m1)m2
 WHERE m2.rn = 3; 


-- 9. 가장 나중에 가입한 회원을 조회한다.
-- 7번문제의 풀이의 ORDER BY를 내림차순으로만 바꿔주면된다. 
SELECT m.member_no
     , m.member_id
     , m.member_name
     , m.hire_date
  FROM (SELECT member_no
             , member_id
             , member_name
             , hire_date
          FROM members
         ORDER BY hire_date DESC) m
 WHERE ROWNUM = 1; 




DROP TABLE board;
DROP TABLE members;