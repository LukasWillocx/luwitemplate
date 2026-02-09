# luwitemplate

> Unified brand styling for Shiny, ggplot2, and plotly from a single `_brand.yml` file. Whilst currently 'Luwi' themed, with all colors and fonts being centralized in the _brand.yml file, this can easily be adapted to establish a distinct look for your R projects.

## Installation
```r
devtools::install_github("yourusername/luwitemplate")
```

## Quick Start
```r
library(luwitemplate)
library(shiny)
library(ggplot2)

ui <- page_fluid(
  theme = my_theme(),  # Shiny UI styled from _brand.yml
  plotOutput("plot")
)

server <- function(input, output) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
      geom_point(size = 3) +
      scale_color_luwi_d() +  # Brand colors
      theme_luwi()            # Brand theme
  })
}

shinyApp(ui, server)
```

## What You Get

**One `_brand.yml` file controls:**
- Shiny UI components (buttons, cards, navbar)
- ggplot2 themes (fonts, colors, backgrounds)
- Plotly interactives (grids, tooltips, hover)
- Color palettes (discrete, sequential, diverging)

**Key functions:**

| Function | Use Case |
|----------|----------|
| `my_theme()` | Shiny app theme |
| `theme_luwi()` | ggplot2 static plots |
| `luwi_ggplotly()` | Interactive plotly charts |
| `scale_color_luwi_d()` | Discrete colors (categorical data) |
| `scale_color_luwi_c()` | Sequential colors (continuous data) |
| `scale_color_luwi_div()` | Diverging colors (hot/cold data) |

## Complete Example
```r
library(luwitemplate)
library(ggplot2)
library(plotly)

# Static plot
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  scale_color_luwi_d() +
  theme_luwi()

# Interactive plot for Shiny
p <- ggplot(mtcars, aes(mpg, wt)) + geom_point()
luwi_ggplotly(p, tooltip = c("x", "y"))

# Extract theme components
colors <- get_theme_colors()  # Named list: primary, secondary, etc.
fonts <- get_theme_fonts()    # Named list: primary, secondary, all_families
```

## _brand.yml Structure

Define your colors and fonts once:
```yaml
meta:
  name: your-brand

color:
  palette:
    primary: "#your-color"
    secondary: "#your-color"
    # ... more semantic colors

typography:
  fonts:
    - family: "Your Font"
      source: google
```

See [bslib brand documentation](https://rstudio.github.io/bslib/articles/brand.html) for full spec.

## License

MIT
