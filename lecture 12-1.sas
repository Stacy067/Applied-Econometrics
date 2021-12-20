/*---------------------------------------------------*/
/* Statistics Class : Applied Econometrics (12-1)                 */
/* Date : 2021-07-11                                                             */
/* Raw data : transport.dta, playball_modified.dta, mroz.dta */
/*---------------------------------------------------*/

data transport;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/transport.dta'
out=transport
replace;

proc contents;
title 'contents of transport data';
run;

proc means;
title 'summary stats transport data';
run;

proc reg;
model auto=dtime;
output out=lpmout p=p;
run;

proc print data lpmout;
run;

***LPM+WLS;
data gls;
set lpmout;
if p<0 then p=.001;
if p>1 then p=.999;
sig2=p*(1-p);
w=1/sig2;
run;

proc reg data=gls;
model auto=dtime;
weight w;
title 'GLS for LPM';
run;

proc qlim data=transport;
model auto=dtime/discrete(d=logit);
output out=logitout marginal;
title 'logit';
run;

proc means data=logitout;
var meff_p2_dtime;
title 'average logit marginal effects';
run;

proc qlim data=transport;
model auto=dtime/discrete;
output out=probitout marginal;
title 'probit';
run;

proc means data=probitout;
var meff_p2_dtime;
title 'average probit marginal effects';
run;

*Final Offer Arbitration;
data playball_modified;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/playball_modified.dta'
out=playball_modified
replace;

data palyball_modified;
set playball_modified;
lpoffer=log(poffer);
lmoffer=log(moffer);
indvar1=0.5*(lpoffer+lmoffer);
indvar2=runs+rbil
indvar3=hits/atbats;
run;

proc qlim data=playball_modified;
model y= d75 d79 d80 d81 d83 d84 indvar1 indvar2 indvar3/discrete;
output out=playballout marginal;
title 'probit';
run;

proc means data=playballout;
var meff_p2_indvar2;
title 'average probit marginal effects';
run;

*logit;
proc qlim data=playball_modified;
model y= d75 d79 d80 d81 d84 indvar1 indvar2 indvar3/discrete(d=logit);
output out=playballout_logit marginal;
title 'logit';
run;

proc means data=playballout;
var meff_p2_indvar2;
title 'average logit margianal effects';
run;

*test for fair arbitration;
proc qlim data=playball_modified;
model y= d75 d79 d80 d81 d83 d84 lpoffer lmoffer indvar2 indvar3/discrete;
run;

**LPM;
proc reg;
model y= d75 d79 d80 d81 d83 d84 indvar1 indvar2 indvar3;
run;

**labor supply;

data mroz;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/mroz.dta'
out=mroz
replace;

proc contents data=mroz position;
title 'mroz data contents';
run;

proc qlim data=moroz;
model lfp=age educ kids mtr/discrete;
output out=probitout;
title 'probit';
run;



