\name{model_coef}
\alias{model_coef}
\docType{data}
\title{
Coefficients of the GXBioAge Gompertz-X survival model
}
\description{
A list of trained coefficients from a Gompertz survival
regression fit on NHANES data. These coefficients are the single
source of truth used by \code{\link{calc_bioage}},
\code{\link{predict_bioage}} and \code{\link{predict_bioage_file}}.
}
\format{
A list with five elements:
\itemize{
  \item \code{b_age1} — age coefficient from Model 1 (age only).
  \item \code{b_age2} — age coefficient used in the final formula
        (set equal to \code{b_age1} per the original paper).
  \item \code{log_gamma} — \code{log(rate_2 / rate_1)}, the
        difference in baseline Gompertz rates.
  \item \code{b_vars} — named numeric vector of marker coefficients
        in the order \code{TC, CRP, PLT, CREA, WBC}.
  \item \code{markers} — character vector of marker names matching
        \code{b_vars}.
}
}
\source{
Trained on NHANES data; see
\code{inst/training-notes.md} for the original R training script.
}
\seealso{
\code{\link{calc_bioage}}, \code{\link{predict_bioage}},
\code{\link{predict_bioage_file}}.
}
\examples{
GXBioAge::model_coef$b_vars
}
\keyword{datasets}
