#' Extract fonts from bslib theme
#'
#' @param theme A bslib theme object (defaults to my_theme())
#' @return Named list of font values
#' @export

get_theme_fonts <- function(theme) {
  # For bslib brand themes, we need to read the brand file directly
  brand_file <- system.file("_brand.yml", package = "luwitemplate")

  if (brand_file != "" && file.exists(brand_file)) {
    brand_config <- yaml::read_yaml(brand_file)

    if (!is.null(brand_config$typography$fonts)) {
      fonts <- brand_config$typography$fonts
      families <- sapply(fonts, function(f) f$family)

      return(list(
        primary = families[1],
        secondary = if (length(families) > 1) families[2] else NULL,
        all_families = families
      ))
    }
  }

  # Fallback
  return(list(
    primary = "sans",
    secondary = NULL,
    all_families = "sans"
  ))
}
