*-------------------------------------------------------------------------------
* Read in EV model data
* See README.md for info on data sources.
*-------------------------------------------------------------------------------
* Called from main.do

insheet using "${InputsPath}\\${InputDataFile}", comma names case clear
tsset year

rename LDVCarNoRA LDVSalesCar
rename LDVTruckNoRA LDVSalesTruck
* NoRA indicates EIA's No-Reconciliation-Act base projection


* CAFE data adjustments
*-------------------------------------------------------------------------------
replace CAFECar = L.CAFECar * (1 + $CAFEGrowthRateCar) if year > $LastCAFEYear
replace CAFETruck = L.CAFETruck * (1 + $CAFEGrowthRateTruck) if year > $LastCAFEYear
* CAFE standards are specified in law only through a specific, future year
* Here, apply an assumption about how the standards will evolve after that year.

replace CAFECar = $CAFELimitCar if CAFECar > $CAFELimitCar
replace CAFETruck = $CAFELimitTruck if CAFETruck > $CAFELimitTruck
* Constrain CAFE[Car|Truck] so that, if assumed to increase beyond greatest
* value specified in law, rising CAFE stringency is capped so that ICEVs
* (esp trucks) will not eventually be assumed to be more efficient than EVs.
* Needed if CAFE stringency is NOT held at current law after $LastCAFEYear


* ResidElecPr and GasPr data adjustments
*-------------------------------------------------------------------------------
replace ResidElecPr = ResidElecPr / 100
* Converts to $/kWh terms, from cents

replace ResidElecPr = L.ResidElecPr if ResidElecPr == .
replace GasPr = L.GasPr if GasPr == .
* O&M calculations are forward-looking.
* Hold ResidElecPr and GasPr fixed after $EndYear

summarize year
assert r(max) >= $EndYear + $NumOMYears
* Make sure all the data needed are there!
