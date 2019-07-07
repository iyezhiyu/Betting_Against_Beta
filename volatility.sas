/*
Calculate the volatitily of each stock.
The volatility of each stock at day I is defined as the standard deviation of the 
logarithmic daily returns of the stock in the past year (at least 120 days valid).
*/


data stkday;
 set TRD_Dalyr;
 year=input(substr(left(Trddt),1,4),4.);
 month=input(substr(left(Trddt),6,2),2.);
 m=(year-1994)*12+month;
 Dretwd=log(1+Dretwd);
 drop year month Trddt;
run;
data stkvol;
input stkcd $ tmonth stkvol;
datalines;
'000000' 0 0
;
run;
%macro stkvol;
%do i=1 %to 279;
data stkday1;
 set stkday;
  if m>&i-12 and m<=&i;
  tmonth=&i;
run;
proc means data=stkday1 noprint;
by stkcd;
output out=stkday2;
run;
data stkday3;
set stkday2;
 if _STAT_^='STD' then delete;
 if _FREQ_<120 then delete;
 stkvol=Dretwd;
 drop _TYPE_ _FREQ_ _STAT_ m Dretwd tmonth;
run;
data stkday4;
 set stkday3;
 tmonth=&i;
run;
data stkvol;
 set stkvol stkday4;
run;
%end;
%mend stkvol;
%stkvol;
data stkvol;
set stkvol;
 if tmonth=0 then delete;
run;
/*结束-------------------计算个股波动率-------------------*/


/*
Calculate the volatility of the market.
The volatility of the market at day I is defined as the standard deviation of the 
logarithmic daily returns of the market in the past year (at least 120 days valid).
*/
/*开始-------------------计算市场波动率-------------------*/
data mktday;
set fivefactor_daily;
 year=input(substr(left(trddy),1,4),4.);
 month=input(substr(left(trddy),6,2),2.);
 m=(year-1994)*12+month;
 mkt=log(1+mkt_rf+rf);
 drop mkt_rf smb hml umd rmw cma rf year month trddy;
run;
data mktvoltotal;
input tmonth mkt m;
datalines;
0 0 0
;
run;
%macro mktvol;
%do i=1 %to 279;
data mktday1;
 set mktday;
  if m>&i-12 and m<=&i;
  tmonth=&i;
run;
data mktvoltotal;
 set mktvoltotal mktday1;
run;
%end;
%mend mktvol;
%mktvol;
data mktvoltotal;
set mktvoltotal;
 if m=0 then delete;
run;
proc means data=mktvoltotal noprint;
by tmonth;
output out=mktvolresult;
run;
data mktvol;
set mktvolresult;
 if _STAT_^='STD' then delete;
 if _FREQ_<120 then delete;
 mktvol=mkt;
 drop _TYPE_ _FREQ_ _STAT_ m mkt;
run;
