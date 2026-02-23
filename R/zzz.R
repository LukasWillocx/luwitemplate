
#' Package Load Hook
#'
#' Automatically loads and registers Google Fonts specified in the brand YAML
#' when the package is loaded. This ensures fonts are available for ggplot2
#' themes without requiring manual setup.
#'
#' @param libname Character string giving the library directory where the
#'   package was installed.
#' @param pkgname Character string giving the name of the package.
#'
#' @return NULL (invisibly). Called for side effects (font registration).

.onLoad <- function(libname, pkgname) {
  if (requireNamespace("showtext", quietly = TRUE)) {
    fonts_dir <- system.file("fonts", package = pkgname)
    sysfonts::font_add(
      family = "Manrope",
      regular = file.path(fonts_dir, "Manrope-Regular.ttf")
    )
    sysfonts::font_add(
      family = "Montserrat",
      bold = file.path(fonts_dir, "Montserrat-Bold.ttf")
    )
    showtext::showtext_auto()
  }
}
