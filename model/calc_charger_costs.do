*-------------------------------------------------------------------------------
* Calculate charger costs: CostL[2|3] and PreWideIIJACostL[2|3]
*-------------------------------------------------------------------------------
* Called from main.do

gen CostL2 = $BaseYearCostL2 * (1 + exp(-ChargerCostRate * (year - ${BaseYear}))) / 2
gen CostL3 = $BaseYearCostL3 * (1 + exp(-ChargerCostRate * (year - ${BaseYear}))) / 2

gen PreWideIIJACostL2 = CostL2
gen PreWideIIJACostL3 = CostL3
replace PreWideIIJACostL2 = (1 - $IIJASubsidyRate) * CostL2 if (IIJA == 1 & year == $IIJAFundsStart)
replace PreWideIIJACostL3 = (1 - $IIJASubsidyRate) * CostL3 if (IIJA == 1 & year == $IIJAFundsStart)
/*
Create one-year-only special value of CostL[2|3], for the year before IIJA
subsidies become widely available. 

The need for this variable: suppliers are assumed to have one year of foresight.
This var ensures that charger costs in 2023 ($IIJAFundsStart) are seen to be
subsidized from 2022 ($IIJAFundsStart - 1) viewpoint.
*/
