/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (8)                  */
/* Date : 2021-05-05                                                         */
/* Raw data : minwage.dta                                               */
/*-------------------------------------------------*/

data minwage;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/ЙЬКа/minwage.dta'
out=minwage
replace; 

data minwage;
set minwage;
t=col1; emp=col2; upr=col3; tsq=col4; afp=col5; pop=col6; trp=col7; yk=col8; sy=col9; q2=col10; q3=col11; q4=col12; 
lemp=log(emp);lupr=log(upr); lpop=log(pop); lyk=log(yk);

proc reg data=minwage;
model lemp=lyk t tsq q2 q3 q4 lupr sy afp trp lpop/dw;
run;

proc autoreg data=minwage;
*model lemp=lyk t tsq q2 q3 q4 lupr sy afp trp lpop/nlag=1 method=uls; *c-o without 1st obs;
model lemp=lyk t tsq q2 q3 q4 lupr sy afp trp lpop/nlag=1 method=ityw; *iterated y-w method;
*output out=minwage residual=ehat;
run;
