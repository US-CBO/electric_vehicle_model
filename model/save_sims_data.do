*-------------------------------------------------------------------------------
* Save simulations data
*-------------------------------------------------------------------------------
* Called from main.do

gen L2Ratio = L2 / EVFleet

keep Iteration year                                 ///
     LDVSalesCar LDVSalesTruck                      ///
     EVShareCar EVShareTruck                        ///
     EVFleet                                        ///
     EVCarPr EVTruckPr ICEVCarPr ICEVTruckPr        ///
     RelPriceEVCar RelPriceEVTruck                  ///
     PriceElasCar PriceElasTruck                    ///
     L2 L3 L2Ratio                                  ///
     ChargerElasCar ChargerElasTruck                ///
     psi muvar zetavar

keep if year < $EndYear + 1

append using "${OutputsSimsPath}\\${Policy}_sims.dta"
save "${OutputsSimsPath}\\${Policy}_sims.dta", replace
