/*
Use the correlation coefficient multiplies the volatility of the stock and divided by
the volatility of the market to acquire the ex-ante beta of each stock at each day.
Also adjust the beta by shrinking the time-series estimate of beta (with the weight of 0.6)
toward the cross-sectional mean (defined as 1 with the weight of 0.4) to reduce the influence
of outliers.
*/


data prebeta;
 merge corrresult4 stkvol;
 by tmonth stkcd;
run;
data prebeta2;
 merge prebeta mktvol;
 by tmonth;
run;
data prebeta3;
 set prebeta2;
 prebeta=corr*stkvol/mktvol;
run;
data prebeta4;
 set prebeta3;
 if missing(prebeta) then delete;
 drop corr mktvol;
run;
data sqbeta;/*beta调整*/
 set prebeta4;
 sqbeta=0.6*prebeta+(1-0.6)*1;
 tmonth=tmonth+1;/*前一个月的beta用于后一个月*/
 drop prebeta;
run;
