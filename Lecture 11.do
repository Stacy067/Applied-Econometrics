/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (11)    */
/* Date : 2021-05-18                               */
/* Raw data : ms_exercise.dta                      */
/*-------------------------------------------------*/

use ms_exercise.dta, clear

sort fid year

**age restriction;
drop if hage>65
drop if wage>65

drop if fd_sh<0.05 | fd_sh>.80
*drop if fd_sh<0.01 | fd_sh>.99

**check for proper fd_sh(Table 1)
sum fd_sh real_inc se
by se: sum fe_sh real_inc

**pooled ols PW
xi: ivregress 2sls fd_sh se (real_inc=hedu wedu) hage hage2 wage wage2 n15a p_f_nf hwkt wwkt nfmem i.loc i.year

**augmented reg endogeneity test for real_inc;
reg real_inc hedu wedu
predict real_inchat
gen e=real_inc-real_inchat
xi: reg fd_sh real_inc se hage hage2 wage wage2 n15ap_f_nf hwkt wwkt nfmem i.year i.loc e

**making interval PW estimates
xi: reg fd_sh real_inc se hage hage2 wage wage2 n15ap_f_nf hwkt wwkt nfmem i.year if se==1
scalar sigma2_ee=(e(rmse)^2(

**panel (BE) approach
egen bmyself=sum(se), by(fid)
gen be_se=(bmyself>0)

**alternatively,
bys fid: gen be_se_most_restricted(MN==bmyself)

**balanced or not
bys fid: gen balanced=(_N==6)
keep if balanced==1

**BE with two-step (no IV)
xtset fid year

*Step 1
qui xi: xtreg fd_sh real_inc n15a hage hage2 wage wage2 hedu wedu p_f_nf hwkt wwkt nfmem i.year i.loc if be_se==0, be
scalar beta=_b[real_inc]
gen new_fd_sh=fd_sh-_b[real_inc]*real_inc

*Step 2
qui xi: xtreg new_fd_sh be_se n15a hage hage2 wage wage2 hedu wedu p_f_nf hwkt wwkt nfmem i.year i.loc if be
nlcom exp(_b[be_se]/beta)
nlcom_b[be_se]/beta

**calculate lnkbar estimate
**making interval PW estimates
qui xi: xtreg real_inc n15a hedu hwkt wwkt wedu hage hage2 wage wage2 nfmem i.loc i.year if be_se==1, be
scalar be_sigma2_ee(e(rmse)^2)
 