****************************************
* Stata graphs for "Multilevel Thinking"
****************************************

clear all

cd "/Users/agrogan/Desktop/GitHub/multilevel-thinking/simulate-and-analyze-multilevel-data"

******************************
* simulated multilevel data
******************************

use "simulated_multilevel_data.dta", clear

spagplot outcome warmth, id(country) ///
title("Desirable Mental Health Outcome by Parental Warmth") ///
subtitle("By Country") ///
note("Simulated Data") ///
xtitle("parental warmth") ///
ytitle("desirable mental health outcome") ///
name("figdata", replace) ///
scheme(cblind1) 

* graph export "../multilevel-concept-paper/fig-data.svg", as(svg) name("figdata") replace

* graph export "../multilevel-concept-paperfig-data.png", as(png) name("figdata") replace

* ![Graph of Simulated Data](fig-data.png){#fig-test}
* figures will need to be in the same folder as the *.qmd file

******************************
* multilevel structure
******************************

use "multilevelstructure.dta", clear

twoway (scatter y x) ///
(lfit y x, lwidth(thick)), ///
title("y as a function of x") ///
scheme(cblind1) ///
name(fignaive, replace)

twoway (scatter y x if country ==1) ///
(scatter y x if country == 2) ///
(scatter y x if country == 3) ///
(lfit y x if country == 1) ///
(lfit y x if country == 2) ///
(lfit y x if country == 3), ///
title("y as a function of x") ///
legend(order(- "country:" 1 "1" 2 "2" 3 "3") col(1)) ///
scheme(cblind1) ///
name(figaware, replace)

******************************
* sources of variation
******************************

clear all

set obs 1000

forvalues i = 1/30 { 
	
	di `i'
	
	scalar i`i' = `i'
	
	scalar s`i' = `i'
}

generate x = rnormal(.5, .10)

twoway (function y = i1 + s1* x) ///
(function y = i2 + s2* x) ///
(function y = i3 + s3* x) ///
(function y = i4 + s4* x) ///
(function y = i5 + s5* x) ///
(function y = i6 + s6* x) ///
(function y = i7 + s7* x) ///
(function y = i8 + s8* x) ///
(function y = i9 + s9* x) ///
(function y = i10 + s10* x) ///
(function y = i11 + s11* x) ///
(function y = i12 + s12* x) ///
(function y = i13 + s13* x) ///
(function y = i14 + s14* x) ///
(function y = i15 + s15* x) ///
(function y = i16 + s16* x) ///
(function y = i17 + s17* x) ///
(function y = i18 + s18* x) ///
(function y = i19 + s19* x) ///
(function y = i20 + s20* x) ///
(function y = i21 + s21* x) ///
(function y = i22 + s22* x) ///
(function y = i23 + s23* x) ///
(function y = i24 + s24* x) ///
(function y = i25 + s25* x) ///
(function y = i26 + s26* x) ///
(function y = i27 + s27* x) ///
(function y = i28 + s28* x) ///
(function y = i29 + s29* x) ///
(function y = i30 + s30* x), ///
text(1 .01 "variation in intercept", orientation(vertical) placement(north) box  margin(l+1 t+1 b+1 r+1) fcolor(gs15)) ///
text(40 .4 "variation in slope", box margin(l+1 t+1 b+1) fcolor(gs15)) ///
text(5 .5 "{&larr} {&larr} {&larr} variation in x {&rarr} {&rarr} {&rarr}", box margin(l+1 t+1 b+1) fcolor(gs15)) ///
legend(off) ///
title("Sources of Variation") ///
subtitle("In a Multilevel Model") ///
xtitle("x") ///
scheme(cblind1) ///
name(variation1, replace)

*********************************************
* simulated multilevel longitudinal data
*********************************************

use "simulated_multilevel_longitudinal_data.dta", clear

keep if id <= 10

spagplot outcome t, id(id) ///
title("Desirable Mental Health Outcome by Time") ///
subtitle("By Individual") ///
note("Simulated Data; Selected Individuals") ///
xtitle("time") ///
ytitle("desirable mental health outcome") ///
name("figdata2", replace) ///
scheme(cblind1) 








