test_that("calc_bioage returns a named numeric vector of length 2", {
  out <- calc_bioage(age = 55, TC = 5.1, CRP = 1.5,
                     PLT = 230, CREA = 0.85, WBC = 6.2)
  expect_type(out, "double")
  expect_length(out, 2)
  expect_named(out, c("BioAge", "BioAgeDiff"))
})

test_that("calc_bioage matches the expected analytic value (healthy case)", {
  out <- calc_bioage(age = 55, TC = 5.1, CRP = 1.5,
                     PLT = 230, CREA = 0.85, WBC = 6.2)
  # Computed independently from the R training script
  expect_equal(unname(out["BioAge"]),     56.08, tolerance = 1e-2)
  expect_equal(unname(out["BioAgeDiff"]),  1.08, tolerance = 1e-2)
})

test_that("calc_bioage matches the expected analytic value (risk case)", {
  out <- calc_bioage(age = 65, TC = 6.5, CRP = 8.0,
                     PLT = 280, CREA = 1.40, WBC = 9.5)
  expect_equal(unname(out["BioAge"]),     71.32, tolerance = 1e-2)
  expect_equal(unname(out["BioAgeDiff"]),  6.32, tolerance = 1e-2)
})

test_that("calc_bioage matches the expected analytic value (young & fit case)", {
  out <- calc_bioage(age = 32, TC = 4.2, CRP = 0.5,
                     PLT = 220, CREA = 0.75, WBC = 5.4)
  expect_equal(unname(out["BioAge"]),     32.83, tolerance = 1e-2)
  expect_equal(unname(out["BioAgeDiff"]),  0.83, tolerance = 1e-2)
})

test_that("calc_bioage gives BioAge ~ age + log_gamma/b_age1 when all markers = 0", {
  out <- calc_bioage(age = 50, TC = 0, CRP = 0,
                     PLT = 0, CREA = 0, WBC = 0)
  # Should be approximately 50 + 2.46
  expect_equal(unname(out["BioAge"]),     52.46, tolerance = 1e-2)
  expect_equal(unname(out["BioAgeDiff"]),  2.46, tolerance = 1e-2)
})

test_that("calc_bioage rejects non-numeric or length>1 age", {
  expect_error(calc_bioage(age = "55", TC = 5, CRP = 1,
                           PLT = 200, CREA = 0.8, WBC = 6))
  expect_error(calc_bioage(age = c(50, 60), TC = 5, CRP = 1,
                           PLT = 200, CREA = 0.8, WBC = 6))
})
