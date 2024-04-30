*-------------------------------------------------------------------------------
* Solve for calibration parmeter: Alpha (EV demand)
*-------------------------------------------------------------------------------
* Called from main.do

/*
Iterate to find alphas unique to the random parameters.
EVshare = e^(xb) / (1 + e^(xb)), a logistic function, means no algebraic
solution for alpha.
e^(xb) = exp{α_[Car|Truck]
           + βp * ln(RelPriceEV[Car|Truck]_t)
           + βL2 * ln(L2_t-1 / EVFleet_t-1)
           + βL3 * ln(L3_t-1)
           + ψ_t}, 
where t is BaseYear
NOTE: Separate estimates of βL2 and βL3 do not exist. Use βLk instead.
No ψ_t term in $BaseYear formula below because = 0.
Appears in subsequent years (see project_EV_shares.do).
*/ 
scalar AlphaCar = $InitAlphaCar
scalar AlphaTruck = $InitAlphaTruck

foreach VehType in "Car" "Truck" {
    * Initialize EVShare for BaseYear using start-of-BaseYr values
    * for L2, L3, and EVFleet, per the theory model
    scalar EVShare`VehType'BY = EVShare`VehType'[1]

    if year == $BaseYear {
        local XBeta BetaPr * ln(RelPriceEV`VehType')                         ///
                  + BetaLk * (ln($BaseYearL2 / EVFleet$BaseYear) + ln($BaseYearL3))

        replace EVShare`VehType' = exp(Alpha`VehType' + `XBeta') /           ///
                              (1 + exp(Alpha`VehType' + `XBeta'))
    }

    * Pincer: solve for AlphaCar and AlphaTruck giving observed baseline share values 
    * (solution depends on, varies due to, random parameter values)
    while (abs(EVShare`VehType'[1] - EVShare`VehType'BY) > ${ConvrgTolerance`VehType'}) {
        if (EVShare`VehType'[1] <= EVShare`VehType'BY) {
            scalar Alpha`VehType' = Alpha`VehType' + 0.01  // Go UP if EV[Car/Truck]Share too low
        }
        else {
            scalar Alpha`VehType' = Alpha`VehType' - 0.01  // Go DOWN if EV[Car/Truck]Share too high
        }

        replace EVShare`VehType' = exp(Alpha`VehType' + `XBeta') /           ///
                              (1 + exp(Alpha`VehType' + `XBeta')) if year == $BaseYear
    }
}
