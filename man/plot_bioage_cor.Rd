\name{plot_bioage_cor}
\alias{plot_bioage_cor}
\docType{data}
\title{Visualise the correlation between chronological age and BioAge}
\usage{
plot_bioage_cor(data,
                title = "BioAge vs chronological age",
                xlab  = "Chronological age (years)",
                ylab  = "BioAge (years)",
                point_size  = 1.5,
                point_alpha = 0.9,
                smooth = TRUE,
                kde_n  = 200,
                density_colors = c("#9eaad1", "#dacfe5",
                                   "#f5dbb6", "#f59790"),
                base_size = 18,
                save = NULL, width = 7, height = 6, dpi = 300)
}
\arguments{
\item{data}{A data.frame. Must contain \code{Age} plus the
five marker columns (\code{TC, CRP, PLT, CREA, WBC}) and
may already contain \code{BioAge}. If \code{BioAge} is
missing it will be computed via \code{\link{predict_bioage}}.}

\item{title}{Character. Plot title. Default
\code{"BioAge vs chronological age"}.}

\item{xlab}{Character. X-axis label. Default
\code{"Chronological age (years)"}.}

\item{ylab}{Character. Y-axis label. Default
\code{"BioAge (years)"}.}

\item{point_size}{Numeric. Point size passed to
\code{geom_point}. Default \code{1.5}.}

\item{point_alpha}{Numeric in (0, 1]. Point transparency.
Default \code{0.9}.}

\item{smooth}{Logical. If \code{TRUE} (default) overlay the
linear regression line.}

\item{kde_n}{Integer. Resolution of the 2D KDE grid
(\code{MASS::kde2d(n = ...)}). Default \code{200}.}

\item{density_colors}{Character vector of >= 2 colours used
for the density gradient. Default
\code{c("#9eaad1", "#dacfe5", "#f5dbb6", "#f59790")}.}

\item{base_size}{Numeric. Base font size for
\code{theme_classic}. Default \code{18}.}

\item{save}{Character or \code{NULL}. If non-NULL, the plot
is saved to this path (file extension determines the
device: \code{.png}, \code{.pdf}, \code{.jpg}, \code{.tiff},
\code{.svg}, \code{.bmp} are recognised; anything else
defaults to PNG). The function returns the ggplot object
invisibly in this case so callers can keep editing it.}

\item{width, height}{Numeric. Width and height in inches when
\code{save} is used. Default \code{7 x 6}.}

\item{dpi}{Integer. Resolution for raster devices. Default
\code{300}.}
}
\value{
A \code{ggplot} object. The plot is rendered as a
side effect unless \code{save} is supplied, in which case
it is returned invisibly.
}
\description{
Produces a density-coloured scatter plot of BioAge against
chronological Age for a batch of subjects, with a linear
regression overlay and an annotation box reporting the
Pearson correlation coefficient (\code{R}), the mean absolute
error (\code{MAE = mean(|BioAge - Age|)}), and the p-value of
the correlation test.
}
\details{
Point colour is mapped to a 2D kernel density estimate of the
(Age, BioAge) joint distribution via \code{MASS::kde2d}, so
that crowded regions appear warmer. The colour gradient is
fixed to a 4-stop palette
(\code{#9eaad1, #dacfe5, #f5dbb6, #f59790}) and the legend
is hidden by default.

In both cases rows with NA in \code{Age} or \code{BioAge} are
silently dropped before plotting, with an informative message.

Requires the Suggests packages \code{ggplot2} and
\code{MASS}; an informative error is raised if any are missing.
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
plot_bioage_cor(df)
}
}
\seealso{
\code{\link{predict_bioage}}, \code{\link{predict_bioage_file}},
\code{\link{plot_bioage_diff}}.
}
\author{
Xin Gao, PhD \email{gaoxin_0612@163.com}
}
