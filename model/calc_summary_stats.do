*-------------------------------------------------------------------------------
* Calculate summary statistics
*-------------------------------------------------------------------------------
* Called from main.do

use "${OutputsSimsPath}\\${Policy}_sims.dta", clear
sort year

local EVSales (LDVSalesCar * EVShareCar + LDVSalesTruck * EVShareTruck)
local LDVSales (LDVSalesCar + LDVSalesTruck)
gen EVShare =  `EVSales' / `LDVSales'

local vars = "EVFleet EVShare RelPriceEVCar RelPriceEVTruck EVShareCar EVShareTruck L2 L3 L2Ratio"
foreach var in `vars' {
    by year: egen `var'P17 = pctile(`var'), p(16.66667)
    by year: egen `var'P50 = pctile(`var'), p(50)
    by year: egen `var'P83 = pctile(`var'), p(83.33333)
}

sort year Iteration
gen policy = "$Policy"
gen NumIterations = $NumIterations
save "${OutputsSimsPath}\\${Policy}_${NumIterations}_sims.dta", replace
drop if Iteration > 1

local outputVariables                                                        ///
year policy NumIterations year                                               ///
EVFleetP17 EVFleetP50 EVFleetP83                                             ///
EVShareP17 EVShareP50 EVShareP83                                             ///
RelPriceEVCarP17 RelPriceEVCarP50 RelPriceEVCarP83                           ///
RelPriceEVTruckP17 RelPriceEVTruckP50 RelPriceEVTruckP83                     ///
EVShareCarP17 EVShareCarP50 EVShareCarP83                                    ///
EVShareTruckP17 EVShareTruckP50 EVShareTruckP83                              ///
L2P17 L2P50 L2P83                                                            ///
L3P17 L3P50 L3P83                                                            ///
L2RatioP17 L2RatioP50 L2RatioP83

outsheet `outputVariables' using "${OutputsPath}\\${Policy}_${NumIterations}_summary_stats.csv", comma replace
