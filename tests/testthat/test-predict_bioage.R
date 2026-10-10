test_that("predict_bioage returns input columns plus BioAge/BioAgeDiff by default", {
  df <- data.frame(
    ID  = c("S001", "S002", "S003"),
    Age = c(55, 65, 32),
    TC  = c(5.1, 6.5, 4.2),
    CRP = c(1.5, 8.0, 0.5),
    PLT = c(230, 280, 220),
    CREA = c(0.85, 1.40, 0.75),
    WBC = c(6.2, 9.5, 5.4)
  )
  res <- predict_bioage(df)
  expect_true(all(c("BioAge", "BioAgeDiff", "ID", "Age", "TC",
                    "CRP", "PLT", "CREA", "WBC") %in% colnames(res)))
  expect_equal(nrow(res), 3)
})

test_that("predict_bioage keep=FALSE returns only the two result columns", {
  df <- data.frame(
    Age = c(55, 65), TC = c(5.1, 6.5),
    CRP = c(1.5, 8.0), PLT = c(230, 280),
    CREA = c(0.85, 1.40), WBC = c(6.2, 9.5)
  )
  res <- predict_bioage(df, keep = FALSE)
  expect_equal(colnames(res), c("BioAge", "BioAgeDiff"))
})

test_that("predict_bioage batch output equals calc_bioage row by row", {
  df <- data.frame(
    Age = c(55, 65, 32),
    TC  = c(5.1, 6.5, 4.2),
    CRP = c(1.5, 8.0, 0.5),
    PLT = c(230, 280, 220),
    CREA = c(0.85, 1.40, 0.75),
    WBC = c(6.2, 9.5, 5.4)
  )
  res <- predict_bioage(df, keep = FALSE)
  expected <- c(
    calc_bioage(55, 5.1, 1.5, 230, 0.85, 6.2)["BioAge"],
    calc_bioage(65, 6.5, 8.0, 280, 1.40, 9.5)["BioAge"],
    calc_bioage(32, 4.2, 0.5, 220, 0.75, 5.4)["BioAge"]
  )
  expect_equal(res$BioAge, unname(expected), tolerance = 1e-9)
})

test_that("predict_bioage errors on missing required columns", {
  df <- data.frame(Age = 55, TC = 5.1)  # missing everything else
  expect_error(predict_bioage(df), "Missing required columns")
})

test_that("predict_bioage errors on NA by default but can omit", {
  df <- data.frame(
    Age = c(55, NA), TC = c(5.1, 6.0),
    CRP = c(1.5, 2.0), PLT = c(230, 250),
    CREA = c(0.85, 0.95), WBC = c(6.2, 7.0)
  )
  expect_error(predict_bioage(df), "NA values")
  expect_message(
    res <- predict_bioage(df, na_action = "omit"),
    "dropped 1 row"
  )
  expect_equal(nrow(res), 1)
})
