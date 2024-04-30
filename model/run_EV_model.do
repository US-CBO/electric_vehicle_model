********************************************************************************
* Run EV model
* Runs CBO's EV model for all the policies specified in PolicyList, below.
* To simulate individual policies, run 'do main.do [policyname]' at the Stata
* command line
********************************************************************************
set more off
clear all
macro drop _all
cls

* Uncomment the line below and enter the file path where this .do file is saved.
* global ModelPath "Enter/your/full/file/path/here"
cd "$ModelPath"

local PolicyList "NoPolicy" "IIJA_Only" "IIJA_RA" "IIJA_RA_EPA_New_Stds"
foreach pol in `PolicyList' {
    do main.do `pol'
}
