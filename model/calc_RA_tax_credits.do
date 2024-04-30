* ------------------------------------------------------------------------------
* Calc tax credits from Reconciliation Act of 2022 (EVTC and AMPC)
* ------------------------------------------------------------------------------
* Called from main.do

* Section 30D EV tax credit (EVTC) calculations
*-------------------------------------------------------------------------------
* All EVs expected to qualify for $3750 'Domestic Battery Assembly' portion of EVTC.

gen EVCritMinQual = 0
replace EVCritMinQual = 1 if year == 2023
replace EVCritMinQual = 0.5 if year == 2024  
* ICCT: 0.1, but in model year 2023 product lineup, 0.5 of EV models qualified.
forvalues y = 2025 / $RAEndYear {
    replace EVCritMinQual = $PctQualEVTCLow * ${CritMinLow`y'}   ///
                          + $PctQualEVTCMed * ${CritMinMed`y'}   ///
                          + $PctQualEVTCHi  * ${CritMinHi`y'} if year == `y'
}
gen EVCritMinNotQual = 1 - EVCritMinQual
/*
Share of EVs qualifying/not qualifying for additional 3750 portion of EVTC for
satisfying 'Critical Minerals' provision of RA. (Note: 'Critical Minerals'
provision is separate from 'Foreign Entities of Concern' provision (not yet
implemented).
*/

gen EVBuyerQual = 0
forvalues y = $RAStartYear / $RAEndYear {
    replace EVBuyerQual = ${EVBuyerQual`y'} if year == `y'
}
gen EVBuyerNotQual = 1 - EVBuyerQual
/*
Share of EV buyers who qualify/don't qualify (based on income and MSRP of the
EV they buy)  for either portion of the EV tax credit.
*/

gen EVTC = 0
replace EVTC = (3750 * EVBuyerQual * (1 + EVCritMinQual))             ///
             + (7500 * EVBuyerNotQual * (EVBuyerQual > 0) * $lease)   ///
             + (3750 * EVBuyerQual * EVCritMinNotQual * $lease)
/*
E(EVTC per vehicle), accounting for share of buyers who do not qualify, or who
choose cars that do not qualify, for EVTC.

Line 1: 'EVBuyerQual' is share of EV buyers who qualify (on income & MSRP) for any
   portion of credit. Qualified EV buyers receive 3750 (Domestic Battery Assembly) 
   plus expected portion 'EVCritMinQual' of additional 3750 (Critical Minerals).
Line 2: Buyers who do NOT qualify can receive entire 7500 credit if they lease.
   The '(EVBuyerQual > 0)' prevents credit from being applied after $RAEndYear.
Line 3: Buyers who qualify for Domestic Battery Assembly but not for Critical 
   Minerals can increase their EV tax credit by 3750 if they lease.
NOTE: p(buyer is qualified) and p(car is qualified) treated here as INDEPENDENT.
*/

gen randICCT = rnormal($ICCTMean, $ICCTStdDev)
replace EVTC = min(EVTC * randICCT, 7500)
* Add Gaussian noise, 5% StdDev, to ICCT values, but don't let them exceed $7500.


* Section 45X Advanced Manufacturing Tax Credits (AMPC) calulations
*-------------------------------------------------------------------------------
foreach VehType in "Car" "Truck" {
    gen AMPC`VehType' = 0
    forvalues y = $RAStartYear / $RAEndYear {
        * ICCT estimates of credit sharing (from mfr to consumer).
        local AMPCCreditShare (${AMPCShareMed`y'} * $PctQualEVTCMed + ${AMPCShareHi`y'} * $PctQualEVTCHi)
        replace AMPC`VehType' = ${AMPCBase`VehType'} * `AMPCCreditShare' * randICCT if year == `y'
    }
}
