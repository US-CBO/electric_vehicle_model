*-------------------------------------------------------------------------------
* Draw random values
*-------------------------------------------------------------------------------
* Called from main.do

* Create a variety of scalar values based on random draws and global parameters

* WARNING:
* Changing the order of the random draws will affect the model results!
scalar BetaPr = rnormal($EtaPrElasEVMean, $EtaPrElasEVStdDev) / (1 - ${EVSharePre$BaseYear})
scalar BetaLk = rnormal($EtaChargerElasEVMean, $EtaChargerElasEVStdDev) / (1 - ${EVSharePre$BaseYear})
scalar GammaElasEVCharger = rnormal($GammaElasEVMean, $GammaElasEVStdDev)
scalar ConsumerMyopiaFactor = runiform($ConsumerMyopiaMin, $ConsumerMyopiaMax)
scalar RWFE = runiform($RWFEMin, $RWFEMax)   // Real World Fuel Economy
scalar EVCostFactBatt = rnormal($EVCostFactBattMean, $EVCostFactBattStdDev)
scalar EVCostFactOthPt = rnormal($EVCostFactOthPtMean, $EVCostFactOthPtStdDev)
scalar EVCostFactAssembly = rnormal($EVCostFactAssemblyMean, $EVCostFactAssemblyStdDev)
scalar EVCostFactIndirect = rnormal($EVCostFactIndirectMean, $EVCostFactIndirectStdDev)
scalar ICEVCostFact = rnormal($ICEVCostFactMean, $ICEVCostFactStdDev)
scalar BaseYearRelVMTRatio = runiform($BaseYearRelVMTRatioMin, $BaseYearRelVMTRatioMax)
scalar ChargerCostRate = runiform($ChargerCostRateMin, $ChargerCostRateMax)
