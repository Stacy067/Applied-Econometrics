/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (7)                  */
/* Date : 2021-05-05                                                         */
/* Raw data : rts_location.dta                                            */
/*-------------------------------------------------*/

data practice_hetero;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/ЙЬКа/rts_location.dta'
out=practice_hetero
replace;

proc means;
var;
run;

data practice_hetero;
set practice_hetero;
s_u=s*u;

**test s_u=0;
proc reg;
model lnw= s u s_u/covb;
test u=s_u=0;
run;

**heteroskedastic error correction;
proc reg;
model lnw=s;
where u=1;
run;

proc reg;
model lnw=s;
where u=0;
run;

data GQtest;
sse_u=452.79915;
df_u=1182;
sse_nu=163.76167;
df_nu=469;
fstat=(sse_u/df_u)/(sse_nu/df_nu);
fc=finv(.95, df_u, df_nu);
pval_f=1-probf(fstat,df_u,df_nu);
run;

**title 'F-test and Wald test';
proc print data=GQtest;
var fstat fc pval_f;
title 'F-test';
run;

**use a correction of weighted least squared;
data practice_hetero;
set practice_hetero;
var=0.38308*u+0.34917*(1-u);
w=1/var;
run;

proc reg;
model lnw=s;
weight w;
run;

**heteroskedastic error detection and correction;
proc reg;
model lnw=s/R;
output out=practice_hetero R=ehat;
run;

proc plot;
plot lnw*s='+';
run;

data practice_hetero;
set practice_hetero;
ehat2=ehat*ehat;
s2=s*s;
run;

**white hetero test;
proc reg;
model ehat2=s;
model ehat2=s s2; 

**white hetero correction method;
proc reg;
model lnw=s/white;
run;


















