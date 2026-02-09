#' Create Luwi Branded bslib Theme
#'
#' Generates a Bootstrap 5 theme from your _brand.yml file with optional custom
#' CSS. This is the central theming function that powers all other styling in
#' the package - use it in your Shiny UI to ensure consistent branding across
#' your application.
#'
#' @return A `bslib::bs_theme()` object ready to use in Shiny applications
#'
#' @details
#' This function:
#' 1. Reads your package's `_brand.yml` file (colors, fonts, spacing)
#' 2. Creates a Bootstrap 5 theme using [bslib::bs_theme()]
#' 3. Applies custom CSS from `inst/css/custom.css` if available
#'
#' The returned theme object is used as the default in other package functions
#' like [theme_luwi()], [get_theme_colors()], and [luwi_ggplotly()], ensuring
#' consistent styling across Shiny UI, static plots, and interactive visualizations.
#'
#' **_brand.yml structure:**
#' Your `_brand.yml` should define colors, typography, and other brand elements.
#' See the [bslib brand YAML documentation](https://rstudio.github.io/bslib/articles/brand.html)
#' for complete specification.
#'
#' @section Custom CSS:
#' Place additional CSS rules in `inst/css/custom.css` to override or extend
#' Bootstrap defaults. This file is automatically included if present.
#'
#' @family theme-generators
#' @seealso
#'   [bslib::bs_theme()] for the underlying theme constructor,
#'   [get_theme_colors()] to extract colors from the theme,
#'   [get_theme_fonts()] to extract fonts from the theme,
#'   [theme_luwi()] for ggplot2 theme using these colors/fonts
#'
#' @examples
#' # Get the theme
#' theme <- my_theme()
#'
#' # Use in Shiny app
#' library(shiny)
#' library(bslib)
#'
#' ui <- page_fluid(
#'   theme = my_theme(),
#'   h1("My Branded App"),
#'   p("All Bootstrap components use your brand colors automatically")
#' )
#'
#' \dontrun{
#' # Complete Shiny app with plots
#' library(ggplot2)
#' library(plotly)
#'
#' ui <- page_fluid(
#'   theme = my_theme(),
#'
#'   # Navbar uses brand colors automatically
#'   navset_card_tab(
#'     nav_panel("Static Plot",
#'       plotOutput("static_plot")
#'     ),
#'     nav_panel("Interactive",
#'       plotlyOutput("interactive_plot")
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   output$static_plot <- renderPlot({
#'     ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'       geom_point(size = 3) +
#'       scale_color_luwi_d() +
#'       theme_luwi()
#'   })
#'
#'   output$interactive_plot <- renderPlotly({
#'     p <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
#'       geom_point()
#'     luwi_ggplotly(p)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' # Extract and use theme components
#' theme <- my_theme()
#' colors <- get_theme_colors(theme)
#' fonts <- get_theme_fonts(theme)
#'
#' # Inspect the theme
#' print(theme)
#'
#' # Customize further with bslib functions
#' custom_theme <- my_theme() %>%
#'   bslib::bs_add_variables("border-radius" = "0.5rem")
#'
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

