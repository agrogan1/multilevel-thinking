**************************************************
* simulate cross sectional and multilevel data
**************************************************

* setup

clear all

set seed 3846

cd "/Users/agrogan/Desktop/GitHub/multilevel-thinking/simulate-and-analyze-multilevel-data"

* first let's make the country specific random effect(s)
* we'll need those in a bit

clear all

set obs 30 // 30 countries

generate country = _n // country id

generate u0 = rnormal(0, 1) // country specific random effect

generate u1 = rnormal(0, 1) // country specific random effect

save randomeffects.dta, replace

* build the initial data set

clear all

set obs 1000

generate id = _n

generate e = rnormal(0, 25) // normal error

generate v0 = rnormal(0, 5) // person specific random effect

generate x = rnormal(100, 10) // normal x

generate z = rnormal(100, 10) // normal z

generate country = runiformint(1,30) // country id is integer from 1 to 30

merge m:1 country using "randomeffects.dta" // get random effects

generate y = 5 * x + -3 * z + u0 + u1 * x + e // generate y

spagplot y x, id(country) scheme(s1color) // what does the data look like?

graph close _all

mixed y || country: // unconditional model

estat icc

mixed y x z || country: x // cross sectional MLM

* now make the data longitudinal

expand 3 // 3 timepoints per person

sort id // sort by id

by id: generate t = _n // generate time indicator

generate x_noise = rnormal(0, 10) // a little random noise

replace x = x + (t - 1) * 10  + x_noise // make x time varying

replace e = rnormal(0, 50) // new person time error term

replace y =  5 * x + -3 * z + 5 * t + u0 + u1 * x + v0 + e // replace y

mixed y || country: || id: // unconditional model

estat icc // ICC

mixed y x z t || country: || id: t // MLM

* save data

rename y outcome

rename x warmth

rename z physical_punishment

drop u0 u1 v0 e // drop error terms

drop _merge // drop merge indicator

save simulated_multilevel_longitudinal_data.dta, replace

keep if t == 1

drop t // drop time indicator for cross sectional data

save simulated_multilevel_data.dta, replace

********************
* analysis
********************

* simulated clustered data

use "simulated_clustered_data.dta", clear

rename x_individualA x

rename y_individualA y

regress y x

est store OLS

mixed y x || group_numA:

estat sd, variance post // post results as variance scale rather than log scale

est store MLM 

etable, estimates(OLS MLM) ///
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("tableA.md", as(markdown) replace)

estimates drop OLS MLM

* multilevel structure

use "multilevelstructure.dta", clear

regress y x 

est store OLS

mixed y x || country:

estat sd, variance post // post results as variance scale rather than log scale

est store MLM 

etable, estimates(OLS MLM) ///
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("tableB.md", as(markdown) replace)

estimates drop OLS MLM

* cross sectional

use "simulated_multilevel_data.dta", clear

mixed outcome warmth physical_punishment || country: warmth // multilevel model

estat sd, variance post // post results as variance scale rather than log scale

est store cross_sectional // store estimates

etable, estimates(cross_sectional) ///
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("table1.md", as(markdown) replace)

estimates drop cross_sectional

* longitudinal

use "simulated_multilevel_longitudinal_data.dta", clear

mixed outcome t warmth physical_punishment || country: warmth || id: t // multilevel model

estat sd, variance post // post results as variance scale rather than log scale

est store longitudinal // store estimates

etable, estimates(longitudinal) ///
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("table2.md", as(markdown) replace)

estimates drop longitudinal

* MLM, FE and CRE

use "simulated_multilevel_longitudinal_data.dta", clear

mixed outcome t warmth physical_punishment || id: // multilevel model

estat sd, variance post // post results as variance scale rather than log scale

est store MLM // store estimates

xtreg outcome t warmth physical_punishment, i(id) fe // FE model

est store FE

bysort id: egen mean_warmth = mean(warmth)

mixed outcome t warmth mean_warmth physical_punishment || id: // CRE model

estat sd, variance post // post results as variance scale rather than log scale

est store CRE // store estimates

etable, estimates(MLM FE) /// MLM & FE
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("table3.md", as(markdown) replace)

etable, estimates(MLM FE CRE) /// MLM, FE & CRE
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("table4.md", as(markdown) replace)

estimates drop MLM FE CRE

	
	
	
	