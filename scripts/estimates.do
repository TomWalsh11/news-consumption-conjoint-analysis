clear all
use conjoint_data.dta, clear

encode outlet_headline, generate(outlet_headline1)
encode endorser_partisanship, generate(endorser_partisanship1)
encode endorser_gender, generate(endorser_gender1)
encode endorser_religiosity, generate(endorser_religiosity1)

drop outlet_headline endorser_partisanship endorser_gender endorser_religiosity

recode outlet_headline1 (7=1 "N") (6=2 "3R") (4=3 "2R") (2=4 "1R") (5=5 "3D") (3=6 "2D") (1=7 "1D"), gen(outlet_headline)
recode endorser_partisanship1 (2=1 "Independent") (3=2 "Republican") (1=3 "Democrat"), gen(endorser_partisanship)
recode endorser_gender1 (2=1 "Male") (1=2 "Female"), gen(endorser_gender)
recode endorser_religiosity1 (1=1 "Not Religious") (2=2 "Religious"), gen(endorser_religiosity)

drop outlet_headline1 endorser_partisanship1 endorser_gender1 endorser_religiosity1

* jadjust program grabs estimates and SEs from model and eliminates interaction terms
capture program drop jadjust
program def jadjust
capture matrix drop resmat
* get coefficients and SEs
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
* eliminate interactions terms
local namess : rownames coef
 foreach el of local namess {
   local include = regexm("`el'", "#")
   if "`include'" != "1" {
                    matrix getthis = coef["`el'",1..2]
                    matrix resmat = nullmat(resmat) \ getthis
            }
 }
end

** Figure 1: Analysis Normal **

foreach x of varlist outlet_headline endorser_partisanship endorser_gender endorser_religiosity  {
reg  chosen_article i.`x' , cl(id) 
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
mat2txt , matrix(resmat) saving(news_choice.txt) replace

* Table 1 - Main *

eststo: reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id)

esttab using Table_1.rtf, varwidth(30) se(2) ar2 b(2) star(* 0.05 ** 0.01 *** 0.001) label title("Dependent Variable: 1(article chosen)") modelwidth(11) onecell nogap nomtitles nodepvars nonumbers replace
eststo clear

** Figure 2: Analysis by Respondent Partisanship **

gen partyid = 1 if party == 1
replace partyid = 2 if party == 2

forvalues i = 1/2 {
reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if partyid==`i'
jadjust
mat2txt, matrix(resmat) saving(PartyID`i') replace
}

* Table 2 - Partisanship *

eststo: reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if partyid==1
eststo: reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if partyid==2

esttab using Table_2.rtf, varwidth(30) se(2) ar2 b(2) star(* 0.05 ** 0.01 *** 0.001) label title("Dependent Variable: 1(article chosen)") modelwidth(11) onecell nogap mlabels("Democrats" "Republicans") nodepvars nonumbers replace
eststo clear

** Figure 3: By Respondent Respondent Religiosity **

gen religiosity = 1 if religion == 9
replace religiosity = 2 if religion >= 1 & religion <= 8

forvalues i = 1/2 {
reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if religiosity==`i'
jadjust
mat2txt, matrix(resmat) saving(Religiosity`i') replace
}

* Table 3 - Religiosity *

eststo: reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if religiosity==1
eststo: reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if religiosity==2

esttab using Table_3.rtf, varwidth(30) se(2) ar2 b(2) star(* 0.05 ** 0.01 *** 0.001) label title("Dependent Variable: 1(article chosen)") modelwidth(11) onecell nogap mlabels("Not Religious" "Religious") nodepvars nonumbers replace
eststo clear

** Figure 4: Analysis by Respondent Gender **

encode gender, generate(gender1)
drop gender
recode gender1 (3=1 "Male") (2=2 "Female") (3=3 .), gen(gender)
drop gender1

forvalues i = 1/2 {
reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if gender==`i'
jadjust
mat2txt, matrix(resmat) saving(Gender`i') replace
}

* Table 4 - Gender *

eststo: reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if gender==1
eststo: reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if gender==2

esttab using Table_4.rtf, varwidth(30) se(2) ar2 b(2) star(* 0.05 ** 0.01 *** 0.001) label title("Dependent Variable: 1(article chosen)") modelwidth(11) onecell nogap mlabels("Male" "Female") nodepvars nonumbers replace
eststo clear

** Figure 5: Analysis for Independents **

gen independent = 1 if party == 3

forvalues i = 1/2 {
reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity if independent == 1, cl(id),
jadjust
mat2txt, matrix(resmat) saving(Independents.txt) replace
}

* Table 5 - Independents *

eststo: reg chosen_article i.outlet_headline i.endorser_partisanship i. endorser_gender i.endorser_religiosity, cl(id), if independent==1

esttab using Table_5.rtf, varwidth(30) se(2) ar2 b(2) star(* 0.05 ** 0.01 *** 0.001) label title("Dependent Variable: 1(article chosen)") modelwidth(11) onecell nogap nodepvars nonumbers replace
eststo clear
