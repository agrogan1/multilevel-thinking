* code for more levels & cross classified chapter
* ML stands for more levels; CC stands for cross classified

*************************
* setup
*************************

clear

cd "/Users/agrogan/Desktop/GitHub/multilevel-thinking/simulate-and-analyze-multilevel-data"

*************************
* 4 level model
*************************

use simulated_multilevel_longitudinal_data.dta, clear // LONGITUDINAL DATA

*************************
* simulate UN Region
*************************

generate UNregion = runiformint(1,5) // 5 random UNregions

bysort country: replace UNregion = UNregion[1] // all obs in country same UNregion

replace outcome = outcome + UNregion - 2.5 // add a little bit of a "random effect"

*************************
* save data
*************************

save "fourlevel.dta", replace

*************************
* unconditional model
*************************

mixed outcome || UNregion: || country: || family:

estat icc

est store fourlevel0 // store estimates

etable, estimates(fourlevel0) ///
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("tableML0.md", as(markdown) replace)

estimates drop fourlevel0

*************************
* model w covariates
*************************

mixed outcome t warmth physical_punishment i.identity i.intervention HDI || UNregion: || country: || id: // multilevel model

est store fourlevel // store estimates

etable, estimates(fourlevel) ///
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("tableML1.md", as(markdown) replace)

estimates drop fourlevel

*************************
* cross classified model
*************************

use "simulated_multilevel_data.dta", clear // CROSS SECTIONAL DATA

***********************************
* simulate language group
***********************************

* generate language = runiformint(1,6) // 6 random UN languages

* replace outcome = outcome + (language - 3) // add a little bit of a "random effect"

generate language = runiformint(1,100) // 100 random languages

replace outcome = outcome + (language - 50)/25 // add a little bit of a "random effect"

*************************
* save data
*************************

save crossclassified.dta, replace

*************************
* unconditional model
*************************

mixed outcome || _all: R.country || _all: R.language

* estat icc

est store crossclassified0 // store estimates

etable, estimates(crossclassified0) ///
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("tableCC0.md", as(markdown) replace)

estimates drop crossclassified0

*************************
* model w covariates
*************************

mixed outcome warmth physical_punishment i.identity i.intervention HDI || _all: R.country || _all: R.language

est store crossclassified // store estimates

etable, estimates(crossclassified) ///
novarlabel /// variable names only
cstat(_r_b) /// beta's only
showstars showstarsnote ///
column(index) ///
export("tableCC1.md", as(markdown) replace)

estimates drop crossclassified




