/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (6-1)   */
/* Date : 2021-05-05                               */
/* Raw data : cyrect.dta                           */
/*-------------------------------------------------*/

ren col1 c
ren col2 y
gen z=y-c

reg c y-c

*2 stage LS
reg y z
predict yhat
reg c yhat

**ILS
reg c z

*IV reg, compare SE of beta 1 with the 2SLS one
ivreg c (y=z)

*hausman test
reg c y
estimates store ols
ivreg c (y=z)
estimates store iv
hausman iv ols