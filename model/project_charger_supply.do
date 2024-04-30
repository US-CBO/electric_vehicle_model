*-------------------------------------------------------------------------------
* Project charger supply from $StartYear to $EndYear
*-------------------------------------------------------------------------------
* Called from main.do

local y = `1'
* four-digit calendar-year value from Year Loop in main.do

local YearObsNum = `y' - $BaseYear + 1
* Observation number in data that year `y' corresponds to
local PWObsNum = $IIJAFundsStart - $BaseYear
* Observation number of last yr IIJA funds are "pre-widely" (PW) available

scalar L2CostChange`y' = CostL2[`YearObsNum'] - CostL2[`YearObsNum' + 1] / (1 + $CostofCap)
scalar L3CostChange`y' = CostL3[`YearObsNum'] - CostL3[`YearObsNum' + 1] / (1 + $CostofCap)
* L[2|3] cost changes governs suppliers' investment decisions
* CostChange = f(cost(current year), projected_cost(next year))

scalar L2CostChange2023 = CostL2[`PWObsNum'] - PreWideIIJACostL2[`PWObsNum' + 1] / (1 + $CostofCap)
scalar L3CostChange2023 = CostL3[`PWObsNum'] - PreWideIIJACostL3[`PWObsNum' + 1] / (1 + $CostofCap)
* Correct the 2023 value to reflect suppliers' anticipation that IIJA subsidies
* available in 2024

* Update L[2|3] charger network sizes
forvalues k = 2 / 3 {
    replace L`k' = exp(                             ///
      DeltaL`k'                                     ///
    + (GammaElasEVCharger * ln(EVFleet))            ///
    - (GammaElasEVCharger * ln(L`k'CostChange`y'))  ///
    ) if year == `y'
}

/* 
For $BaseYear:
Set L2 so that L2/EVFleet ratio equals its observed base year value. 
Else the f(DeltaL2, GammaELasEVCharger) (above) yields a lower base L2 ratio
than what the market actually supplies - a shortcoming of the model's treatment
of L2.
*/
if `y' == $BaseYear {
    replace L2 = EVFleet * ($BaseYearL2 / EVFleet$BaseYear) if year == `y'
}

/*
For $BaseYear + 1:
Consistent with special case for $BaseYear, continue to hold L2/EVFleet ratio to
the observed level, minus expected scrappage. That is, allow suppliers to
produce no new L2 chargers in anticipation of receiving 80% IIJA subsidies in
$BaseYear + 2.
*/
if `y' == $BaseYear + 1 {
    replace L2 = max(L2, $S5 * L.L2) if year == `y'
    replace L3 = max(L3, $S5 * L.L3) if year == `y'
}
* Using $S5 here for scrappage rate: w/logistic failure, avg charger age is ~5 years.
* Averaging across charger ages, about (1 - $S5) = 4.7% of chargers fail annually.

replace L2 = max(L2, EVFleet * ($BaseYearL2 / EVFleet$BaseYear))
* Set L2 so that base-year L2/EV ratio is maintained, then add incremental IIJA
* stations onto that (below)

scalar randL2`y' = rnormal(1, 0.1)
scalar randL3`y' = rnormal(1, 0.1)
* Generate 10% Gaussian random noise values, which will be applied to supply
* responses ($IIJAL2Increm and $IIJAL3Increm), below.

/*
Replace projections for years when IIJA subsidies are available.
Assume that depreciated chargers are replaced using SUBSIDY funds.
That is, Lk increments, net of equipment failure (1 - $S5), are supplied 
entirely by subsidized chargers.
*/
if IIJA == 1 {
    if (`y' >= $IIJAFundsStart & `y' <= $IIJAFundsEnd) {
        replace L2 = L2 + $S5 * randL2`y' * ${IIJAL2Increm`y'} if year == `y'
        replace L3 = L3 + $S5 * randL3`y' * ${IIJAL3Increm`y'} if year == `y'
    }
}
