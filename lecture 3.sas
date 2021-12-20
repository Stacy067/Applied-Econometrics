/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (3)                  */
/* DinDinD Practice                                                           */
/* Date : 2021-05-05                                                         */
/* Raw data : dind_Kim2009.dta                                        */
/*-------------------------------------------------*/

data practice4;

proc import dbms=stata
datafile = 'C:/Users/rlatj/Desktop/ЙЬКа/dind_Kim2009.dta'
out = practice4
replace;

data practice4;
set practice4;
metro_col=metro*col;
metro_t=metro*t;
col_t=col*t;
metro_col_t=metro*col*t;
run;

proc sort;
by metro;
run;

proc reg;
model lhwage = col t col_t;
where metro=1;
run;

proc reg;
model lhwage=col t col_t metro metro_t metro_col metro_col_t/covb;
run;
