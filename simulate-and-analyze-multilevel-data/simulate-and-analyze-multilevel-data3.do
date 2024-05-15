*********************************************
*********************************************
* simulate and analyze multilevel data V.2
*********************************************
*********************************************

* based on a blog at 
* https://blog.stata.com/2014/07/18/how-to-simulate-multilevellongitudinal-data/
* Spring 2024: updated after Reviews by Oxford university Press

********************
* setup
********************

clear all

set seed 3846 // random seed

cd "/Users/agrogan/Desktop/GitHub/multilevel-thinking/simulate-and-analyze-multilevel-data"

********************
* simulate data
********************

* setup

clear all

set seed 3846 // random seed

set obs 30 // 30 countries

* country level

generate country = _n // country id

generate u_0i = rnormal(0, 2)

generate HDI = runiformint(30, 90)

* family level

expand 100 // families

bysort country: generate family = _n // family id

egen id = concat(country family), punct(.) // unique id for families across countries

generate u_0ij = rnormal(0, 3) // random intercept

* ... at the family level ...

generate mean_warmth = runiformint(2, 7) // different levels of mean warmth

generate mean_physicalpunishment = runiformint(2, 5) // different levels of mean physical_punishment

generate identity = runiformint(0, 1) // randomly distributed identity group

generate intervention = runiformint(0, 1) // randomly distributed intervention

* event level

expand 3

bysort country family: generate t = _n // time point

generate e_ijt = rnormal(0, 5)

generate physical_punishment = mean_physicalpunishment - runiformint(0, 2) // physical_punishment

generate warmth = mean_warmth - runiformint(0, 2) // warmth

generate outcome = 50 + ///
-1 * physical_punishment + ///
1 * warmth + /// 
1 * intervention + /// 
1 * t + ///
u_0i + u_0ij + e_ijt

* labels

label variable warmth "parental warmth in past week"

label variable physical_punishment "physical punishment in past week"

label variable HDI "Human Development Index"

label variable identity "hypothetical identity group variable"

label variable intervention "recieved intervention"

label variable country "country id"

label variable family "family id"

label variable id "unique country family id"

label variable t "time"

label variable outcome "beneficial outcome"

********************
* save data
********************

* longitudinal data

drop mean_warmth mean_physicalpunishment u_0i u_0ij e_ijt

save simulated_multilevel_longitudinal_data.dta, replace

* cross sectional data

keep if t == 1 // only keep time 1 observation

drop t // drop time indicator for cross sectional data

save simulated_multilevel_data.dta, replace

* export to other formats

export excel using "simulated_multilevel_data.xlsx", firstrow(variables) replace // Excel

export spss using "simulated_multilevel_data.sav", replace // SPSS

********************
* analysis
********************

********************
* cross sectional
********************

use simulated_multilevel_data.dta, clear

* unconditional model

mixed outcome || country: 

estat icc

* estat sd, variance post // post results as variance scale rather than log scale

est store cross_sectional0 // store estimates

etable, estimates(cross_sectional0) ///
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("table0.md", as(markdown) replace)

estimates drop cross_sectional0

* model w covariates

mixed outcome warmth physical_punishment i.identity i.intervention HDI || country: warmth // multilevel model

* estat sd, variance post // post results as variance scale rather than log scale

est store cross_sectional // store estimates

etable, estimates(cross_sectional) ///
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("table1.md", as(markdown) replace)

estimates drop cross_sectional

* cross sectional with unstructured covariance matrix

mixed outcome warmth physical_punishment i.identity i.intervention HDI || country: warmth, cov(uns) // multilevel model

* estat sd, variance post // post results as variance scale rather than log scale

est store cross_sectional2 // store estimates

etable, estimates(cross_sectional2) ///
novarlabel /// variable names only 
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("table1A.md", as(markdown) replace)

estimates drop cross_sectional2

* within and between

egen gmean_warmth = mean(warmth) // grand mean

bysort country: egen cmean_warmth = mean(warmth) // country specific means

generate dev_warmth = warmth - cmean_warmth // deviation from country specific means

generate cdev_warmth = cmean_warmth - gmean_warmth // deviation from grand mean

mixed outcome dev_warmth cdev_warmth physical_punishment i.identity i.intervention HDI || country: warmth // multilevel model

* estat sd, variance post // post results as variance scale rather than log scale

est store cross_sectional3 // store estimates

etable, estimates(cross_sectional3) ///
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("table1B.md", as(markdown) replace)

estimates drop cross_sectional3

drop gmean_warmth cmean_warmth dev_warmth cdev_warmth

********************
* longitudinal
********************

use simulated_multilevel_longitudinal_data.dta, clear

* unconditional model

mixed outcome || country: || family:

estat icc

* model w covariates

mixed outcome t warmth physical_punishment i.identity i.intervention HDI || country: warmth || id: t // multilevel model

* estat sd, variance post // post results as variance scale rather than log scale

est store longitudinal // store estimates

etable, estimates(longitudinal) ///
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("table2.md", as(markdown) replace)

estimates drop longitudinal

* model w covariates and interactions

mixed outcome c.t##(c.warmth c.physical_punishment i.identity i.intervention c.HDI) || country: warmth || id: t // multilevel model

* estat sd, variance post // post results as variance scale rather than log scale

est store longitudinalB // store estimates

etable, estimates(longitudinalB) ///
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("table2B.md", as(markdown) replace)

estimates drop longitudinalB


* MLM, FE and CRE

mixed outcome t warmth physical_punishment i.identity i.intervention HDI || id: // multilevel model

* estat sd, variance post // post results as variance scale rather than log scale

est store MLM // store estimates

encode id, generate(idNUMERIC) // numeric version of id for FE

xtreg outcome t warmth physical_punishment i.identity i.intervention HDI, i(idNUMERIC) fe // FE model

est store FE

bysort id: egen mean_warmth = mean(warmth)

bysort id: egen mean_physicalpunishment = mean(physical_punishment)

mixed outcome t warmth mean_warmth physical_punishment mean_physicalpunishment i.identity i.intervention HDI || idNUMERIC: // CRE model

* estat sd, variance post // post results as variance scale rather than log scale

est store CRE // store estimates

etable, estimates(MLM FE) /// MLM & FE
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("table3.md", as(markdown) replace)

etable, estimates(MLM FE CRE) /// MLM, FE & CRE
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("table4.md", as(markdown) replace)

estimates drop MLM FE CRE

	
