# CBO's Electric Vehicle Model
CBO's electric vehicle model projects U.S. market equilibrium demand for electric vehicles (EVs) and supply of public EV chargers (both the rapid "L3" chargers and the slower "L2" chargers found in office and retail parking facilities). Demand and supply are jointly determined based on model parameter values for elasticities, costs, markups, prices, attributes of representative vehicles, and optimizing behaviors by market participants. The model is capable of examining the effects of federal policies such as the electric vehicle tax credit and the advanced manufacturing production credit in the Reconcilation Act of 2022 and the EV charger subsidies from the Infrastructure Investment and Jobs Act (IIJA). The model solves for market equilibria each year out to 2050.

The code and data in this repository allow users to replicate -- but for small differences due to revisions in the code for this release -- the results found in CBO's working paper [Modeling the Demand for Electric Vehicles and the Supply of Charging Stations in the United States: Working Paper 2023-06](https://www.cbo.gov/publication/58964) by David H. Austin, Principal Analyst in CBO's Microeconomic Studies Division. The model has not been used for any CBO baseline or cost estimate analyses.

There are many abbreviations and initialisms used throughout the code and documentation for this model. A table of those can be found [here](docs/abbreviations.md).

## How to run the model
The code was written and tested using Stata/IC 14.2 for Windows (64-bit x86-64), although it should be compatible with other versions of that program. (Further information about Stata can be found at https://www.stata.com.)

The model is structured to run four specific policies:
* `NoPolicy`
* `IIJA_Only`
* `IIJA_RA`
* `IIJA_RA_EPA_New_Stds`

To run all policy simulations at once, run the Stata program `model/run_EV_model.do`. For that program to run, however, you must first **edit line 13** and enter the full file path to the `model/` directory to which this repo was downloaded locally.

To run just a single policy, run the Stata program `model/main.do [PolicyName]` from the Stata Command window. Note that [**PolicyName**] must match one of the five policies supported by the model. And similar to the file path specification in `model/run_EV_model.do`, you must first **edit line 9** and enter the full file path to the `model/` directory to which this repo was downloaded locally.

All model parameters are set in `model/set_parameters.do`, and this should be the only file you need to make edits to to change the default model behavior. The first paramter in that file sets the model to run 2000 simulations for each policy and takes about 15 minutes to run a single policy (about 60 minutes if all four policies are run from `model/run_EV_model.do`). Running times will vary depending on your computer's processor speed and which Stata version you use. For development testing, this parameter can be reduced to just 20 simulations to significantly shorten the model run time.

## Input data sources
The model reads in a single exogenous data file: `inputs/EVModelData.csv`. That datafile contains data from four sources:

* Current and projected future U.S. sales of light-duty vehicles  
Source: [Energy Information Administration, Annual Energy Outlook, "Light-Duty Vehicle Sales by Technology Type"](https://www.eia.gov/outlooks/aeo/data/browser/#/?id=48-AEO2023&region=1-0&cases=noIRA&start=2021&end=2050&f=A&sourcekey=0), Table 38, Region: United States, Cases & Scenarios: "No Inflation Reduction Act"

* Supply of public EV charging stations in the U.S.  
Source: [Department of Energy, Alternative Fuels Data Center](https://afdc.energy.gov/fuels/electricity-stations)

* Projected future U.S. electricity prices  
Source: [Energy Information Administration, Annual Energy Outlook, "Energy Prices by Sector and Source"](https://www.eia.gov/outlooks/aeo/data/browser/#/?id=8-AEO2023&cases=ref2023&sourcekey=0) Table 8, Region: United States

* Projected future U.S. motor gasoline prices  
Source: [Energy Information Administration, Annual Energy Outlook, "Energy Prices by Sector and Source"](https://www.eia.gov/outlooks/aeo/data/browser/#/?id=12-AEO2023&region=0-0&cases=ref2023&start=2021&end=2050&f=A&sourcekey=0) Table 12, Region: United States


## What to expect for output
The model produces two types of output: 
* Numeric data in comma-separated values (`*.csv`) files written to the `outputs/` directory and 
* Figures in `*.png` files written to the `outputs/figures` directory. 

The model also creates Stata-formated `*.dta` files written to the `outputs/sims` directory, but those files are not included in the repo. (They are excluded in the `.gitignore` file in the root of the repo.)

The numeric output data contain summary statistics calculated based on 2000 iterations of a simulated policy. Most summary statistics produced are medians. Some output variables also include 17th- and 83rd-percentile values, in which case the variables will have `P50`, `P17`, and `P83` suffixes, respectively.

Output measures are:
* EV sales shares, overall and with separate shares for cars, light trucks
* EV fleet size (number of vehicles in operation),
* Relative prices of representative EV cars, light trucks (versus prices of comparable ICEVs),
* Number of L2 charging stations,
* Ratio of L2 / EV Fleet, and 
* Number of L3 charging stations


## Model calibration
The model is calibrated so that, under the **`NoPolicy`** scenario, it projects median EV shares in 2030 of approximately 16.5%, 24%, or 34% for, respectively, CBO's slow, historical-growth, and rapid growth scenarios. Historical-growth target for 2030 reflects a trajectory indicated by fitting past EV sales data to a quadratic equation, using the fitted relationship to predict the 2030 EV share. Slow and rapid growth scenarios target 2030 EV shares 8-10 percentage points higher or lower than in the historical-growth scenario.

To recalibrate the model's EV share projection for a different targeted value (in 2030 or another desired year), change the value of the `MeanDrift` parameter and determine, by trial and error over 100+ iterations of the model, whether the model projects values close to the desired target. Confirm a final choice over 2000 iterations, adjusting the value and repeating the procedure if necessary.

To recalibrate the model's L2 charger-station supply projection, repeat the above exercise by changing the `InitDeltaL2` parameter. CBO set that parameter value to target the 2022 observed ratio of (`L2` / `EVFleet`). The model projects L3 stations without user input.

## Anticipated policy update
The model does not currently adjust EV tax credits for the 'Foreign Entitities of Concern' provision of the Reconciliation Act, because the Treasury Department had not, at time of model finalization, specified how the FEOC provision was to be applied.

## Contact
Questions about the data, computer code, and documentation may be directed to CBO's Office of Communications at communications@cbo.gov.

CBO will respond to inquiries as its workload permits.