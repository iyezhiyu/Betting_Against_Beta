/*
Calculate and annulize the Sharpe ratio of the 10 groups updated each month.
*/


data sharp;
 set totalreg4;
 keep tmonth grp Mretwd;
run;
proc sort data=sharp;
 by tmonth grp;
run;
data sharp2;
 merge sharp rf;
 by tmonth;
run;
data sharp3;
 set sharp2;
 if missing(Mretwd) then delete;
run;
proc sort data=sharp3;
 by grp tmonth;
run;
proc means data=sharp3 noprint nway missing;
 var Mretwd rf;
 by grp tmonth;
 output out=sharp4 mean=;
run;
data sharp5;
 set sharp4;
 keep grp Mretwd rf;
run;
proc means data=sharp5 noprint nway missing;
 var Mretwd rf;
 by grp;
 output out=sharp6 mean=;
run;
data sharp7;
 set sharp6;
 ret=(1+Mretwd)**12-1;
 rf=(1+rf)**12-1;
 drop _TYPE_ _FREQ_ Mretwd;
run;
data sharp8;
 merge sharp7 portvol5;
 by grp;
run;
data sharp9;/*计算出夏普比率*/
 set sharp8;
 sharp=(ret-rf)/vol;
 drop ret rf vol;
run;
