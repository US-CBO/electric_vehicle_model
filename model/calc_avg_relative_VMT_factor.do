*-------------------------------------------------------------------------------
* Calculate average relative VMT factor
*-------------------------------------------------------------------------------
* Called from main.do

/*
Replace the year-specific RelVMTFactors with AVERAGES over the expected life of
a new vehicle built that year ($VehLife). (Note - the value of VehLife used in
the model does not change over time.) This averaging models EV buyers as 
foreseeing, at time of purchase, that their RelVMTFactor will increase over time 
as the charger network expands, and accounting for that in their expected 
relative lifetime O&M costs.
*/

gen AvgRelVMTFactor = RelVMTFactor
gen CumSumRelVMTFactor = sum(RelVMTFactor)
gen CumSumRLaggedRelVMTFactor = sum(L.RelVMTFactor)
* Create two cumulative sums that, when differenced, drop the [1st] through the
* [`y'-1st] summands at observation [`y'] in the loop below.

local ObsNumVMTParity = 1 + ($FinalYrFullVMTGap +1) + $YrsCloseVMTGap - $BaseYear
* Observation number when VMT parity occurs (when EV/ICEV VMT ratio = 1)

forvalues y = 1 / `= `ObsNumVMTParity' - 1' {
* Only loop to (ObsNumVMTParity - 1) beacuse RelVMTFactor = 1 at ObsNumVMTParity.
    local CumSumToObsNumVMTParity = CumSumRelVMTFactor[`ObsNumVMTParity' - 1] - CumSumRLaggedRelVMTFactor[`y']
    local NumYrsVMTParity = `y' + $VehLife - `ObsNumVMTParity'
    local RelVMTFactorNumerator = `CumSumToObsNumVMTParity' + `NumYrsVMTParity'
    replace AvgRelVMTFactor = (`RelVMTFactorNumerator') / $VehLife if year == $BaseYear + `y' - 1
}
* If VMT parity occurs in year corresponding to 8th observation, and expected
* vehicle lifetime is 15 years, the average is {sum(RelVMTFactor[1:7]) + (15-7)}/15,
* where (15-7)=8 is number of years RelVMTFactor=1

drop CumSumRelVMTFactor CumSumRLaggedRelVMTFactor
