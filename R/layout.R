#' Standard page layout with optional sidebar
#'
#' Creates a branded page with consistent structure across apps.
#' Automatically applies your custom theme.
#'
#' @param title Application title (shown in navbar)
#' @param sidebar Optional sidebar content (UI elements)
#' @param ... Main content (UI elements)
#' @param sidebar_width Width of sidebar in pixels (default: 300)
#'
#' @return A Shiny UI object
#' @export
my_page <- function(title, sidebar = NULL, ..., sidebar_width = 300) {
  shiny::navbarPage(
    title = title,
    theme = my_theme(),
    shiny::tabPanel(
      "Main",
      if (!is.null(sidebar)) {
        bslib::layout_sidebar(
          sidebar = bslib::sidebar(sidebar, width = sidebar_width),
          ...
        )
      } else {
        bslib::page_fillable(...)
      }
    )
  )
}

#' Simple page without sidebar
#'
#' Creates a full-width page with your branded theme.
#'
#' @param title Application title
#' @param ... Page content (UI elements)
#'
#' @return A Shiny UI object
#' @export
my_simple_page <- function(title, ...) {
  bslib::page_navbar(
    title = title,
    theme = my_theme(),
    ...
  )
}
