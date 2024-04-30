*-------------------------------------------------------------------------------
* Update elasticities
*-------------------------------------------------------------------------------
* Called from main.do

replace PriceElasCar = BetaPr * (1 - L.EVShareCar)
replace PriceElasTruck = BetaPr * (1 - L.EVShareTruck)
replace ChargerElasCar = BetaLk * (1 - L.EVShareCar)
replace ChargerElasTruck = BetaLk * (1 - L.EVShareTruck)
/*
Calculations for observing the model's implied elasticity values.
NOTE: These elasticities do NOT affect EV shares, which depend on Beta constants
instead.
*/

