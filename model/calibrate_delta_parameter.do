*-------------------------------------------------------------------------------
* Solve for calibration parameter: Delta (EV charger supply)
*-------------------------------------------------------------------------------
* Called from main.do

/*
Solving for Delta that maintains baseline ratio of L2 to EVFleet @ 2 plugs per
station, vs Cole et al. (2023) achieving a fully built-out equilibrium where
all cars are EVs.
*/

scalar L3CostDelta$BaseYear = CostL3[1] - CostL3[2] / (1 + $CostofCap)
/*
Note 1: CostL3[2] is supplier's anticipated future cost at time of supply decision.
Note 2: PreWideIIJACostLk does not figure in the base year CostDelta calculations
(suppliers have one year of foresight but not two years)
Note 3: No analogous L2CostDelta because DeltaL2 initialized as a constant (below)
*/

scalar DeltaL2 = $InitDeltaL2
scalar DeltaL3 = ln($BaseYearL3)                              ///
               - (GammaElasEVCharger * ln(EVFleet$BaseYear))  ///
               + (GammaElasEVCharger * ln(L3CostDelta$BaseYear))
* Calibrates to a target L2/EV ratio (equal to baseline ratio) as a compromise
* to (1) targeting to some high fantasy ratio or (2) letting ratio decline.
