*-------------------------------------------------------------------------------
* Make figures
*-------------------------------------------------------------------------------
* Called from main.do

local FigureSettings graphregion(color(white)) plotregion(style(none))
local PNGSettings as(png) replace width(728) height(530)

* Median Projected L3 Charging Stations
twoway tsline L3P50, title("Median Projected L3 Charging Stations") subtitle("Policy: $Policy") `FigureSettings'
graph export "${OutputsPath}\\figures\\median_L3_${Policy}_${NumIterations}.png", `PNGSettings'
 
* Median Projected L2 Charging Stations
twoway tsline L2P50, title("Median Projected L2 Charging Stations") subtitle("Policy: $Policy") `FigureSettings'
graph export "${OutputsPath}\\figures\\median_L2_${Policy}_${NumIterations}.png", `PNGSettings'

* Median Projected Market Share of New EV Sales
twoway tsline EVShareP50, title("Median Projected Market Share of New EV Sales") subtitle("Policy: $Policy") `FigureSettings'
graph export "${OutputsPath}\\figures\\median_EVShare_${Policy}_${NumIterations}.png", `PNGSettings'

* Median Projected EV Fleet Size
twoway tsline EVFleetP50, title("Median Projected EV Fleet Size") subtitle("Policy: $Policy") `FigureSettings'
graph export "${OutputsPath}\\figures\\median_EVFleet_${Policy}_${NumIterations}.png", `PNGSettings'
