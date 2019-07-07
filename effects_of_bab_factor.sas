/*
Calculate the the return, Alphas, volatility, Sharpe ratio of the BAB factor.
*/


data babreg;
 merge babtotal fivefactor_monthly;
 by tmonth;
run;
data babreg2;
 set babreg;
 if missing(bab) then delete;
 babexret=bab-rf;
run;

/*BAB excess return*/
proc reg data=babreg2 outest=babexret tableout noprint;
 model babexret= ;
run;

/*BAB Alpha of the CAPM and the realized beta*/
proc reg data=babreg2 outest=babcapm tableout noprint;
 model babexret=mkt_rf;
run;

/*BAB Alpha of the Fama-French Three factor model*/
proc reg data=babreg2 outest=babff3 tableout noprint;
 model babexret=mkt_rf smb hml;
run;

/*BAB Alpha of the Carhart Four factor model*/
proc reg data=babreg2 outest=babch4 tableout noprint;
 model babexret=mkt_rf smb hml umd;
run;

/*BAB Alpha of the Fama-French Five factor model*/
proc reg data=babreg2 outest=babff5 tableout noprint;
 model babexret=mkt_rf smb hml rmw cma;
run;

/*BAB annulized volatility*/
proc means data=babreg2 noprint;
 var bab;
 output out=babvol std=;
run;
data babvol2;
 set babvol;
 babvol=bab*sqrt(12);
 keep babvol;
run;

/*BAB annulized Sharpe ratio*/
proc means data=babreg2 noprint nway missing;
 var bab rf;
 output out=babsharp mean=;
run;
data babsharp2;
 set babsharp;
 bab=(1+bab)**12-1;
 rf=(1+rf)**12-1;
 drop _TYPE_ _FREQ_;
run;
data babsharp3;
 merge babsharp2 babvol2;
run;
data babsharp4;
 set babsharp3;
 babsharp=(bab-rf)/babvol;
run;
