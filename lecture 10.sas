/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (10)                 */
/* Date : 2021-05-05                                                         */
/* Raw data : grunfeld.dta, grunfeld2.dta                          */
/*-------------------------------------------------*/

data grunfeld;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/grunfeld.dta'
out=grunfeld
replace;

proc contents;
title 'contents of grunfeld data';
run;

proc means;
title 'summary stats grunfeld data';
run;

data grunfeld;
set grunfeld;
if i=3 | i =8;
d=(i=8);
dv=d*v;
dk=d*k;
run;

proc reg;
model inv= d v k dv dk;
test d=0, dv=0, dk=0;
run;

**Heteroskedastic error consistent Test and SUR model Test;
proc reg;
model inv= v k;
where d=1;
title 'reg of we';
run;

proc reg;
model inv= v k;
where d=0;
title 'reg of ge';
run;

**alternatively;
proc reg;
by i;
model inv= v k;
title 'seperate reg';
run;

data GQtest;
sse_we=1773.23;
df_we=17;
sse_ge=13217;
df_ge=17;
fstat=(sse_ge/df_ge)/(sse_we/df_we);
fc=finv(.95, df_ge, df_we);
pval_f=1-probf(fstat,df_ge,df_we);
run;

proc print data=GQtest;
var fstat fc pval_f;
title 'F-test';
run;

**after confirming hetero, use a correction of weighted squares;
data grunfeld;
set grunfeld;
var=104.307*d+777.446*(1-d);
w=1/var;
run;

proc reg;
model inv= d v k dv dk;
weight w;
test d=0, dv=0, dk=0;
run;

**SUR model;
data we;
set grunfeld;
if d=1; 
inv_we=inv;
v_we=v;
k_we=k;
keep t inv_we v_we k_we;
run;

data ge;
set grunfeld;
if d=0; 
inv_ge=inv;
v_ge=v;
k_ge=k;
keep t inv_ge v_ge k_ge;
run;

data grunfeld2;
merge we ge;
by t;
run;

proc reg data=grunfeld2;
model inv_we=v_we k_we;
output out=weout r=ehat_we;
title 'WE reg';
run;

proc reg data=grunfeld2;
model inv_ge=v_ge k_ge;
output out=geout r=ehat_ge;
title 'GE reg';
run;

data all;
merge weout geout;
run;

proc corr;
var ehat_we ehat_ge;
title 'residual corr';
run;

proc syslin data=grunfeld2 sur;
we : model inv_we=v_we k_we;
ge : model inv_ge=v_ge k_ge;
sttest : stest we.intercept=ge.intercept, we.v_we=ge.v_ge, we.k_we=ge.k_ge;
title 'SUR estimation with tests';
run;

**panel;
data grunfeld;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/grunfeld.dta'
out=grunfeld
replace;

proc reg;
model inv= v k;
title 'pooled ols';
run;

proc panel;
id i t;
model inv= v k/fixone;
title 'FE';
run;

**show LSDV=FE;
data grunfeld_d;
d1 = (i=1); d2 = (i=2); d3 = (i=3); d4 = (i=4); d5 = (i=5); d6 = (i=6); d7 = (i=7); d8 = (i=8); d9 = (i=9); d10 = (i=10); 
run;

proc reg data=grunfeld_d;
model inv=d1-d10 v k/noint;
title 'grunfeld LSDV';
run;

proc panel;
id i t;
model inv = v k/raone;
run;
