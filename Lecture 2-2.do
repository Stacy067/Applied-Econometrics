/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (2-2)   */
/* Date : 2021-05-05                               */
/* Raw data : incinerator.dta                      */
/*-------------------------------------------------*/

use "C:\Users\rlatj\Desktop\미분\incinerator.dta" 

rename var1 y
rename var2 x

reg y x

predict yhat

list x yhat in 1

set obs 6
replace x = 1 in 6
set obs 6
replace x = 1 in 6
predict yhat
list x yhat in 6

save 5obs_ex.dta