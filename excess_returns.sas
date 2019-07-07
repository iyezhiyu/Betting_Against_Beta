/*
Group the stocks into 10 groups using last month beta can calculate this month's
returns minus the risk free return.
*/


data totalreg;
 merge zbeta2 fivefactor_monthly;
 by tmonth;
 drop z;
run;
data totalreg2;
 set totalreg;
  if missing(sqbeta) then delete;
run;
proc rank data=totalreg2 out=totalreg3 groups=10;
var sqbeta;
by tmonth;
ranks grp;
run;
data totalreg4;
 set totalreg3;
 ret=Mretwd-rf;
run;
proc sort data=totalreg4;
by grp tmonth;
run;
proc means data=totalreg4 noprint;
var ret;
by grp tmonth;
output out=totalreg5 mean=;
run;
data totalreg6;
 set totalreg5;
 drop tmonth _TYPE_ _FREQ_;
run;

proc reg data=totalreg6 outest=totalreg7 tableout noprint;
by grp;
model ret=;
run;
data excessreturn;/*十组的超额收益*/
 set totalreg7;
 if _TYPE_='STDERR' then delete;
 if _TYPE_='PVALUE' then delete;
 if _TYPE_='L95B' then delete;
 if _TYPE_='U95B' then delete;
 keep grp Intercept;
run;
