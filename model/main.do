********************************************************************************
* CBO's Electric Vehicle Model
********************************************************************************
set more off
set varabbrev off
clear all

* Uncomment the line below and enter the file path where this .do file is saved.
* global ModelPath "Enter/your/full/file/path/here"
cd "$ModelPath"

* Assign argument passed in to main.do as a global macro var called Policy
if "`1'" == "" global Policy "NoPolicy"
else global Policy "`1'"

quietly {
    do set_policy_switches.do $Policy
    do set_parameters.do
    set seed $RandSeed                          // From set_parameters.do

    * Create empty data set for collecting simulation results
    save "${OutputsSimsPath}\\${Policy}_sims.dta", replace emptyok

    * Begin Simulation Loop
    forvalues i = 1 / $NumIterations {
        noisily display "Iteration `i' $Policy"
        do read_model_data.do                   // LDVCar/Truck, CAFECar/Truck, ResidElecPr, GasPr
        do initialize_EV_shares.do              // Sets EVShareCar|Truck
        do initialize_EV_fleet.do               // Sets EVFleetCar|Truck
        do draw_random_values.do                // Makes numerous random draws once per simulation
        gen Iteration = `i'
        * Demand side
        do calc_vehicle_prices.do               // Calcs EVCarPr, EVTruckPr, ICEVCarPr, ICEVTruckPr
        do calc_RA_tax_credits.do               // Calcs EVTC, AMPCCar, AMPCTruck
        do apply_RA_tax_credits.do              // Updates EVCarPr and EVTruckPr
        do calc_relative_VMT_factor.do          // Calcs RelVMTFactor
        do calc_avg_relative_VMT_factor.do      // Calcs AvgRelVMTFactor
        do calc_OM_costs.do                     // Calcs Operating and Maintenance costs
        do adjust_vehicle_prices.do             // Adjusts vehicle prices for O&M costs
        do calc_relative_prices.do              // Calcs RelPriceEVCar and RelPriceEVTruck
        * Supply side
        do calc_charger_costs.do                // Calcs CostL2 and CostL3
        * Calibration
        do calibrate_alpha_parameter.do         // Calcs AlphaCar, AlphaTruck to calibrate EV demand
        do calibrate_delta_parameter.do         // Calcs DeltaL2, DeltaL3 to calibrate EV charger supply
        do calc_attribute_drift_parameters.do   // Calcs mu and zetaStdDevFactor

        do initialize_variables.do              // Initialize variables used in Year Loop

        * Begin Year Loop
        forvalues y = $StartYear / $EndYear {
            do update_attribute_drift_parameters.do `y'
            do update_elasticities.do
            do project_EV_shares.do `y'
            do project_charger_supply.do `y'
            do apply_charger_supply_condition.do `y'
        } 

        do save_sims_data.do

    }  // End Simulation loop

    do calc_summary_stats.do
    do make_figures.do

}  // END quietly block
* EV model finished
