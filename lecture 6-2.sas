/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (6-2)               */
/* Date : 2021-05-05                                                         */
/* Raw data : truffles.dta                                                    */
/*-------------------------------------------------*/

data truffles;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/ЙЬКа/truffles.dta'
out=truffles
replace;

proc contents data=truffles;
title 'truffles data contents';
run;

proc means data=truffles;
title 'truffles summary stats';
run;

proc reg;
redform_Q:model q=ps di pf;
redform_P:model p=ps di pf;
output out=pout p=phat;
test  ps=0, di=0;
title 'reduced form regressions';
run;

proc reg data=pout;
model q=phat pf;
title '2nd stage reg for supply curve';
run;

proc syslin data=truffles 2sls;
endogenous p;
instruments ps di pf;
demand: model q=p ps di;
supply: model q=p pf;
title '2sls estimation';
run;

