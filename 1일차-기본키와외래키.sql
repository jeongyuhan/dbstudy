-- �� �����̼� (�θ� ���̺�)
CREATE TABLE ��
(
    �����̵� VARCHAR2(30) PRIMARY KEY,
    ���̸� VARCHAR2(30),
    ���� NUMBER(3),
    ��� CHAR(1),
    ���� VARCHAR2(5),
    ������ NUMBER(7)
);

-- �ֹ� �����̼� (�ڽ� ���̺�)
CREATE TABLE �ֹ�
(
    �ֹ���ȣ NUMBER PRIMARY KEY,
    �ֹ��� VARCHAR2(30) REFERENCES ��(�����̵�),  -- �ܷ�Ű(�����̺��� �����̵� Į���� ����), FOREIGN KEY(FK), �ݵ�� Į��Ÿ��(���� ��Ȳ���� VARCHAR2(30))�� �����ش�.
    �ֹ���ǰ VARCHAR2(20),
    ���� NUMBER,
    �ܰ� NUMBER,
    �ֹ����� DATE
);
    
DROP TABLE ��;    