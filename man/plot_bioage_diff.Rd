\name{plot_bioage_diff}
\alias{plot_bioage_diff}
\docType{data}
\title{Visualise the BioAge-to-chronological age difference (BioAgeDiff)}
\usage{
plot_bioage_diff(data, bins = 30,
                 title = "BioAgeDiff diagnostic",
                 save  = NULL,
                 width  = 10, height = 5, dpi = 300)
}
\arguments{
\item{data}{A data.frame. Must contain \code{Age} plus the
five marker columns (\code{TC, CRP, PLT, CREA, WBC}) and
may already contain \code{BioAge} (or \code{BioAgeDiff}).}

\item{bins}{Integer. Number of bins for the histogram.
Default \code{30}.}

\item{title}{Character. Main title. Default
\code{"BioAgeDiff diagnostic"}.}

\item{save}{Character or \code{NULL}. If non-NULL, save the
plot to this path.}

\item{width, height, dpi}{See \code{\link{plot_bioage_cor}}.}
}
\value{
A \code{ggplot} object (or a patchwork composite of two
ggplots). When \code{save} is supplied the plot is
returned invisibly.
}
\description{
Produces a one-page diagnostic figure with two panels for a
batch of predicted BioAge values: (1) a histogram of
\code{BioAgeDiff} (\code{BioAge - Age}) with a dashed
vertical reference at 0 and the mean overlaid; and (2) a
Bland-Altman-style scatter of the difference against the
mean of BioAge and chronological age, with the mean
difference and the limits of agreement
(\code{mean +/- 1.96 * SD}) drawn as horizontal reference
lines.
}
\details{
The same input rules as \code{\link{plot_bioage_cor}} apply:
either pass a data.frame that already has \code{BioAge} or
the raw six input columns.

Requires the Suggests package \code{ggplot2} (and
\code{patchwork} for a single composed figure; if missing,
the two panels are printed sequentially).
}
\examples{
\dontrun{
df <- data.frame(
  Age  = c(55, 65, 32, 50, 72, 45, 60, 38, 80, 28),
  TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8, 5.5, 4.5, 6.0, 4.0),
  CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0, 2.0, 0.8, 4.0, 0.4),
  PLT  = c(230, 280, 220, 240, 260, 235, 250, 225, 270, 215),
  CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80, 0.95, 0.78, 1.20, 0.72),
  WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0, 6.8, 5.8, 8.2, 5.2)
)
plot_bioage_diff(df)
}
}
\seealso{
\code{\link{plot_bioage_cor}}, \code{\link{predict_bioage}}.
}
\author{
Xin Gao, PhD \email{gaoxin_0612@163.com}
}
