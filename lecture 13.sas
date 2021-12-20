/*-------------------------------------------*/
/* Statistics Class : Applied Econometrics (13)      */
/* Date : 2021-07-11                                               */
/* Raw data : mroz.dta                                           */
/*-------------------------------------------*/

data mroz;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/ЙЬКа/mroz.dta'
out=mroz
replace;

data mroz;
set mroz;
if wage>0 then lwage=log(wage); else lwage=0;
kids=(kids16_kids618>0);
label lwage='log(wage)' kids='kids';
keep lwage kids hours educ exper age kids16 mtr lfp;
run;

******* self-selection;
proc reg data=mroz;
model lwage=educ exper;
where lfp=1;
title 'LS on censored data';
run;

proc qlim data=mroz;
model lfp=age educ kids mtr/discrete(d=normal);
output out=probitout xbeta mills;
title 'probit selection eq';
run;

data probitout;
set probitout;
pdf=pdf('normal', xbeta_lfp);
cdf=probnorm(xbeta_lfp);
imr=pdf/cdf;
run;

proc reg data=probitout;
model lwage=educ exper imr;
where lfp=1;
title 'LS with imr';
run;

*heckit;
proc qlim data=mroz;
model lfp=age educ kids mtr/discrete(d=normal);
model lwage= educ exper/select(lfp=1);
title 'Heckit MLE';
run;

********tobit;
proc sgplot data=morz;
title "Wife's hours of work";
histogram hours/scale=count;
run;

proc reg data=mroz;
model hours= educ exper age kids16;
title 'hours eq using all data';
run;

proc reg data=mroz;
model hours= educ exper age kids16;
where hours>0;
title 'hours eq using cesored data';
run;

proc qlim data=mroz;
model hours= educ exper age kids16;
endogenous hours ~ censored(lb=0);
output out=tobit marginal;
title 'hours eq tobit';
run;

proc means data=tobit;
title 'tobit average marginal effects';
run;

