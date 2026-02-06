#' Get the branded bslib theme
#'
#' @return A bslib theme object
#' @export
my_theme <- function() {
  brand_file <- system.file("_brand.yml", package = "luwitemplate")
  if (brand_file == "") {
    stop("_brand.yml not found in package.")
  }

  theme <- bslib::bs_theme(
    version = 5,
    brand = brand_file
  )

  # Add custom CSS
  css_file <- system.file("css/custom.css", package = "luwitemplate")
  if (css_file != "" && file.exists(css_file)) {
    theme <- bslib::bs_add_rules(theme, readLines(css_file))
  } else {
    warning("custom.css not found at: ", css_file)
  }

  theme
}

