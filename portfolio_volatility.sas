/*
Calculate and annulize the volatility of the 10 groups updated each month.
*/


data portvol;
 set totalreg4;
 keep tmonth grp Mretwd;
run;
proc means data=portvol noprint;
 var Mretwd;
 by grp tmonth;
 output out=portvol2 mean=;
run;
data portvol3;
 set portvol2;
 keep grp Mretwd;
run;
proc means data=portvol3 noprint;
 var Mretwd;
 by grp;
 output out=portvol4 std=;
run;
data portvol5;/*年化波动率*/
 set portvol4;
 vol=sqrt(12)*Mretwd;
 drop _TYPE_ _FREQ_  Mretwd;
run;
