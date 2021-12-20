/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (12)    */
/* Date : 2021-07-11                               */
/* Raw data : playball_modified.dta, mroz.dta      */
/*-------------------------------------------------*/

*Arbitration, labor Supply Decision

use playball_modified.dta
gen indvar1=0.5*log(poffer)+log(moffer))
gen indvar2=runs+rbi
gen indvar3=hits/atbats

probit y d75 d79 d80 d81 d83 d84 indvar1 indvar2 indvar3
*marginal effect
mfx
*get marginal effects directly
dprobit y d75 d79 d80 d81 d83 d84 indvar1 indvar2 indvar3

*test for a fair decision rule
gen lpoffer=log(poffer)
gen lmoffer=log(moffer)
probit y d75 d79 d80 d81 d83 d84 indvar1 indvar2 indvar3
test lpoffer=lmoffer

**LR test
probit y d75 d80 d81 d83 d84 indvar1 indvar2 indvar3
estimates store res
probit y d75 d80 d81 d83 d84 lpoffer lmoffer indvar2 indvar3
estimates store unres
lrtest res unres
logit y d75 d80 d81 d83 d84 indvar1 indvar2 indvar3
mfx


