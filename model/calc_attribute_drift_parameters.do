*-------------------------------------------------------------------------------
* Calculate attribute drift parameters
*-------------------------------------------------------------------------------
* Called from main.do

* Attribute drift at time t, ψ_t, is calculated as:
* ψ_t = μ + ψ_(t-1) + ζ, where
*    μ ~ N(μ_mean * |β|, μ_stddev * |β|),
*    β = BetaPr (price elasticity of EV demand), and
*    ζ ~ N(0, 2|μ|)

scalar muMean = $drift * ($MeanDrift + $muEPAFactor * EPA_New_Stds * (year <= $EPANewStdsEnd))
* Recall, $drift is a dummy value = 1 (or = 0 when simulating zero attribute drift)

scalar muStdDev = $drift * abs(muMean) / 4
* Division by 4 in muStdDev yields a 2-sigma range of +/- 0.5*(muMean)

scalar mu = rnormal(muMean * abs(BetaPr), muStdDev * abs(BetaPr))
* DRAW mu once per iteration, not every year of every iteration, as with zeta

scalar zetaStdDevFactor = 2 * $drift
* Cole et al., 2023 assumes (2 * drift) for zetaStdDevFactor
