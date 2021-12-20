/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (9)                  */
/* Date : 2021-05-05                                                         */
/* Raw data : am_panel.dta                                              */
/*-------------------------------------------------*/

data am_panel;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/ЙЬКа/am_panel.dta'
out=am_panel
replace; 

data long;
set am_panel;
i=hhid; t=time; 
x=lsize;
y=lsize;
z=headsch;
run;

proc panel;
id hhid time;
model ltexp=lsize headsch/pooled;
run;

proc panel;
id hhid time;
model ltexp=lsize headsch/btwng;
run;

proc panel;
id hhid time;
model ltexp=lsize headsch/ranone;
run;

proc panel;
id hhid time;
model ltexp=lsize headsch/fixone;
run;

***cluster-robust standard errors with pooled ols;
**implement this after inital data step;
*proc panel data=am_panel; 
*id hhid time;
*model ltexp=lsize headsch/pooled hccme=4;
*run;

data wide;
set long;
by i;
keep i z x_1-x_2 y_1-y_2;
retain x_1-x_2 y_1-y_2;
array ax(1:2) x_1-x_2;
array ay(1:2) y_1-y_2;
if first.i then do;
ax(j)=0;
ay(j)=0;
end;
end;
ax(t)=x;
ay(t)=y;
if last.t then output;
run;

data wide;
set wide;
dx=x_2-x_1;
dy=y_2-y_1;
run;

proc reg data=wide;
model dy=dx/noint;
run;

proc panel data=wide;
flatdata indid=i tsname="t" base=(x y)
keep=(z)/out=flat_out;
id i t;
model y=x/fixone noint;
run;



