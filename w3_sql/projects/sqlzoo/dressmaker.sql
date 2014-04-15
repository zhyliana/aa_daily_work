--- createdress, 1, 50
drop table construction;
drop table dressmaker;
drop table order_line;
drop table dress_order;
drop table quantities;
drop table material;
drop table garment;
drop table jmcust;

CREATE TABLE jmcust (
  c_no		INTEGER	PRIMARY KEY
 ,c_name	CHAR(20)	NOT NULL
 ,c_house_no	INTEGER	NOT NULL
 ,c_post_code	CHAR(9)	NOT NULL
 );

CREATE TABLE garment (
  style_no	INTEGER	PRIMARY KEY
 ,description	CHAR(20)	NOT NULL
 ,labour_cost	REAL		NOT NULL
 ,notions	CHAR(50)
 );

CREATE TABLE material (
  material_no	INTEGER	PRIMARY KEY
 ,fabric	CHAR(20)	NOT NULL
 ,colour	CHAR(20)	NOT NULL
 ,pattern	CHAR(20)	NOT NULL
 ,cost		REAL		NOT NULL
 );

CREATE TABLE quantities (
  style_q	INTEGER NOT NULL REFERENCES garment
 ,size_q	INTEGER	NOT NULL
 ,quantity	REAL		NOT NULL
 ,PRIMARY KEY ( style_q, size_q )
	);

CREATE TABLE dress_order (
  order_no	INTEGER	PRIMARY KEY
 ,cust_no	INTEGER REFERENCES jmcust
 ,order_date	DATE NOT NULL 
 ,completed	CHAR(1)
 );

CREATE TABLE order_line (
  order_ref	INTEGER	NOT NULL REFERENCES dress_order
 ,line_no	INTEGER	NOT NULL
 ,ol_style	INTEGER	REFERENCES garment
 ,ol_size	INTEGER	NOT NULL
 ,ol_material	INTEGER	REFERENCES material
 ,PRIMARY KEY (order_ref, line_no)
 ,FOREIGN KEY (ol_style, ol_size) REFERENCES quantities
 );

CREATE TABLE dressmaker (
  d_no		INTEGER	PRIMARY KEY
 ,d_name	CHAR(20)	NOT NULL
 ,d_house_no	INTEGER	NOT NULL
 ,d_post_code	CHAR(8)	NOT NULL
 );

CREATE TABLE construction (
  maker		INTEGER	NOT NULL REFERENCES dressmaker
 ,order_ref	INTEGER	NOT NULL REFERENCES dress_order
 ,line_ref	INTEGER	NOT NULL
 ,start_date DATE NOT NULL 
 ,finish_date DATE 
 ,PRIMARY KEY ( maker, order_ref, line_ref )
 ,FOREIGN KEY ( order_ref, line_ref ) REFERENCES order_line
 );
GRANT SELECT ON construction TO PUBLIC;
GRANT SELECT ON dressmaker TO PUBLIC;
GRANT SELECT ON order_line TO PUBLIC;
GRANT SELECT ON dress_order TO PUBLIC;
GRANT SELECT ON quantities TO PUBLIC;
GRANT SELECT ON material TO PUBLIC;
GRANT SELECT ON garment TO PUBLIC;
GRANT SELECT ON jmcust TO PUBLIC;

--- tabjmcust, 1, 50
insert into jmcust values (  1,'Ms Black',12,'A21 4XY ');
insert into jmcust values (  2,'Ms Brown',24,'B2 5AB  ');
insert into jmcust values (  3,'Ms Gray',78,'CD31 4GH ');
insert into jmcust values (  4,'Ms White',25,'E24 8PQ ');
insert into jmcust values (  5,'Mr Brass',34,'FG24 9NM ');
insert into jmcust values (  6,'Ms Muir',31,'H2 7CV ');
insert into jmcust values (  7,'Dr Green',3,'SJ4 4WE ');
insert into jmcust values (  8,'Mrs Peacock',100,'DD6 9NM ');
--- tabgarment, 1, 50
insert into garment values (  1,'Trousers',18.00,'Zip/2 off 1.5cm buttons/ hem tape/ waist band  ');
insert into garment values (  2,'Long Skirt',15.00,'Zip/ 1 off button 3cm/ hemtape ');
insert into garment values (  3,'Shorts',10.00,'Zip/ Clip ');
insert into garment values (  4,'Short Skirt',14.25,'1 off 2cm button ');
insert into garment values (  5,'Sundress',20.00 ,NULL);
insert into garment values (  6,'Suntop',6.50 ,NULL);
--- tabmaterial, 1, 50
insert into material values (  1,'Silk','Black','Plain',7.00 );
insert into material values (  2,'Silk','Red Abstract','Printed',10.00 );
insert into material values (  3,'Cotton','Yellow Stripe','Woven',3.00 );
insert into material values (  4,'Cotton','Green Stripe','Woven',3.00 );
insert into material values (  5,'Cotton','Black Dotted','Woven',3.00 );
insert into material values (  6,'Cotton','Red Stripe','Woven',3.00 );
insert into material values (  7,'Polyester','Pale Yellow','Printed',2.55 );
insert into material values (  8,'Cotton','Blue Stripe','Woven',3.00 );
insert into material values (  9,'Cotton','Pink Check','Woven',3.00 );
insert into material values (  10,'Silk','Green Abstract','Printed',15.00 );
insert into material values (  11,'Rayon','Red/Orange','Printed',4.00 );
insert into material values (  12,'Serge','Navy Blue','Woven',5.50 );
insert into material values (  13,'Cotton','Blue Abstract','Printed',3.50 );
insert into material values (  14,'Cotton','Green Abstract','Printed',3.50 );
--- tabquantities, 1, 50
insert into quantities values (  1,8,2.7 );
insert into quantities values (  1,10,2.7 );
insert into quantities values (  1,12,2.8 );
insert into quantities values (  1,14,2.8 );
insert into quantities values (  1,16,3.0 );
insert into quantities values (  1,18,3.0 );
insert into quantities values (  2,8,3.4 );
insert into quantities values (  2,10,3.4 );
insert into quantities values (  2,12,3.8 );
insert into quantities values (  2,14,3.8 );
insert into quantities values (  2,16,4.2 );
insert into quantities values (  2,18,4.5 );
insert into quantities values (  3,8,1.3 );
insert into quantities values (  3,10,1.3 );
insert into quantities values (  3,12,1.3 );
insert into quantities values (  3,14,1.5 );
insert into quantities values (  3,16,1.6 );
insert into quantities values (  3,18,1.8 );
insert into quantities values (  4,8,1.2 );
insert into quantities values (  4,10,1.2 );
insert into quantities values (  4,12,1.2 );
insert into quantities values (  4,14,1.4 );
insert into quantities values (  4,16,1.5 );
insert into quantities values (  4,18,1.9 );
insert into quantities values (  5,8,3.2 );
insert into quantities values (  5,10,3.2 );
insert into quantities values (  5,12,3.2 );
insert into quantities values (  5,14,3.4 );
insert into quantities values (  5,16,5.2 );
insert into quantities values (  5,18,5.2);
insert into quantities values (  6,8,1.0 );
insert into quantities values (  6,10,1.0 );
insert into quantities values (  6,12,1.0 );
insert into quantities values (  6,14,1.5 );
insert into quantities values (  6,16,1.5 );
insert into quantities values (  6,18,1.8 );
--- tabdress_order, 1, 50
insert into dress_order values (  1,8,DATE '2002-01-10','Y');
insert into dress_order values (  2,7,DATE '2002-01-11','Y');
insert into dress_order values (  3,6,DATE '2002-01-20','Y');
insert into dress_order values (  4,5,DATE '2002-02-02','Y');
insert into dress_order values (  5,4,DATE '2002-02-03','Y');
insert into dress_order values (  6,3,DATE '2002-02-20','N');
insert into dress_order values (  7,2,DATE '2002-02-21','N');
insert into dress_order values (  8,1,DATE '2002-02-27','N');
insert into dress_order values (  9,2,DATE '2002-02-27','N');
insert into dress_order values (  10,3,DATE '2002-02-28','N');
insert into dress_order values (  11,4,DATE '2002-03-01','N');
insert into dress_order values (  12,5,DATE '2002-03-03','N');
--- taborder_line, 1, 50
insert into order_line values (  1,1,1,8,1);
insert into order_line values (  1,2,2,8,2);
insert into order_line values (  2,1,3,10,3);
insert into order_line values (  2,2,4,10,4);
insert into order_line values (  2,3,5,10,5);
insert into order_line values (  3,1,6,12,6);
insert into order_line values (  4,1,1,14,7);
insert into order_line values (  4,2,2,14,10);
insert into order_line values (  5,1,3,16,9);
insert into order_line values (  5,2,4,16,10);
insert into order_line values (  5,3,5,16,11);
insert into order_line values (  6,1,1,8,12);
insert into order_line values (  6,2,2,8,13);
insert into order_line values (  6,3,3,8,14);
insert into order_line values (  7,1,4,10,1);
insert into order_line values (  7,2,5,10,2);
insert into order_line values (  7,3,6,10,3);
insert into order_line values (  8,1,6,12,4);
insert into order_line values (  8,2,5,12,5);
insert into order_line values (  8,3,4,12,6);
insert into order_line values (  9,1,3,14,7);
insert into order_line values (  10,1,2,16,8 );
insert into order_line values (  10,2,1,16,9 );
insert into order_line values (  11,1,1,18,10);
insert into order_line values (  11,2,2,18,11);
insert into order_line values (  11,3,3,18,12);
insert into order_line values (  12,1,4,8,13);
insert into order_line values (  12,2,5,8,14);
insert into order_line values (  12,3,6,8,1);
insert into order_line values (  12,4,1,8,2);
insert into order_line values (  12,5,2,8,3);
--- tabdressmaker, 1, 50
insert into dressmaker values (  1,'Mrs Hem',2,'A12 6BC');
insert into dressmaker values (  2,'Miss Stitch',4,'DF4 7HJ');
insert into dressmaker values (  3,'Mr Needles',56,'E12 6LG');
insert into dressmaker values (  4,'Ms Sew',27,'EF7 9KL');
insert into dressmaker values (  5,'Mr Seam',31,'H45 7YH');
insert into dressmaker values (  6,'Mr Taylor',3,'SH6 9RT');
insert into dressmaker values (  7,'Miss Pins',7,'B4 9BL');
--- tabconstruction, 1, 50
insert into construction values (  1,1,1,DATE '2002-01-10',DATE '2002-03-05');
insert into construction values (  2,1,2,DATE '2002-01-10',DATE '2002-03-15');
insert into construction values (  3,2,1,DATE '2002-01-11',DATE '2002-03-05');
insert into construction values (  4,2,2,DATE '2002-01-11',DATE '2002-03-25');
insert into construction values (  5,2,3,DATE '2002-01-11',DATE '2002-03-05');
insert into construction values (  6,3,1,DATE '2002-01-20',DATE '2002-03-25');
insert into construction values (  7,4,1,DATE '2002-02-02',DATE '2002-03-05');
insert into construction values (  1,4,2,DATE '2002-02-02',DATE '2002-03-25');
insert into construction values (  2,5,1,DATE '2002-02-03',DATE '2002-03-15');
insert into construction values (  3,5,2,DATE '2002-02-03',DATE '2002-03-25');
insert into construction values (  4,5,3,DATE '2002-02-03',DATE '2002-03-27');
insert into construction values (  5,6,1,DATE '2002-02-20',NULL);
insert into construction values (  6,6,2,DATE '2002-02-20',DATE '2002-03-28');
insert into construction values (  7,6,3,DATE '2002-02-20',NULL);
insert into construction values (  1,7,1,DATE '2002-02-21',NULL);
insert into construction values (  2,7,2,DATE '2002-02-21',NULL);
insert into construction values (  3,7,3,DATE '2002-02-21',DATE '2002-03-28');
insert into construction values (  4,8,1,DATE '2002-02-27',DATE '2002-03-03');
insert into construction values (  5,8,2,DATE '2002-02-27',NULL);
insert into construction values (  6,8,3,DATE '2002-02-27',NULL);
insert into construction values (  7,9,1,DATE '2002-02-27',NULL);
insert into construction values (  1,10,1,DATE '2002-02-28',NULL);
insert into construction values (  2,10,2,DATE '2002-03-28',NULL );
insert into construction values (  3,11,1,DATE '2002-03-01',DATE '2002-03-04');
insert into construction values (  4,11,2,DATE '2002-03-01',NULL);
insert into construction values (  5,11,3,DATE '2002-03-01',NULL);
insert into construction values (  7,12,2,DATE '2002-03-03',NULL);
insert into construction values (  1,12,3,DATE '2002-03-03',NULL);
insert into construction values (  2,12,4,DATE '2002-03-03',NULL);
insert into construction values (  2,12,5,DATE '2002-03-03',NULL);
