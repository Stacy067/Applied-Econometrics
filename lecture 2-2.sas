/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (2-2)               */
/* Date : 2021-05-05                                                         */
/* Raw data : incinerator.dta                                             */
/*-------------------------------------------------*/

data practice2;
input y x;
datalines;
*cards;
2 -1
0 0
2 -1
2 0
-1 2
. 1
;

proc reg;
model y=x/P;

*model y= x/covb;
*model y= x/R P noprint;
output out=practice2new P=yhat;
run;

proc print data=practice2new (first0bs=5 obs=6);
var x y yhat;
run;
