# luwitemplate

> Unified brand styling for R Shiny applications and individual objects like ggplot, and plotly from a single `_brand.yml` file. Whilst currently 'Luwi' themed, with all colors and fonts being centralized in the _brand.yml file, this can easily be adapted to establish a distinct look for your R projects.

## Installation
```r
devtools::install_github("LukasWillocx/luwitemplate")
```

## Quick Start 

### Light mode only

When opted to only use light-mode, all color-dark arguments in the `_brand.yml` 
are ignored. Besides loading the custom theme through `library(luwitemplate)`, 
the only argument that needs to be specified is `theme = my_theme()` for broad, 
app-wide styling. Helper functions for ggplot and ggplotly are listed below.
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
  }, bg = 'transparent')
}

shinyApp(ui, server)
```

### Light and darkmode 
Dark mode relies on helper functions to override Shiny's bootstrap variables that are often
*baked in*. In the ui section this requires `input_dark_mode(id = "dark_mode")` 
& `dark_mode_css(),`, in the server section `dm <- use_dark_mode(input, session)`, which is
then called in each plot with the custom theme : `theme_luwi(theme=dm$theme())`.

```
library(luwitemplate)
library(bslib)
library(ggplot2)

ui <- page_fluid(
  theme = my_theme(),  # Shiny UI styled from _brand.yml
  input_dark_mode(id = "dark_mode"), # Additional syntax to enable darkmode
  dark_mode_css(), # Additional syntax to enable darkmode
  plotOutput("plot",height='800px')
)

server <- function(input, output) {
  
  dm <- use_dark_mode(input, session)
  
  output$plot <- renderPlot({
    ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
      geom_point(size = 3) +
      scale_color_luwi_d() +  # Brand colors, identical to light only mode
      theme_luwi(theme=dm$theme()) # Brand theme, specific argument for light/dark
  }, bg = 'transparent')
}

shinyApp(ui, server)
```


## What You Get

**One `_brand.yml` file controls:**
- Shiny UI components (buttons, cards, navbar)
- ggplot2 themes (fonts, colors, backgrounds)
- Plotly interactives (grids, tooltips, hover)
- Color palettes (discrete, sequential, diverging)
- Fully functional dark theme with helper functions

**Key functions:**

| Function | Use Case |
|----------|----------|
| `my_theme()` | Shiny app theme |
| `theme_luwi()` | ggplot2 static plots |
| `luwi_ggplotly()` | Interactive plotly charts |
| `scale_color_luwi_d()` | Discrete colors (categorical data) |
| `scale_color_luwi_c()` | Sequential colors (continuous data) |
| `scale_color_luwi_div()` | Diverging colors (hot/cold data) |
| `scale_fill_luwi_d()` | Discrete fill colors (categorical data) |
| `scale_fill_luwi_c()` | Sequential fill colors (continuous data) |
| `scale_fill_luwi_div()` | Diverging fill colors (hot/cold data) |
| `use_dark_mode(input, session)` | Pass dark mode CSS to theme |
| `dark_mode_css()` | Overrides bootstrap color declarations in dark mode |
| `input_dark_mode(id = "dark_mode")` | Dark - light toggle button, animated |

## Light Example
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

The colors and fonts are defined once in a file named `_brand.yml`.
```yaml
meta:
  name: luwitemplate brand
color:
  primary: "#570a10"
  secondary: "#ad720a"
  success: "#325106"
  danger: "#d64550"
  warning: "#cda029"
  info: "#5a8cb5"
  light: &light-color "#bad9cf"
  dark: &dark-color "#1a1c1a"
  foreground: *dark-color
  background: *light-color
# Dark mode overrides — same hue families, lifted for contrast on dark surfaces
color-dark:
  primary: "#cf8536"
  secondary: "#30d9a0"
  success: "#6aad3a"
  danger: "#e8737b"
  warning: "#e0c050"
  info: "#7cb8d8"
  light: "#1c1e26"
  dark: "#d6e8e0"
  foreground: "#d6e8e0"
  background: "#1c1e26"
# Direct Bootstrap Sass variable mappings
theme:
  # Body
  body-bg: *light-color
  body-color: *dark-color
  # Border radius
  border-radius: "0.75rem"
  border-radius-sm: "0.5rem"
  border-radius-lg: "1rem"
# text styling
typography:
  fonts:
    - family: &base-font Manrope
      source: google
    - family: &header-font Montserrat
      source: google
  base:
    family: *base-font
    size: 1rem
    line-height: 1.65
    weight: 400
  headings:
    family: *header-font
    weight: 700
    line-height: 1.1
```

See [bslib brand documentation](https://rstudio.github.io/bslib/articles/brand.html) for full spec.

## License

MIT
