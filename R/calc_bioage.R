#' Calculate Biological Age (BioAge) for a single subject
#'
#' Implements the GOLD BioAge formula from a Gompertz survival
#' regression. Returns the predicted biological age and the
#' age difference (BioAge - chronological age) for one subject.
#'
#' Units must match the training units of the model:
#' \itemize{
#'   \item \code{age}:  years
#'   \item \code{TC}:   total cholesterol, mmol/L
#'   \item \code{CRP}:  C-reactive protein, mg/L
#'   \item \code{PLT}:  platelet count, 10^9/L
#'   \item \code{CREA}: creatinine, mg/dL
#'   \item \code{WBC}:  white blood cell count, 10^9/L
#' }
#'
#' @param age  Numeric scalar. Chronological age in years.
#' @param TC   Numeric scalar. Total cholesterol (mmol/L).
#' @param CRP  Numeric scalar. C-reactive protein (mg/L).
#' @param PLT  Numeric scalar. Platelet count (10^9/L).
#' @param CREA Numeric scalar. Creatinine (mg/dL).
#' @param WBC  Numeric scalar. White blood cell count (10^9/L).
#'
#' @return A named numeric vector of length 2:
#'   \code{BioAge} (years) and \code{BioAgeDiff} (years;
#'   BioAge minus chronological age).
#'
#' @export
#'
#' @examples
#' # A 55-year-old with healthy markers
#' calc_bioage(age = 55, TC = 5.1, CRP = 1.5,
#'             PLT = 230, CREA = 0.85, WBC = 6.2)
calc_bioage <- function(age, TC, CRP, PLT, CREA, WBC) {
  if (!is.numeric(age) || length(age) != 1L)
    stop("`age` must be a single numeric value (years).")
  mc <- model_coef
  marker_part <-
    mc$b_vars["TC"]   * TC +
    mc$b_vars["CRP"]  * CRP +
    mc$b_vars["PLT"]  * PLT +
    mc$b_vars["CREA"] * CREA +
    mc$b_vars["WBC"]  * WBC
  bioage <- (mc$b_age2 * age + marker_part + mc$log_gamma) / mc$b_age1
  c(BioAge     = unname(bioage),
    BioAgeDiff = unname(bioage - age))
}
