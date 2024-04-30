*-------------------------------------------------------------------------------
* Calculate relative prices: EV / ICEV
*-------------------------------------------------------------------------------
* Called from main.do

gen RelPriceEVCar = EVCarPr / ICEVCarPr
gen RelPriceEVTruck = EVTruckPr / ICEVTruckPr

* Smoothly reduce EV prices (RelPriceEV) if EPA_New_Stds == 1, 
* as a way to achieve EPA-suggested compliance strategy of selling more EVs.
if EPA_New_Stds == 1 {
    local RelPrFactor = (1 + $NewStdsPriceFactor)
    foreach VehType in "Car" "Truck" {
        replace RelPriceEV`VehType' = RelPriceEV`VehType' / (`RelPrFactor' - 0.30) if year == 2027
        replace RelPriceEV`VehType' = RelPriceEV`VehType' / (`RelPrFactor' - 0.20) if year == 2028
        replace RelPriceEV`VehType' = RelPriceEV`VehType' / (`RelPrFactor' - 0.10) if year == 2029
        replace RelPriceEV`VehType' = RelPriceEV`VehType' / (`RelPrFactor' - 0.05) if year == 2030
        replace RelPriceEV`VehType' = RelPriceEV`VehType' / (`RelPrFactor' - 0.00) if year >= 2031
    }
}
