/*-------------------------------------------*/
/* Statistics Class : Applied Econometrics (14)      */
/* Date : 2021-07-11                                               */
/* Raw data : cola.dta, olympics.dta, yinger.dta     */
/*-------------------------------------------*/

data cola;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/cola.dta'
out=cola
replace;

proc print data=cola(obs=6);
title 'cola observations';
run;

proc means data=cola;
title 'cola summary stats';
run;

proc mdc data=cola outest=est;
model choice=price/type=clogit nchoice=3;
id id;
output out=colaout p=phat;
title 'cola conditional logit';
run;


**count olympics;

data olympics;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/olympics.dta'
out=olympics
replace;

proc contents;
title 'olympics contents';
run;

data olympics;
set olympics;
lnpop=log(pop);
lngdp=log(gdp);
if year=88;
if medaltot ne .;
keep medaltot lnpop lngdp;
run;

proc means;
title 'olympics summary stats';
run;

proc reg;
model medaltot=lnpop lngdp;
run;

proc countreg data=olympics;
model medaltot=lnpop lngdp/dist=poisson;
output out=out88 xbeta=xbeta pred=phat;
title 'poission reg';
run;


**yinger;

data yinger;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/yinger.dta'
out=yinger
replace;


**panel approachr;

proc panel;
id auditid t;
model y= t/fixone;
model y= t/pooled;
model y= t/raone;
title 'FE, Pooled, RE';
run;

