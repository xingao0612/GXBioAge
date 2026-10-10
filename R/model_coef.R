#' Coefficients of the GXBioAge Gompertz-X survival model
#'
#' A list of trained coefficients from a Gompertz survival regression
#' fit on NHANES data. These coefficients are loaded into the package
#' namespace and are the single source of truth used by
#' \code{\link{calc_bioage}}, \code{\link{predict_bioage}} and
#' \code{\link{predict_bioage_file}}.
#'
#' The list contains five elements:
#' \describe{
#'   \item{\code{b_age1}}{Numeric scalar. Age coefficient from Model 1
#'     (age-only Gompertz regression).}
#'   \item{\code{b_age2}}{Numeric scalar. Age coefficient used in the
#'     final BioAge formula. Set equal to \code{b_age1} per the
#'     original GOLD BioAge paper.}
#'   \item{\code{log_gamma}}{Numeric scalar. \code{log(rate_2 / rate_1)},
#'     the difference in baseline Gompertz rates between the
#'     marker-adjusted model and the age-only model.}
#'   \item{\code{b_vars}}{Named numeric vector of marker coefficients
#'     in the order \code{TC, CRP, PLT, CREA, WBC}.}
#'   \item{\code{markers}}{Character vector of marker names matching
#'     the order of \code{b_vars}, used for matrix multiplication.}
#' }
#'
#' @format A list of length 5.
#' @source Trained on NHANES data; see
#'   \code{inst/training-notes.md} for the original R training script.
"model_coef"

#' @export
model_coef <- list(
  b_age1    = 0.09054393,
  b_age2    = 0.09054393,
  log_gamma = 0.2225259,
  b_vars    = c(
    TC   = -0.0892437290,
    CRP  =  0.0617189632,
    PLT  = -0.0006558133,
    CREA =  0.2467716593,
    WBC  =  0.0288810968
  ),
  markers   = c("TC", "CRP", "PLT", "CREA", "WBC")
)
