--- createsouth, 1, 50
DROP TABLE tstck;
DROP TABLE tretn;
DROP TABLE tdlvrd;
DROP TABLE tdlvr;
DROP TABLE tsupl;
DROP TABLE tshipd;
DROP TABLE tship;
DROP TABLE tpurcd;
DROP TABLE tpurc;
DROP TABLE tcust;
DROP TABLE tprod;

CREATE TABLE tprod
 (code CHAR(4) PRIMARY KEY
 ,dscr VARCHAR(30)
 ,pric DECIMAL(10,2) 
 );

CREATE TABLE tcust
 (code CHAR(4) PRIMARY KEY
 ,firm VARCHAR(30)
 ,addr VARCHAR(30)
 );

CREATE TABLE tpurc
 (cust CHAR(4) NOT NULL
 ,recv DATE NOT NULL 
 ,PRIMARY KEY (cust,recv)
 ,FOREIGN KEY (cust) REFERENCES tcust(code)
 );

CREATE TABLE tpurcd
 (cust CHAR(4) NOT NULL
 ,recv DATE NOT NULL 
 ,prod CHAR(4) NOT NULL
 ,qnty INTEGER
 ,PRIMARY KEY (cust, recv, prod)
 ,FOREIGN KEY(cust,recv) REFERENCES tpurc(cust,recv)
 ,FOREIGN KEY(prod) REFERENCES tprod(code)
 );

CREATE TABLE tship
 (cust CHAR(4) NOT NULL
 ,recv DATE NOT NULL
 ,addr CHAR(30)
 ,shpd DATE NOT NULL
 ,PRIMARY KEY (cust,recv,shpd)
 ,FOREIGN KEY (cust,recv) REFERENCES tpurc (cust,recv)
 );

CREATE TABLE tshipd
 (cust CHAR(4) NOT NULL
 ,recv DATE NOT NULL 
 ,shpd DATE NOT NULL 
 ,prod CHAR(4) NOT NULL
 ,qnty INTEGER
 ,PRIMARY KEY (cust,recv,shpd,prod)
 ,FOREIGN KEY (cust,recv,shpd) REFERENCES tship (cust,recv,shpd)
 );

CREATE TABLE tsupl
 (code CHAR(4) NOT NULL
 ,addr CHAR(30)
 ,PRIMARY KEY (code)
 );

CREATE TABLE tdlvr
 (supl CHAR(4) NOT NULL
 ,recv DATE NOT NULL 
 ,PRIMARY KEY (supl, recv)
 ,FOREIGN KEY (supl) REFERENCES tsupl(code)
 );

CREATE TABLE tdlvrd
 (supl CHAR(4) NOT NULL
 ,recv DATE NOT NULL
 ,prod CHAR(4) NOT NULL
 ,qnty INTEGER
 ,PRIMARY KEY (supl,recv,prod)
 ,FOREIGN KEY (supl,recv) REFERENCES tdlvr(supl,recv)
 ,FOREIGN KEY (prod) REFERENCES tprod(code)
 );

CREATE TABLE tretn
 (cust CHAR(4) NOT NULL
 ,recv DATE NOT NULL
 ,prod CHAR(4) NOT NULL
 ,qnty INTEGER
 ,expl VARCHAR(100)
 ,PRIMARY KEY (cust,recv,prod)
 ,FOREIGN KEY (cust) REFERENCES tcust(code)
 ,FOREIGN KEY (prod) REFERENCES tprod(code)
 );

CREATE TABLE tstck
 (chck DATE NOT NULL 
 ,prod CHAR(4) NOT NULL
 ,qnty INTEGER
 ,PRIMARY KEY (chck,prod)
 ,FOREIGN KEY (prod) REFERENCES tprod(code)
 );

GRANT SELECT ON tdlvrd TO PUBLIC;
GRANT SELECT ON tdlvr TO PUBLIC;
GRANT SELECT ON tsupl TO PUBLIC;
GRANT SELECT ON tshipd TO PUBLIC;
GRANT SELECT ON tship TO PUBLIC;
GRANT SELECT ON tpurcd TO PUBLIC;
GRANT SELECT ON tpurc TO PUBLIC;
GRANT SELECT ON tcust TO PUBLIC;
GRANT SELECT ON tprod TO PUBLIC;
GRANT SELECT ON tstck TO PUBLIC;
GRANT SELECT ON tretn TO PUBLIC;

COMMIT;
--- tabtcust, 1, 50
insert into tcust values ('c001','Ambiguous Applications','Absorption Ave.');
insert into tcust values ('c002','Inconspicuous Inc.','Interception Rd.');
insert into tcust values ('c003','Contiguous Corp.','Circumscription Close');
insert into tcust values ('c004','Strenuous Systems','Surjection Street');
insert into tcust values ('c005','Assiduous Assoc.','Attribution Alley');
insert into tcust values ('c006','Incongruous Int.','Irresolution Pl.');
--- tabtsupl, 1, 50
insert into tsupl values ('s001','Makeshift Supplies           ');
insert into tsupl values ('s002','Forklift Distr.               ');
insert into tsupl values ('s003','Thrift Bros.                  ');
insert into tsupl values ('s004','Adrift Ltd.                   ');
--- tabtprod, 1, 50
insert into tprod values ('p001','Kensington',20.00);
insert into tprod values ('p002','Barrington',80.00);
insert into tprod values ('p003','Bennington',60.00);
insert into tprod values ('p004','Lexington',10.00);
insert into tprod values ('p005','Wilmington',15.00);
insert into tprod values ('p006','Farmington',15.00);
insert into tprod values ('p007','Arlington',15.00);
insert into tprod values ('p008','Huntington',30.00);
insert into tprod values ('p009','Worthington',30.00);
insert into tprod values ('p010','Coddington',20.00);
--- tabtdlvr, 1, 50
insert into tdlvr values ('s001',DATE '2002-02-14');
insert into tdlvr values ('s001',DATE '2002-02-15');
insert into tdlvr values ('s001',DATE '2002-02-19');
insert into tdlvr values ('s002',DATE '2002-02-16');
insert into tdlvr values ('s003',DATE '2002-02-15');
--- tabtdlvrd, 1, 50
insert into tdlvrd values ('s001',DATE '2002-02-14','p005',10);
insert into tdlvrd values ('s001',DATE '2002-02-15','p005',-10);
insert into tdlvrd values ('s001',DATE '2002-02-19','p005',10);
insert into tdlvrd values ('s002',DATE '2002-02-16','p005',5);
insert into tdlvrd values ('s002',DATE '2002-02-16','p007',40);
insert into tdlvrd values ('s003',DATE '2002-02-15','p002',20);
insert into tdlvrd values ('s003',DATE '2002-02-15','p006',50);
insert into tdlvrd values ('s003',DATE '2002-02-15','p008',20);
--- tabtpurc, 1, 50
insert into tpurc values ('c001',DATE '2002-02-17');
insert into tpurc values ('c002',DATE '2002-01-30');
insert into tpurc values ('c002',DATE '2002-02-12');
insert into tpurc values ('c003',DATE '2002-01-27');
insert into tpurc values ('c003',DATE '2002-02-02');
insert into tpurc values ('c003',DATE '2002-02-04');
insert into tpurc values ('c003',DATE '2002-02-10');
insert into tpurc values ('c003',DATE '2002-02-11');
insert into tpurc values ('c003',DATE '2002-02-12');
insert into tpurc values ('c003',DATE '2002-02-17');
insert into tpurc values ('c005',DATE '2002-02-06');
insert into tpurc values ('c005',DATE '2002-02-09');
insert into tpurc values ('c005',DATE '2002-02-12');
insert into tpurc values ('c005',DATE '2002-02-15');
insert into tpurc values ('c006',DATE '2002-01-26');
insert into tpurc values ('c006',DATE '2002-02-08');
insert into tpurc values ('c006',DATE '2002-02-16');
insert into tpurc values ('c006',DATE '2002-02-20');
--- tabtpurcd, 1, 50
insert into tpurcd values ('c001',DATE '2002-02-17','p004',1);
insert into tpurcd values ('c001',DATE '2002-02-17','p005',5);
insert into tpurcd values ('c001',DATE '2002-02-17','p006',5);
insert into tpurcd values ('c001',DATE '2002-02-17','p007',5);
insert into tpurcd values ('c001',DATE '2002-02-17','p010',4);
insert into tpurcd values ('c002',DATE '2002-01-30','p008',5);
insert into tpurcd values ('c002',DATE '2002-02-12','p001',5);
insert into tpurcd values ('c002',DATE '2002-02-12','p003',4);
insert into tpurcd values ('c002',DATE '2002-02-12','p005',3);
insert into tpurcd values ('c002',DATE '2002-02-12','p008',3);
insert into tpurcd values ('c003',DATE '2002-01-27','p005',3);
insert into tpurcd values ('c003',DATE '2002-01-27','p007',1);
insert into tpurcd values ('c003',DATE '2002-02-02','p006',1);
insert into tpurcd values ('c003',DATE '2002-02-02','p007',1);
insert into tpurcd values ('c003',DATE '2002-02-02','p008',3);
insert into tpurcd values ('c003',DATE '2002-02-02','p010',4);
insert into tpurcd values ('c003',DATE '2002-02-04','p001',5);
insert into tpurcd values ('c003',DATE '2002-02-04','p003',3);
insert into tpurcd values ('c003',DATE '2002-02-04','p005',4);
insert into tpurcd values ('c003',DATE '2002-02-10','p001',5);
insert into tpurcd values ('c003',DATE '2002-02-10','p006',1);
insert into tpurcd values ('c003',DATE '2002-02-11','p004',5);
insert into tpurcd values ('c003',DATE '2002-02-11','p006',5);
insert into tpurcd values ('c003',DATE '2002-02-11','p008',4);
insert into tpurcd values ('c003',DATE '2002-02-12','p008',1);
insert into tpurcd values ('c003',DATE '2002-02-17','p001',5);
insert into tpurcd values ('c003',DATE '2002-02-17','p003',4);
insert into tpurcd values ('c003',DATE '2002-02-17','p004',3);
insert into tpurcd values ('c003',DATE '2002-02-17','p005',3);
insert into tpurcd values ('c003',DATE '2002-02-17','p008',5);
insert into tpurcd values ('c005',DATE '2002-02-06','p004',5);
insert into tpurcd values ('c005',DATE '2002-02-06','p008',5);
insert into tpurcd values ('c005',DATE '2002-02-06','p010',4);
insert into tpurcd values ('c005',DATE '2002-02-09','p004',1);
insert into tpurcd values ('c005',DATE '2002-02-09','p006',5);
insert into tpurcd values ('c005',DATE '2002-02-09','p007',2);
insert into tpurcd values ('c005',DATE '2002-02-12','p001',1);
insert into tpurcd values ('c005',DATE '2002-02-12','p008',5);
insert into tpurcd values ('c006',DATE '2002-01-26','p005',1);
insert into tpurcd values ('c006',DATE '2002-01-26','p008',2);
insert into tpurcd values ('c006',DATE '2002-01-26','p010',15);
insert into tpurcd values ('c006',DATE '2002-02-08','p003',5);
insert into tpurcd values ('c006',DATE '2002-02-08','p005',2);
insert into tpurcd values ('c006',DATE '2002-02-16','p004',1);
insert into tpurcd values ('c006',DATE '2002-02-16','p006',2);
insert into tpurcd values ('c006',DATE '2002-02-20','p004',4);
insert into tpurcd values ('c006',DATE '2002-02-20','p005',4);
insert into tpurcd values ('c006',DATE '2002-02-20','p007',5);
insert into tpurcd values ('c006',DATE '2002-02-20','p008',4);
--- tabtship, 1, 50
insert into tship values ('c001',DATE '2002-02-17',NULL,DATE '2002-02-18');
insert into tship values ('c002',DATE '2002-01-30',NULL,DATE '2002-01-31');
insert into tship values ('c002',DATE '2002-02-12',NULL,DATE '2002-02-13');
insert into tship values ('c003',DATE '2002-01-27',NULL,DATE '2002-01-28');
insert into tship values ('c003',DATE '2002-02-02',NULL,DATE '2002-02-03');
insert into tship values ('c003',DATE '2002-02-04',NULL,DATE '2002-02-05');
insert into tship values ('c003',DATE '2002-02-10',NULL,DATE '2002-02-11');
insert into tship values ('c003',DATE '2002-02-11','Continuation Cresent',DATE '2002-02-12');
insert into tship values ('c003',DATE '2002-02-12',NULL,DATE '2002-02-13');
insert into tship values ('c003',DATE '2002-02-17',NULL,DATE '2002-02-18');
insert into tship values ('c005',DATE '2002-02-06','Diminution Drive',DATE '2002-02-07');
insert into tship values ('c005',DATE '2002-02-09',NULL,DATE '2002-02-10');
insert into tship values ('c005',DATE '2002-02-12',NULL,DATE '2002-02-13');
insert into tship values ('c005',DATE '2002-02-15','Diminution Drive',DATE '2002-02-16');
insert into tship values ('c006',DATE '2002-01-26',NULL,DATE '2002-01-27');
insert into tship values ('c006',DATE '2002-02-08',NULL,DATE '2002-02-09');
insert into tship values ('c006',DATE '2002-02-16',NULL,DATE '2002-02-17');
--- tabtshipd, 1, 50
insert into tshipd values ('c001',DATE '2002-02-17',DATE '2002-02-18','p004',1);
insert into tshipd values ('c001',DATE '2002-02-17',DATE '2002-02-18','p005',5);
insert into tshipd values ('c001',DATE '2002-02-17',DATE '2002-02-18','p006',5);
insert into tshipd values ('c001',DATE '2002-02-17',DATE '2002-02-18','p007',5);
insert into tshipd values ('c001',DATE '2002-02-17',DATE '2002-02-18','p010',4);
insert into tshipd values ('c002',DATE '2002-01-30',DATE '2002-01-31','p008',5);
insert into tshipd values ('c002',DATE '2002-02-12',DATE '2002-02-13','p001',5);
insert into tshipd values ('c002',DATE '2002-02-12',DATE '2002-02-13','p003',4);
insert into tshipd values ('c002',DATE '2002-02-12',DATE '2002-02-13','p005',3);
insert into tshipd values ('c002',DATE '2002-02-12',DATE '2002-02-13','p008',3);
insert into tshipd values ('c003',DATE '2002-01-27',DATE '2002-01-28','p005',3);
insert into tshipd values ('c003',DATE '2002-01-27',DATE '2002-01-28','p007',1);
insert into tshipd values ('c003',DATE '2002-02-02',DATE '2002-02-03','p006',1);
insert into tshipd values ('c003',DATE '2002-02-02',DATE '2002-02-03','p007',1);
insert into tshipd values ('c003',DATE '2002-02-02',DATE '2002-02-03','p008',3);
insert into tshipd values ('c003',DATE '2002-02-02',DATE '2002-02-03','p010',4);
insert into tshipd values ('c003',DATE '2002-02-04',DATE '2002-02-05','p003',3);
insert into tshipd values ('c003',DATE '2002-02-04',DATE '2002-02-05','p005',4);
insert into tshipd values ('c003',DATE '2002-02-10',DATE '2002-02-11','p001',5);
insert into tshipd values ('c003',DATE '2002-02-10',DATE '2002-02-11','p006',1);
insert into tshipd values ('c003',DATE '2002-02-11',DATE '2002-02-12','p004',5);
insert into tshipd values ('c003',DATE '2002-02-11',DATE '2002-02-12','p006',5);
insert into tshipd values ('c003',DATE '2002-02-11',DATE '2002-02-12','p008',4);
insert into tshipd values ('c003',DATE '2002-02-17',DATE '2002-02-18','p001',5);
insert into tshipd values ('c003',DATE '2002-02-17',DATE '2002-02-18','p003',4);
insert into tshipd values ('c003',DATE '2002-02-17',DATE '2002-02-18','p004',3);
insert into tshipd values ('c003',DATE '2002-02-17',DATE '2002-02-18','p005',3);
insert into tshipd values ('c003',DATE '2002-02-17',DATE '2002-02-18','p008',5);
insert into tshipd values ('c005',DATE '2002-02-06',DATE '2002-02-07','p004',5);
insert into tshipd values ('c005',DATE '2002-02-06',DATE '2002-02-07','p008',5);
insert into tshipd values ('c005',DATE '2002-02-06',DATE '2002-02-07','p010',4);
insert into tshipd values ('c005',DATE '2002-02-09',DATE '2002-02-10','p004',1);
insert into tshipd values ('c005',DATE '2002-02-09',DATE '2002-02-10','p006',5);
insert into tshipd values ('c005',DATE '2002-02-09',DATE '2002-02-10','p007',2);
insert into tshipd values ('c005',DATE '2002-02-12',DATE '2002-02-13','p001',1);
insert into tshipd values ('c005',DATE '2002-02-12',DATE '2002-02-13','p008',5);
insert into tshipd values ('c006',DATE '2002-01-26',DATE '2002-01-27','p005',1);
insert into tshipd values ('c006',DATE '2002-01-26',DATE '2002-01-27','p008',2);
insert into tshipd values ('c006',DATE '2002-01-26',DATE '2002-01-27','p010',15);
insert into tshipd values ('c006',DATE '2002-02-08',DATE '2002-02-09','p003',5);
insert into tshipd values ('c006',DATE '2002-02-08',DATE '2002-02-09','p005',2);
insert into tshipd values ('c006',DATE '2002-02-16',DATE '2002-02-17','p004',1);
insert into tshipd values ('c006',DATE '2002-02-16',DATE '2002-02-17','p006',2);
--- tabtretn, 1, 50
insert into tretn values ('c006',DATE '2002-01-28','p008',1,'Took off all the handles and the things that held the candles.');
insert into tretn values ('c002',DATE '2002-02-01','p008',5,'Badly contaminated.');
insert into tretn values ('c002',DATE '2002-02-01','p009',1,'The wrong shade of magnolia.');
insert into tretn values ('c006',DATE '2002-02-10','p009',5,'Sub-space phase adjustment coil burnt out.');
insert into tretn values ('c005',DATE '2002-02-15','p001',1,'Reminiscent of spouse.');
--- tabtstck, 1, 50
insert into tstck values (DATE '2002-01-10','p001',40);
insert into tstck values (DATE '2002-01-10','p002',40);
insert into tstck values (DATE '2002-01-10','p003',40);
insert into tstck values (DATE '2002-01-10','p004',40);
insert into tstck values (DATE '2002-01-10','p005',40);
insert into tstck values (DATE '2002-01-10','p006',40);
insert into tstck values (DATE '2002-01-10','p007',40);
insert into tstck values (DATE '2002-01-10','p008',40);
insert into tstck values (DATE '2002-01-10','p009',40);
insert into tstck values (DATE '2002-01-10','p010',40);
insert into tstck values (DATE '2002-02-02','p010',25);
insert into tstck values (DATE '2002-02-02','p007',39);
insert into tstck values (DATE '2002-02-02','p005',30);
insert into tstck values (DATE '2002-02-02','p002',38);
insert into tstck values (DATE '2002-02-03','p002',40);
