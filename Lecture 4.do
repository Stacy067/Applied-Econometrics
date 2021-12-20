/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (4)     */
/* Date : 2021-05-05                               */
/* Raw data : el2002practice.dta                   */
/*-------------------------------------------------*/

cd C:/Users/rlatj/Desktop/미분

use el2002practice.dta

reg li90w lfavgw i90age i90age2 fage fage2

test (i90age=1)(i90age2=0)(fage=0)(fage2=0)
test i90age i90age2 fage fage2

*do F test manually for omitted vars
scalar df_unrest=e(df_r)
scalar ssru=e(rss)
scalar list ssru df_unrest

reg li90w lfavgw
scalar ssrr=e(rss)
scalar df_rest=e(df_r)
scalar q=df_rest-df_unrest
scalar fstat=((ssrr-ssru)/q)(ssru/(df_unrest))
scalar crit_value=invFtail(q,df_unrest,.05)
scalar list fstat crit_value

**OVBias correction
reg li90w lfavgw farp i90age i90age2 fage fage2

**OVBias test
reg li90w lfavgw i90age i90age2 fage fage2
reg sonrw farw i90age i90age2 fage fage2

sureg(li90w lfavgw i90age i90age2 fage fage2)(sonrw farw i90age i90age2 fage fage2), corr small
test([li90w]_b[lfavgw]=[sonrw]_b[farw])

**EIV Bias
reg li90w li70w i90age i90age2 fage fage2

** EIV Bias correction
corr li70w li71w
eivreg li90w li70w i90age i90age2 fage fage2, r(li70w .805)


