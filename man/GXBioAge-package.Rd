\name{GXBioAge-package}
\alias{GXBioAge-package}
\alias{GXBioAge}
\docType{package}
\title{
GXBioAge: Gompertz-X Biological Age from a Survival Model
}
\description{
GXBioAge — Gompertz-X Biological Age (the suffix "X" denotes five
clinical laboratory biomarkers used for model construction) —
implements a biological age (BioAge) estimator based on a Gompertz
survival regression trained on NHANES data. The model uses
chronological age plus five routine blood markers — Total Cholesterol
(TC), C-Reactive Protein (CRP), Platelet count (PLT), Creatinine
(CREA) and White Blood Cell count (WBC) — and returns both BioAge
and the BioAge-to-chronological age difference (BioAgeDiff).

Four user-facing interfaces are provided:
\itemize{
  \item \code{\link{calc_bioage}} — single-subject calculation
  \item \code{\link{predict_bioage}} — batch prediction on a
        data.frame
  \item \code{\link{predict_bioage_file}} — read a CSV/TSV file,
        return a results table, and optionally dump diagnostic
        visualisations
  \item \code{\link{plot_bioage_cor}} /
        \code{\link{plot_bioage_diff}} — ggplot2-based
        visualisations of batch BioAge results (correlation
        scatter with R / MAE / p annotation, and a
        BioAgeDiff diagnostic panel)
}
}
\author{
Xin Gao, PhD
\email{gaoxin_0612@163.com}

Department of Clinical Laboratory, Xiangya Hospital of Central
South University.
}
\references{
Citation: (Pending publication).
}
\seealso{
\code{\link{calc_bioage}},
\code{\link{predict_bioage}},
\code{\link{predict_bioage_file}},
\code{\link{plot_bioage_cor}},
\code{\link{plot_bioage_diff}},
\code{\link{model_coef}}.
}
\keyword{package}
