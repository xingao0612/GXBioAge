test_that("predict_bioage_file reads example CSV and adds BioAge columns", {
  f <- system.file("extdata", "example_input.csv", package = "GXBioAge")
  skip_if(f == "", "example_input.csv not installed; skipping")
  res <- predict_bioage_file(f)
  expect_true(is.data.frame(res))
  expect_equal(nrow(res), 5)
  expect_true(all(c("BioAge", "BioAgeDiff") %in% colnames(res)))
  expect_true(all(!is.na(res$BioAge)))
})

test_that("predict_bioage_file writes a result CSV when out is provided", {
  f   <- system.file("extdata", "example_input.csv", package = "GXBioAge")
  skip_if(f == "", "example_input.csv not installed; skipping")
  out <- tempfile(fileext = ".csv")
  on.exit(unlink(out), add = TRUE)
  predict_bioage_file(f, out = out)
  expect_true(file.exists(out))
  written <- read.csv(out, stringsAsFactors = FALSE)
  expect_equal(nrow(written), 5)
  expect_true(all(c("BioAge", "BioAgeDiff") %in% colnames(written)))
})

test_that("predict_bioage_file errors on a non-existent file", {
  expect_error(
    predict_bioage_file("this_file_should_not_exist.csv"),
    "not found"
  )
})
