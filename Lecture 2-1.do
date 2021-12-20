/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (2-1)    */
/* Date : 2021-05-05                               */
/* Raw data : incinerator.dta                      */
/*-------------------------------------------------*/

use "C:\Users\rlatj\Desktop\미분\incinerator.dta" 
sum houseprice nearinc y81
twoway scatter houseprice nearinc if y81==1
twoway (scatter houseprice nearinc) (lfit houseprice nearinc), title(Fitted Regression Line)
keep if y81==1
graph box houseprice, over(nearinc) nooutside ytitle("HP") subtitle("") note("Two areas, box-plot represents the 25th, 50th, and 75th percentile")
clear
use "C:\Users\rlatj\Desktop\미분\incinerator.dta" 
gen hp_near=houseprice if nearinc==1 & y81==1
gen hp_notnear=houseprice if nearinc==0 & y81==1
ttest hp_near=hp_notnear, unp une
ttest hp_near=hp_notnear, unp
reg houseprice nearinc if y81==1
reg houseprice nearinc if y81==0
gen nearincy81=nearinc*y81
reg houseprice nearinc y81 nearincy81
