#' Read a delimited text file and predict BioAge for each subject
#'
#' Convenience wrapper around \code{\link{predict_bioage}} for
#' CSV/TSV inputs. Reads a delimited file with one subject per row,
#' runs the BioAge prediction, and optionally writes the augmented
#' table to disk.
#'
#' The input file must contain the six required columns
#' (\code{Age, TC, CRP, PLT, CREA, WBC}) and may include any
#' number of additional identifier columns (e.g. \code{ID}, \code{sex})
#' which are passed through to the output.
#'
#' @param file Character. Path to the input delimited file.
#' @param sep Character. Field separator. Default \code{","} (CSV).
#'   Use \code{"\\t"} for TSV.
#' @param header Logical. Does the file have a header row? Default
#'   \code{TRUE}.
#' @param stringsAsFactors Logical. Default \code{FALSE}.
#' @param out Character or \code{NULL}. If non-NULL, path where the
#'   augmented result CSV should be written.
#' @param na_action Passed to \code{\link{predict_bioage}}.
#' @param plot_dir Character or \code{NULL}. If non-NULL, a directory
#'   where two PNG visualisations of the batch results are written:
#'   \code{plot_dir/bioage_correlation.png} (a density-coloured
#'   scatter of BioAge vs. chronological age with R/MAE/p annotation,
#'   produced by \code{\link{plot_bioage_cor}}) and
#'   \code{plot_dir/bioage_diff.png} (a BioAgeDiff diagnostic panel,
#'   produced by \code{\link{plot_bioage_diff}}). The directory is
#'   created if it does not exist. Requires the Suggests packages
#'   \code{ggplot2} and (for the correlation plot) \code{MASS}; an
#'   informative error is raised if any are missing. Default
#'   \code{NULL} (no plots).
#' @param plot_width,plot_height Numeric. Width and height in inches
#'   for the saved figures. Default \code{7 x 6} for the
#'   correlation plot and \code{10 x 5} for the difference plot.
#' @param plot_dpi Integer. Resolution for the saved figures.
#'   Default \code{300}.
#' @param ... Additional arguments passed to
#'   \code{utils::read.table}.
#'
#' @return Invisibly returns a data.frame with the input columns plus
#'   \code{BioAge} and \code{BioAgeDiff}. If \code{out} is provided,
#'   the same data.frame is also written there. If \code{plot_dir}
#'   is provided, the two visualisations are written there as a
#'   side effect.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Read CSV, predict, write results CSV, and dump diagnostic plots
#' predict_bioage_file(
#'   "inst/extdata/example_input.csv",
#'   out      = "results.csv",
#'   plot_dir = "plots"
#' )
#' }
predict_bioage_file <- function(file, sep = ",", header = TRUE,
                                stringsAsFactors = FALSE,
                                out = NULL,
                                na_action = c("error", "omit"),
                                plot_dir = NULL,
                                plot_width  = c(cor = 7, diff = 10),
                                plot_height = c(cor = 6, diff = 5),
                                plot_dpi    = 300,
                                ...) {
  na_action <- match.arg(na_action)
  if (!file.exists(file))
    stop("Input file not found: ", file)

  df <- utils::read.table(
    file           = file,
    sep            = sep,
    header         = header,
    stringsAsFactors = stringsAsFactors,
    check.names    = FALSE,
    ...
  )

  res <- predict_bioage(df, keep = TRUE, na_action = na_action)

  if (!is.null(out)) {
    utils::write.csv(res, out, row.names = FALSE)
    message("predict_bioage_file: wrote results to ", out)
  }

  if (!is.null(plot_dir)) {
    if (!dir.exists(plot_dir))
      dir.create(plot_dir, recursive = TRUE, showWarnings = FALSE)
    if (length(plot_width)  == 1L) plot_width  <- c(cor = plot_width,  diff = plot_width)
    if (length(plot_height) == 1L) plot_height <- c(cor = plot_height, diff = plot_height)
    if (length(plot_width)  < 2L) plot_width  <- c(cor = plot_width,  diff = 10)
    if (length(plot_height) < 2L) plot_height <- c(cor = plot_height, diff = 5)

    cor_path <- file.path(plot_dir, "bioage_correlation.png")
    diff_path <- file.path(plot_dir, "bioage_diff.png")
    plot_bioage_cor(res,
                    save   = cor_path,
                    width  = unname(plot_width[["cor"]]),
                    height = unname(plot_height[["cor"]]),
                    dpi    = plot_dpi)
    message("predict_bioage_file: wrote correlation plot to ", cor_path)
    plot_bioage_diff(res,
                     save   = diff_path,
                     width  = unname(plot_width[["diff"]]),
                     height = unname(plot_height[["diff"]]),
                     dpi    = plot_dpi)
    message("predict_bioage_file: wrote diagnostic plot to ", diff_path)
  }

  invisible(res)
}
