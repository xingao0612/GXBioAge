# GXBioAge

**GXBioAge** — *Gompertz-X Biological Age* (the suffix "X" denotes five
clinical laboratory biomarkers used for model construction) — is a
small R package that estimates biological age (BioAge) from a Gompertz
survival regression trained on NHANES data. The model uses
chronological age plus five routine blood markers:

| Marker | Unit |
|---|---|
| Age (chronological) | years |
| TC — Total Cholesterol | mmol/L |
| CRP — C-Reactive Protein | mg/L |
| PLT — Platelet count | 10⁹/L |
| CREA — Creatinine | mg/dL |
| WBC — White Blood Cell count | 10⁹/L |


## Installation

From the source directory:

```r
# install.packages("devtools")
devtools::install("path/to/GXBioAge")

# The plotting functions need ggplot2 (+ MASS, recommended).
install.packages(c("ggplot2", "MASS"))
```

Or after building:

```r
install.packages("GXBioAge_0.3.0.tar.gz", repos = NULL, type = "source")
```

## Quick start

```r
library(GXBioAge)

# 1) Single subject
calc_bioage(age = 55, TC = 5.1, CRP = 1.5,
            PLT = 230, CREA = 0.85, WBC = 6.2)
#>   BioAge BioAgeDiff
#>   56.08       1.08

# 2) Batch on a data.frame
df <- data.frame(
  ID   = c("S001", "S002", "S003"),
  Age  = c(55, 65, 32),
  TC   = c(5.1, 6.5, 4.2),
  CRP  = c(1.5, 8.0, 0.5),
  PLT  = c(230, 280, 220),
  CREA = c(0.85, 1.40, 0.75),
  WBC  = c(6.2, 9.5, 5.4)
)
predict_bioage(df)

# 3) Read CSV and write results
predict_bioage_file(
  system.file("extdata", "example_input.csv", package = "GXBioAge"),
  out = "results.csv"
)

# 4) Batch visualisations of a prediction table
df <- predict_bioage(
  data.frame(
    Age  = c(55, 65, 32, 50, 72, 45, 60, 38, 80, 28),
    TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8, 5.5, 4.5, 6.0, 4.0),
    CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0, 2.0, 0.8, 4.0, 0.4),
    PLT  = c(230, 280, 220, 240, 260, 235, 250, 225, 270, 215),
    CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80, 0.95, 0.78, 1.20, 0.72),
    WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0, 6.8, 5.8, 8.2, 5.2)
  )
)
plot_bioage_cor(df)   # density-coloured scatter + R / MAE / p
plot_bioage_diff(df)  # BioAgeDiff distribution + Bland-Altman panel

# Or do everything in one step from a CSV:
predict_bioage_file(
  system.file("extdata", "example_input.csv", package = "GXBioAge"),
  out      = "results.csv",
  plot_dir = "plots"
)
# -> results.csv, plots/bioage_correlation.png, plots/bioage_diff.png
```

## Model

For any individual, BioAge is computed as

```
BioAge = ( β_age · Age
        + β_TC · TC + β_CRP · CRP
        + β_PLT · PLT + β_CREA · CREA + β_WBC · WBC
        + log(γ₂ / γ₁) ) / β_age
```

with β_age from a Gompertz model on Age alone and the marker
coefficients from a model on Age + markers; the age coefficient in
the marker model is constrained to equal β_age, and
log(γ₂ / γ₁) absorbs the difference in baseline rates between the
two nested models.

A positive `BioAgeDiff` indicates that the blood-marker profile
carries excess mortality risk relative to peers of the same
chronological age — i.e. *accelerated biological aging*.

## License

MIT. See `LICENSE` / `LICENSE.md`.

## Author

**Xin Gao, PhD**
Department of Clinical Laboratory, Xiangya Hospital of Central South University
[gaoxin_0612@163.com](mailto:gaoxin_0612@163.com)

Citation: *(Pending publication)*
