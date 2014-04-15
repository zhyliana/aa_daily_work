--- createcc, 1, 50
DROP TABLE permit;
DROP TABLE image;
DROP TABLE vehicle;
DROP TABLE keeper;
DROP TABLE camera;

CREATE TABLE camera(
   id INTEGER NOT NULL PRIMARY KEY
  ,perim VARCHAR(3)
);

CREATE TABLE keeper(
   id INTEGER NOT NULL PRIMARY KEY
  ,name VARCHAR(20)
  ,address VARCHAR(25)
);

CREATE TABLE vehicle(
   id VARCHAR(10) NOT NULL PRIMARY KEY
  ,keeper INTEGER
  ,FOREIGN KEY(keeper) REFERENCES keeper(id)
);

CREATE TABLE image( 
   camera INTEGER NOT NULL

 ,whn DATETIME NOT NULL
  
  ,reg VARCHAR(10)
  ,PRIMARY KEY (camera,whn)
  ,FOREIGN KEY (camera) REFERENCES camera(id)
  ,FOREIGN KEY (reg) REFERENCES vehicle(id)
);

CREATE TABLE permit(
   reg VARCHAR(10) NOT NULL
 ,sDate DATETIME NOT NULL
  ,chargeType VARCHAR(10)
  ,PRIMARY KEY (reg,sDate)
  ,FOREIGN KEY (reg) REFERENCES vehicle(id)
);

GRANT SELECT ON camera TO PUBLIC;
GRANT SELECT ON keeper TO PUBLIC;
GRANT SELECT ON vehicle TO PUBLIC;
GRANT SELECT ON image TO PUBLIC;
GRANT SELECT ON permit TO PUBLIC;

--- tabcamera, 1, 50
insert into camera values (1,'IN');
insert into camera values (2,'IN');
insert into camera values (3,'IN');
insert into camera values (4,'IN');
insert into camera values (5,'IN');
insert into camera values (6,'IN');
insert into camera values (7,'IN');
insert into camera values (8,'IN');
insert into camera values (9,'OUT');
insert into camera values (10,'OUT');
insert into camera values (11,'OUT');
insert into camera values (12,'OUT');
insert into camera values (13,'OUT');
insert into camera values (14,'OUT');
insert into camera values (15,'OUT');
insert into camera values (16,'OUT');
insert into camera values (17,NULL);
insert into camera values (18,NULL);
insert into camera values (19,NULL);
--- tabkeeper, 1, 50
insert into keeper values (1,'Ambiguous, Arthur','Absorption Ave.');
insert into keeper values (2,'Inconspicuous, Iain','Interception Rd.');
insert into keeper values (3,'Contiguous, Carol','Circumscription Close');
insert into keeper values (4,'Strenuous, Sam','Surjection Street');
insert into keeper values (5,'Assiduous, Annie','Attribution Alley');
insert into keeper values (6,'Incongruous, Ingrid','Irresolution Pl.');
--- tabvehicle, 1, 50
insert into vehicle values ('SO 02 ASP',1);
insert into vehicle values ('SO 02 BSP',3);
insert into vehicle values ('SO 02 CSP',1);
insert into vehicle values ('SO 02 DSP',4);
insert into vehicle values ('SO 02 ESP',1);
insert into vehicle values ('SO 02 FSP',3);
insert into vehicle values ('SO 02 GSP',6);
insert into vehicle values ('SO 02 HSP',5);
insert into vehicle values ('SO 02 ISP',6);
insert into vehicle values ('SO 02 JSP',2);
insert into vehicle values ('SO 02 KSP',5);
insert into vehicle values ('SO 02 LSP',2);
insert into vehicle values ('SO 02 MSP',2);
insert into vehicle values ('SO 02 NSP',4);
insert into vehicle values ('SO 02 OSP',6);
insert into vehicle values ('SO 02 PSP',4);
insert into vehicle values ('SO 02 QSP',6);
insert into vehicle values ('SO 02 RSP',1);
insert into vehicle values ('SO 02 SSP',2);
insert into vehicle values ('SO 02 TSP',6);
insert into vehicle values ('SO 02 ATP',1);
insert into vehicle values ('SO 02 BTP',2);
insert into vehicle values ('SO 02 CTP',1);
insert into vehicle values ('SO 02 DTP',3);
insert into vehicle values ('SO 02 ETP',5);
insert into vehicle values ('SO 02 FTP',4);
insert into vehicle values ('SO 02 GTP',5);
insert into vehicle values ('SO 02 HTP',2);
insert into vehicle values ('SO 02 ITP',2);
insert into vehicle values ('SO 02 JTP',4);
insert into vehicle values ('SO 02 KTP',3);
insert into vehicle values ('SO 02 MUP',NULL);
insert into vehicle values ('SO 02 NUP',NULL);
insert into vehicle values ('SO 02 OUP',NULL);
insert into vehicle values ('SO 02 PUP',NULL);
insert into vehicle values ('SO 02 QUP',NULL);
--- tabpermit, 1, 50
insert into permit values ('SO 02 ASP',DATE '2006-01-21','Weekly');
insert into permit values ('SO 02 BSP',DATE '2006-01-30','Weekly');
insert into permit values ('SO 02 CSP',DATE '2007-01-21','Weekly');
insert into permit values ('SO 02 DSP',DATE '2007-01-30','Weekly');
insert into permit values ('SO 02 ESP',DATE '2007-02-21','Weekly');
insert into permit values ('SO 02 FSP',DATE '2007-02-25','Weekly');
insert into permit values ('SO 02 GSP',DATE '2007-02-28','Weekly');
insert into permit values ('SO 02 HSP',DATE '2006-01-21','Monthly');
insert into permit values ('SO 02 ISP',DATE '2006-01-30','Monthly');
insert into permit values ('SO 02 JSP',DATE '2007-01-21','Monthly');
insert into permit values ('SO 02 KSP',DATE '2007-01-30','Monthly');
insert into permit values ('SO 02 LSP',DATE '2007-02-21','Monthly');
insert into permit values ('SO 02 MSP',DATE '2007-02-25','Monthly');
insert into permit values ('SO 02 NSP',DATE '2007-02-28','Monthly');
insert into permit values ('SO 02 OSP',DATE '2006-01-21','Monthly');
insert into permit values ('SO 02 PSP',DATE '2006-01-30','Monthly');
insert into permit values ('SO 02 QSP',DATE '2007-01-21','Annual');
insert into permit values ('SO 02 RSP',DATE '2007-01-30','Annual');
insert into permit values ('SO 02 SSP',DATE '2007-02-21','Annual');
insert into permit values ('SO 02 TSP',DATE '2007-02-25','Annual');
insert into permit values ('SO 02 ATP',DATE '2007-01-21','Daily');
insert into permit values ('SO 02 BTP',DATE '2006-01-30','Daily');
insert into permit values ('SO 02 CTP',DATE '2007-01-21','Daily');
insert into permit values ('SO 02 DTP',DATE '2007-01-30','Daily');
insert into permit values ('SO 02 ETP',DATE '2007-02-21','Daily');
insert into permit values ('SO 02 FTP',DATE '2007-02-25','Daily');
insert into permit values ('SO 02 GTP',DATE '2007-02-28','Daily');
insert into permit values ('SO 02 HTP',DATE '2006-01-21','Daily');
insert into permit values ('SO 02 ITP',DATE '2006-01-30','Daily');
insert into permit values ('SO 02 JTP',DATE '2007-01-21','Daily');
insert into permit values ('SO 02 KTP',DATE '2007-01-30','Daily');
insert into permit values ('SO 02 ATP',DATE '2007-01-22','Daily');
insert into permit values ('SO 02 BTP',DATE '2006-01-31','Daily');
insert into permit values ('SO 02 CTP',DATE '2007-01-22','Daily');
insert into permit values ('SO 02 DTP',DATE '2007-01-31','Daily');
insert into permit values ('SO 02 ETP',DATE '2007-02-22','Daily');
insert into permit values ('SO 02 FTP',DATE '2007-02-26','Daily');
insert into permit values ('SO 02 GTP',DATE '2007-03-01','Daily');
insert into permit values ('SO 02 HTP',DATE '2006-01-22','Daily');
insert into permit values ('SO 02 ITP',DATE '2006-01-31','Daily');
insert into permit values ('SO 02 JTP',DATE '2007-01-22','Daily');
insert into permit values ('SO 02 KTP',DATE '2007-01-31','Daily');
insert into permit values ('SO 02 BTP',DATE '2007-02-03','Daily');
insert into permit values ('SO 02 BTP',DATE '2007-02-04','Daily');
insert into permit values ('SO 02 BTP',DATE '2007-02-05','Daily');
insert into permit values ('SO 02 BTP',DATE '2007-02-06','Daily');
insert into permit values ('SO 02 BTP',DATE '2007-02-07','Daily');
--- tabimage, 1, 50
insert into image values (1,TIMESTAMP '2007-02-25 06:10:13.00','SO 02 ASP');
insert into image values (17,TIMESTAMP '2007-02-25 06:20:01.00','SO 02 ASP');
insert into image values (18,TIMESTAMP '2007-02-25 06:23:40.00','SO 02 ASP');
insert into image values (9,TIMESTAMP '2007-02-25 06:26:04.00','SO 02 ASP');
insert into image values (17,TIMESTAMP '2007-02-25 06:57:31.00','SO 02 CSP');
insert into image values (17,TIMESTAMP '2007-02-25 07:00:40.00','SO 02 CSP');
insert into image values (12,TIMESTAMP '2007-02-25 07:04:31.00','SO 02 CSP');
insert into image values (5,TIMESTAMP '2007-02-25 07:10:00.00','SO 02 GSP');
insert into image values (16,TIMESTAMP '2007-02-25 07:13:00.00','SO 02 GSP');
insert into image values (2,TIMESTAMP '2007-02-25 07:20:01.00','SO 02 TSP');
insert into image values (19,TIMESTAMP '2007-02-25 07:23:00.00','SO 02 TSP');
insert into image values (19,TIMESTAMP '2007-02-25 07:26:31.00','SO 02 TSP');
insert into image values (19,TIMESTAMP '2007-02-25 07:29:00.00','SO 02 TSP');
insert into image values (8,TIMESTAMP '2007-02-25 07:35:41.00','SO 02 CSP');
insert into image values (18,TIMESTAMP '2007-02-25 07:39:04.00','SO 02 CSP');
insert into image values (18,TIMESTAMP '2007-02-25 07:42:30.00','SO 02 CSP');
insert into image values (10,TIMESTAMP '2007-02-25 07:45:11.00','SO 02 CSP');
insert into image values (8,TIMESTAMP '2007-02-25 07:48:10.00','SO 02 CSP');
insert into image values (19,TIMESTAMP '2007-02-25 07:51:10.00','SO 02 CSP');
insert into image values (18,TIMESTAMP '2007-02-25 07:55:11.00','SO 02 CSP');
insert into image values (11,TIMESTAMP '2007-02-25 07:58:01.00','SO 02 CSP');
insert into image values (18,TIMESTAMP '2007-02-25 16:28:40.00','SO 02 SSP');
insert into image values (9,TIMESTAMP '2007-02-25 16:31:01.00','SO 02 SSP');
insert into image values (18,TIMESTAMP '2007-02-25 16:38:31.00','SO 02 RSP');
insert into image values (9,TIMESTAMP '2007-02-25 16:39:10.00','SO 02 RSP');
insert into image values (9,TIMESTAMP '2007-02-25 16:45:04.00','SO 02 HSP');
insert into image values (9,TIMESTAMP '2007-02-25 16:48:11.00','SO 02 HSP');
insert into image values (9,TIMESTAMP '2007-02-25 16:51:30.00','SO 02 HSP');
insert into image values (9,TIMESTAMP '2007-02-25 16:58:01.00','SO 02 ISP');
insert into image values (12,TIMESTAMP '2007-02-25 17:01:13.00','SO 02 ISP');
insert into image values (3,TIMESTAMP '2007-02-25 17:07:00.00','SO 02 JSP');
insert into image values (18,TIMESTAMP '2007-02-25 17:10:43.00','SO 02 JSP');
insert into image values (19,TIMESTAMP '2007-02-25 17:14:11.00','SO 02 JSP');
insert into image values (3,TIMESTAMP '2007-02-25 17:17:03.00','SO 02 JSP');
insert into image values (10,TIMESTAMP '2007-02-25 18:23:11.00','SO 02 MUP');
insert into image values (11,TIMESTAMP '2007-02-25 18:26:13.00','SO 02 NUP');
insert into image values (12,TIMESTAMP '2007-02-25 18:29:01.00','SO 02 OUP');
insert into image values (3,TIMESTAMP '2007-02-25 18:33:10.00','SO 02 PUP');
insert into image values (15,TIMESTAMP '2007-02-25 18:36:31.00','SO 02 PUP');
insert into image values (3,TIMESTAMP '2007-02-25 18:39:10.00','SO 02 PUP');
insert into image values (10,TIMESTAMP '2007-02-26 05:13:30.00','SO 02 TSP');
insert into image values (18,TIMESTAMP '2007-02-25 16:29:11.00','SO 02 DSP');
insert into image values (19,TIMESTAMP '2007-02-25 16:31:01.00','SO 02 DSP');
insert into image values (19,TIMESTAMP '2007-02-25 17:42:41.00','SO 02 DSP');
insert into image values (9,TIMESTAMP '2007-02-25 18:54:30.00','SO 02 DSP');
insert into image values (3,TIMESTAMP '2007-02-25 17:16:11.00','SO 02 ESP');
insert into image values (10,TIMESTAMP '2007-02-25 18:08:40.00','SO 02 ESP');
insert into image values (11,TIMESTAMP '2007-02-25 18:08:00.00','SO 02 FSP');
insert into image values (12,TIMESTAMP '2007-02-25 18:08:13.00','SO 02 GSP');
