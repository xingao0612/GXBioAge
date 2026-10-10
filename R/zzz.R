.onAttach <- function(libname, pkgname) {
  ver <- tryCatch(
    as.character(utils::packageVersion("GXBioAge")),
    error = function(e) "?"
  )
  packageStartupMessage(
    "GXBioAge v", ver, " loaded. ",
    "Use ?calc_bioage for single-subject calculation, ",
    "predict_bioage() for a data.frame of subjects, ",
    "predict_bioage_file() for CSV input, or ",
    "plot_bioage_cor() / plot_bioage_diff() for batch visualisations."
  )
}
