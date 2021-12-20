/*----------------------------------------------------------*/
/* Statistics Class : Applied Econometrics (12-2)                             */
/* Date : 2021-07-11                                                                         */
/* Raw data : psm_example.dta, psm_example_prescreendind.dta */
/*----------------------------------------------------------*/

data practice_psm; *psm_example_prescreendind.dta;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/psm_example.dta'
out=practice_psm
replace;

proc ttest; *ols with non-random treatment;
class treat;
var infant_mor_rate;
run;

proc reg;
model infant_mor_rate=treat;
run;

proc reg;
model infant_mor_rate=treat pov_rate;
run;

proc reg;
model infant_mor_rate=treat percapita_doc;
run;

proc reg;
model infant_mor_rate=treat pov_rate precapita_doc;
run;

proc probit;
model treat=pov_rate percapita_doc;
output out=practice_psm p=Prob;
run;

proc psmatch region=allobs;
class treat;
psmodel=treat (Treated='1')=pov_rate percapita_doc;
match=method=replace(k=1) distance=ps caliper=.;
output out (obs=match)=OutEx4 ps=_Ps matchid=_MatchID;
run;

proc ttest data=OutEx4;
class treat;
var infant_mor_rate;
run;

**********************;

data practice_psm1;
proc import dbms=stata
datafile='C:/Users/rlatj/Desktop/미분/psm_example_prescreened_dind.dta'
out= practice_psm1
replace;

proc menas;
var;
run;

proc ttest; *ols with non-random treatment;
class treat;
var infant_mor_rate1;
run;

proc reg;
model infant_mor_rate1=treat;
run;

data practice_psm1;
set practice_psm1;
d_inf=infant_mor_rate2-infant_mor_rate1;
run;

proc reg;
model d_inf=treat;
run;

proc psmatch region=allobs;
class treat;
psmodel treat (Treated='1')=pov_rate percapita_doc;
match method=replace(k=1) distance=ps caliper=.;
output out (obs=match)=OutEx4 ps=_Ps matchid=_MatchID;
run;

proc ttest data=OutEx4;
class treat;
var infant_mor_rate2;
run;

