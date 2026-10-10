\name{calc_bioage}
\alias{calc_bioage}
\docType{data}
\title{Calculate Biological Age (BioAge) for a single subject}
\usage{
calc_bioage(age, TC, CRP, PLT, CREA, WBC)
}
\arguments{
\item{age}{Numeric scalar. Chronological age in years.}
\item{TC}{Numeric scalar. Total cholesterol (mmol/L).}
\item{CRP}{Numeric scalar. C-reactive protein (mg/L).}
\item{PLT}{Numeric scalar. Platelet count (10^9/L).}
\item{CREA}{Numeric scalar. Creatinine (mg/dL).}
\item{WBC}{Numeric scalar. White blood cell count (10^9/L).}
}
\value{
A named numeric vector of length 2:
\code{BioAge} (years) and \code{BioAgeDiff} (years;
BioAge minus chronological age).
}
\description{
Implements the GOLD BioAge formula from a Gompertz survival
regression. Returns the predicted biological age and the
age difference (BioAge - chronological age) for one subject.
}
\details{
Units must match the training units of the model: TC in mmol/L,
CRP in mg/L, CREA in mg/dL, PLT and WBC in 10^9/L.
}
\examples{
# A 55-year-old with healthy markers
calc_bioage(age = 55, TC = 5.1, CRP = 1.5,
            PLT = 230, CREA = 0.85, WBC = 6.2)
}
\seealso{
\code{\link{predict_bioage}}, \code{\link{predict_bioage_file}},
\code{\link{model_coef}}.
}
\author{
Xin Gao, PhD \email{gaoxin_0612@163.com}
}
