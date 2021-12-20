/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (6-1)   */
/* Date : 2021-05-05                               */
/* Raw data : morz.dta                             */
/*-------------------------------------------------*/

use mroz.dta, clear
gen lwage=log(wage)
reg lwage educ exper
ivregress 2sls lwage (educ=mothereduc fathereduc) exper
estat firststage
estat endogenous
estat overid