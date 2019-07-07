/*
Calculate the correlation coefficients of the stocks and the market.
Use overlapping 3-day log returns in the past five years (at least 750 days valid)
for correlation to control for non-synchronous trading.
And use the overlapping 3-day log returns in the past five years of the stock and
the market respectively to calculate the correlation coefficient of each stock and the market.
*/


data stkcorr;/*此步开始计算股票的overlapping log returns*/
 set TRD_Dalyr;
 lagstk=lag(Dretwd);
 lag2stk=lag(Dretwd);
run;
data stkcorr2;/*该步及下一步是去除每只股票前两个数据，因为overlapping为三天*/
 set stkcorr;
 by stkcd;
 if first.stkcd then delete;
run;
data stkcorr3;
 set stkcorr2;
 by stkcd;
 if first.stkcd then delete;
run;
data stkcorr4;/*个股的overlapping returns*/
 set stkcorr3;
 dstk=log(1+Dretwd)+log(1+lagstk)+log(1+lag2stk);
 drop Dretwd lagstk lag2stk;
run;
proc sort data=stkcorr4;
by Trddt stkcd;
run;


data mktcorr;/*市场的overlapping log returns*/
set fivefactor_daily;
 mkt=mkt_rf+rf;
 lagmkt=lag(mkt);
 lag2mkt=lag2(mkt);
 if missing(lagmkt)=0 and missing(lag2mkt)=0 then do
   dmkt=log(1+mkt)+log(1+lagmkt)+log(1+lag2mkt);
 end;
 Trddt=trddy;
 keep Trddt dmkt;
run;

data corr;/*此步开始计算相关系数*/
 merge stkcorr4 mktcorr;
 by Trddt;
run;
data corr2;
 set corr;
 year=input(substr(left(Trddt),1,4),4.);
 month=input(substr(left(Trddt),6,2),2.);
 m=(year-1994)*12+month;
 if missing(dstk) then delete;
 if missing(dmkt) then delete;
 drop Trddt year month;
run;
data corrtotal;
input stkcd $ tmonth corr;
datalines;
'000000' 0 0
;
run;
%macro corr;
%do i=1 %to 279;
data corr3;
 set corr2;
  if m>&i-60 and m<=&i;
  tmonth=&i;
run;
proc sort data=corr3;
by stkcd tmonth;
run;
proc corr data=corr3 out=corr4 noprint;
var dstk dmkt;
by stkcd tmonth;
run;
data corr5;
 set corr4;
  if _TYPE_='MEAN' then delete;
  if _TYPE_='STD' then delete;
  if _TYPE_='CORR' and _NAME_='dstk' then do
   corr=dmkt;
  end;
  if _TYPE_='CORR' and _NAME_='dmkt' then delete;
  drop _NAME_;
run;
data corr6;
 set corr5;
  lagnstk=lag(dstk);
  lagnmkt=lag(dmkt);
run;
data corr7;
 set corr6;
  if _TYPE_='N' then delete;
  if _TYPE_='CORR' and lagnstk<750 then delete;
  if _TYPE_='CORR' and lagnmkt<750 then delete;
  drop _TYPE_ dstk dmkt lagnstk lagnmkt;
run;
data corrtotal;
 set corrtotal corr7;
run; 
%end;
%mend corr;
%corr;
data corrtotal;
set corrtotal;
 if tmonth=0 then delete;
run;
data corrresult4;
set corrtotal;
run;
proc sort data=corrresult4;
by tmonth stkcd;
run;
