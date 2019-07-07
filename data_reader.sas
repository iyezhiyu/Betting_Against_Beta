/*
Read the daily trading data of the stocks from 1994 to 2017
in the Chinese stock market.
The data is from GTA database.
*/


%macro readreturn;/*循环读入1994年至2017年股票日交易数据*/
%do i=1 %to 27;
DATA TRD_Dalyr&i (Label="日个股回报率文件");
Infile "path to the data\TRD_Dalyr(&i).txt" encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Trddt $10.;
Format Dretwd 10.8;
Informat Stkcd $6.;
Informat Trddt $10.;
Informat Dretwd 10.8;
Label Stkcd="证券代码";
Label Trddt="交易日期";
Label Dretwd="考虑现金红利再投资的日个股回报率";
Input Stkcd $ Trddt $ Dretwd ;
Run;
%end;
%mend readreturn;
%readreturn;
data TRD_Dalyr;
 set TRD_Dalyr1-TRD_Dalyr27;
run;
proc sort data=TRD_Dalyr;
by stkcd Trddt;
run;


/*
Read the daily data of the Carhart four factors and the Fama-French five factors.
The Fama-French three factors: net return of the market, SMB, HML.
The Carhart four factors: net return of the market, SMB, HML, UMD.
The Fama-French five factors: net return of the market, SMB, HML, RMW, CMA.
The data is from the China Asset Management Research Center of the
Central University of Finance and Economics.
*/
DATA fivefactor_daily (Label="五因子日度数据");/*读入四因子、五因子日度数据*/
Infile 'path to the data\fivefactor_daily.txt' encoding="utf-8" 
delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format trddy $10.;
Format mkt_rf best12.;
Format smb best12.;
Format hml best12.;
Format umd best12.;
Format rmw best12.;
Format cma best12.;
Format rf best12.;
Format smb_equal best12.;
Format hml_equal best12.;
Format umd_equal best12.;
Format rmw_equal best12.;
Format cma_equal best12.;
Informat trddy $10.;
Informat mkt_rf best12.;
Informat smb best12.;
Informat hml best12.;
Informat umd best12.;
Informat rmw best12.;
Informat cma best12.;
Informat rf best12.;
Informat smb_equal best12.;
Informat hml_equal best12.;
Informat umd_equal best12.;
Informat rmw_equal best12.;
Informat cma_equal best12.;
Label trddy="交易日期";
Label mkt_rf="市场风险因子";
Label smb="规模风险因子";
Label hml="账面市值比风险因子";
Label umd="惯性因子";
Label rmw="盈利能力因子";
Label cma="投资模式因子";
Label rf="无风险利率";
Label smb_equal="（流通市值加权）规模风险因子";
Label hml_equal="（流通市值加权）账面市值比风险因子";
Label umd_equal="（流通市值加权）惯性因子";
Label rmw_equal="（流通市值加权）盈利能力因子";
Label cma_equal="（流通市值加权）投资模式因子";
Input trddy mkt_rf smb  hml umd rmw cma rf smb_equal hml_equal umd_equal rmw_equal cma_equal;
Run;
data fivefactor_daily;
 set fivefactor_daily;
 keep trddy mkt_rf smb hml umd rmw cma rf;
run;

/*
Read the monthly trading data of the stocks from 1994 to 2017
in the Chinese stock market.
The data is from GTA database.
*/
%macro readreturn2;/*循环读入个股月收益数据*/
%do i=1 %to 2;
DATA TRD_Mnth&i (Label="月个股回报率文件");
Infile "path to the data\TRD_Mnth(&i).txt" encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Trdmnt $7.;
Format Mretwd 10.8;
Informat Stkcd $6.;
Informat Trdmnt $7.;
Informat Mretwd 10.8;
Label Stkcd="证券代码";
Label Trdmnt="交易月份";
Label Mretwd="考虑现金红利再投资的月个股回报率";
Input Stkcd $ Trdmnt $ Mretwd ;
Run;
%end;
%mend readreturn2;
%readreturn2;
data TRD_Mnth;
 set TRD_Mnth1 TRD_Mnth2;
run;
data stkmonth;
 set TRD_Mnth;
 year=input(substr(left(Trdmnt),1,4),4.);
 month=input(substr(left(Trdmnt),6,2),2.);
 tmonth=(year-1994)*12+month;
 drop year month Trdmnt;
run;
proc sort data=stkmonth;
by tmonth stkcd;
run;


/*
Read the monthly data of the Carhart four factors and the Fama-French five factors.
The Fama-French three factors: net return of the market, SMB, HML.
The Carhart four factors: net return of the market, SMB, HML, UMD.
The Fama-French five factors: net return of the market, SMB, HML, RMW, CMA.
The data is from the China Asset Management Research Center of the
Central University of Finance and Economics.
*/
DATA fivefactor_monthly (Label="五因子月度数据");/*循环读入四因子、五因子月度数据*/
Infile 'path to the data\fivefactor_monthly.txt' encoding="utf-8" 
delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format trdmn $7.;
Format mkt_rf best12.;
Format smb best12.;
Format hml best12.;
Format umd best12.;
Format rmw best12.;
Format cma best12.;
Format rf best12.;
Format smb_equal best12.;
Format hml_equal best12.;
Format umd_equal best12.;
Format rmw_equal best12.;
Format cma_equal best12.;
Informat trdmn $7.;
Informat mkt_rf best12.;
Informat smb best12.;
Informat hml best12.;
Informat umd best12.;
Informat rmw best12.;
Informat cma best12.;
Informat rf best12.;
Informat smb_equal best12.;
Informat hml_equal best12.;
Informat umd_equal best12.;
Informat rmw_equal best12.;
Informat cma_equal best12.;
Label trdmn="交易日期";
Label mkt_rf="市场风险因子";
Label smb="规模风险因子";
Label hml="账面市值比风险因子";
Label umd="惯性因子";
Label rmw="盈利能力因子";
Label cma="投资模式因子";
Label rf="无风险利率";
Label smb_equal="（流通市值加权）规模风险因子";
Label hml_equal="（流通市值加权）账面市值比风险因子";
Label umd_equal="（流通市值加权）惯性因子";
Label rmw_equal="（流通市值加权）盈利能力因子";
Label cma_equal="（流通市值加权）投资模式因子";
Input trdmn $ mkt_rf smb  hml umd rmw cma rf smb_equal hml_equal umd_equal rmw_equal cma_equal;
Run;
data fivefactor_monthly;
 set fivefactor_monthly;
 keep trdmn mkt_rf smb hml umd rmw cma rf;
run;
data fivefactor_monthly;
 set fivefactor_monthly;
 year=input(substr(left(trdmn),1,4),4.);
 month=input(substr(left(trdmn),6,2),2.);
 tmonth=(year-1994)*12+month;
 drop year month trdmn;
run;
data rf;
 set fivefactor_monthly;
  keep tmonth rf;
run;
