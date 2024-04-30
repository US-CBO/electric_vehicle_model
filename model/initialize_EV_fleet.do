*-------------------------------------------------------------------------------
* Initialize EV fleet
*-------------------------------------------------------------------------------
* Called from main.do

local ANLSales$BaseYear (${ANLSalesCar$BaseYear} + ${ANLSalesTruck$BaseYear})
local EIASales$BaseYear (${EIASalesCar$BaseYear} + ${EIASalesTruck$BaseYear})

scalar EVFleet$BaseYear = ${ANLEVFleet$BaseYear} * (`EIASales$BaseYear' / `ANLSales$BaseYear')
* Rescale EV fleet data (from ANL) to correct for discrepancies between EIA and
* ANL sales data.
