# econ280project
This Git repository contains the data and command to replicate the extension on the paper "Risk Pooling, Risk Preferences, and Social Networks" by Orazio Attanasio, Abigail Barr, Juan Camilo Cardenas, Garance Genicot, and Costas Meghir to be published in the *American Economic Journal: Applied Economics*.

## Contents:
- One Stata do file: `01_defection_analysis.do`
- Two Stata datasets: `AttanasioEtAl2011Dyadic.dta` and `AttanasioEtAl2011Vector.dta`
- One table with the result: `marginal_effects_analysis.tex'
- One PDF with the explanation of the extension and the table displaying the results: `econ280project.pdf'
- : 

## Instructions:
1. Download the entire folder.
2. In the code, change your username and path to the folder in rows 34 and 35:

```stata
if "`c(username)'" == "YOUR_USER_NAME" {
    global path "YOUR_PATH_TO_FOLDER"
}
