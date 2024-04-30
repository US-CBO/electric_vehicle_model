*-------------------------------------------------------------------------------
* Set EV Model Parameters
*-------------------------------------------------------------------------------
* Called from main.do

global NumIterations = 2000


*-------------------------------------------------------------------------------
* Set relative file paths
*-------------------------------------------------------------------------------
global InputsPath "..\inputs"
global InputDataFile "EV_model_data.csv"

global OutputsSimsPath "..\outputs\sims"
global OutputsPath "..\outputs"


*-------------------------------------------------------------------------------
* Year parameters
*-------------------------------------------------------------------------------
global BaseYear 2022          // [EV fleet, EV share, and EV charger] data year
global StartYear 2023         // StartYear for Year loop
global EndYear 2050           // EndYear for Year loop

global RAStartYear 2023       // As specified in Reconciliation Act legislation
global RAEndYear 2032         // As specified in Reconciliation Act legislation

global IIJAFundsStart 2023    // As specified in IIJA legislation
global IIJAFundsEnd 2032      // As specified in IIJA legislation
global IIJASubsidiesEnd 2034  // Year by which CBO expects all IIJA subsidy funding to have been spent

global EPANewStdsEnd 2032     // As specified by EPA


*-------------------------------------------------------------------------------
* Set seed value for all random number generation
*-------------------------------------------------------------------------------
global RandSeed 19712682      // Do not change this value


*-------------------------------------------------------------------------------
* Reconcilation Act (RA) parameters
*-------------------------------------------------------------------------------
global ICCTMean 1
global ICCTStdDev 0.05
* Mean and standard deviation for random normal noise applied to ICCT estimates.

* EV tax credit (EVTC)
*-------------------------------------------------------------------------------
global PctQualEVTCLow = 0                // Default value 0; alt value 1
global PctQualEVTCMed = 1                // Default value 1; alt value 0
global PctQualEVTCHi = 0                 // Default value 0; alt value 1
assert $PctQualEVTCLow + $PctQualEVTCMed + $PctQualEVTCHi == 1  // These must sum to 1
* ICCT moderate case for shares of EV purchases (by year) that qualify for tax credit.

global lease 0.5
* Share of EV tax credit NON-qualifiers who lease instead of buy.

global CritMinLow2025 0.760
global CritMinMed2025 0.790
global CritMinHi2025 0.820

global CritMinLow2026 0.720
global CritMinMed2026 0.776
global CritMinHi2026 0.834

global CritMinLow2027 0.680
global CritMinMed2027 0.762
global CritMinHi2027 0.848

global CritMinLow2028 0.640
global CritMinMed2028 0.748
global CritMinHi2028 0.862

global CritMinLow2029 0.600
global CritMinMed2029 0.734
global CritMinHi2029 0.876

global CritMinLow2030 0.560
global CritMinMed2030 0.720
global CritMinHi2030 0.890

global CritMinLow2031 0.555
global CritMinMed2031 0.740
global CritMinHi2031 0.945

global CritMinLow2032 0.550
global CritMinMed2032 0.780
global CritMinHi2032 1.000
* Percent of EV sales satisfying Critical Minerals provision of RA.
* Under Low/Med/Hi scenarios
* Source: ICCT for 2025, 2030, and 2032
* https://theicct.org/wp-content/uploads/2023/01/ira-impact-evs-us-jan23-2.pdf
* CBO interpoloation between those dates. (See CBO working paper 2023-06.)


* ICCT estimated uptake of PASSENGER CLEAN-VEHICLE TAX CREDITS (Internal Revenue Code Section 30D)
* Domestic battery assembly: 100% qualify ($3,750)

* CBO estimated share of EV buyers who qualify for EV tax credits
global EVBuyerQual2023 0.6700
global EVBuyerQual2024 0.6800
global EVBuyerQual2025 0.6900
global EVBuyerQual2026 0.7025
global EVBuyerQual2027 0.7150
global EVBuyerQual2028 0.7300
global EVBuyerQual2029 0.7450
global EVBuyerQual2030 0.7600
global EVBuyerQual2031 0.7600
global EVBuyerQual2032 0.7600
/*
Qualification Criteria:
MSRP: 87% of new Battery EVs qualify (from ICCT). (EV makers will introduce cheaper models over time.)

AGI: 68% of new-EV buyers qualify in 2023, rising to 77% in 2030

MSRP + AGI COMBINED: (CBO) - AGI and MSRP are correlated, so estimated jointly.
Supposing 90% of hi-MSRP EVs are purchased by hi-AGI buyers, then 10% of 
hi-MSRP EVs would be purchased by buyers with NON-high AGIs, reducing the 'bite'
of the AGI*MSRP restriction by 10%*13% = ~1 pp of cars that qualify on AGI but 
NOT MSRP grounds.

COMBINED EFFECT: AGI qualification becomes:
"(68-1)% qualify in 2023, rising to (77-1)% in 2030".
*/


* Section 45X Advanced Manufacturing Tax Credits (AMPC)
*-------------------------------------------------------------------------------
* (AMPC credit per kWh) * (battery sizes CBO uses in this model).
global AMPCBaseCar 3150     // $45 * 70kwh
global AMPCBaseTruck 5400   // $45 * 12kwh

global AMPCShareMed2023 0.25
global AMPCShareHi2023 0.5
global AMPCShareMed2024 0.5
global AMPCShareHi2024 1
global AMPCShareMed2025 0.5
global AMPCShareHi2025 1
global AMPCShareMed2026 0.5
global AMPCShareHi2026 1
global AMPCShareMed2027 0.5
global AMPCShareHi2027 1
global AMPCShareMed2028 0.5
global AMPCShareHi2028 1
global AMPCShareMed2029 0.5
global AMPCShareHi2029 1
global AMPCShareMed2030 0.375
global AMPCShareHi2030 0.75
global AMPCShareMed2031 0.25
global AMPCShareHi2031 0.5
global AMPCShareMed2032 0.125
global AMPCShareHi2032 0.25
* Percentage of 45X credit that mfrs will share with consumer.
* Source: ICCT, same source as above
* Note: AMPCShareLow, and AMPCShareMed|Hi after 2032, are 0


*-------------------------------------------------------------------------------
* Model calibration
*-------------------------------------------------------------------------------
global drift 1
* positive attribute drift, requiring user choices for MeanDrift, InitDeltaL2.
* set drift = 0 to prevent attribute drift.

global MeanDrift 0.037
/*
Set MeanDrift = 0.037 for CBO historical-growth scenario: 2030 median projected EV share of ~24%. 
Set MeanDrift = 0.0075 for CBO slow-growth scenario: 2030 median projected EV share of ~16.5%.
Set MeanDrift = 0.065 for CBO rapid-growth scenario: 2030 median projected EV share of ~34%.
NOTE: MeanDrift values have no intrinsic meaning and must be updated if new data
are added to model.
To update, enter a new value, iterate the model at least 100 times, and adjust
by trial and error. Confirm over 2000 iterations.
*/

global InitAlphaCar -4.5
global InitAlphaTruck -5.5
/*
Starting values for model's iterative convergence to equilibrium value. 
NOTE: If model has difficulty converging, try different initial Alpha values.
Larger (-) starting values may be helpful as initial L2 increases or if
optimizing to L2 instead of L2/EV
*/

global ConvrgToleranceCar 0.001
global ConvrgToleranceTruck 0.0004
* Convergence tolerances when calibrating alpha parameter. 
* Smaller 'Truck' value indicates model convergence less sensitive to AlphaTruck.

global InitDeltaL2 4.46
/*
Start value for L2 supply, chosen to achieve observed $BaseYear L2/EV ratio.
NOTE: InitDeltaL2 4.46 developed through trial/error using 2022 data. That
value achieves target 1.5% L2 stations per EV, meaning (2 * 1.49%) = 3% L2
plugs per EV, as observed in end-2022 data. Model sustains that ratio.
NOTE ALSO: An InitDeltaL3 parameter is not needed.
*/


*-------------------------------------------------------------------------------
* Elasticity parameters
*-------------------------------------------------------------------------------
global EtaPrElasEVMean -2
global EtaPrElasEVStdDev 0.5
* 'Eta' for demand elasticity.
* Source: Cole et al. (2023). 
* StdDev reflects range of values from literature.

global EtaChargerElasEVMean 0.4
global EtaChargerElasEVStdDev 0.1
* 'Eta' for demand elasticity. Here, charger network elasticity of EV demand. 
* Source for values used here: Springel, 2020 (estimated means of 0.42 and 0.37). 

global EVSharePre$BaseYear 0.0422
* Latest full-year EV share (from ANL data) PRIOR TO $BaseYear
* (so EVSharePre$BaseYear is based on 2021 at present)
* For initializing BetaPr and BetaLk, EV elasticities of EV price and charger supply

global GammaElasEVMean 0.67
global GammaElasEVStdDev 0.025
* 'Gamma' for supply elasticity. Here, EV fleet size elasticity of charger supply.
* Source: Springel (2020) (0.67) and 
*         Li et al. (2017), (0.61 with 0.16 s.e. or estimated Std Dev.)  


*-------------------------------------------------------------------------------
* CAFE and GHG Tailpipe Standards parameters
*-------------------------------------------------------------------------------
global LastCAFEYear 2026
* Last year of CAFE standards specified in law

global CAFEGrowthRateCar 0
global CAFEGrowthRateTruck 0
* Annual growth rates in CAFE MPG standard after LastCAFEYear

global CAFELimitCar 70
global CAFELimitTruck 50
* Max assumed CAFE MPG of an ICEV car to prevent future CAFE standards for ICEVs
* from exceeding EV efficiency

global EPATargetEVShare 0.65
* EPA-suggested EV share [0,1] for compliance w/EPA GHG standards by $EPANewStdsEnd.

global NonCAFECostGrowthShare 0.2
* Annual increase in ICEV cost if CAFE standards unchanged from prev year.
* Value is arbitrary, preferable to assuming CAFE is ONLY source of 
* increase in ICEV costs.

global muEPAFactor 0.0108
* EMPIRICALLY DEVELOPED value for higher attribute drift to force illustrative path 
* for EV shares that reach $EPATargetEVShare by $EPANewStdsEnd or earlier. 
* (At that point, default attribute drift resumes.) 
* Numeric value meaningless by itself. 
* Use in combination with $New_Stds_PriceFactor.

global NewStdsPriceFactor 0.4
* Relative-price multiplier for EV vs ICEV prices when EPA_New_Stds == 1.
* Lowers EV prices to achieve ILLUSTRATIVE path of EV shares that 
* EPA says would comply with proposed GHG tailpipe standards for 2027-2032.
* Numeric value meaningless by itself. 
* Use with $muEPAFactor.


*-------------------------------------------------------------------------------
* Base-year LDV and EV sales parameters
*-------------------------------------------------------------------------------
global ANLSalesCar$BaseYear 2852.363
global EIASalesCar$BaseYear 5251.19
global ANLSalesTruck$BaseYear 10866.350
global EIASalesTruck$BaseYear 9010.59
/*
LDV Car|Truck Sales data from ANL (Argonne National Lab) and EIA.
(They differ because their definitions of 'car' and 'truck' differ)
Note: ANL *until 2023 provided* separate sales totals for cars and light trucks.
However, at present, they only provide combined sales of all light-duty EVs.
*/

global ANLEVShareCar$BaseYear 0.1006
global ANLEVShareTruck$BaseYear 0.0581
/*
EV model uses ANL data on EV *shares*, and EIA's EV *sales projections*
So the model must rescale ANL's implied EV car sales total (ANLSalesCar * ANLEVShareCar)
to EIA's definition of 'car' (EIASalesCar / ANLSalesCar), and the same for EV
truck sales. See 'initialize_EV_shares.do'
*/

global ANLEVFleet$BaseYear 2913097.7  // End 2022 estimated size US EV LDV fleet
* Total EV sales to 2022, since 2010 accounting for scrappage via
* $VehNotScrapped (defined elsewhere in this file)
* Source: EIA (2010), 
* ANL (2011-2022) https://www.anl.gov/esia/reference/light-duty-electric-drive-vehicles-monthly-sales-updates-historical-data)

global ShareCorrect2023 1.1   // 1.1 ~= 8.4/7.5
* Special correction for model's 2023 EV share projection
* Ensures projected 2023 share = 8.4% as observed in ANL data for first 4 months
* of 2023, vs. model's projected ~7.5%.
* Prevents small kink at 2023 in output plot and reduction of model's future
* projected shares.


*-------------------------------------------------------------------------------
* Vehicle Operation and Maintenance (OM) costs
*-------------------------------------------------------------------------------
global NumOMYears 8        // Do not set > largest 'yy' in VMTCaryy, VMTTruckyy
* Num years of discounted future O&M costs that consumers consider when choosing
* between EV and ICEV.

global VehNotScrapped 0.956
* Bento et al. (2018) finds E(age at scrappage) = 15.6, implying 6.4% scrappage/yr.
* CBO uses 4.4% here to reflect that EV sales are not in steady state but growing
* (using 5% annual growth).

global DiscRate 0.03
* Discount rate
* Source: Cole et al. (2023) assumes 3%; Clinton et al. (2020) assume 5%

global CostofCap 0.08
* Cost of Capital
* Avg, 2013-2023 for: Automotive/Elec Utilities/Electronics/Electro Eqpt/Construct & Engnring
* Source: Damodaran (2023)
* Re Cole et al. (2023): (pi)(t) = C(t) - {C(t+1) / CostofCap}, i.e. 
* COST of waiting till t+1 (profit) = BENEFIT of waiting (discounted reduction
* in battery costs).

global ConsumerMyopiaMin 0.5
global ConsumerMyopiaMax 1
* Discounted Consumer Myopia Factor
* Source: Cole et al. (2023)

global RWFEMin 0.74
global RWFEMax 0.78
* Real world fuel economy (RWFE): < CAFE test values
* Source: www.govinfo.gov/content/pkg/FR-2022-05-02/pdf/2022-07200.pdf

global EVEnergyCar 0.292             // kWh/mi, = typical current EV, consistent with $8750 for 70-kWh batt for 240-mi range.
global EVEnergyTruck 0.5             // kWh/mi, = least-efficient current EV car & $15k cost for 120 kWh batt for 240 mi range.

global ICEVMaintperMiCar 0.061       // Maintenance $ per mile, from UBS breakdown.
global ICEVMaintperMiTruck 0.094     // UBS estimates the cross-over maint cost at $0.065/mi.

global EVMaintperMiCar 0.026         // Maintenance $ per mile, from UBS breakdown.
global EVMaintperMiTruck 0.039       // UBS estimates the cross-over maint cost at $0.029/mi.

global HomeEVChargerCost 1300
* Cost of home EV charger.
* Assume every EV purchase requires a charger.


*-------------------------------------------------------------------------------
* Vehicle components and component costs
*-------------------------------------------------------------------------------
global EVBattSizeCar 70
global EVBattSizeTruck 120
* EV battery sizes (kWh)

global EVCostFactBattMean -0.06
global EVCostFactBattStdDev 0.006
global EVCostFactOthPtMean -0.016
global EVCostFactOthPtStdDev 0.0016
global EVCostFactAssemblyMean -0.007
global EVCostFactAssemblyStdDev 0.0007
global EVCostFactIndirectMean -0.10     // UBS, 14% (based on a 2017-2025 proj) seems too big
global EVCostFactIndirectStdDev 0.015   // Larger StdDev:Mean than above (lower confidence)
* EV cost factors (annual rates of decrease in component costs).
* Source: UBS

global EVCostChangeRate 1                // Default 1.
* Set < 1 to slow the rates of cost decrease defined by $EVCostFact*, for
* sensitivity testing.

* EV batteries
global BaseYearCostkWh 125         // UBS as of 2021 (as with component cost ests below)
global kWhCostFloor 50
* EV other powertrain costs
global BaseYearCostPt 3232
global PtCostFloor 1293            // by analogy to battery cost floor of 50 vs 125 in 2021

global BaseYearEVAssembly 12246    // UBS 2021 value, declining at 0.7% per year
global EVAssemblyCostFloor 100     // UBS no floor on assembly costs (slow annual decline)

global BaseYearIndirectCosts 5817  // UBS 2021, decline at 5% (UBS says 14% - too rapid?)
global IndirectCostFloor 3200      // UBS value for 2025, note: is lower than for ICEV (4000)
                                   // Smaller workforce per vehicle ==> lower admin costs?
* EV Manufacturer Markup Factor
global BaseYearRatioEVtoICEVMkup 0.2     // UBS 2021 estimated EV:ICEV mfacturer markup ratio
global AnnIncrRatioEVtoICEVMkup 0.8
global EVMarkupParityYear 2035          // CBO assumes EV:ICEV ratio rises to one in 2035
assert $BaseYearRatioEVtoICEVMkup + $AnnIncrRatioEVtoICEVMkup == 1  // These must sum to 1

global ICEVCostFactMean 0.016
global ICEVCostFactStdDev 0.0008  // +/- 1/20th of that? (0.0008) 
* ICEV cost, annual increase (mostly from CAFE compliance)

global ICEVPtCost 6800
global ICEVAssemblyCost 12700
global ICEVIndirectCost 4000      // (deprec; amortization; R&D; administrative)
* ICEV Costs
* Source: UBS; 2021 value  
* Note: have not scaled these costs up for ICE trucks (using same value).


*-------------------------------------------------------------------------------
* Vehicle price markups
*-------------------------------------------------------------------------------
global DealerMarkup 0.15
* Source: UBS (2017), via... Lutsey and Nicholas (ICCT 2019)

global ManufMarkupCar 0.05
global ManufMarkupTruck 0.125  
* ManufMarkupTruck = Avg(15% SUV markup, 10% Crossover markup)
* Crossover markup (not used in model) = Avg(Car markup, SUV markup)
* Source: ICCT (2019) pg 7.

global SalesTaxRate 0.085
* Assumed sales tax rate on all vehicle purchases


*-------------------------------------------------------------------------------
* Vehicle miles traveled (VMT)
*-------------------------------------------------------------------------------
global BaseYearRelVMTRatioMin 0.6
global BaseYearRelVMTRatioMax 0.7
* Initial avg EV/ICEV ratio of VMT
* Source: Lucas Davis (2019), How Much are Electric Vehicles Driven?

global FinalYrFullVMTGap 2025   // Final model year for initial EV/ICEV VMT ratio
global YrsCloseVMTGap 10        // Number of years until VMT parity occurs (EV/ICEV)
global VehLife 15               // Life expectancy of veh (used with RelVMTFactor)
assert $YrsCloseVMTGap + ($FinalYrFullVMTGap - $BaseYear) + 1 <= $VehLife
* At current settings, 10 + (3) + 1 = 14, and declining as $BaseYear grows.
* Formula containing `NumYrsVMTParity' will be incorrect if this condition untrue.
* However, it is fine if $YrsCloseVMTGap, $VehLife exceed NumOMYears.
 
global VMTCar1 13843
global VMTCar2 13580
global VMTCar3 13296
global VMTCar4 12992
global VMTCar5 12672
global VMTCar6 12337
global VMTCar7 11989
global VMTCar8 11630
global VMTCar9 11262
global VMTCar10 10887
global VMTTruck1 15962
global VMTTruck2 15670
global VMTTruck3 15320
global VMTTruck4 15098
global VMTTruck5 14528
global VMTTruck6 14081
global VMTTruck7 13548
global VMTTruck8 13112
global VMTTruck9 12544
global VMTTruck10 12078
* Average vehicle miles traveled (VMT) by AGE OF VEHICLE, first ten years
* Source: Oak Ridge National Laboratory (2022), Transportation Energy Data Book,
* Edition 40, Table 3.14, https://tinyurl.com/yc49hknn (PDF)


*-------------------------------------------------------------------------------
* EV Charging Stations and Costs
*-------------------------------------------------------------------------------
global BaseYearL2 45000       // AFDC, Jan 2023. Cf NREL 75000.
global BaseYearL3 6750        // AFDC, Jan 2023. Cf NREL 700.
/* 
BaseYearL2, L3:
Observed L3: 6708 public + 118 private (some off-limits, e.g. "government only").
Observed L2: 44,268 public + 3,345 private (some off-limits, e.g. "fleet use only".
Assuming 2x EVSE ports per L2 station, 4x EVSE ports per L3 station, on the
basis of a 2022 count of stations vs plugs on AFDC web site of
    L2: 29,231 (59,598), and 
    L3: 4,888 (20,339).
Source: AFDC, Jan 2023
https://afdc.energy.gov/stations/#/analyze?country=US&fuel=ELEC&ev_levels
*/

global BaseYearCostL2 5000    // 2021 value
global BaseYearCostL3 200000  // 2021 value
/*
BaseYearCostL2, L3:
If 2 L2 ports per station @7.7kW ($2500/port ==> $5000)
If 4 L3 ports per station @100kW (~$50,000/port (50kW @ $27.9k, 150kW @ $87.8k) ==> $200000)
Source: Rocky Mountain Institute, 2019
"Reducing EV Charging Infrastructure Costs", https://rmi.org/ev-charging-costs

Cf Cole et al. (2023):
Uses $2,000/L2 port (2 ports/station * $2,000 = $4,000/station).
Uses $100,000/L3 port (4 ports/station * $100,000 = $400,000/station).
*/


global FullBuildL3 15000
* Source: NREL (2017) estimates that 15,000 L3 stations will be needed to serve
* a 100% EV fleet.

global ChargerCostRateMin 0.02
global ChargerCostRateMax 0.04
* Rate of reduction in charger costs (bounds of runiform distribution). 
* Source: Cole et al. (2023) assume 0.02, which tends to result in long-run
* costs asymptoting to 50% of 2020 costs


*-------------------------------------------------------------------------------
* EV Charging Station Survival and Failure Rates
*-------------------------------------------------------------------------------
/*
The IIJA subsidies *can* cause the charger network to expand beyond what
charger suppliers find privately optimal after the subsidies expire.
This module prevents suppliers from decommissioning working chargers to
reduce the size of the network. Instead, it gradually reduces the size of
the network through equipment failure until it is exceeded by suppliers'
preferred network size.

The charger supply condition does not currently bind for L3 or L2, the latter
because L2 supply is constrained to at least equal the L2/EVFleet ratio observed
in $BaseYear.

The rates below are for L2Survive, L3survive in apply_charger_supply_condition.do.
If IIJA subsides expand the charger network beyond what is privately optimal
for suppliers, these rates are applied after IIJA subsidies end.

Survival and failure rates below reflect a logistic age-based survival function,
Survival S_Y = 1/(1 + exp(-g*(t - LD50))), where Failure F_Y = (1 - S_Y).

Rates use g = 0.6, LD50 = 10, for an expected charger life of around 10 years.
*/
* Assumed Survival rates by age of charger
global S1 0.9955
global S2 0.9918
global S3 0.9852
global S4 0.9734
global S5 0.9526
global S6 0.9168
global S7 0.8581
global S8 0.7685
global S9 0.6457
global S10 0.5
global S11 0.3543
global S12 0.2315
global S13 0.1419
global S14 0.0832
global S15 0.0474
global S16 0.0266
global S17 0.0148
global S18 0.0082
global S19 0.0045
global S20 0.0025

* Assumed Failure rates by age of charger
global F1 0.0045
global F2 0.0037
global F3 0.0066
global F4 0.0118
global F5 0.0208
global F6 0.0357
global F7 0.0587
global F8 0.0896
global F9 0.1229
global F10 0.1457
global F11 0.1457
global F12 0.1229
global F13 0.0896
global F14 0.0587
global F15 0.0357
global F16 0.0208
global F17 0.0118
global F18 0.0066
global F19 0.0037
global F20 0.0022

* Average charger age, by years since cohort birth, for g=0.6.
* For example, A2 means average charger age at **end** of 2nd year, accounting
* for failures over past year.
global A1 1
global A2 1.99
global A3 2.97
global A4 3.92
global A5 4.82
global A6 5.62
global A7 6.24
global A8 6.62
global A9 6.75
global A10 6.75
global A11 6.8
global A12 7.06
global A13 7.54
global A14 8.22
global A15 8.65


*-------------------------------------------------------------------------------
* Other IIJA-related parameters
*-------------------------------------------------------------------------------
global IIJASubsidyRate = 0.8

/* 
Charger Supplies in Presence of IIJA Subsidies
(metered spending of IIJA subsidies)

The annual charger supplies below reflect metered spending of $7b in IIJA
subsidies, 2022-2032, based on:
    (1) CBO's scoring of the IIJA legislation and 
    (2) assumed costs of new chargers.
IIJA funding is $7.5b, but CBO expects 20% of the $2.5b tranche will go to
FUEL CELL or other alternative energy source, not EV chargers.
 
Further, the values (numbers of chargers added per year, while subsidies are
available) reflect suppliers' equilibrium responses to those subsidies, as
modeled by CBO using elasticities specified elsewhere in this code. Where 
applicable--based on the effects of the subsidies on charger supply curves--that
modeling adjusts for chargers that would have been supplied even in the absence
of the subsidies (primarily in the first few years of the 2023-2032 interval).
The supply increments given here thus do not directly reflect the number of
chargers that can be supplied for a given amount of subsidy funding.
*/
global IIJAL2Increm2022 = 0        // No IIJA funds spent in 2022.
global IIJAL2Increm2023 = 5935
global IIJAL2Increm2024 = 12241
global IIJAL2Increm2025 = 19230
global IIJAL2Increm2026 = 32314
global IIJAL2Increm2027 = 50630
global IIJAL2Increm2028 = 51090
global IIJAL2Increm2029 = 42339
global IIJAL2Increm2030 = 25693
global IIJAL2Increm2031 = 16002
global IIJAL2Increm2032 = 5894
 
global IIJAL3Increm2022 = 0        // No IIJA funds spent in 2022.
global IIJAL3Increm2023 = 853
global IIJAL3Increm2024 = 1689
global IIJAL3Increm2025 = 2525
global IIJAL3Increm2026 = 4130
global IIJAL3Increm2027 = 6808
global IIJAL3Increm2028 = 7202
global IIJAL3Increm2029 = 5944
global IIJAL3Increm2030 = 3592
global IIJAL3Increm2031 = 2227
global IIJAL3Increm2032 = 818
