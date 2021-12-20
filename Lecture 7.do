/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (7)     */
/* Date : 2021-05-05                               */
/* Raw data : rts_location.dta                     */
/*-------------------------------------------------*/

cd C:/Users/rlatj/Desktop/미분

use rts_location.dta, clear

ttest lnw, by(u) une

reg lnw une

graph box lnw, over(u)

gen s_u=s*u
reg lnw s u s_u
test u s_u

*GQ test
reg lnw u if u==0
scalar rmse_rural=e(rmse)
scalar df_rural=e(df_r)

reg lnw u if u==1
scalar rmse_urban=e(rmse)
scalar df_urban=e(df_r)

scalar list rmse_rural df_rural rmse_urban df_urban

scalar GQ=rmse_urban^2/rmse_rural^2
scalar crit=invFtail(df_urban, df_rural, .05)
scalar pvalue=Ftail(df_urban, df_rural, GQ)
scalar list GQ crit pvalue

*WLS correction
gen wt=rmse_urban^2*u+rmse_rural^2*(1-u)
reg lnw u [aweight=1/wt]

*White test
reg lnw u
predict ehat, resid
gen lnehat2=log(ehat*ehat)
gen s2=s^2
reg lnehat2 s s2

*NR square is chi square dist, 2 var (s and s2)
scalar LM=e(N)*e(r2)
scalar pvalue=chi2tail(2, LM)
scalar list LM pvalue

predict lnsig2, xb
gen wt_white=exp(lnsig2)

reg lnw u [aweight=1/wt_white]

*Heteroskedastic error correction
reg lnw u, vce(robust)

