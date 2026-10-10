#' @importFrom stats cor.test lm predict
#' @importFrom graphics text
#' @importFrom grDevices png pdf dev.off
#' @importFrom utils head
NULL

#' Visualise the correlation between chronological age and BioAge
#'
#' Produces a density-coloured scatter plot of BioAge against
#' chronological Age for a batch of subjects, with a linear
#' regression overlay and an annotation box reporting the
#' Pearson correlation coefficient (\code{R}), the mean absolute
#' error (\code{MAE = mean(|BioAge - Age|)}), and the p-value of
#' the correlation test.
#'
#' Point colour is mapped to a 2D kernel density estimate of the
#' (Age, BioAge) joint distribution via \code{MASS::kde2d}, so
#' that crowded regions appear warmer. The colour gradient is
#' fixed to a 4-stop palette
#' (\code{#9eaad1, #dacfe5, #f5dbb6, #f59790}) and the legend
#' is hidden by default.
#'
#' The input can be either:
#' \itemize{
#'   \item a \code{data.frame} that already contains the
#'         \code{BioAge} column (the typical output of
#'         \code{\link{predict_bioage}} or
#'         \code{\link{predict_bioage_file}}); or
#'   \item a \code{data.frame} of raw inputs that does not yet
#'         contain \code{BioAge}, in which case
#'         \code{\link{predict_bioage}} is called internally
#'         first.
#' }
#' In both cases rows with NA in \code{Age} or \code{BioAge} are
#' silently dropped before plotting, with an informative message.
#'
#' @param data A data.frame. Must contain \code{Age} plus the
#'   five marker columns (\code{TC, CRP, PLT, CREA, WBC}) and
#'   may already contain \code{BioAge}. If \code{BioAge} is
#'   missing it will be computed via
#'   \code{\link{predict_bioage}}.
#' @param title Character. Plot title. Default
#'   \code{"BioAge vs chronological age"}.
#' @param xlab Character. X-axis label. Default
#'   \code{"Chronological age (years)"}.
#' @param ylab Character. Y-axis label. Default
#'   \code{"BioAge (years)"}.
#' @param point_size Numeric. Point size passed to
#'   \code{geom_point}. Default \code{1.5}.
#' @param point_alpha Numeric in (0, 1]. Point transparency.
#'   Default \code{0.9}.
#' @param smooth Logical. If \code{TRUE} (default) overlay the
#'   linear regression line.
#' @param kde_n Integer. Resolution of the 2D KDE grid
#'   (\code{MASS::kde2d(n = ...)}). Default \code{200}.
#' @param density_colors Character vector of >= 2 colours used
#'   for the density gradient. Default
#'   \code{c("#9eaad1", "#dacfe5", "#f5dbb6", "#f59790")}.
#' @param base_size Numeric. Base font size for
#'   \code{theme_classic}. Default \code{18}.
#' @param save Character or \code{NULL}. If non-NULL, the plot
#'   is saved to this path (file extension determines the
#'   device: \code{.png}, \code{.pdf}, \code{.jpg}, \code{.tiff},
#'   \code{.svg}, \code{.bmp} are recognised; anything else
#'   defaults to PNG). The function returns the ggplot object
#'   invisibly in this case so callers can keep editing it.
#' @param width,height Numeric. Width and height in inches when
#'   \code{save} is used. Default \code{7 x 6}.
#' @param dpi Integer. Resolution for raster devices. Default
#'   \code{300}.
#'
#' @return A \code{ggplot} object. The plot is rendered as a
#'   side effect unless \code{save} is supplied, in which case
#'   it is returned invisibly.
#'
#' @examples
#' \dontrun{
#' df <- data.frame(
#'   Age  = c(55, 65, 32, 50, 72, 45, 60, 38, 80, 28),
#'   TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8, 5.5, 4.5, 6.0, 4.0),
#'   CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0, 2.0, 0.8, 4.0, 0.4),
#'   PLT  = c(230, 280, 220, 240, 260, 235, 250, 225, 270, 215),
#'   CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80, 0.95, 0.78, 1.20, 0.72),
#'   WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0, 6.8, 5.8, 8.2, 5.2)
#' )
#' plot_bioage_cor(df)
#' }
#' @export
plot_bioage_cor <- function(data,
                            title  = "BioAge vs chronological age",
                            xlab   = "Chronological age (years)",
                            ylab   = "BioAge (years)",
                            point_size  = 1.5,
                            point_alpha = 0.9,
                            smooth = TRUE,
                            kde_n  = 200,
                            density_colors = c("#9eaad1", "#dacfe5",
                                               "#f5dbb6", "#f59790"),
                            base_size = 18,
                            save = NULL,
                            width  = 7,
                            height = 6,
                            dpi    = 300) {

  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("Package 'ggplot2' is required for plot_bioage_cor(). ",
         "Install it with install.packages('ggplot2').")
  if (!requireNamespace("MASS", quietly = TRUE))
    stop("Package 'MASS' is required for plot_bioage_cor(). ",
         "MASS is part of the standard R distribution.")

  df <- .prepare_plot_data(data)
  if (nrow(df) < 3L) {
    warning("plot_bioage_cor: fewer than 3 complete rows; ",
            "the KDE and regression line will be skipped.")
  }

  # 2D KDE density per point ---------------------------------------
  if (nrow(df) >= 3L &&
      stats::sd(df$Age)   > 0 &&
      stats::sd(df$BioAge) > 0) {
    kde <- MASS::kde2d(df$Age, df$BioAge, n = kde_n)
    ix  <- findInterval(df$Age,   kde$x)
    iy  <- findInterval(df$BioAge, kde$y)
    ix[ix < 1] <- 1L; ix[ix > length(kde$x)] <- length(kde$x)
    iy[iy < 1] <- 1L; iy[iy > length(kde$y)] <- length(kde$y)
    df$density <- kde$z[cbind(ix, iy)]
  } else {
    # Degenerate case: constant column -> uniform density
    df$density <- 1
  }

  # Stats ------------------------------------------------------------
  ct     <- suppressWarnings(stats::cor.test(df$Age, df$BioAge,
                                            method = "pearson"))
  R_val  <- unname(ct$estimate)
  p_val  <- ct$p.value
  MAE    <- mean(abs(df$BioAge - df$Age), na.rm = TRUE)

  p_text <- if (is.na(p_val)) {
    "p = NA"
  } else if (p_val < 2e-16) {
    "p < 2e-16"
  } else {
    paste0("p = ", signif(p_val, 3))
  }
  label_text <- paste0(
    "R   = ", sprintf("%.3f", R_val), "\n",
    "MAE = ", sprintf("%.3f", MAE),   "\n",
    p_text
  )

  # Plot -------------------------------------------------------------
  p <- ggplot2::ggplot(df, ggplot2::aes(x = .data$Age,
                                        y = .data$BioAge)) +
    ggplot2::geom_point(
      ggplot2::aes(color = .data$density),
      size  = point_size,
      alpha = point_alpha,
      shape = 16
    ) +
    ggplot2::scale_color_gradientn(
      colours = density_colors,
      guide   = "none"
    )

  if (isTRUE(smooth) && nrow(df) >= 3L &&
      stats::sd(df$Age) > 0 && stats::sd(df$BioAge) > 0) {
    p <- p + ggplot2::geom_smooth(
      method   = "lm",
      se       = FALSE,
      color    = "black",
      linewidth = 1.4
    )
  }

  p <- p +
    ggplot2::labs(title = title, x = xlab, y = ylab) +
    ggplot2::annotate(
      "text",
      x     = min(df$Age, na.rm = TRUE) + 1,
      y     = max(df$BioAge, na.rm = TRUE) - 5,
      label = label_text,
      hjust = 0,
      vjust = 1,
      size  = 6
    ) +
    ggplot2::theme_classic(base_size = base_size) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        size = base_size + 2, hjust = 0.5, face = "bold"
      ),
      axis.title = ggplot2::element_text(size = base_size + 2),
      axis.text  = ggplot2::element_text(size = base_size - 2,
                                         color = "black"),
      axis.line  = ggplot2::element_line(linewidth = 1)
    )

  if (!is.null(save)) {
    .ggsave_bioage(p, save, width = width, height = height, dpi = dpi)
    return(invisible(p))
  }
  p
}


#' Visualise the BioAge-to-chronological age difference (BioAgeDiff)
#'
#' Produces a one-page diagnostic figure with two panels for a
#' batch of predicted BioAge values:
#' \enumerate{
#'   \item a histogram of \code{BioAgeDiff} (\code{BioAge - Age})
#'         with a dashed vertical reference at 0 and the mean
#'         overlaid; and
#'   \item a Bland-Altman-style scatter of the difference against
#'         the mean of BioAge and chronological age, with the
#'         mean difference and the limits of agreement
#'         (\code{mean +/- 1.96 * SD}) drawn as horizontal
#'         reference lines.
#' }
#'
#' The same input rules as \code{\link{plot_bioage_cor}} apply:
#' either pass a data.frame that already has \code{BioAge} or
#' the raw six input columns.
#'
#' @param data A data.frame. See \code{\link{plot_bioage_cor}}.
#' @param bins Integer. Number of bins for the histogram.
#'   Default \code{30}.
#' @param title Character. Main title. Default
#'   \code{"BioAgeDiff diagnostic"}.
#' @param save Character or \code{NULL}. If non-NULL, save the
#'   plot to this path.
#' @param width,height,dpi See \code{\link{plot_bioage_cor}}.
#'
#' @return A \code{ggplot} object (or a \code{patchwork} / list
#'   of two ggplots). When \code{save} is supplied the plot is
#'   returned invisibly.
#'
#' @examples
#' \dontrun{
#' df <- data.frame(
#'   Age  = c(55, 65, 32, 50, 72, 45, 60, 38, 80, 28),
#'   TC   = c(5.1, 6.5, 4.2, 5.2, 5.8, 4.8, 5.5, 4.5, 6.0, 4.0),
#'   CRP  = c(1.5, 8.0, 0.5, 2.4, 3.0, 1.0, 2.0, 0.8, 4.0, 0.4),
#'   PLT  = c(230, 280, 220, 240, 260, 235, 250, 225, 270, 215),
#'   CREA = c(0.85, 1.40, 0.75, 0.90, 1.10, 0.80, 0.95, 0.78, 1.20, 0.72),
#'   WBC  = c(6.2, 9.5, 5.4, 7.0, 7.8, 6.0, 6.8, 5.8, 8.2, 5.2)
#' )
#' plot_bioage_diff(df)
#' }
#' @export
plot_bioage_diff <- function(data,
                             bins  = 30,
                             title = "BioAgeDiff diagnostic",
                             save  = NULL,
                             width  = 10,
                             height = 5,
                             dpi    = 300) {

  if (!requireNamespace("ggplot2", quietly = TRUE))
    stop("Package 'ggplot2' is required for plot_bioage_diff(). ",
         "Install it with install.packages('ggplot2').")

  df <- .prepare_plot_data(data)
  if (nrow(df) < 2L)
    warning("plot_bioage_diff: fewer than 2 complete rows; ",
            "the diagnostic plot will be sparse.")

  diff_vec <- df$BioAge - df$Age
  mean_diff <- mean(diff_vec, na.rm = TRUE)
  sd_diff   <- stats::sd(diff_vec, na.rm = TRUE)
  loa_lo    <- mean_diff - 1.96 * sd_diff
  loa_hi    <- mean_diff + 1.96 * sd_diff

  # Panel 1: histogram ---------------------------------------------
  h <- ggplot2::ggplot(df, ggplot2::aes(x = .data$BioAgeDiff)) +
    ggplot2::geom_histogram(
      ggplot2::aes(y = ggplot2::after_stat(density)),
      bins   = bins,
      fill   = "#9eaad1",
      color  = "white",
      alpha  = 0.9
    ) +
    ggplot2::geom_density(color = "#f59790", linewidth = 1.1,
                          na.rm = TRUE) +
    ggplot2::geom_vline(xintercept = 0,
                        linetype = "dashed", color = "grey30") +
    ggplot2::geom_vline(xintercept = mean_diff,
                        linetype = "solid",  color = "black",
                        linewidth = 1) +
    ggplot2::labs(
      title = "Distribution of BioAgeDiff",
      x     = "BioAgeDiff (years)",
      y     = "Density"
    ) +
    ggplot2::annotate(
      "text",
      x     = max(diff_vec, na.rm = TRUE),
      y     = Inf,
      hjust = 1.05, vjust = 1.5,
      label = paste0("mean = ", sprintf("%.2f", mean_diff), "\n",
                     "SD   = ", sprintf("%.2f", sd_diff)),
      size  = 5
    ) +
    ggplot2::theme_classic(base_size = 16) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
      axis.title = ggplot2::element_text(size = 16),
      axis.text  = ggplot2::element_text(size = 13, color = "black"),
      axis.line  = ggplot2::element_line(linewidth = 1)
    )

  # Panel 2: Bland-Altman style scatter ----------------------------
  df$mean_age <- (df$BioAge + df$Age) / 2
  y_pad <- 0.04 * diff(range(df$BioAgeDiff, na.rm = TRUE))
  b <- ggplot2::ggplot(
    df,
    ggplot2::aes(x = .data$mean_age, y = .data$BioAgeDiff)
  ) +
    ggplot2::geom_point(color = "#5b6ea8", alpha = 0.8, size = 2) +
    ggplot2::geom_hline(yintercept = mean_diff,
                        linetype = "solid",  color = "black",
                        linewidth = 1) +
    ggplot2::geom_hline(yintercept = c(loa_lo, loa_hi),
                        linetype = "dashed", color = "grey30") +
    ggplot2::labs(
      title = "Bland-Altman style plot",
      x     = "Mean of BioAge and Age (years)",
      y     = "BioAgeDiff (years)"
    ) +
    ggplot2::annotate(
      "text",
      x     = max(df$mean_age, na.rm = TRUE),
      y     = loa_hi + y_pad,
      hjust = 1.05, vjust = 0,
      label = paste0("+1.96 SD = ", sprintf("%.2f", loa_hi)),
      size  = 4
    ) +
    ggplot2::annotate(
      "text",
      x     = max(df$mean_age, na.rm = TRUE),
      y     = loa_lo - y_pad,
      hjust = 1.05, vjust = 1,
      label = paste0("-1.96 SD = ", sprintf("%.2f", loa_lo)),
      size  = 4
    ) +
    ggplot2::theme_classic(base_size = 16) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
      axis.title = ggplot2::element_text(size = 16),
      axis.text  = ggplot2::element_text(size = 13, color = "black"),
      axis.line  = ggplot2::element_line(linewidth = 1)
    )

  p <- .combine_two_panels(h, b, title = title, base_size = 16)

  if (!is.null(save)) {
    .ggsave_bioage(p, save, width = width, height = height, dpi = dpi)
    return(invisible(p))
  }
  p
}


# ---- internal helpers ----------------------------------------------

# Validate the data frame, fill in BioAge if missing, and drop NA
# rows in Age or BioAge. Returns a data.frame with at least the
# columns Age and BioAge (BioAgeDiff added when derivable).
.prepare_plot_data <- function(data) {
  if (!is.data.frame(data))
    stop("`data` must be a data.frame.")
  if (!"Age" %in% colnames(data))
    stop("`data` must contain an 'Age' column.")

  if (!"BioAge" %in% colnames(data)) {
    message("plot_bioage_*: 'BioAge' not found in `data`; ",
            "running predict_bioage() first.")
    data <- predict_bioage(data, keep = TRUE, na_action = "omit")
  }
  keep <- stats::complete.cases(data[, c("Age", "BioAge"),
                                     drop = FALSE])
  if (any(!keep)) {
    message("plot_bioage_*: dropped ", sum(!keep),
            " row(s) with NA in Age or BioAge.")
    data <- data[keep, , drop = FALSE]
  }
  if (!"BioAgeDiff" %in% colnames(data))
    data$BioAgeDiff <- data$BioAge - data$Age
  data
}

# Save a ggplot to a file. Extension chooses the device; unknown
# extensions fall back to PNG.
.ggsave_bioage <- function(plot, path, width, height, dpi) {
  ext <- tolower(tools::file_ext(path))
  if (!dir.exists(dirname(path))) {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  }
  args <- list(filename = path, plot = plot,
               width = width, height = height, dpi = dpi)
  switch(ext,
         "pdf"  = do.call(ggplot2::ggsave,
                          c(args, list(device = "pdf"))),
         "svg"  = do.call(ggplot2::ggsave,
                          c(args, list(device = "svg"))),
         "jpg"  = ,
         "jpeg" = do.call(ggplot2::ggsave,
                          c(args, list(device = "jpeg"))),
         "tiff" = do.call(ggplot2::ggsave,
                          c(args, list(device = "tiff"))),
         "bmp"  = do.call(ggplot2::ggsave,
                          c(args, list(device = "bmp"))),
         do.call(ggplot2::ggsave,
                 c(args, list(device = "png")))
  )
  invisible(path)
}

# Combine two ggplots side by side, using patchwork if available
# (a standard companion of ggplot2), otherwise falling back to a
# cheap tagged list so the function still works without it.
.combine_two_panels <- function(p1, p2, title, base_size) {
  if (requireNamespace("patchwork", quietly = TRUE)) {
    return(
      patchwork::wrap_plots(p1, p2, ncol = 2L) +
        patchwork::plot_annotation(
          title = title,
          theme = ggplot2::theme(
            plot.title = ggplot2::element_text(
              size = base_size + 2, hjust = 0.5, face = "bold"
            )
          )
        )
    )
  }
  # Fallback: print the two panels sequentially and return a
  # lightweight wrapper that subclasses "ggplot" so print
  # dispatch still works.
  structure(
    list(left = p1, right = p2, title = title, base_size = base_size),
    class = c("bioage_pair_plot", "list")
  )
}

# S3 print method for the no-patchwork fallback.
#' @export
print.bioage_pair_plot <- function(x, ...) {
  grid::grid.newpage()
  grid::grid.rect(gp = grid::gpar(fill = "white"))
  # Left panel
  grid::grid.text(x$title,
                  x = 0.5, y = 0.97, gp = grid::gpar(
                    fontsize = x$base_size + 4, fontface = "bold"))
  print(x$left, vp = grid::viewport(x = 0.25, y = 0.45,
                                    width = 0.5, height = 0.85))
  print(x$right, vp = grid::viewport(x = 0.75, y = 0.45,
                                     width = 0.5, height = 0.85))
  invisible(x)
}
