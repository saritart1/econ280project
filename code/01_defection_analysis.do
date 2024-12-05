/*******************************************************************************
  Project:   Econ280 replication project  

  Title:          01_defection_analysis
  Author:         Sara Restrepo
  Date:           December 2024
  Version:        Stata 18
  Resume:         THis code creates an extension of the paper
  Paper:          Risk Pooling, Risk Preferences, and Social Networks
				  Orazio Attanasio, Abigail Barr, Juan Camilo Cardenas, Garance Genicot, and Costas Meghir
				  American Economic Journal: Applied Economics 2012
  Link to data:   https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/16OAH0
  Notes:		  I do a defection behavior analysis (participants forming risk-sharing groups but then opting out after the outcomes of their individual gambles are revealed)

*******************************************************************************/

clear
set matsize 300
set mem 500m
set more off

************************************************
**#            0. Key Macros                   *
************************************************

*Folder globals

di "current user: `c(username)'"


if "`c(username)'" == "sararestrepotamayo"{
	global path "/Users/sararestrepotamayo/Documents/GitHub/econ280project"
}
if "`c(username)'" == "YOUR_USER_NAME"{
	global path "YOUR_PATH_TO_FOLDER"
}

************************************************
**#            1. Replication                  *
************************************************

use "$path/data/raw/AttanasioEtAl2011Vector.dta", clear

	keep renegade female yage ysch married tcons lcons survhhsz familyoutdeg friendsoutdeg iid

	tempfile vector_temp
	save `vector_temp'	
rename iid iida
	tempfile vector_temp_a
	save `vector_temp_a'	
use `vector_temp', clear
rename iid iidb
	tempfile vector_temp_b
	save `vector_temp_b'

use "$path/data/raw/AttanasioEtAl2011Dyadic.dta", clear

* Merging jugadora

merge m:1 iida using `vector_temp_a', nogen

rename (renegade female yage ysch married tcons lcons survhhsz familyoutdeg friendsoutdeg) (renegade_a female_a yage_a ysch_a married_a tcons_a lcons_a survhhsz_a familyoutdeg_a friendsoutdeg_a)


merge m:1 iidb using `vector_temp_b', nogen

rename (renegade female yage ysch married tcons lcons survhhsz familyoutdeg friendsoutdeg) (renegade_b female_b yage_b ysch_b married_b tcons_b lcons_b survhhsz_b familyoutdeg_b friendsoutdeg_b)

summarize renegade_a renegade_b female_a female_b yage_a yage_b ysch_a ysch_b

* Create dyadic variables (differences between jugadora and jugadorb)
rename difyage age_diff 
rename difysch education_diff
gen income_diff = abs(lcons_a - lcons_b)

* Summarize new variables
summarize age_diff education_diff income_diff

*Relabelling
label var female_a "Player A female"
label var female_b "Player B female"
label var income_diff "Difference in income"
label var renegade_a "Befection Behavior"
gen female_interaction = female_a * female_b
label var female_interaction "Both female"


* Clear any previous stored models
eststo clear

logit renegade_a difchoice1 age_diff education_diff income_diff friendfamily female_a female_b
margins, dydx(*) // Calculate marginal effects
eststo Naive: margins, dydx(*) // Store model 1 (Naive)

logit renegade_a difchoice1 age_diff education_diff income_diff friendfamily female_a female_b female_interaction
margins, dydx(*) // Calculate marginal effects
eststo GenderInteraction: margins, dydx(*) // Store model 2 (Gender Interaction)

xi: logit renegade_a difchoice1 age_diff education_diff income_diff friendfamily female_a female_b female_interaction i.municode
margins, dydx(*) // Calculate marginal effects
eststo MunicipalityFE: margins, dydx(*) // Store model 3 (Municipality FE)

* Export a properly grouped table
esttab using "$path/results/marginal_effects_analysis.tex", replace label se star(* 0.10 ** 0.05 *** 0.01) alignment(D{.}{.}{-1}) keep(difchoice1 age_diff education_diff income_diff friendfamily female_a female_b female_interaction) varlabels(difchoice1 "Difference in Round 1 Gamble Choice" age_diff "Difference in Age" education_diff "Difference in Years of Schooling" income_diff "Difference in Income" friendfamily "One Recognised Friendship, Other Family Tie" female_a "Player A Female" female_b "Player B Female" female_interaction "Gender Interaction") collabels(Naive "Naive Specification" GenderInteraction "Gender Interaction Specification" MunicipalityFE "Municipality FE Specification")

