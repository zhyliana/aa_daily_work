--- createholy, 1, 50
DROP TABLE msp;
DROP TABLE party;

CREATE TABLE party (code VARCHAR(10) NOT NULL
                    ,name VARCHAR(50)
		    ,leader VARCHAR(50)
		    ,PRIMARY KEY (code)
		    );
CREATE TABLE msp (name VARCHAR(50) NOT NULL
                  ,party VARCHAR(10)
		  ,constituency VARCHAR(50)
                  ,PRIMARY KEY (name)
                  ,FOREIGN KEY (party) REFERENCES party(code)
                  );
GRANT ALL ON party TO andrew;
GRANT ALL ON msp TO andrew;
CREATE INDEX msp_party ON msp(party);
GRANT SELECT ON party TO PUBLIC;
GRANT SELECT ON msp TO PUBLIC;

--- tabparty, 1, 50
insert into party values ('Com','Communist',NULL);
insert into party values ('Con','Conservative','McLetchie MSP, David');
insert into party values ('Green','Green',NULL);
insert into party values ('Lab','Labour','Dewar MSP, Rt Hon Donald');
insert into party values ('LD','Liberal Democrat','Wallace QC MSP, Mr Jim');
insert into party values ('NLP','Natural Law Party',NULL);
insert into party values ('SNP','Scottish National Party','Salmond MSP, Mr Alex');
insert into party values ('SSP','Scottish Socialist Party',NULL);
insert into party values ('SWP','Socialist Workers Party',NULL);
--- tabmsp, 1, 50
insert into msp values ('Adam MSP, Brian','SNP','North East Scotland');
insert into msp values ('Aitken MSP, Bill','Con','Glasgow');
insert into msp values ('Alexander MSP, Ms Wendy','Lab','Paisley North');
insert into msp values ('Baillie MSP, Jackie','Lab','Dumbarton');
insert into msp values ('Barrie MSP, Scott','Lab','Dunfermline West');
insert into msp values ('Boyack MSP, Ms Sarah','Lab','Edinburgh Central');
insert into msp values ('Brankin MSP, Rhona','Lab','Midlothian');
insert into msp values ('Brown MSP, Robert','LD','Glasgow');
insert into msp values ('Campbell MSP, Colin','SNP','West of Scotland');
insert into msp values ('Canavan MSP, Dennis',NULL,'Falkirk West');
insert into msp values ('Chisholm MSP, Malcolm','Lab','Edinburgh North and Leith');
insert into msp values ('Craigie MSP, Cathie','Lab','Cumbernauld and Kilsyth');
insert into msp values ('Crawford JP MSP, Bruce','SNP','Mid-Scotland and Fife');
insert into msp values ('Cunningham MSP, Roseanna','SNP','Perth');
insert into msp values ('Curran MSP, Ms Margaret','Lab','Glasgow Baillieston');
insert into msp values ('Davidson MSP, Mr David','Con','North East Scotland');
insert into msp values ('Deacon MSP, Susan','Lab','Edinburgh East and Musselburgh');
insert into msp values ('Dewar MSP, Rt Hon Donald','Lab','Glasgow Anniesland');
insert into msp values ('Douglas-Hamilton QC MSP, Rt Hon Lord James','Con','Lothians');
insert into msp values ('Eadie MSP, Helen','Lab','Dunfermline East');
insert into msp values ('Elder MSP, Dorothy-Grace','SNP','Glasgow');
insert into msp values ('Ewing FRSA MSP, Dr Winnie','SNP','Highlands and Islands');
insert into msp values ('Ewing MSP, Fergus','SNP','Inverness East, Nairn and Lochaber');
insert into msp values ('Ewing MSP, Mrs Margaret','SNP','Moray');
insert into msp values ('Fabiani MSP, Linda','SNP','Central Scotland');
insert into msp values ('Ferguson MSP, Patricia','Lab','Glasgow Maryhill');
insert into msp values ('Fergusson MSP, Alex','Con','South of Scotland');
insert into msp values ('Finnie MSP, Ross','LD','West of Scotland');
insert into msp values ('Galbraith FRCSGlas MP MSP, Mr Sam','Lab','Strathkelvin and Bearsden');
insert into msp values ('Gallie MSP, Phil','Con','South of Scotland');
insert into msp values ('Gibson MSP, Mr Kenneth','SNP','Glasgow');
insert into msp values ('Gillon MSP, Karen','Lab','Clydesdale');
insert into msp values ('Godman MSP, Trish','Lab','West Renfrewshire');
insert into msp values ('Goldie MSP, Miss Annabel','Con','West of Scotland');
insert into msp values ('Gorrie OBE MSP, Donald','LD','Central Scotland');
insert into msp values ('Grahame MSP, Christine','SNP','South of Scotland');
insert into msp values ('Grant MSP, Rhoda','Lab','Highlands and Islands');
insert into msp values ('Gray MSP, Iain','Lab','Edinburgh Pentlands');
insert into msp values ('Hamilton MSP, Mr Duncan','SNP','Highlands and Islands');
insert into msp values ('Harding MSP, Mr Keith','Con','Mid-Scotland and Fife');
insert into msp values ('Harper MSP, Robin','Green','Lothians');
insert into msp values ('Henry MSP, Hugh','Lab','Paisley South');
insert into msp values ('Home Robertson MSP, Mr John','Lab','East Lothian');
insert into msp values ('Hughes MSP, Janis','Lab','Glasgow Rutherglen');
insert into msp values ('Hyslop MSP, Fiona','SNP','Lothians');
insert into msp values ('Ingram MSP, Mr Adam','SNP','South of Scotland');
insert into msp values ('Jackson MSP, Dr Sylvia','Lab','Stirling');
insert into msp values ('Jackson QC MSP, Gordon','Lab','Glasgow Govan');
insert into msp values ('Jamieson MSP, Cathy','Lab','Carrick, Cumnock and Doon Valley');
insert into msp values ('Jamieson MSP, Margaret','Lab','Kilmarnock and Loudoun');
--- tabmsp, 51, 50
insert into msp values ('Jenkins MSP, Ian','LD','Tweeddale, Ettrick and Lauderdale');
insert into msp values ('Johnston MSP, Mr Nick','Con','Mid-Scotland and Fife');
insert into msp values ('Johnstone MSP, Alex','Con','North East Scotland');
insert into msp values ('Kerr MSP, Mr Andy','Lab','East Kilbride');
insert into msp values ('Lamont MSP, Johann','Lab','Glasgow Pollok');
insert into msp values ('Livingstone MSP, Marilyn','Lab','Kirkcaldy');
insert into msp values ('Lochhead MSP, Richard','SNP','North East Scotland');
insert into msp values ('Lyon MSP, George','LD','Argyll and Bute');
insert into msp values ('MacAskill MSP, Mr Kenny','SNP','Lothians');
insert into msp values ('Macdonald MSP, Lewis','Lab','Aberdeen Central');
insert into msp values ('MacDonald MSP, Ms Margo','SNP','Lothians');
insert into msp values ('Macintosh MSP, Mr Kenneth','Lab','Eastwood');
insert into msp values ('MacKay MSP, Angus','Lab','Edinburgh South');
insert into msp values ('MacLean MSP, Kate','Lab','Dundee West');
insert into msp values ('Macmillan MSP, Maureen','Lab','Highlands and Islands');
insert into msp values ('Martin MSP, Paul','Lab','Glasgow Springburn');
insert into msp values ('Marwick MSP, Tricia','SNP','Mid-Scotland and Fife');
insert into msp values ('Matheson MSP, Mr Michael','SNP','Central Scotland');
insert into msp values ('McAllion MSP, Mr John','Lab','Dundee East');
insert into msp values ('McAveety MSP, Mr Frank','Lab','Glasgow Shettleston');
insert into msp values ('McCabe MSP, Mr Tom','Lab','Hamilton South');
insert into msp values ('McConnell MSP, Mr Jack','Lab','Motherwell and Wishaw');
insert into msp values ('McGrigor MSP, Mr Jamie','Con','Highlands and Islands');
insert into msp values ('McGugan MSP, Irene','SNP','North East Scotland');
insert into msp values ('McIntosh MSP, Mrs Lyndsay','Con','Central Scotland');
insert into msp values ('McLeish MSP, Henry','Lab','Central Fife');
insert into msp values ('McLeod MSP, Fiona','SNP','West of Scotland');
insert into msp values ('McLetchie MSP, David','Con','Lothians');
insert into msp values ('McMahon MSP, Mr Michael','Lab','Hamilton North and Bellshill');
insert into msp values ('McNeil MSP, Duncan','Lab','Greenock and Inverclyde');
insert into msp values ('McNeill MSP, Pauline','Lab','Glasgow Kelvin');
insert into msp values ('McNulty MSP, Des','Lab','Clydebank and Milngavie');
insert into msp values ('Monteith MSP, Mr Brian','Con','Mid-Scotland and Fife');
insert into msp values ('Morgan MSP, Alasdair','SNP','Galloway and Upper Nithsdale');
insert into msp values ('Morrison MSP, Mr Alasdair','Lab','Western Isles');
insert into msp values ('Muldoon MSP, Bristow','Lab','Livingston');
insert into msp values ('Mulligan MSP, Mrs Mary','Lab','Linlithgow');
insert into msp values ('Mundell MSP, David','Con','South of Scotland');
insert into msp values ('Munro MSP, Mr John','LD','Ross, Skye and Inverness West');
insert into msp values ('Murray MSP, Dr Elaine','Lab','Dumfries');
insert into msp values ('Neil MSP, Alex','SNP','Central Scotland region');
insert into msp values ('Oldfather MSP, Ms Irene','Lab','Cunninghame South');
insert into msp values ('Paterson MSP, Mr Gil','SNP','Central Scotland');
insert into msp values ('Peacock MSP, Peter','Lab','Highlands and Islands');
insert into msp values ('Peattie MSP, Cathy','Lab','Falkirk East');
insert into msp values ('Quinan MSP, Mr Lloyd','SNP','West of Scotland');
insert into msp values ('Radcliffe MSP, Nora','LD','Gordon');
insert into msp values ('Raffan MSP, Mr Keith','LD','Mid-Scotland and Fife');
insert into msp values ('Reid MSP, Mr George','SNP','Mid-Scotland and Fife');
insert into msp values ('Robison MSP, Shona','SNP','North East Scotland');
--- tabmsp, 101, 50
insert into msp values ('Robson MSP, Euan','LD','Roxburgh and Berwickshire');
insert into msp values ('Rumbles MSP, Mr Mike','LD','West Aberdeenshire and Kincardine');
insert into msp values ('Russell MSP, Michael','SNP','South of Scotland');
insert into msp values ('Salmond MSP, Mr Alex','SNP','Banff and Buchan');
insert into msp values ('Scanlon MSP, Mary','Con','Highlands and Islands');
insert into msp values ('Scott MSP, John','Con','Ayr');
insert into msp values ('Scott MSP, Tavish','LD','Shetland');
insert into msp values ('Sheridan MSP, Tommy','SSP','Glasgow');
insert into msp values ('Simpson MSP, Dr Richard','Lab','Ochil');
insert into msp values ('Smith MSP, Elaine','Lab','Coatbridge and Chryston');
insert into msp values ('Smith MSP, Iain','LD','North East Fife');
insert into msp values ('Smith MSP, Mrs Margaret','LD','Edinburgh West');
insert into msp values ('Steel KBE MSP, Rt Hon Sir David','LD','Lothians');
insert into msp values ('Stephen MSP, Nicol','LD','Aberdeen South');
insert into msp values ('Stone MSP, Mr Jamie','LD','Caithness, Sutherland and Easter Ross');
insert into msp values ('Sturgeon MSP, Ms Nicola','SNP','Glasgow');
insert into msp values ('Swinney MSP, Mr John','SNP','North Tayside');
insert into msp values ('Thomson MSP, Elaine','Lab','Aberdeen North');
insert into msp values ('Tosh MSP, Mr Murray','Con','South of Scotland');
insert into msp values ('Ullrich MSP, Mrs Kay','SNP','West of Scotland');
insert into msp values ('Wallace MSP, Ben','Con','North East Scotland');
insert into msp values ('Wallace QC MSP, Mr Jim','LD','Orkney');
insert into msp values ('Watson MSP, Mike','Lab','Glasgow Cathcart');
insert into msp values ('Welsh MSP, Mr Andrew','SNP','Angus');
insert into msp values ('White MSP, Ms Sandra','SNP','Glasgow');
insert into msp values ('Whitefield MSP, Karen','Lab','Airdrie and Shotts');
insert into msp values ('Wilson MSP, Allan','Lab','Cunninghame North');
insert into msp values ('Wilson MSP, Andrew','SNP','Central Scotland');
insert into msp values ('Young OBE MSP, John','Con','West of Scotland');
