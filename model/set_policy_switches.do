*-------------------------------------------------------------------------------
* Set policy switches to determine which polic(-y/-ies) get simulated
*-------------------------------------------------------------------------------
* Called from main.do

local policy = "`1'"

if "`policy'" == "NoPolicy" {
    scalar IIJA = 0          // NO: IIJA Charger Subsidies
    scalar RA_EVTC = 0       // NO: RA EV Tax Credits
    scalar RA_AMPC = 0       // NO: RA Advanced Manufacturing Production Credit
    scalar EPA_New_Stds = 0  // NO: Proposed post 2026 EPA greenhouse gas emmisions standards
}

else if "`policy'" == "IIJA_Only" {
    scalar IIJA = 1          // YES: IIJA Charger Subsidies
    scalar RA_EVTC = 0       // NO: RA EV Tax Credits
    scalar RA_AMPC = 0       // NO: RA Advanced Manufacturing Production Credit
    scalar EPA_New_Stds = 0  // NO: Proposed post 2026 EPA greenhouse gas emmisions standards
}

else if "`policy'" == "IIJA_RA" {
    scalar IIJA = 1          // YES: IIJA Charger Subsidies
    scalar RA_EVTC = 1       // YES: RA EV Tax Credits
    scalar RA_AMPC = 1       // YES: RA Advanced Manufacturing Production Credit
    scalar EPA_New_Stds = 0  // NO: Proposed post 2026 EPA greenhouse gas emmisions standards
}

else if "`policy'" == "IIJA_RA_EPA_New_Stds" {
    scalar IIJA = 1          // YES: IIJA Charger Subsidies
    scalar RA_EVTC = 1       // YES: RA EV Tax Credits
    scalar RA_AMPC = 1       // YES: RA Advanced Manufacturing Production Credit
    scalar EPA_New_Stds = 1  // YES: Proposed post 2026 EPA greenhouse gas emmisions standards
}

else {
    display "policy does not match one of the acceptable policy names."
    exit 198  // invalid syntax error (https://www.stata.com/manuals/perror.pdf)
}
