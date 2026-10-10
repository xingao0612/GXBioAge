\name{predict_bioage}
\alias{predict_bioage}
\docType{data}
\title{Predict BioAge for a data frame of subjects}
\usage{
predict_bioage(data, keep = TRUE, na_action = c("error", "omit"))
}
\arguments{
\item{data}{A data.frame with one row per subject and the six
required columns: \code{Age}, \code{TC}, \code{CRP}, \code{PLT},
\code{CREA}, \code{WBC}. Extra columns are passed through unchanged.}
\item{keep}{Logical. If \code{TRUE} (default), the returned
data.frame contains all input columns plus \code{BioAge} and
\code{BioAgeDiff}. If \code{FALSE}, only those two columns are
returned.}
\item{na_action}{How to handle missing values: \code{"error"}
(default; stop if any required column has NA) or \code{"omit"}
(drop rows with NA in any required column, with a message).}
}
\value{
A data.frame.
}
\description{
Vectorised batch prediction. Each row of \code{data} is one subject
and must contain the six required columns. Units must match the
training units — see \code{\link{calc_bioage}}.
}
\examples{
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
}
\seealso{
\code{\link{calc_bioage}}, \code{\link{predict_bioage_file}},
\code{\link{model_coef}}.
}
\author{
Xin Gao, PhD \email{gaoxin_0612@163.com}
}
