*-------------------------------------------------------------------------------
* Calculate relative VMT factor
*-------------------------------------------------------------------------------
* Called from main.do

/*
Average vehicle-miles traveled by EV is initially lower than for ICEV.
As EV charger network grows, assume (EV/ICEV) VMT ratio increases over time,
irrespective of a vehicle's attributes, i.e. the ratio increases for both new
and existing EVs.

Assume the percentage difference in VMT by EV versus ICEV, (1 - BaseYearRelVMTRatio),
closes to zero over $YrsCloseVMTGap, in equal increments, beginning after
$FinalYrFullVMTGap.
*/
local BaseYearRelVMTGap (1 - BaseYearRelVMTRatio)
* E.g. if base year EV/ICEV VMT ratio is 0.6 then RelVMTGap is 0.4.
gen YearsSinceMaxGap = max(0, (year - $FinalYrFullVMTGap))
gen GapReducedBy = YearsSinceMaxGap * `BaseYearRelVMTGap' / $YrsCloseVMTGap
* E.g. if RelVMTGap has been closing for 3 yrs, baseyr gap = 0.4, & gap closes
* in 10 years, then initial gap has closed by 30% or 3 * 0.4 / 10 
gen RelVMTFactor = min(1, (BaseYearRelVMTRatio + GapReducedBy))
* E.g. if BaseYearRelVMTRatio 0.6 and is reduced by 30% then RelVMTFactor = 0.72
* RelVMTFactor is an attribute of year.

drop YearsSinceMaxGap GapReducedBy
