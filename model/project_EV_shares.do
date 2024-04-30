*-------------------------------------------------------------------------------
* Project EV shares
*-------------------------------------------------------------------------------
* Called from main.do

local y = `1'
* y = year, from $StartYear to $EndYear

foreach VehType in "Car" "Truck" {
    local XBeta BetaPr * ln(RelPriceEV`VehType')       ///
              + BetaLk * (ln(L.L2 / L.EVFleet) + ln(L.L3))

    replace EVShare`VehType' = exp(Alpha`VehType' + `XBeta' + psi) /         ///
                          (1 + exp(Alpha`VehType' + `XBeta' + psi)) if year==`y'
}
* Note: although price elasticity (Eta) is a constant, share elasticity (BetaPr)
* is NOT constant: it evolves with EV Share: BetaPr = Eta / (1 - l.EVShareCar).

if `y' == 2023 {
    replace EVShareCar = EVShareCar * $ShareCorrect2023 if year == `y'
    replace EVShareTruck = EVShareTruck * $ShareCorrect2023 if year == `y'
}
* Ensure that projection for 2023 = 8.4% observed in first 4 mos. of 2023

replace EVFleet = $VehNotScrapped * L.EVFleet                    ///
                + LDVSalesCar * 1000 * EVShareCar                ///
                + LDVSalesTruck * 1000 * EVShareTruck if year == `y'
* LDVSales[Car|Truck] is in 1000s

if EPA_New_Stds == 1 {
    foreach VehType in "Car" "Truck" {
        local YearCondition (`y' > $EPANewStdsEnd & year == `y')
        local EVShareCondition (EVShare`VehType' < L.EVShare`VehType')
        replace EVShare`VehType' = max(EVShare`VehType', L.EVShare`VehType') if `YearCondition' & `EVShareCondition'

        local EVSales (LDVSalesCar * EVShareCar + LDVSalesTruck * EVShareTruck)
        local LDVSales (LDVSalesCar + LDVSalesTruck)
        local EVTargetCondition (`EVSales' / `LDVSales' > $EPATargetEVShare)
        local RelPrFactor (1 + $NewStdsPriceFactor)
        replace RelPriceEV`VehType' = RelPriceEV`VehType' * `RelPrFactor' if `YearCondition' & `EVTargetCondition'
    }
}
/*
Special section for EV shares and prices in years after EPA's "illustrative compliance path".
Prevent end of EV tax credits from putting firms out of compliance with standards.
If EPA standard exceeded, reverses automakers' lowering of EV prices to meet standards.

YearCondition -- 'year' > final year of proposed EPA CAFE standards.
EVShareCondition -- Projected EVShare would decline after standards expire.
EVTargetCondition -- EVShare exceeds $EPATargetEVShare.
If YearCondition & EVShareCondition, then manufacturers maintain EV shares
If YearCondition & EVFleetCondition, then manufacturers can re-raise EV prices
*/
