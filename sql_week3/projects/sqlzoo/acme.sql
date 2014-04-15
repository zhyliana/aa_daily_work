--- createacme, 1, 50
DROP TABLE shipped;
DROP TABLE receipt;
DROP TABLE product;
DROP TABLE badguy;
CREATE TABLE badguy (
  id CHAR(4) NOT NULL
 ,name VARCHAR(35)
 ,address VARCHAR(100)
 ,PRIMARY KEY (id));
CREATE TABLE product (
  id CHAR(4) NOT NULL
 ,description VARCHAR(40)
 ,price DECIMAL(10,2)		
 ,PRIMARY KEY (id)
  );
CREATE TABLE receipt (
 badguy CHAR(4) NOT NULL
 , rdate DATE NOT NULL		
 , notes VARCHAR(20)
 , amount DECIMAL(10,2)		
 ,PRIMARY KEY (badguy, rdate)
 ,FOREIGN KEY rb (badguy) REFERENCES badguy(id)
 );
CREATE TABLE shipped (badguy CHAR(4) NOT NULL
 ,sdate DATE NOT NULL		
 ,product CHAR(4) NOT NULL
 ,quantity INTEGER
 ,PRIMARY KEY (badguy, sdate, product)
 ,FOREIGN KEY sb (badguy) REFERENCES badguy(id)
 );
CREATE INDEX shippedproduct ON shipped(product);
GRANT ALL ON badguy TO andrew;
GRANT ALL ON receipt TO andrew;
GRANT ALL ON product TO andrew;
GRANT ALL ON shipped TO andrew;
GRANT SELECT ON badguy TO PUBLIC;
GRANT SELECT ON receipt TO PUBLIC;
GRANT SELECT ON product TO PUBLIC;
GRANT SELECT ON shipped TO PUBLIC;

--- tabbadguy, 1, 50
insert into badguy values ('C001','Wile E Coyote','http://www.geocities.com/EnchantedForest/1141/');
insert into badguy values ('C002','Sylvester','http://www.eden.rutgers.edu/~crburke/syl.html');
insert into badguy values ('C003','Tom','http://www.geocities.com/Hollywood/6859/tj.html');
insert into badguy values ('C004','Elmer Fudd','http://www.cyberstudio.com/deepthoughts/deepfud.html');
insert into badguy values ('C005','Dick Dastardly','http://www.dfcom.freeserve.co.uk/hbw/wacky/00.htm');
--- tabproduct, 1, 50
insert into product values ('P001','Anvil',75.00);
insert into product values ('P002','Portable holes',5.00);
insert into product values ('P003','Horseshoe magnet',80.00);
insert into product values ('P004','TNT',50.00);
insert into product values ('P005','Petard',50.00);
insert into product values ('P006','Elastic band',2.00);
insert into product values ('P007','Rocket roller skates',80.00);
insert into product values ('P008','Space ship',60000000.00);
insert into product values ('P009','Road sign "Diversion Left"',30.00);
insert into product values ('P010','Road sign "Diversion Right"',30.00);
--- tabshipped, 1, 50
insert into shipped values ('C001',DATE '1998-07-10','P003',1);
insert into shipped values ('C001',DATE '1998-07-22','P004',2);
insert into shipped values ('C001',DATE '1998-07-22','P005',12);
insert into shipped values ('C001',DATE '1998-07-23','P005',12);
insert into shipped values ('C001',DATE '1998-07-23','P006',1);
insert into shipped values ('C001',DATE '1998-07-23','P007',1);
insert into shipped values ('C005',DATE '1998-01-01','P008',1);
--- tabreceipt, 1, 50
insert into receipt values ('C001',DATE '1998-07-15','Cheque',80.00);
insert into receipt values ('C001',DATE '1998-07-23','Cash',700.00);
insert into receipt values ('C005',DATE '1998-02-10','DD',5.00);
insert into receipt values ('C005',DATE '1998-03-10','DD',5.00);
insert into receipt values ('C005',DATE '1998-04-10','DD',5.00);
insert into receipt values ('C005',DATE '1998-05-10','DD',5.00);
insert into receipt values ('C005',DATE '1998-06-10','DD',5.00);
insert into receipt values ('C005',DATE '1998-07-10','DD',5.00);
