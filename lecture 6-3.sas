/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (6-3)               */
/* Date : 2021-05-05                                                         */
/* Raw data : mroz.dta                                                      */
/*-------------------------------------------------*/

*****IV for OVBias*****;
data mroz;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/ЙЬКа/mroz.dta'
out=mroz
replace;

proc contents data=mroz;
title 'mroz data contents';
run;

data mroz;
set mroz;
exper2=exper**2;
lwage=log(wage);
run;

proc reg;
model lwage=educ exper exper2;
run;

proc corr;
var educ mothereduc fatehreduc;
title 'Correlation between educ and potential iv';
run;

proc reg;
model educ=exper exper2 mothereduc fathereduc;
test mothereduc=0, fathereduc=0;
output out=mrozout r=ehat;
title '1st stage with external iv mothereduc and fathereduc';
run;

proc reg data=mrozout;
model lwage=educ exper exper2 ehat;
title 'Hausman test using external iv mothereduc and fathereduc';
run;

proc syslin data=mroz 2sls;
endogenous educ;
instruments exper exper2 mothereduc fathereduc;
model lwage=educ exper exper2/overid;
title 'IV/2sls using external iv mothereduc and fathereduc';
run;

