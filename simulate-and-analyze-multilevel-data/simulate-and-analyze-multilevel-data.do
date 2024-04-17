************************************************************
* analyze data for p value and multilevel structure examples
************************************************************

********************
* setup
********************

clear all

set seed 3846 // random seed

cd "/Users/agrogan/Desktop/GitHub/multilevel-thinking/simulate-and-analyze-multilevel-data"

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
