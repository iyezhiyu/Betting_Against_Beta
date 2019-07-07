/*
Calculate the ex-ante beta of 10 groups updated each month.
*/


data shiqianbeta;
 set totalreg4;
 keep tmonth grp sqbeta;
run;
proc means data=shiqianbeta noprint;
var sqbeta;
by grp tmonth;
output out=shiqianbeta2 mean=;
run;
data shiqianbeta3;
set shiqianbeta2;
keep grp sqbeta;
run;
proc means data=shiqianbeta3 noprint;
var sqbeta;
by grp;
output out=shiqianbeta4 mean=;
run;
data averagebeta;/*在股票组合形成时期的个股事前beta的平均*/
 set shiqianbeta4;
  drop _TYPE_ _FREQ_;
run;



/*
Calculate the Alpha of CAPM and the realized beta of 10 groups updated each month.
*/


data capm;
 set totalreg5;
 drop _TYPE_ _FREQ_;
run;
proc sort data=capm;
by tmonth grp;
run;
data capm2;
merge capm fivefactor_monthly;
by tmonth;
 keep grp tmonth ret mkt_rf;
run;
data capm3;
 set capm2;
 if missing(ret) then delete;
 if missing(mkt_rf) then delete;
run;
proc sort data=capm3;
by grp tmonth;
run;
proc reg data=capm3 outest=capm4 tableout noprint;
by grp;
model ret=mkt_rf;
run;
data capm5;/*截距即为CAPM的Alpha，市场风险因子的系数即为事后Beta*/
set capm4;
 if _TYPE_='STDERR' then delete;
 if _TYPE_='PVALUE' then delete;
 if _TYPE_='L95B' then delete;
 if _TYPE_='U95B' then delete;
 keep grp _TYPE_ Intercept mkt_rf;
run;



/*
Calculate the Alpha of the Fama-French Three factor model of the 10 groups updated each month.
*/


data FFthree;
 set totalreg5;
 drop _TYPE_ _FREQ_;
run;
proc sort data=FFthree;
by tmonth grp;
run;
data FFthree2;
merge FFthree fivefactor_monthly;
by tmonth;
 keep grp tmonth ret mkt_rf smb hml;
run;
data FFthree3;
 set FFthree2;
 if missing(ret) then delete;
 if missing(mkt_rf) then delete;
run;
proc sort data=FFthree3;
by grp tmonth;
run;
proc reg data=FFthree3 outest=FFthree4 tableout noprint;
by grp;
model ret=mkt_rf smb hml;
run;
data FFthree5;/*截距即为FF三因子的Alpha*/
set FFthree4;
 if _TYPE_='STDERR' then delete;
 if _TYPE_='PVALUE' then delete;
 if _TYPE_='L95B' then delete;
 if _TYPE_='U95B' then delete;
 keep grp _TYPE_ Intercept;
run;



/*
Calculate the Alpha of the Carhart Four factor model of the 10 groups updated each month.
*/


data CH;
 set totalreg5;
 drop _TYPE_ _FREQ_;
run;
proc sort data=CH;
by tmonth grp;
run;
data CH2;
merge CH fivefactor_monthly;
by tmonth;
 keep grp tmonth ret smb hml mkt_rf umd;
run;
data CH3;
 set CH2;
 if missing(ret) then delete;
 if missing(mkt_rf) then delete;
run;
proc sort data=CH3;
by grp tmonth;
run;
proc reg data=CH3 outest=CH4 tableout noprint;
by grp;
model ret=mkt_rf smb hml umd;
run;
data CH5;/*截距即为Carhart四因子的Alpha*/
set CH4;
 if _TYPE_='STDERR' then delete;
 if _TYPE_='PVALUE' then delete;
 if _TYPE_='L95B' then delete;
 if _TYPE_='U95B' then delete;
 keep grp _TYPE_ Intercept;
run;



/*
Calculate the Alpha of the Fama-French Five factor model of the 10 groups updated each month.
*/


data FFwu;
 set totalreg5;
 drop _TYPE_ _FREQ_;
run;
proc sort data=FFwu;
by tmonth grp;
run;
data FFwu2;
merge FFwu fivefactor_monthly;
by tmonth;
 keep grp tmonth ret mkt_rf smb hml rmw cma;
run;
data FFwu3;
 set FFwu2;
 if missing(ret) then delete;
 if missing(mkt_rf) then delete;
run;
proc sort data=FFwu3;
by grp tmonth;
run;
proc reg data=FFwu3 outest=FFwu4 tableout noprint;
by grp;
model ret=mkt_rf smb hml rmw cma;
run;
data FFwu5;/*截距即为FF五因子的Alpha*/
set FFwu4;
 if _TYPE_='STDERR' then delete;
 if _TYPE_='PVALUE' then delete;
 if _TYPE_='L95B' then delete;
 if _TYPE_='U95B' then delete;
 keep grp _TYPE_ Intercept;
run;
