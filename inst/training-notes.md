# Training Notes for GXBioAge

This package ships with coefficients from a Gompertz survival
regression that was originally fit in R using
`flexsurv::flexsurvreg`. The two nested models are:

```r
# Model 1: age only
gom1 <- flexsurvreg(Surv(fu_years, status) ~ Age, data = dat,
                    dist = "gompertz")

# Model 2: age + five blood markers
gom2 <- flexsurvreg(Surv(fu_years, status) ~ Age + TC + CRP +
                                       PLT + WBC + CREA,
                    data = dat, dist = "gompertz")

# Age coefficient (set equal between the two models per the paper)
b_age1 <- coef(gom1)["Age"]
b_age2 <- b_age1

# Marker coefficients
my_vars <- c("TC", "CRP", "PLT", "CREA", "WBC")
b_vars  <- coef(gom2)[my_vars]

# Baseline-rate adjustment
log_gamma <- log(gom2$res["rate", 1] / gom1$res["rate", 1])
```

These five values (`b_age1`, `b_age2`, `log_gamma`, `b_vars`,
`markers`) are saved in `R/model_coef.R` and re-exported as the
package object `GXBioAge::model_coef`.

## Units (must match between training and prediction)

| Variable | Unit |
|---|---|
| Age  | years |
| TC   | mmol/L |
| CRP  | mg/L |
| PLT  | 10⁹/L |
| CREA | mg/dL |
| WBC  | 10⁹/L |

If the training data used different units, you must re-fit the
Gompertz model and update `R/model_coef.R` accordingly.

## Notes for v0.2.0

The previous release (v0.1.0) included *Uric Acid (UA)* as a sixth
marker. The v0.2.0 model drops UA and is re-fit on the remaining
five markers, which yields slightly different `b_vars` values and a
different sign of `log_gamma`. Callers upgrading from v0.1.0 input
files should drop the `UA` column before calling `predict_bioage()`.

## Validation

The companion HTML calculator at
`Gompertz_BioAge_Calculator.html` uses the same coefficients and
formula; results from `calc_bioage()` should match the calculator
to at least 2 decimal places.
