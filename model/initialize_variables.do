*-------------------------------------------------------------------------------
* Initialize variables used in year loop
*-------------------------------------------------------------------------------
* Called from main.do

gen EVFleet = EVFleet$BaseYear
gen PriceElasCar = 0 
gen PriceElasTruck = 0
gen ChargerElasCar = 0 
gen ChargerElasTruck = 0 
gen L2 = $BaseYearL2
gen L3 = $BaseYearL3
gen psi = 0               // Recall: ψ_t = μ + ψ_(t-1) + ζ
gen muvar = 0             // μ ~ N(μ_mean * |β|, μ_stddev * |β|)
gen zetavar = 0           // ζ ~ N(0, 2|μ|)
