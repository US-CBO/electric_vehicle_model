*-------------------------------------------------------------------------------
* Initialize EV[Car|Truck]Share
*-------------------------------------------------------------------------------
* Called from main.do

gen EVShareCar = (${ANLEVShareCar$BaseYear} * ${EIASalesCar$BaseYear}) / LDVSalesCar if year == $BaseYear
gen EVShareTruck = (${ANLEVShareTruck$BaseYear} * ${EIASalesTruck$BaseYear}) / LDVSalesTruck if year == $BaseYear
/*
Numerators are EV sales expressed as ANL's EV shares applied to EIA's sales.
This formulation is necessary because model relies on ANL for EV shares but
uses EIA for EV sales projections and EIA and ANL use slightly different
classifications for 'car' and 'truck'.
*/
