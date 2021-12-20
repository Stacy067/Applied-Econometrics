/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (9)     */
/* Date : 2021-05-05                               */
/* Raw data : am_panel.dta                         */
/*-------------------------------------------------*/

iis hhid
tis time

reg ltexp lsize headsch
xreg ltexp lsize headsch, re

xtreg ltexp lsize headsch, fe

reg ltexp lsize headsch, fe

reg ltexp lsize headsch d*, nonconstant

tab hhid, gen(d)

reshape wide ltexp lsize headsch, i(hhid) j(time)
gen dltexp=ltexp2-ltexp1
gen dlsize=lsize2-lsize1

reg dltexp dlsize, nonconstant

reshape long ltexp lsize headsch, i(hhid) j(time)

*Hausman test
reshape long ltexp lsize headsch, i(hhid) j(time)
xtreg ltexp lsize, fe
estimates store fe
xtreg ltexp lsize, re
estimates store re
hausman fe reg

*EIV reg
reshape wide ltexp lsize headsch, i(hhid) j(time)
corr lsize2 lsize1
eivreg ltexp2 lsize2, r(lsize2 .774)
