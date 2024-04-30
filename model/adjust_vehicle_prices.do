*-------------------------------------------------------------------------------
* Adjust vehicle prices for operating and maintenance costs
*-------------------------------------------------------------------------------
* Called from main.do

* Expected ownership costs, as retail price + first $NumOMYears of O&M
replace ICEVCarPr = ICEVCarPr + (ICEVCarOM * ConsumerMyopiaFactor)
replace ICEVTruckPr = ICEVTruckPr + (ICEVTruckOM * ConsumerMyopiaFactor)

replace EVCarPr = EVCarPr + (EVCarOM * ConsumerMyopiaFactor)
replace EVTruckPr = EVTruckPr + (EVTruckOM * ConsumerMyopiaFactor)

/* 
Consumer myopia relates to how attentive consumers are to future O&M costs: 

For $NumOMYears = 8, a ConsumerMyopiaFactor ~ U[0.5, 1] means that, on average,
'myopic' consumers value the future savings from an EV's lower O&M costs (vs. ICEV)
the same as if they were *not* myopic (i.e. fully attentive to future costs and
savings) but discounted those financial flows at 9.8% per year, rather than 
at DiscRate = 3%. (For $NumOMYears = 5, the equivalent discount rate is 13.2%).
*/
