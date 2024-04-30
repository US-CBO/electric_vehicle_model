*-------------------------------------------------------------------------------
* Calculate operating and maintenance (O&M) costs
*-------------------------------------------------------------------------------
* Called from main.do

foreach VehType in "Car" "Truck" {
    gen AdjCAFE`VehType' = CAFE`VehType' * RWFE  // Adjust CAFE std by real world fuel efficiency factor
    gen ICEV`VehType'OM = 0
    gen   EV`VehType'OM = 0

    forvalues t = 1 / $NumOMYears {
        local tminus1 = `t' - 1
        local MidYearDiscFactor ((1 + $DiscRate ) ^ (`tminus1' * -1) + (1 + $DiscRate ) ^ (`t' * -1)) / 2

        * GasPr is $/gal, 1/AdjCAFE is gal/mi so result is $/mi
        local ICEVDriveCost ${VMT`VehType'`t'} * (${ICEVMaintperMi`VehType'} + F`tminus1'.GasPr * (1 / AdjCAFE`VehType'))
        local   EVDriveCost ${VMT`VehType'`t'} * (  ${EVMaintperMi`VehType'} + F`tminus1'.ResidElecPr * ${EVEnergy`VehType'})

        replace ICEV`VehType'OM = ICEV`VehType'OM + (AvgRelVMTFactor * `ICEVDriveCost' * `MidYearDiscFactor')
        replace   EV`VehType'OM =   EV`VehType'OM + (AvgRelVMTFactor *   `EVDriveCost' * `MidYearDiscFactor')
    }
    replace EV`VehType'OM = EV`VehType'OM + $HomeEVChargerCost
}
