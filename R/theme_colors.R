#' Extract colors from bslib theme
#'
#' @param theme A bslib theme object (defaults to my_theme())
#' @return Named list of color values
#' @export
get_theme_colors <- function(theme = my_theme()) {

  # Explicitly list all color variable names from your YAML
  color_vars <- c(
    # Bootstrap semantic colors
    "primary", "secondary", "success", "danger", "warning", "info", "light", "dark",
    # Layout colors
    "body-bg", "body-color",
    # Input/border colors
    "input-border-color"
  )

  # Extract all at once
  colors <- bslib::bs_get_variables(theme, color_vars)

  # Convert hyphens to underscores for R-friendly names
  names(colors) <- gsub("-", "_", names(colors))

  # Return as list
  as.list(colors)
}

#' Get sequential color palette for continuous data
#'
#' @param theme A bslib theme object (defaults to my_theme())
#' @param type Type of palette: "warm" (coral), "cool" (teal), or "green" (olive)
#' @param n Number of colors to generate (default: 9)
#' @param reverse Reverse the palette direction
#' @return Character vector of hex colors
#' @export
scale_color_luwi_sequential <- function(theme = my_theme(), type = "warm", n = 9, reverse = FALSE) {

  colors <- get_theme_colors(theme)

  palette <- switch(type,
                    "warm" = colorRampPalette(c(colors$light, colors$primary, colors$danger))(n),
                    "cool" = colorRampPalette(c(colors$light, colors$info, colors$secondary))(n),
                    "green" = colorRampPalette(c(colors$light, colors$success, colors$dark))(n),
                    stop("Type must be 'warm', 'cool', or 'green'")
  )

  if (reverse) palette <- rev(palette)
  palette
}

#' Get diverging color palette (e.g., for hot/cold data)
#'
#' @param theme A bslib theme object (defaults to my_theme())
#' @param n Number of colors to generate (default: 11, should be odd)
#' @param reverse Reverse the palette direction
#' @return Character vector of hex colors
#' @export
scale_color_luwi_diverging <- function(theme = my_theme(), n = 11, reverse = FALSE) {

  colors <- get_theme_colors(theme)

  # Cool (teal) -> Light -> Warm (coral)
  palette <- colorRampPalette(c(
    colors$secondary,  # Teal (cold)
    colors$info,       # Lighter teal
    colors$light,      # Neutral warm
    colors$primary,    # Coral
    colors$danger      # Red-orange (hot)
  ))(n)

  if (reverse) palette <- rev(palette)
  palette
}

#' Get discrete color palette for categorical data
#'
#' @param theme A bslib theme object (defaults to my_theme())
#' @param n Number of colors needed (max 15)
#' @return Character vector of hex colors
#' @export
scale_color_luwi_discrete <- function(theme = my_theme(), n = NULL) {

  colors <- get_theme_colors(theme)

  # Carefully selected palette with good contrast
  # Based on your theme colors but ensuring distinctiveness
  palette <- c(
    colors$primary,      # 1. Coral (main accent)
    colors$secondary,    # 2. Teal (secondary accent)
    colors$success,      # 3. Olive green
    colors$warning,      # 4. Amber/gold
    colors$danger,       # 5. Red
    "#a855f7",           # 6. Purple (generated to complement)
    "#ec4899",           # 7. Pink
    "#06b6d4",           # 8. Cyan
    "#10b981",           # 9. Emerald
    "#f59e0b",           # 10. Orange
    "#8b5cf6",           # 11. Violet
    "#14b8a6",           # 12. Teal variant
    "#f97316",           # 13. Orange variant
    "#84cc16",           # 14. Lime
    colors$dark          # 15. Dark (last resort)
  )

  if (is.null(n)) {
    return(palette)
  }

  if (n > 15) {
    warning("Only 15 distinct colors available. Consider using a gradient for more categories.")
    n <- 15
  }

  palette[1:n]
}
