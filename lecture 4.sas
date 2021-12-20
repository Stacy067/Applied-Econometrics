/*-------------------------------------------------*/
/* Statistics Class : Applied Econometrics (4)                  */
/* Date : 2021-05-05                                                         */
/* Raw data : incinerator.dta                                             */
/*-------------------------------------------------*/

OPTIONS LS=80;

DATA son_90(rename=(v30001=f_i_n v30002=s_p_n));
INFILE "C:/Users/rlatj/Desktop/미분/xxxxx.dat";
INPUT
V21601 1-3
V30806 4-8
.....................
;
LABEL
V21601="RELEASE NUMBER"
....................
V20178="TOTAL HEAD LABOR Y 90"
V20179="P TOT HD LAB Y 90 ACC>1"
V20187="HEAD 90 AVG HRLY EARNING"
.....................
V30001="1968 INTERVIEW NUMBER"
V30002="PERSON NUMBER"
V30003="RELATIONSHIP TO HEAD          68"
V30643="1990 SEQUENCE NUMBER        90"
V30645="AGE OF INDIVIDUAL                  90"
V30657="COMPLETED EDUC-IND           90"
V30686="CORE IND WEIGHT                   90"
V30690="SEQUENCE NUMBER                91"
V30692="AGE OF INDIVIDUAL                  91"
V30809="AGE OF INDIVIDUAL                  93"
V30820="G90 HIGHEST GRADE COMPLETED            93"
V32000="SEX OF INDIVIDUAL"
V32017="PERSON NUMBER OF FATHER"
;

if V30643 ne 1 then delete;
if V30001 ge 5000 then delete;
if V32000 ne 1 then delete;
if V30003 ne 3 then delete;
if V20179 ne 0 then delete;

IF V30645=0 THEN V30645=.; IF V30645=99 THEN V30645.;
i90age=V30645; i90age2=i90age**2;

if i90age ge 40 then delete;
if i90age le 24 then delete;
i90w=v20178; if i90w le 0 then i90w=.; li90w=log(i90w);
i90hw=i90w/v19044; li90hw=log(i90hw);

proc sort data=son_90;
by f_i_n s_p_n;
run;

DATA fa_68(rename=(V30001=f_i_n V30002=f_p_n));
INFILE "C:/Users/rlatj/Desktop/미분/yyyyy.dat" LRECL=263;
INPUT
V30117 1-4
...
;
LABEL
V30002="PERSON NUMBER"
V30004="AGE OF INDIVIDUAL             68"
V30010="YEARS OF SCHOOL COMPLETED           68"
V30019="INDIVIDUAL WEIGHT          68"
V30021="1969 SEQUENCE NUMBER"
...
V32000="SEX OF INDIVIDUAL"
;

if V30021 ne 1 then delete;
if V30001 ge 5000 then delete;
if V32000 ne 1 then delete;

IF V30004=0 THEN V30004=.;IF V30004=99 THEN V30004=.;

i68age=V30004;
i68age2=i68age**2

fedu=V30010;

i68w=v514; if i68w le 0 the i68w=.; li68w=log(i68w);
i68hw=v514/v465; li68hw=log(i68hw);

proc sort data=fa_68;
by f_i_n_f_p_n;
run;

data fa_son;
merge son_90 fa_68;
by f_i_n f_p_n;
run;

data fa_son;
merge son_90 fa_68;
by f_i_n f_p_n;
run;

proc reg data=fa_son;
model li90w=li68w i90age i90age2 i68age i68age2; 
run;



data new;
set fa_son;
file '/users/corr_90.dat';
put li90w 10.6 +1 li90h2 10.6 +1 i90age 10.6 +1 i90age2 10.6 +1 V18892  10.6 +1 V18889 10.6 +1 favgw  10.6 +1 lfavghw 10.6 +1 favgw 10.6 +1 fage 10.6 +1 fage2 10.6 +1 V95 10.6 +1 V361 10.6 +1 ;
run;

data corr;
infile 'corr_90.dat';
input
li90w li90hw i90w i90age i90age2 V18892 V18889 lfavgw lfavghw favgw fage fage2 V95 V361;

sonw=li90W; farw=lfavgw;

if V18889=1 then reg91=1; if V18889=2 then reg91=10;
if V18889=3 then reg91=100; if V18889 in(4, 5) then reg91=1000;
if V18892 ge 5 then m91=4; if V18892=4 then m91=3;
if V18892=3 then m91=2; if V18892 in (1,2) then m91=1;

if V18892 le 4 then i90metro=1; else i90metro=0;
if V95 le 3 then i68metro=1; else i68metro=0;

reg_m91=reg91*m91;

alpha91=0.25;/*use median cost-of-housing index*/

if reg_m91=1 then sonrw=sonw-log(1.2907**alpha91);
if reg_m91=10 then sonrw=sonw-log(1.1079**alpha91);
if reg_m91=100 then sonrw=sonw-log(1.1098**alpha91);
if reg_m91=1000 then sonrw=sonw-log(1.3065**alpha91);
....
if reg_m68=1 then farrw=farw-log(pd_ne*1.2907**alpha91);
if reg_m68=10 then farrw=farw-log(pd_nc*1.1079**alpha91);
if reg_m68=100 then farrw=farw-log(pd_s*1.1098**alpha91);
if reg_m68=1000 then farrw=farw-log(pd_w*1.3065**alpha91);
....
sonp=sonw-sonrw; farp=farw-farrw;

proc reg;
model sonw=farw farp i90age i90age2 fage fage2;
run;
