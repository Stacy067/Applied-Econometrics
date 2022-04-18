/*---------------------------------------------------------------*/
/* Statistics Class : Applied Econometrics (13)                  */
/* Date : 2021-07-11                                             */
/* Raw data : mroz.dta, cig_tax_databank.dta, metro_wage_gap.dta */
/*---------------------------------------------------------------*/


**********************
use mroz.dta
sum
*By selection, we only observe n(=428)(<N=753) for wage equation, lfp is a binary dep for participation or selection

gen lwage=log(wage)
reg lwage educ exper if hours>0

*make a var for kids presence, women's lfp would be determined by age, exper, kids, mtr(marginal tax) for reservation wage

gen kids=(kids16+kids618>0)

**step 1
probit lfp age educ kids mtr

*make imr variable
predict w, xb
gen imr=normalden(w)/normal(w)

**step 2
reg lwage educ exper imr

*use heckman command
heckman lwage educ exper, select(lfp=age educ kids mtr) twostep


**************************
*Cigarette Tax, Quality-adjusted price method 
use cig_tax_databank.dta, clear

qui summ wcig
scalar x_cig=r(mean)


*CW+Heckman-Lee

gen d_cig=(luvcig~=.)
sum d_cig
probit d_cig ltexp lnhhs rf06 rm06 rf714 rm714 rf1550 rm1550 rf51 headage femhead headread wagebis urban cond_exp
predict d_cighat, xb
gen pdfd_cighat=normalden(d_cighat)
gen cdfd_cighat=normalprob(d_cighat)
gen imrd_cighat=pdfd_cighat/cdfd_cighat

areg luvcig ltexp lnhhs rf06 rm06 rf714 rm714 rf1550 rm1550 rf51 headage femhead headread wagebis urban cond_exp
imrd_cighat, absorb(cluster1)
predict luvcig_hat1,dre

reg wcig luvcig_hat1 ltexp lnhhs rf06 rm06 rf714 rm714 rf1550 rm1550 rf51 headage femhead headread wagebis urban cond_exp


*************************
*FE+Selection Bias, metro wage gap

use metro_wage_gap.dta, clear

xtreg wage m ne nc west race edud1 edud2 edud3 edud4 edud5 exp, fe
estimates store fe
xtreg wage m ne nc west race edud1 edud2 edud3 edud4 edud5 exp, re
estimates store re
hausman re

*Selection Bias

probit m ne nc west race edud* exp exp2
predict w, xb
gen imr_m=normalden(w)/normal(w)
gen imr_n=normalden(w)/(1-normal(w))

gen lambda=m*imr_m-(1-m)*imr_n
reg wage m ne nc west race edud* exp exp2 lambda



 

