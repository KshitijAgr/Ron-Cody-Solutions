
*Data set DAILYPRICES;
data dailyprices;
   infile datalines;
   length Symbol $ 4;
   input Symbol $ @;
   do Date = '01jan2007'd  to '05jan2007'd;
      input Price @;
      if not missing(Price) then output;
   end;
   format Date mmddyy10.;
datalines;
CSCO 19.75 20 20.5 21 .
IBM 76 78 75 79 81
LU 2.55 2.53 . . .
AVID 41.25 . . . .
BAC 51 51 51.2 49.9 52.1
;

*Sorted DataSet;

proc sort data=dailyprices;
by Symbol Date;
run;

*Question 1;

data dailyprices_recent;
set dailyprices;
if last.symbol then output;
by symbol;
run;

Proc print data=dailyprices_Recent;
run;

*Question 2;

proc means data=dailyprices noprint;
class Symbol;
var Price;
output out = summary
mean =
n = 
min =
max=/ autoname;
run;

data summary(drop = _type_);
set summary(drop = _Freq_);
if _type_ = 1;
run;

proc print data=summary noobs;
run;

*Question 3;

data Count_N_Days;
set dailyprices;
by symbol;
if first.symbol  then N_Days= 1; 
else  N_Days+1; 
if last.symbol then output;
keep symbol N_Days;
run;

*Question 4;

proc freq data=Dailyprices;
tables Symbol / nocum nopercent missing;
run;

*Question 5;

data difference;
set dailyprices;
retain first_price;
if first.symbol & last.symbol then delete;
if first.symbol then first_price = price;
if last.symbol then do;
Diff = price - first_price;
output;
end;
by symbol;
drop date first_price;
run;

*Question 6;

data difference_lag;
set dailyprices;
if first.symbol and last.symbol then delete;
if first.symbol or last.symbol then 
Diff = price - lag(price);
/* Diff = Dif(Price); */
if last.symbol then output;
by symbol;
drop date;
run;

*Question 7;

data day_2_day_diff;
set dailyprices;
if first.symbol and last.symbol then delete;
Diff = price- lag(price);
/* Diff = Dif(Price); */
if first.symbol then Diff = 0;
by symbol;
run;




