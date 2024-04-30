*-------------------------------------------------------------------------------
* Update attribute drift parameters
*-------------------------------------------------------------------------------
* Called from main.do

local y = `1'
* y = year, from $StartYear to $EndYear

scalar zeta`y' = rnormal(0, zetaStdDevFactor * abs(mu))

replace psi = mu + L.psi + zeta`y' if year==`y'
replace muvar = mu
replace zetavar = zeta`y' if year == `y'
* These variable versions of mu and zeta store the scalar values 
* of mu and zeta that are used in the actual sims
