*-------------------------------------------------------------------------------
* Apply Reconciliation Act (RA) credits to EV prices
* Includes: 
*    EV tax credits (EVTC) and 
*    Advanced manufacturing production credits (AMPC)
*-------------------------------------------------------------------------------
* Called from main.do

if ((RA_EVTC == 1) & (RA_AMPC == 1)) {
    replace EVCarPr = EVCarPr - EVTC - AMPCCar
    replace EVTruckPr = EVTruckPr - EVTC - AMPCTruck
}

else if ((RA_EVTC == 1) & (RA_AMPC == 0)) {
    replace EVCarPr = EVCarPr - EVTC
    replace EVTruckPr = EVTruckPr - EVTC
}

else if ((RA_EVTC == 0) & (RA_AMPC == 1)) {
    replace EVCarPr = EVCarPr - AMPCCar
    replace EVTruckPr = EVTruckPr - AMPCTruck
}
