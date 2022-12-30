*********************************************
*********************************************
* simulate and analyze multilevel data V.2
*********************************************
*********************************************

* based on a blog at 
* https://blog.stata.com/2014/07/18/how-to-simulate-multilevellongitudinal-data/

********************
* setup
********************

clear all

set seed 3846 // random seed

cd "/Users/agrogan/Desktop/GitHub/multilevel-thinking/simulate-and-analyze-multilevel-data"

********************
* simulate data
********************

clear all

set seed 3846 // random seed

set obs 30 // 30 countries

generate country = _n // country id

generate u_0i = rnormal(0, 2)

generate HDI = runiformint(30, 90)

* family level

expand 100 // families

bysort country: generate family = _n // family id

generate u_0ij = rnormal(0, 3) // random intercept

* event level

expand 3

bysort country family: generate t = _n // time point

generate e_ijt = rnormal(0, 5)

generate physical_punishment = runiformint(0, 5) 

generate warmth = runiformint(0, 7)

generate outcome = -1 * physical_punishment + ///
1 * warmth + ///  
1 * t + ///
u_0i + u_0ij + e_ijt

********************
* save data
********************

save simulated_multilevel_longitudinal_data.dta, replace

keep if t == 1 // only keep time 1 observation

drop t // drop time indicator for cross sectional data

save simulated_multilevel_data.dta, replace

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

* model w covariates

mixed outcome warmth physical_punishment HDI || country: warmth // multilevel model

estat sd, variance post // post results as variance scale rather than log scale

est store cross_sectional // store estimates

etable, estimates(cross_sectional) ///
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("table1.md", as(markdown) replace)

estimates drop cross_sectional

* cross sectional with unstructured covariance matrix

mixed outcome warmth physical_punishment HDI || country: warmth, cov(uns) // multilevel model

estat sd, variance post // post results as variance scale rather than log scale

est store cross_sectional2 // store estimates

etable, estimates(cross_sectional2) ///
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(estimates) ///
export("table1A.md", as(markdown) replace)

estimates drop cross_sectional2

********************
* longitudinal
********************

use simulated_multilevel_longitudinal_data.dta, clear

* unconditional model

mixed outcome || country: || family:

estat icc

* model w covariates

mixed outcome physical_punishment warmth HDI t || country: || family:



