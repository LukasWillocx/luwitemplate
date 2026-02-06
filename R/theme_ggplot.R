#' Custom ggplot2 theme matching bslib theme
#'
#' @param theme A bslib theme object (defaults to my_theme())
#' @param base_size Base font size
#' @return A ggplot2 theme object
#' @export
theme_luwi <- function(theme = my_theme(), base_size = 14) {
  colors <- get_theme_colors(theme)
  fonts <- get_theme_fonts()

  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "transparent", color = NA),
      panel.background = ggplot2::element_rect(fill = "transparent", color = NA),
      legend.box.background = ggplot2::element_rect(fill = "transparent", color = NA),
      panel.grid.major = ggplot2::element_line(color = ggplot2::alpha(colors$primary, 0.4), linewidth = 0.4,linetype='dashed'),
      panel.grid.minor = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(
        family = fonts$primary,
        face = "bold",
        size = base_size * 1.3,
        color = colors$body_color
      ),
      plot.subtitle = ggplot2::element_text(
        color = colors$body_color,
        margin = ggplot2::margin(b = 10)
      ),
      axis.text = ggplot2::element_text(color = colors$body_color, family = fonts$primary),
      axis.title = ggplot2::element_text(color = colors$body_color, family = fonts$primary),
      legend.text = ggplot2::element_text(color = colors$body_color, family = fonts$primary),
      legend.title = ggplot2::element_text(color = colors$body_color, family = fonts$primary),
      legend.background = ggplot2::element_rect(fill = "transparent", color = NA),
      legend.key = ggplot2::element_rect(fill = "transparent", color = NA),
      strip.background = ggplot2::element_rect(fill = colors$light, color = NA),
      strip.text = ggplot2::element_text(
        family = fonts$primary,
        face = "bold",
        color = colors$body_color
      )
    )
}

#' Custom ggplotly function matching bslib theme
#' @param p a ggplot object
#' @param theme A bslib theme object (defaults to my_theme())
#' @param base_size Base font size
#' @param tooltip which variable and corresponding value to display on hover
#' @return A ggplot2 theme object
#' @export
luwi_ggplotly <- function(p, theme = my_theme(), base_size = 14, tooltip = "y") {
  colors <- get_theme_colors(theme)
  fonts <- get_theme_fonts()

  # Convert primary color with alpha to rgba format for plotly
  primary_alpha <- grDevices::col2rgb(colors$primary, alpha = TRUE)
  grid_color <- sprintf("rgba(%s, %s, %s, 0.4)",
                        primary_alpha[1],
                        primary_alpha[2],
                        primary_alpha[3])

  ggplotly(p, tooltip = tooltip) %>%
    plotly::config(displayModeBar = FALSE) %>%
    plotly::layout(
      paper_bgcolor = "transparent",
      plot_bgcolor = "transparent",
      # Global font
      font = list(
        family = fonts$primary,
        color = colors$body_color
      ),
      # Title
      title = list(
        font = list(
          family = fonts$primary,
          size = base_size*1.3,
          color = colors$body_color
        )
      ),
      # X-axis
      xaxis = list(
        titlefont = list(family = fonts$primary, color = colors$body_color),
        tickfont = list(family = fonts$primary, color = colors$body_color),
        gridcolor = grid_color,
        gridwidth = 0.4,
        griddash = "dash",
        showgrid = TRUE,
        zeroline = FALSE
      ),
      # Y-axis
      yaxis = list(
        titlefont = list(family = fonts$primary, color = colors$body_color),
        tickfont = list(family = fonts$primary, color = colors$body_color),
        gridcolor = grid_color,
        gridwidth = 0.4,
        griddash = "dash",
        showgrid = TRUE,
        zeroline = FALSE
      ),
      # Legend
      legend = list(
        font = list(family = fonts$primary, color = colors$body_color)
      ),
      # Hover tooltips
      hoverlabel = list(
        font = list(family = fonts$primary, size = base_size)
      )
    )
}

#' ggplot2 color scale for continuous data
#'
#' @param type Type of palette: "warm", "cool", or "green"
#' @param ... Additional arguments passed to scale_color_gradientn
#' @export
scale_color_luwi_c <- function(type = "warm", ...) {
  ggplot2::scale_color_gradientn(
    colors = scale_color_luwi_sequential(type = type),
    ...
  )
}

#' ggplot2 fill scale for continuous data
#'
#' @param type Type of palette: "warm", "cool", or "green"
#' @param ... Additional arguments passed to scale_fill_gradientn
#' @export
scale_fill_luwi_c <- function(type = "warm", ...) {
  ggplot2::scale_fill_gradientn(
    colors = scale_color_luwi_sequential(type = type),
    ...
  )
}

#' ggplot2 color scale for diverging data (hot/cold)
#'
#' @param ... Additional arguments passed to scale_color_gradientn
#' @export
scale_color_luwi_div <- function(...) {
  ggplot2::scale_color_gradientn(
    colors = scale_color_luwi_diverging(),
    ...
  )
}

#' ggplot2 fill scale for diverging data (hot/cold)
#'
#' @param ... Additional arguments passed to scale_fill_gradientn
#' @export
scale_fill_luwi_div <- function(...) {
  ggplot2::scale_fill_gradientn(
    colors = scale_color_luwi_diverging(),
    ...
  )
}

#' ggplot2 color scale for discrete/categorical data
#'
#' @param ... Additional arguments passed to scale_color_manual
#' @export
scale_color_luwi_d <- function(...) {
  ggplot2::scale_color_manual(
    values = scale_color_luwi_discrete(),
    ...
  )
}

#' ggplot2 fill scale for discrete/categorical data
#'
#' @param ... Additional arguments passed to scale_fill_manual
#' @export
scale_fill_luwi_d <- function(...) {
  ggplot2::scale_fill_manual(
    values = scale_color_luwi_discrete(),
    ...
  )
}
