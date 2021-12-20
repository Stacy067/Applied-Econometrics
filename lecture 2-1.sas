/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (2-1)               */
/* Date : 2021-05-05                                                         */
/* Raw data : incinerator.dta                                             */
/*-------------------------------------------------*/

data proctice0; *use stata data file;

proc import dbms=stata 
datafile='C:/Users/rlatj/Desktop/미분/incinerator.dta'
out=procatice0
replace; *window 접근방식;

proc means data=practice0; *summary stats;
var;
run;

proc plot data=practice0; *scatter diagram for checking;
plot houseprice*nearinc='+'; *less effective figure-> use boxplot after sorting;
where y81=1;
run;

proc sort data=practice0;
by nearinc;
run;

proc univariate; *to understand the above boxplot;
var houseprice;
class nearinc;
where y81=1;

proc ttest; *use test procedure;
var houseprice;
class nearinc;
where y81=1;
run;

proc reg; *use a resgression;
model houseprice=nearinc;
where y81=1;
run; *simple linear reg with a binary x;

proc ttest; *check for initial diff;
var houseprice;
class nearinc;
where y81=0;
run;
