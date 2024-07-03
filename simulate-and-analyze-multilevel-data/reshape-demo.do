* reshape demo

clear all

cd "/Users/agrogan/Desktop/GitHub/multilevel-thinking/simulate-and-analyze-multilevel-data/"

use "simulated_multilevel_longitudinal_data.dta", clear

reshape wide physical_punishment warmth outcome, i(id) j(t) 

save "simulated_multilevel_longitudinal_data_WIDE.dta", replace

* reshape long physical_punishment warmth outcome, i(id) j(t)




