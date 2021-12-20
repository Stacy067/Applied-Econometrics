/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (3-1)   */
/* Date : 2021-05-05                               */
/* Raw data : dind_Kim2009.dta                      */
/*-------------------------------------------------*/

cd C:/users/rlatj/Desktop/미분
use dind_Kim2009.dta

sum lhwage metro col t

gen metro_col=metro*col
gen metro_t=metro*t
gen col_t=col*t
gen metro_col_t=metro*col*t

reg lhwage col if t==0
reg lhwage col if t==1
reg lhwage col t col_t
reg lhwage col t col_t if metro==1
reg lhwage col t col_t if metro==0
reg lhwage col t metro col_t metro_t metro_col metro_col_t