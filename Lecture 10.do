/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (10)    */
/* Date : 2021-05-05                               */
/* Raw data : grunfeld.dta, grunfeld2.dta          */
/*-------------------------------------------------*/

use 'C:/Users/rlatj/Desktop/미분/grunfeld.dta'

**select only GE and WE (two firms) and check for a pooled parameter
keep if(i==3|i==8)
gen d=(i==8)
gen dv=d*v
gen dk=d*k
reg inv d v dv k dk
test d dv dk

**do the previous test with heteroskedastic error
reg inv v k if i==3
scalar sse_ge=e(rss)
reg inv v k if i==8
scalr sse_we=e(rss)

**동일한 자유도로 GQ 계산에서 각각의 자유도 분모 생략
scalar GQ=sse_ge/sse_we
scalar fc95=invFtail(17, 17, .05)
display "GQ Test Stat ="GQ
display "F(17, 17, .05) ="fc95

**pooled test with heteroskedastic error
reg inv d v dv k dk, vce(robust)
test d dv dk

*다른 형태로
reg inv d v dv k dk, robust
test d dv dk

**do the same test with SUR (Use GLS part of EL (2002))
clear

use 'C:/Users/rlatj/Desktop/미분/grunfeld2.dta'

sureg(inv_ge v_ge k_ge)(inv_we v_we k_we), corr small
test([inv_ge]_cons=[inv_we]_cons)([inv_ge]_b[v_ge]=[inv_we]_b[v_we])([inv_ge]_b[k_ge]=[inv_we]_b[k_we])

**ordinary panel work
clear

use 'C:/Users/rlatj/Desktop/미분/grunfeld2.dta'

*alternatively, use xtreg, stpoisson
*xtreg inv v k, fe
*manually FE, FD, LD work
sort i
by i : egen invbar=mean(inv)
by i : egen vbar=mean(v)
by i : egen kbar=mean(k)

gen invd=inv-invbar
gen vd=v-vbar
gen kd=k-kbar

reg invd vd kd, noconstant

xtset i t

xtreg inv v k, fe

**check the results for F test all u_i=0
**verify re and cluster options are the same

xtreg inv v k, re
xtreg inv v k, cluster(i)

**do FD and LD works
*FD
reg d.inv d.v d.k
reg d.inv d.v d.k, vce(cluster i)
*LD
sum t, meanonly
gen time=t if t==r(min)|t==r(max)
tsset i time
reg d.inv d.v d.k, vce(cluster i`')




