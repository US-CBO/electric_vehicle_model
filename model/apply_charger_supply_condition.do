*-------------------------------------------------------------------------------
* Apply charger supply condition (no decommissioning of working chargers)
*-------------------------------------------------------------------------------
* Called from main.do

/*
The IIJA subsidies *can* cause the charger network to expand beyond what
charger suppliers find privately optimal after the subsidies expire.
This module prevents suppliers from decommissioning working chargers to
reduce the size of the network. Instead, it gradually reduces the size of
the network through equipment failure until it is exceeded by suppliers'
preferred network size.

Note: This charger supply condition does not currently bind for L3 or L2
(in the latter case because L2 supply is constrained to at least
equal the L2/EVFleet ratio observed in $BaseYear).
*/
 
local y = `1'
* four-digit calendar year, from project_charger_supply

local IPn = $IIJASubsidiesEnd - $BaseYear + 1
* Observation num (n) where "Investment Pause" (IP) occurs, because IIJA subsidies end.

/*
Ordinarily, scrappage is implicit in supply decisions: 
preferred network size is achieved given (unobserved) scrappage. But IIJA
subsidies--even though charger failures are netted out of the annual increment
of subsidized chargers (see "IIJA == 1" in project_charger_supply.do)--
can push supply enough beyond demand that charger suppliers might optimally 
supply no new chargers for a time after the subsidies end, allowing the charger 
network to shrink from attrition. (Working chargers cannot be decomissioned.)
*/

forvalues n = 1 / `= $EndYear - $BaseYear + 1' {
    scalar L2Survive`n' = 0
    scalar L3Survive`n' = 0
}
* Initialize L2|3 survival scalars for all years

* Correct L2|3 survival scalars to account for effect of aging on survival/failure
* rates after the IIJA subsidies expire.
*-------------------------------------------------------------------------------
forvalues k = 2 / 3 {
    scalar L`k'Survive`IPn' = (                                                                      ///
        $A1 * $S1 * L`k'[`IPn' - 1]                                                                  ///
        - (($A2 -  1) * $F2 * $S1 + (2 -  $A2) *       $S1) * (L`k'[`IPn' -  2] - L`k'[`IPn' -  3])  ///
        - (($A3 -  2) * $F3 * $S2 + (3 -  $A3) * $F2 * $S1) * (L`k'[`IPn' -  3] - L`k'[`IPn' -  4])  ///
        - (($A4 -  3) * $F4 * $S3 + (4 -  $A4) * $F3 * $S2) * (L`k'[`IPn' -  4] - L`k'[`IPn' -  5])  ///
        - (($A5 -  4) * $F5 * $S4 + (5 -  $A5) * $F4 * $S3) * (L`k'[`IPn' -  5] - L`k'[`IPn' -  6])  ///
        - (($A6 -  5) * $F6 * $S5 + (6 -  $A6) * $F5 * $S4) * (L`k'[`IPn' -  6] - L`k'[`IPn' -  7])  ///
        - (($A7 -  6) * $F7 * $S6 + (7 -  $A7) * $F6 * $S5) * (L`k'[`IPn' -  7] - L`k'[`IPn' -  8])  ///
        - (($A8 -  6) * $F7 * $S6 + (7 -  $A8) * $F6 * $S5) * (L`k'[`IPn' -  8] - L`k'[`IPn' -  9])  ///
        - (($A9 -  6) * $F7 * $S6 + (7 -  $A9) * $F6 * $S5) * (L`k'[`IPn' -  9] - L`k'[`IPn' - 10])  ///
        - (($A10 - 6) * $F7 * $S6 + (7 - $A10) * $F6 * $S5) * (L`k'[`IPn' - 10] - L`k'[`IPn' - 11])  ///
        - (($A11 - 6) * $F7 * $S6 + (7 - $A11) * $F6 * $S5) * (L`k'[`IPn' - 11] - L`k'[`IPn' - 12])  ///
    )
}
/*
INTERPRETATION: 
$Ay = average age of y-year-old charger cohort if failed chargers replaced.
$Sy and $Fy = average charger survival and failure rates at age y, respectively.

The average survival odds of a charger in, say, a 2-year-old cohort surviving to 
3 years (with any failed chargers already replaced) is one minus its
average *failure* odds at two years. With failures and replacements, at
year 3 the average age of a charger in that cohort will be $A3 < 3.

At 2 years old, average failure odds are a weighted average of the odds of
failing by 3 years, $F3 * $S2 and failing at 2 years, $F2 * $S1.
If $A3 = 2.97, the respective weights are 97% ($A3 - 2) and 3% (3 - $A3).

Note: The above pattern changes at $A8, a consequence of the survival and failure
rates used in this model. For those rates, average charger age stops rising
at 8 years.
*/


* Correct LkSurvive counts for aging after IIJA Subsidies End (2034)
*-------------------------------------------------------------------------------
local NumYearsAfterIIJASubsidiesEnd = $EndYear - $IIJASubsidiesEnd - 1

forvalues n = 1 / `NumYearsAfterIIJASubsidiesEnd' {
    local nPostIP = `IPn' + `n'
    local nPlus5 = `n' + 5
    local SPlus5 = ${S`nPlus5'}  // when n = 1, SPlus5 will be $S6

    forvalues k = 2 / 3 {
        scalar L`k'Survive`nPostIP' = L`k'Survive`IPn' * (`SPlus5' / $S5)
    }
}


* Apply no-decommissioning condition if (optimal supply) < (surviving chargers)
*-------------------------------------------------------------------------------
local YearObsNum = `y' - $BaseYear + 1
* Observation number in data that year `y' corresponds to

replace L2 = max(L2, L2Survive`YearObsNum') if year == `y'
replace L3 = max(L3, L3Survive`YearObsNum') if year == `y'
/*
Note 1: These commands can only affect L2, L3 when charger supply has been
expanded by IIJA subsidies. Else L2|L3Survive < lagged L2|L3 < L2|L3.

Note 2: These survival corrections have no effect on how Delta calibrations
influence L2 and L3.
*/
