* Load the datasets
drop _all
use "AttanasioEtAl2011Vector.dta", clear

* Check key variables in the vector dataset
describe

* Save a temporary copy of this dataset to merge later
save "vector_temp.dta", replace

* Load the dyadic dataset
use "AttanasioEtAl2011Dyadic.dta", clear

describe

* Merge dyadic dataset with the vector dataset
merge m:1 iid using "vector_temp.dta"

* Check the merge result
assert _merge == 3

* Drop unnecessary merge indicator variable
drop _merge

* Explore the defection variable in Round 2
summarize defaultw2 renegade

* Basic descriptive statistics for key predictors
summarize difchoice1 friendfamily difwin1 female yage ysch

* Logistic regression for defection
gen defection = defaultw2 if !missing(defaultw2)

logit defection difchoice1 friendfamily difwin1 female yage ysch

* Interaction terms to test heterogeneous effects
gen risk_ties = difchoice1 * friendfamily
logit defection difchoice1 friendfamily difwin1 female yage ysch risk_ties

* Robustness check with municipality fixed effects
xi: logit defection difchoice1 friendfamily difwin1 female yage ysch i.municode

* Marginal effects after the logistic regression
margins, dydx(*)

* Visualize predicted probabilities
marginsplot

* Clean up temporary files
erase "vector_temp.dta"
