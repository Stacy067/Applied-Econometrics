/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (6-2)   */
/* Date : 2021-05-05                               */
/* Raw data : truffles.dta                         */
/*-------------------------------------------------*/

use truffles.dta, clear
sum
*demand slope
reg q p di ps
ivreg q (p=pf) di ps

*supply slope
ivreg q (p=di) pf
ivreg q (p=ps) pf
ivreg q (p=di ps) pf

reg p pf di ps
predict phat
reg q phat di ps

*demand slope Hausman test
reg p pf
predict ehat, resid
reg q p di ps ehat
test ehat=0

**overid
ivregress 2sls q (p=di ps) pf
estat firstage
estat endogenous
estat overid