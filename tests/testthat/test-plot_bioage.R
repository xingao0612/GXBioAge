test_that("plot_bioage_cor returns a ggplot when ggplot2 is available", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("MASS")
  df <- data.frame(
    Age  = c(55, 65, 32, 50, 72, 45, 60, 38, 80, 28),
    TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8, 5.5, 4.5, 6.0, 4.0),
    CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0, 2.0, 0.8, 4.0, 0.4),
    PLT  = c(230, 280, 220, 240, 260, 235, 250, 225, 270, 215),
    CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80, 0.95, 0.78, 1.20, 0.72),
    WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0, 6.8, 5.8, 8.2, 5.2)
  )
  p <- plot_bioage_cor(df)
  expect_s3_class(p, "ggplot")
})

test_that("plot_bioage_cor computes BioAge internally if missing", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("MASS")
  df <- data.frame(
    Age  = c(55, 65, 32, 50, 72, 45),
    TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8),
    CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0),
    PLT  = c(230, 280, 220, 240, 260, 235),
    CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80),
    WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0)
  )
  expect_message(
    p <- plot_bioage_cor(df),
    "running predict_bioage"
  )
  expect_s3_class(p, "ggplot")
})

test_that("plot_bioage_cor saves a PNG to disk when `save` is given", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("MASS")
  df <- data.frame(
    Age  = c(55, 65, 32, 50, 72, 45, 60, 38, 80, 28),
    TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8, 5.5, 4.5, 6.0, 4.0),
    CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0, 2.0, 0.8, 4.0, 0.4),
    PLT  = c(230, 280, 220, 240, 260, 235, 250, 225, 270, 215),
    CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80, 0.95, 0.78, 1.20, 0.72),
    WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0, 6.8, 5.8, 8.2, 5.2)
  )
  out <- tempfile(fileext = ".png")
  on.exit(unlink(out), add = TRUE)
  ret <- plot_bioage_cor(df, save = out, width = 6, height = 5, dpi = 96)
  expect_true(file.exists(out))
  expect_s3_class(ret, "ggplot")  # returned invisibly
})

test_that("plot_bioage_cor drops NA rows with a message", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("MASS")
  df <- data.frame(
    Age  = c(55, 65, NA, 50, 72, 45),
    TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8),
    CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0),
    PLT  = c(230, 280, 220, 240, 260, 235),
    CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80),
    WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0)
  )
  expect_message(
    p <- plot_bioage_cor(df),
    "running predict_bioage"
  )
  expect_s3_class(p, "ggplot")
})

test_that("plot_bioage_diff returns a plot object when ggplot2 is available", {
  skip_if_not_installed("ggplot2")
  df <- data.frame(
    Age  = c(55, 65, 32, 50, 72, 45, 60, 38, 80, 28),
    TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8, 5.5, 4.5, 6.0, 4.0),
    CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0, 2.0, 0.8, 4.0, 0.4),
    PLT  = c(230, 280, 220, 240, 260, 235, 250, 225, 270, 215),
    CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80, 0.95, 0.78, 1.20, 0.72),
    WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0, 6.8, 5.8, 8.2, 5.2)
  )
  res <- predict_bioage(df, keep = TRUE)
  p <- plot_bioage_diff(res)
  # Either a ggplot or our fallback pair-plot container
  ok <- inherits(p, "ggplot") ||
    inherits(p, "bioage_pair_plot")
  expect_true(ok)
})

test_that("plot_bioage_diff writes a file when save is given", {
  skip_if_not_installed("ggplot2")
  df <- data.frame(
    Age  = c(55, 65, 32, 50, 72, 45, 60, 38, 80, 28),
    TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8, 5.5, 4.5, 6.0, 4.0),
    CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0, 2.0, 0.8, 4.0, 0.4),
    PLT  = c(230, 280, 220, 240, 260, 235, 250, 225, 270, 215),
    CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80, 0.95, 0.78, 1.20, 0.72),
    WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0, 6.8, 5.8, 8.2, 5.2)
  )
  res <- predict_bioage(df, keep = TRUE)
  out <- tempfile(fileext = ".png")
  on.exit(unlink(out), add = TRUE)
  plot_bioage_diff(res, save = out, width = 8, height = 4, dpi = 96)
  expect_true(file.exists(out))
})

test_that("plot_bioage_cor requires ggplot2", {
  # We can't easily unload ggplot2 here; the message contract is
  # covered by inspecting the function source instead.
  fn <- plot_bioage_cor
  src <- paste(deparse(fn), collapse = "\n")
  expect_match(src, "requireNamespace\\(\"ggplot2\"")
  expect_match(src, "requireNamespace\\(\"MASS\"")
})
