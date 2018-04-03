*Datasets used in this chapter; 

*Data set INVENTORY;
data inventory;
	input Model $ Price;
	format Price dollar8.2;
	datalines;
M567 23.50
S888 12.99
L776 159.98
X999 29.95
M123 4.59
S776 1.99
;
*Data set SALES;

data sales;
	input EmpID:$4. Name&$15. Region:$5. Customer&$18. Date:mmddyy10.  
   			Item:$8. Quantity:5. UnitCost dollar9.;
	TotalSales=Quantity * UnitCost;
	format date mmddyy10. UnitCost TotalSales dollar9.;
	drop Date;
	datalines;
1843 George Smith  North Barco Corporation  10/10/2006 144L 50 $8.99
1843 George Smith  South Cost Cutter's  10/11/2006 122 100 $5.99
1843 George Smith  North Minimart Inc.  10/11/2006 188S 3 $5,199
1843 George Smith  North Barco Corporation  10/15/2006 908X 1 $5,129
1843 George Smith  South Ely Corp.  10/15/2006 122L 10 $29.95
0177 Glenda Johnson  East Food Unlimited  9/1/2006 188X 100 $6.99
0177 Glenda Johnson  East Shop and Drop  9/2/2006 144L 100 $8.99
1843 George Smith  South Cost Cutter's  10/18/2006 855W 1 $9,109
9888 Sharon Lu  West Cost Cutter's  11/14/2006 122 50 $5.99
9888 Sharon Lu  West Pet's are Us  11/15/2006 100W 1000 $1.99
0017 Jason Nguyen  East Roger's Spirits  11/15/2006 122L 500 $39.99
0017 Jason Nguyen  South Spirited Spirits  12/22/2006 407XX 100 $19.95
0177 Glenda Johnson  North Minimart Inc.  12/21/2006 777 5 $10.500
0177 Glenda Johnson  East Barco Corporation  12/20/2006 733 2 $10,000
1843 George Smith  North Minimart Inc.  11/19/2006 188S 3 $5,199
;

*Data set PURCHASE;

data purchase;
	input CustNumber Model $ Quantity;
	datalines;
101 L776 1
102 M123 10
103 X999 2
103 M567 1
;

*Data set LEFT;

data left;
	input Subj $ Height Weight;
	datalines;
001 68 155
002 75 220
003 65 99
005 79 266
006 70 190
009 61 122
;

*Data set RIGHT;

data right;
	input Subj $ Salary;
	format Salary dollar10.;
	datalines;
001 46000
003 67900
004 28200
005 98202
006 88000
007 57200
;

*Data set NEWPRODUCTS;

data newproducts;
   input Model $ Price;
   format Price dollar8.2;
datalines;
L939 10.99
M135 .75
;

*Data set FIRST;

data first;
input Subj $ x y z;
datalines;
001 10 20 30
002 11 21 31
004 12 14 15
;

*Data set SECOND;

data second;
input Subj $ z y x;
datalines;
001 33 44 55
002 60 70 80
003 80 90 100
004 777 888 999
;

*Data set BLOOD;

data blood;
infile '/folders/myfolders/sasuser.v94/RC/blood.txt' truncover;
length Gender $6 BloodType $2 AgeGroup $5;
input Subject  Gender  BloodType   AgeGroup
         WBC      RBC     Chol;
label Gender = "Gender"
      BloodType = "Blood Type"
      AgeGroup = "Age Group"
      Chol = "Cholesterol";
run;

*Question 1;

proc sql;
select * from inventory where Price > 20;
quit;

*Question 2;

proc sql;
create table Price20 as select * from inventory where Price >20;
quit;

*Question 3;

proc sql;
create table N_Sales as select Name, TotalSales from Sales 
where Region="North";
quit;

*Question 4;

proc sql;
select Custnumber,i.Model,Quantity,Price, Price * Quantity as cost 
from Inventory i ,Purchase p where i.model = p.model ;
quit;

*Question 5;

*Part-1;
proc sql;
create table Both1 as select L.Subj, l.Height, l.Weight, r.Salary 
from Left l inner join Right r on l.subj=r.subj;
quit;

*Part-2;
proc sql;
create table Both2 as select L.Subj, l.Height, l.Weight, r.Salary 
from Left l full join Right r on l.subj=r.subj;
quit;

*Part-3;
proc sql;
create table Both3 as select L.Subj, l.Height, l.Weight, r.Salary 
from Left l Left join right r on left.subj=right.subj;
quit;

*Question 6;

proc sql;
create table allproducts as select * from inventory union all select * from newproducts ;
quit;

*Question 7;

proc sql;
create table third as select * from first union all corresponding select * from second ;
quit;

*Question 8;

proc sql;
create table temp (drop= MeanRbc MeanWbc) as 
select subject,RBC,WBC,
mean(RBC) as MeanRbc ,mean(WBC) as MeanWbc,
100*RBC / calculated MeanRbc as Percent_RBC,
100*WBC / calculated MeanWbc as Percent_WBC
from blood;
quit;

proc sql;
select * from temp;
quit;

*Question 9;

proc sql;
create table percentages as
select Subject,RBC,WBC,
mean(RBC) as MeanRBC,mean(WBC) as MeanWBC,
100*RBC / calculated MeanRBC as Percent_RBC,
100*WBC / calculated MeanWBC as Percent_WBC
from blood;
quit;

*Question 10;

data xxx;
input NameX : $15. PhoneX : $13.;
datalines;
Friedman (908)848-2323
Chien (212)777-1324
;

data yyy;
input NameY : $15. PhoneY : $13.;
datalines;
Chen (212)888-1325
Chambliss (830)257-8362
Saffer (740)470-5887
;

proc sql;
select nameX,PhoneX,nameY,PhoneY from xxx x ,yyy y
where spedis(x.NameX,y.NameY) <= 25;
quit;