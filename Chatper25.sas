*Datasets used in this chapter; 

*Data set STOCKS;
data stocks;
   Do date = '01Jan2006'd to '31Jan2006'd;
      input Price @@;
      output;
   end;
   format Date mmddyy10. Price dollar8.;
datalines;
34 35 39 30 35 35 37 38 39 45 47 52
39 40 51 52 45 47 48 50 50 51 52 53
55 42 41 40 46 55 52
;

*Data set BICYCLES;
data bicycles;
   input Country &$25. Model &$14.   Manuf :$10. 
         Units :5.  UnitCost :comma8.;
   TotalSales = (Units * UnitCost) / 1000;
   format UnitCost TotalSales dollar10.;
   label TotalSales = "Sales in Thousands"
         Manuf = "Manufacturer";
datalines;
USA  Road Bike  Trek 5000 $2,200
USA  Road Bike  Cannondale 2000 $2,100
USA  Mountain Bike  Trek 6000 $1,200
USA  Mountain Bike  Cannondale 4000 $2,700
USA  Hybrid  Trek 4500 $650
France  Road Bike  Trek 3400 $2,500
France  Road Bike  Cannondale 900 $3,700
France  Mountain Bike  Trek 5600 $1,300
France  Mountain Bike  Cannondale  800 $1,899
France  Hybrid  Trek 1100 $540
United Kingdom  Road Bike  Trek 2444 $2,100
United Kingdom  Road Bike  Cannondale  1200 $2,123
United Kingdom  Hybrid  Trek 800 $490
United Kingdom  Hybrid  Cannondale 500 $880
United Kingdom  Mountain Bike  Trek 1211 $1,121
Italy  Hybrid  Trek 700 $690
Italy  Road Bike  Trek 4500  $2,890
Italy  Mountain Bike  Trek 3400  $1,877
;

*Data set FITNESS;
data fitness;
   call streaminit(13579246);
   do Subj = 1 to 100;
      TimeMile = round(rand('normal',8,2),.1);
      if TimeMile lt 4.5 then TimeMile = TimeMile + 4;
      RestPulse = 40 + int(2*TimeMile) + rand('normal',5,5);
      MaxPulse = int(RestPulse + rand('normal',100,5));
      output;
   end;
run;


*Question 1;
title"Listing produced on &sysday, &sysdate9 at &systime";

proc print data=stocks(obs=5);
run;

*Question 2;
%let start = 1;
%let end = 5;

data sqrt_table;
do n = &start to &end;
Sqrt_n=sqrt(N);
output;
end;
run;

title "Square Root Table from &start to &end";
proc print data=sqrt_table noobs;
run;

*Question 3;
%macro Print_n(ds_name,obv);
title "Listing of the first &obv Observations from Data set &ds_name";
proc print data=&ds_name(obs=&obv) noobs;
run;
%mend;

%print_n(Bicycles,4);

*Question 4;
%macro Stats(Dsn,Class,Vars);
proc means data=&dsn n mean min max maxdec=1;
class &class;
var &vars;
%mend;

%stats(Bicycles,Country,Units TotalSales);

*Question 5;
proc means data=fitness nway noprint;
var TimeMile RestPulse MaxPulse;
output out=First mean= / autoname;
run;

data _null_;
set First;
call symput('Total_Time',TimeMile_mean);
call symput('Total_Rest',RestPulse_mean);
call symput('Total_Max',MaxPulse_mean);
run;

data Final;
retain Subj TimeMile RestPulse MaxPulse;
format P_TimeMile P_RestPulse R_MaxPulse 8.2;
set Fitness;
P_TimeMile = 100*TimeMile/&Total_Time;
P_RestPulse = 100*RestPulse/&Total_rest;
R_MaxPulse = 100*MaxPulse/&Total_Max;
run;