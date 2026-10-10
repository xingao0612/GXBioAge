\name{predict_bioage_file}
\alias{predict_bioage_file}
\docType{data}
\title{Read a delimited text file and predict BioAge for each subject}
\usage{
predict_bioage_file(file, sep = ",", header = TRUE,
                    stringsAsFactors = FALSE, out = NULL,
                    na_action = c("error", "omit"),
                    plot_dir = NULL,
                    plot_width  = c(cor = 7, diff = 10),
                    plot_height = c(cor = 6, diff = 5),
                    plot_dpi    = 300, ...)
}
\arguments{
\item{file}{Character. Path to the input delimited file.}
\item{sep}{Character. Field separator. Default \code{","} (CSV).
Use \code{"\\t"} for TSV.}
\item{header}{Logical. Does the file have a header row? Default
\code{TRUE}.}
\item{stringsAsFactors}{Logical. Default \code{FALSE}.}
\item{out}{Character or \code{NULL}. If non-NULL, path where the
augmented result CSV should be written.}
\item{na_action}{Passed to \code{\link{predict_bioage}}.}
\item{plot_dir}{Character or \code{NULL}. If non-NULL, a directory
where two PNG visualisations of the batch results are written:
\code{plot_dir/bioage_correlation.png} (a density-coloured
scatter of BioAge vs. chronological age with R/MAE/p annotation,
produced by \code{\link{plot_bioage_cor}}) and
\code{plot_dir/bioage_diff.png} (a BioAgeDiff diagnostic panel,
produced by \code{\link{plot_bioage_diff}}). The directory is
created if it does not exist. Requires the Suggests packages
\code{ggplot2} and (for the correlation plot) \code{MASS}; an
informative error is raised if any are missing. Default
\code{NULL} (no plots).}
\item{plot_width, plot_height}{Numeric. Width and height in inches
for the saved figures. Default \code{7 x 6} for the
correlation plot and \code{10 x 5} for the difference plot.}
\item{plot_dpi}{Integer. Resolution for the saved figures.
Default \code{300}.}
\item{...}{Additional arguments passed to \code{utils::read.table}.}
}
\value{
Invisibly returns a data.frame with the input columns plus
\code{BioAge} and \code{BioAgeDiff}. If \code{out} is provided,
the same data.frame is also written there. If \code{plot_dir}
is provided, the two visualisations are written there as a
side effect.
}
\description{
Convenience wrapper around \code{\link{predict_bioage}} for
CSV/TSV inputs. Reads a delimited file with one subject per row,
runs the BioAge prediction, optionally writes the augmented
table to disk, and optionally dumps two diagnostic
visualisations of the batch result.
}
\examples{
\dontrun{
# Read CSV, predict, write results CSV, and dump diagnostic plots
predict_bioage_file(
  "inst/extdata/example_input.csv",
  out      = "results.csv",
  plot_dir = "plots"
)
}
}
\seealso{
\code{\link{calc_bioage}}, \code{\link{predict_bioage}},
\code{\link{plot_bioage_cor}}, \code{\link{plot_bioage_diff}},
\code{\link{model_coef}}.
}
\author{
Xin Gao, PhD \email{gaoxin_0612@163.com}
}
