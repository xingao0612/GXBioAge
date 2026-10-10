#' Predict BioAge for a data frame of subjects
#'
#' Vectorised batch prediction. Each row of \code{data} is one subject
#' and must contain the six required columns: \code{Age}, \code{TC},
#' \code{CRP}, \code{PLT}, \code{CREA}, \code{WBC}. Units must match
#' the training units (see \code{\link{calc_bioage}}).
#'
#' @param data A data.frame with one row per subject and the six
#'   required columns. Extra columns are passed through unchanged.
#' @param keep Logical. If \code{TRUE} (default), the returned
#'   data.frame contains all input columns plus \code{BioAge} and
#'   \code{BioAgeDiff}. If \code{FALSE}, only \code{BioAge} and
#'   \code{BioAgeDiff} are returned.
#' @param na_action How to handle missing values: \code{"error"}
#'   (default; stop if any required column has NA) or \code{"omit"}
#'   (drop rows with NA in any required column, with a message).
#'
#' @return A data.frame.
#'
#' @export
#'
#' @examples
#' df <- data.frame(
#'   ID   = c("S001", "S002", "S003"),
#'   Age  = c(55, 65, 32),
#'   TC   = c(5.1, 6.5, 4.2),
#'   CRP  = c(1.5, 8.0, 0.5),
#'   PLT  = c(230, 280, 220),
#'   CREA = c(0.85, 1.40, 0.75),
#'   WBC  = c(6.2, 9.5, 5.4)
#' )
#' predict_bioage(df)
predict_bioage <- function(data, keep = TRUE,
                           na_action = c("error", "omit")) {
  na_action <- match.arg(na_action)
  if (!is.data.frame(data))
    stop("`data` must be a data.frame.")
  required <- c("Age", model_coef$markers)
  missing_cols <- setdiff(required, colnames(data))
  if (length(missing_cols) > 0)
    stop("Missing required columns: ",
         paste(missing_cols, collapse = ", "))

  if (anyNA(data[, required, drop = FALSE])) {
    if (na_action == "error") {
      stop("`data` contains NA values in required columns. ",
           "Use na_action = 'omit' to drop those rows.")
    }
    keep_idx <- stats::complete.cases(data[, required, drop = FALSE])
    n_dropped <- sum(!keep_idx)
    data <- data[keep_idx, , drop = FALSE]
    message("predict_bioage: dropped ", n_dropped,
            " row(s) with NA in required columns.")
  }

  X    <- as.matrix(data[, model_coef$markers, drop = FALSE])
  pred <- as.numeric(X %*% model_coef$b_vars)
  bioage <- (model_coef$b_age2 * data$Age + pred + model_coef$log_gamma) /
            model_coef$b_age1
  out <- data.frame(
    BioAge     = unname(bioage),
    BioAgeDiff = unname(bioage - data$Age)
  )
  if (isTRUE(keep)) cbind(data, out) else out
}
