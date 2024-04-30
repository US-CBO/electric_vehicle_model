*-------------------------------------------------------------------------------
* Calculate vehicle prices
* ------------------------------------------------------------------------------
* Called from main.do

local t (year - $BaseYear)

* EV Constituent Costs
*-------------------------------------------------------------------------------
gen EVBattCost = max($BaseYearCostkWh * exp($EVCostChangeRate * EVCostFactBatt * `t'), $kWhCostFloor)
gen EVOthPtCost = max($BaseYearCostPt * exp($EVCostChangeRate * EVCostFactOthPt * `t'), $PtCostFloor)
gen EVAssemblyCost = max($BaseYearEVAssembly * exp($EVCostChangeRate * EVCostFactAssembly * `t'), $EVAssemblyCostFloor)
gen EVIndirectCost = max($BaseYearIndirectCosts * exp($EVCostChangeRate * EVCostFactIndirect * `t'), $IndirectCostFloor)
gen EVManufMarkupFactor = min(1, ($BaseYearRatioEVtoICEVMkup + $AnnIncrRatioEVtoICEVMkup * `t' / ($EVMarkupParityYear - $BaseYear)))
/* 
Note 1: 'EVCostFact' vars come from draw_random_values.do, govern RATES OF CHANGE
Note 2: Pt = powertrain, IndirectCost includes admin costs
Note 3: $EVCostChangeRate = 1 by default; lower values can be used to
        sensitivity-test slower rates of change 
*/

* EV Prices
*-------------------------------------------------------------------------------
foreach VehType in "Car" "Truck" {
    gen EV`VehType'Pr = (                                                                          ///
        ((${EVBattSize`VehType'} * EVBattCost) + EVOthPtCost + EVAssemblyCost + EVIndirectCost) *  ///
        (1 + $DealerMarkup + EVManufMarkupFactor * ${ManufMarkup`VehType'})   *                    ///
        (1 + $SalesTaxRate)                                                                        ///
      - 7500 * 0.250 * (year == 2021)                   /// Tesla (68% of EV sales), Chevy (7%) not eligible for tax credit
      - 7500 * 0.175 * (year == 2022)                   /// Toyota EVs (7.5% share) not eligible by 2022.
      - 7500 * 0.120 * (year == 2023 & IIJA != 1)       /// Ford EVs (5% share) by 2023 (anticipated).
      - 7500 * 0.050 * (year == 2024 & IIJA != 1)       /// ad hoc assumption of dwindling eligibility
    ) // This 7500 math accounts for loss of eligibility of OLDER EV tax credits as mfrs hit unit limit.
}

* ICEV Prices
*-------------------------------------------------------------------------------
gen ICEVCostFactConstCAFE = ICEVCostFact
replace ICEVCostFactConstCAFE = $NonCAFECostGrowthShare * ICEVCostFact if year > $LastCAFEYear
/*
Constant mean annual projected change in ICEV costs. From draw_random_values.do
$NonCAFEGrwothShare = share of annual change in ICEV costs NOT due to CAFE. 
Used when CAFE is constant.
*/

gen ICEVCarPr = ($ICEVPtCost + $ICEVAssemblyCost + $ICEVIndirectCost) *  ///
                exp(ICEVCostFactConstCAFE * `t') *                         ///
                (1 + $DealerMarkup + $ManufMarkupCar) * (1 + $SalesTaxRate)
gen ICEVTruckPr = ICEVCarPr * ((1 + $ManufMarkupTruck) / (1 + $ManufMarkupCar))
