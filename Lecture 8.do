/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (8)     */
/* Date : 2021-05-05                               */
/* Raw data : minwage.dta                          */
/*-------------------------------------------------*/

use minwage.dta, clear

rename col1 t
rename col2 emp
rename col3 upr
rename col4 tsq
rename col5 afp
rename col6 pop
rename col7 trp
rename col8 yk
rename col9 sy
rename col10 q2
rename col11 q3 
rename col12 q4

gen lemp=log(emp)
gen lupr=log(upr)
gen lpop=log(pop)
gen lyk=log(yk)

tsset t

reg lemp lyk t tsq q2 q3 q4 lupr sy afp trp lpop

predict ehat, residual

twoway (scatter ehat t)

corrgram ehat, lags(8)

estat dwatson

prais lemp lyk t tsq q2 q3 q4 lupr sy afp trp lpop

prais lemp lyk t tsq q2 q3 q4 lupr sy afp trp lpop, twoway

*Cochrane-Orcutt(drop 1st obs, rho differencing)
prais lemp lyk t tsq q2 q3 q4 lupr sy afp trp lpop, corc

