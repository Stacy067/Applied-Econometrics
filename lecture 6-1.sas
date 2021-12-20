/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (6-1)               */
/* Date : 2021-05-05                                                         */
/* Raw data : cyrect.dta                                                    */
/*-------------------------------------------------*/

data cyrect;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/ЙЬКа/cyrect.dta'
out=cyrect
replace;

data cyrect;
set cyrect;
c=col1; 
y=col2; 
z=y-c;
run;

proc reg;
model c=y;
run;

proc reg data=cyrect;
model y=z;
output out=cyrect predicted=yhat;
run;

proc reg;
model c=yhat;
run;

proc syslin data= cyrect 2sls;
endogenous c y;
instruments z;
model c=y;
run;

proc model data=cyrect;
endogenous y;
c=b0+b1*y;
fit c/ols 2sls hausman;
instruments z;
run;
