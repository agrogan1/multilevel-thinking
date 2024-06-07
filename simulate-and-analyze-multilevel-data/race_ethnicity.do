* Stata commands for data on race and ethnicity

* data set 1

clear all

set seed 3846

set obs 100

generate id = _n

generate outcome = rnormal(100, 10)

generate race = runiformint(1, 6)

generate latino = runiformint(0, 1)

generate country = runiformint(1, 30)

save race_ethnicity.dta, replace

clear all

* data set 2

clear all

set seed 3846

set obs 100

generate id = _n

generate outcome = rnormal(100, 10)

foreach i of numlist 1/6 {
	
	generate race`i' = rbinomial(1, .3) // generate each race
	
}

replace race2 = 1 if race1 + race2 + race3 + race4 + race5 == 0 // make race2 = 1 if all races == 0

generate latino = runiformint(0, 1)

generate country = runiformint(1, 30)

save race_ethnicity2.dta, replace






