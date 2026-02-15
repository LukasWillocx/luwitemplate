# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Horizontal Navbar App Template — luwitemplate                             ║
# ║                                                                            ║
# ║  A comprehensive template demonstrating layout patterns, theming,          ║
# ║  and dark mode integration. Uses only built-in R datasets so it runs       ║
# ║  out of the box. Copy and adapt for your own applications.                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

library(luwitemplate)
library(bslib)
library(shiny)
library(ggplot2)
library(plotly)
library(DT)
library(dplyr)

# List of packages — used for the interactive library pills in the sidebar
all_packages <- c("shiny", "bslib", "ggplot2", "plotly", "DT", "dplyr", "luwitemplate")

# ── UI ────────────────────────────────────────────────────────────────────────
ui <- bslib::page_navbar(
  title = "Application",
  theme = my_theme(),
  dark_mode_css(),
  window_title = "Template App",

  # Optional: targeted CSS fixes for third-party widget quirks
  # Example: networkD3 Sankey SVG not scaling in Firefox
  # tags$head(tags$style(HTML("
  #   #my_widget_id svg { width: 100% !important; height: 100% !important; }
  # "))),

  # ══════════════════════════════════════════════════════════════════════════════
  # TAB 1 — Wide sidebar: dataset info + library pills + about
  # ══════════════════════════════════════════════════════════════════════════════
  # Use this pattern for an overview or landing page. The wide sidebar holds
  # static information while the main panel shows exploratory visuals.
  nav_panel(
    "Overview",
    layout_sidebar(
      sidebar = sidebar(
        width = 590,

        # ── Dataset information block ──
        tags$div(
          tags$div(style = "text-align: center", h4("Dataset Information")),
          hr(),
          HTML("<strong>Dataset:</strong> mtcars, iris, faithfuld (built-in R datasets)<br>"),
          HTML("<strong>Observations:</strong> 32 / 150 / 20,453<br>"),
          HTML("<strong>Source:</strong> R base packages<br>")
        ),

        # ── Clickable library pills ──
        # Each pill links to the package's documentation page.
        # Bioconductor packages use a different URL pattern.
        tags$div(
          tags$div(style = "text-align: center", h5("R Libraries")),
          hr(),
          tags$ul(
            style = "list-style-type: none; padding-left: 0;",
            lapply(all_packages, function(lib) {
              # Route to the correct documentation site
              if (lib == "luwitemplate") {
                doc_url <- "https://github.com/LukasWillocx/luwitemplate"
                # } else if (lib %in% c("DESeq2", "clusterProfiler", ...)) {
                #   doc_url <- paste0("https://bioconductor.org/packages/release/bioc/html/", lib, ".html")
              } else {
                doc_url <- paste0("https://CRAN.R-project.org/package=", lib)
              }

              tags$li(
                style = "display: inline-block; margin: 5px; text-align: center;",
                tags$a(
                  href = doc_url,
                  target = "_blank",
                  style = "text-decoration: none;",
                  tags$span(
                    style = "border-radius: 15px; background-color: rgba(128, 128, 128, 0.1);
                    border: 1px solid rgba(128, 128, 128, 0.3); padding: 5px 10px;
                    display: inline-block; cursor: pointer;
                    transition: background-color 0.2s, border-color 0.2s;",
                    onmouseover = "this.style.backgroundColor='rgba(128, 128, 128, 0.2)'; this.style.borderColor='rgba(128, 128, 128, 0.5)';",
                    onmouseout  = "this.style.backgroundColor='rgba(128, 128, 128, 0.1)'; this.style.borderColor='rgba(128, 128, 128, 0.3)';",
                    tags$b(lib)
                  )
                )
              )
            })
          )
        ),

        # ── About block ──
        tags$div(
          tags$div(style = "text-align: center", h5("About the Application")),
          hr(),
          p("This is a template application demonstrating the layout patterns,
             theming functions, and dark mode integration provided by luwitemplate.
             All plots, tables, and interactive elements react to the dark mode toggle.")
        )
      ),

      # ── Main panel content ──
      # Explicit heights prevent cards from introducing scrollbars.
      layout_columns(
        col_widths = c(8, 4, 4, 4, 4),
        fill = TRUE,
        # ── Static ggplot2 with renderPlot ──
        # Use bg = 'transparent' in the server renderPlot call.
        card(
          full_screen = TRUE,
          card_header("Static ggplot2 — scatter (discrete color)"),
          card_body(plotOutput("scatter_plot", height = "360px"))
        ),
        # ── Static ggplot2 bar chart ──
        card(
          full_screen = TRUE,
          card_header("Static ggplot2 — bar (discrete fill)"),
          card_body(plotOutput("bar_plot", height = "360px"))
        ),
        # ── Interactive plotly scatter ──
        # Uses luwi_ggplotly() for themed conversion.
        card(
          full_screen = TRUE,
          card_header("Plotly — scatter (discrete)"),
          card_body(plotlyOutput("plotly_scatter", height = "300px"))
        ),
        # ── Plotly with legend suppressed ──
        # Legend hidden at both ggplot and plotly level.
        card(
          full_screen = TRUE,
          card_header("Plotly — no legend, hover only"),
          card_body(plotlyOutput("plotly_no_legend", height = "300px"))
        ),
        # ── Continuous color scale ──
        card(
          full_screen = TRUE,
          card_header("Plotly — heatmap (continuous fill)"),
          card_body(plotlyOutput("heatmap", height = "300px"))
        )
      )
    )
  ),

  # ══════════════════════════════════════════════════════════════════════════════
  # TAB 2 — Narrow sidebar: interactive controls driving reactive outputs
  # ══════════════════════════════════════════════════════════════════════════════
  # Use this pattern when the user needs to select parameters that affect plots.
  nav_panel(
    "Interactive",
    layout_sidebar(
      sidebar = sidebar(
        width = 250,
        h4("Controls"),
        selectInput("x_var", "X variable",
                    choices = c("mpg", "disp", "hp", "wt"),
                    selected = "mpg"),
        selectInput("y_var", "Y variable",
                    choices = c("mpg", "disp", "hp", "wt"),
                    selected = "wt"),
        selectInput("color_var", "Color by",
                    choices = c("cyl", "gear", "am", "carb"),
                    selected = "cyl"),
        hr(),
        p("Selections drive all outputs on this tab. The plotly scatter uses
           WebGL for performant rendering of large point clouds — useful when
           your data has thousands of observations.")
      ),
      layout_columns(
        col_widths = c(7, 5, 12),
        fill = FALSE,
        # ── Plotly with toWebGL() ──
        # For high-volume scatter plots (DESeq2 volcano, etc).
        # Strip 'hoveron' before toWebGL() to suppress scattergl warning.
        card(
          full_screen = TRUE,
          card_header("Plotly + WebGL — reactive scatter"),
          card_body(plotlyOutput("webgl_scatter", height = "400px"))
        ),
        # ── Manual color extraction with get_theme_colors() ──
        # For plots where you need explicit hex values from the theme.
        card(
          full_screen = TRUE,
          card_header("Manual theme colors — boxplot"),
          card_body(plotOutput("themed_boxplot", height = "400px"))
        ),
        # ── DT datatable ──
        card(
          full_screen = TRUE,
          card_header("Data table"),
          card_body(DTOutput("data_table"))
        )
      )
    )
  ),

  # ══════════════════════════════════════════════════════════════════════════════
  # TAB 3 — Full-width content: code / markdown embed
  # ══════════════════════════════════════════════════════════════════════════════
  # Use this pattern for documentation, code display, or narrative content.
  # Simply wrap includeMarkdown() in a card.
  nav_panel(
    "Documentation",
    card(
      card_body(
        # includeMarkdown('www/your_file.Rmd')
        h4("Markdown embed placeholder"),
        p("Replace the contents of this card with:"),
        tags$code("includeMarkdown('www/your_file.Rmd')"),
        hr(),
        h4("Template patterns reference"),
        tags$dl(
          tags$dt("Wide sidebar (overview tab)"),
          tags$dd("width = 590, dataset info + library pills + about text"),
          tags$dt("Narrow sidebar (interactive tab)"),
          tags$dd("width = 250, selectInputs and control widgets"),
          tags$dt("Static ggplot2"),
          tags$dd("renderPlot + bg = 'transparent', theme_luwi(theme = dm$theme())"),
          tags$dt("Interactive plotly"),
          tags$dd("renderPlotly, luwi_ggplotly(p, theme = dm$theme())"),
          tags$dt("Plotly without legend"),
          tags$dd("theme(legend.position = 'none') + layout(showlegend = FALSE)"),
          tags$dt("Plotly with WebGL"),
          tags$dd("Strip hoveron, then toWebGL() — for large point clouds"),
          tags$dt("Manual theme colors"),
          tags$dd("colors <- get_theme_colors(dm$theme()) then colors$primary, etc."),
          tags$dt("Discrete color/fill"),
          tags$dd("scale_color_luwi_d(theme = dm$theme()), scale_fill_luwi_d()"),
          tags$dt("Continuous color/fill"),
          tags$dd("scale_fill_luwi_c(theme = dm$theme(), type = 'warm'|'cool'|'green')"),
          tags$dt("Hover text (no legend)"),
          tags$dd("Map variable to text aesthetic, tooltip = c('text', 'x', 'y')"),
          tags$dt("htmlwidget dark mode text"),
          tags$dd("Extract color in R, inject into JS via sprintf()")
        )
      )
    )
  ),

  # ── Dark mode toggle — always last, pushed to far right ──
  nav_spacer(),
  nav_item(input_dark_mode(id = "dark_mode")),
)

# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  # Initialise dark mode reactive and color accessor
  # dm$theme() returns a bslib theme object — pass it to ALL luwi functions
  # dm$mode()  returns "light" or "dark" as a string
  colors <- get_theme_colors()
  dm     <- use_dark_mode(input, session)

  # ╔════════════════════════════════════════════════════════════════════════════╗
  # ║ PATTERN: Static ggplot2                                                  ║
  # ║ • renderPlot with bg = 'transparent'                                     ║
  # ║ • theme_luwi(theme = dm$theme()) for dark mode reactivity                ║
  # ║ • scale_color_luwi_d() / scale_fill_luwi_d() for discrete palettes      ║
  # ╚════════════════════════════════════════════════════════════════════════════╝
  output$scatter_plot <- renderPlot({
    ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
      geom_point(size = 3) +
      labs(title = "Fuel Economy vs Weight", color = "Cylinders") +
      scale_color_luwi_d(theme = dm$theme()) +
      theme_luwi(theme = dm$theme())
  }, bg = 'transparent')

  output$bar_plot <- renderPlot({
    ggplot(mpg, aes(class, fill = class)) +
      geom_bar() +
      labs(title = "Vehicle Classes") +
      scale_fill_luwi_d(theme = dm$theme()) +
      theme_luwi(theme = dm$theme()) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            legend.position = "none")
  }, bg = 'transparent')

  # ╔════════════════════════════════════════════════════════════════════════════╗
  # ║ PATTERN: Interactive plotly                                              ║
  # ║ • Build ggplot, then wrap with luwi_ggplotly()                           ║
  # ║ • luwi_ggplotly applies theme_luwi AND sets plotly layout colors/fonts   ║
  # ╚════════════════════════════════════════════════════════════════════════════╝
  output$plotly_scatter <- renderPlotly({
    p <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
      geom_point(size = 2) +
      labs(title = "Iris Measurements") +
      scale_color_luwi_d(theme = dm$theme())
    luwi_ggplotly(p, theme = dm$theme(), tooltip = c("x", "y", "color"))
  })

  # ╔════════════════════════════════════════════════════════════════════════════╗
  # ║ PATTERN: Plotly with legend suppressed — variable shown on hover         ║
  # ║ • Map variable to aes(text = ...) for hover display                      ║
  # ║ • theme(legend.position = 'none') for the ggplot side                    ║
  # ║ • layout(showlegend = FALSE) for the plotly side                         ║
  # ║ • Both are needed — ggplot legend.position doesn't survive conversion    ║
  # ╚════════════════════════════════════════════════════════════════════════════╝
  output$plotly_no_legend <- renderPlotly({
    p <- ggplot(iris, aes(Sepal.Length, Petal.Length,
                          color = Species, text = Species)) +
      geom_point(size = 2) +
      scale_color_luwi_d(theme = dm$theme()) +
      theme_luwi(theme = dm$theme()) +
      theme(legend.position = 'none')
    luwi_ggplotly(p, theme = dm$theme(), tooltip = c("text", "x", "y")) %>%
      layout(showlegend = FALSE)
  })

  # ╔════════════════════════════════════════════════════════════════════════════╗
  # ║ PATTERN: Continuous color/fill scale                                     ║
  # ║ • scale_fill_luwi_c(type = "warm"|"cool"|"green")                       ║
  # ║ • Also available: scale_color_luwi_c(), scale_fill_luwi_div()            ║
  # ╚════════════════════════════════════════════════════════════════════════════╝
  output$heatmap <- renderPlotly({
    p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
      geom_tile() +
      labs(title = "Old Faithful") +
      scale_fill_luwi_c(type = "warm", theme = dm$theme()) +
      theme_luwi(theme = dm$theme()) +
      theme(legend.position = 'none')
    luwi_ggplotly(p, theme = dm$theme(), tooltip = c("x", "y", "fill"))
  })

  # ╔════════════════════════════════════════════════════════════════════════════╗
  # ║ PATTERN: Plotly + WebGL for large datasets                               ║
  # ║ • toWebGL() offloads scatter points to GPU — smooth with 10k+ points    ║
  # ║ • Strip 'hoveron' attribute before conversion to suppress scattergl      ║
  # ║   warning (ggplotly sets it, but scattergl doesn't support it)           ║
  # ╚════════════════════════════════════════════════════════════════════════════╝
  output$webgl_scatter <- renderPlotly({
    p <- ggplot(mtcars, aes(x = .data[[input$x_var]],
                            y = .data[[input$y_var]],
                            color = factor(.data[[input$color_var]]),
                            text = rownames(mtcars))) +
      geom_point(size = 2) +
      labs(x = input$x_var, y = input$y_var) +
      scale_color_luwi_d(theme = dm$theme()) +
      theme_luwi(theme = dm$theme()) +
      theme(legend.position = 'none')

    fig <- luwi_ggplotly(p, theme = dm$theme(), tooltip = c("text", "x", "y")) %>%
      layout(showlegend = FALSE)

    # Strip 'hoveron' — not supported by scattergl
    for (i in seq_along(fig$x$data)) {
      fig$x$data[[i]]$hoveron <- NULL
    }
    fig %>% plotly::toWebGL()
  })

  # ╔════════════════════════════════════════════════════════════════════════════╗
  # ║ PATTERN: Manual color extraction with get_theme_colors()                 ║
  # ║ • For cases where you need explicit hex values (custom geoms, manual     ║
  # ║   scale_color_manual, threshold lines, annotations, etc.)               ║
  # ║ • Returns: primary, secondary, success, danger, warning, info,           ║
  # ║            light, dark, body_bg, body_color                              ║
  # ╚════════════════════════════════════════════════════════════════════════════╝
  output$themed_boxplot <- renderPlot({
    tc <- get_theme_colors(dm$theme())

    ggplot(mtcars, aes(x = factor(.data[[input$color_var]]),
                       y = .data[[input$y_var]])) +
      geom_boxplot(fill = tc$primary, color = tc$body_color, alpha = 0.6) +
      geom_hline(yintercept = mean(mtcars[[input$y_var]]),
                 linetype = "dashed", color = tc$secondary) +
      labs(x = input$color_var, y = input$y_var, title = "Manual theme colors") +
      theme_luwi(theme = dm$theme())
  }, bg = 'transparent')

  # ╔════════════════════════════════════════════════════════════════════════════╗
  # ║ PATTERN: DT datatable                                                    ║
  # ║ • Inherits Bootstrap theme automatically — no manual color styling       ║
  # ╚════════════════════════════════════════════════════════════════════════════╝
  output$data_table <- renderDT({
    datatable(mtcars[, c(input$x_var, input$y_var, input$color_var)])
  })

  # ╔════════════════════════════════════════════════════════════════════════════╗
  # ║ PATTERN: htmlwidget with dark mode text color (e.g. networkD3 Sankey)    ║
  # ║ • Extract body_color in R: text_color <- get_theme_colors(theme)$body_color
  # ║ • Inject into JS via sprintf("function(el) { var c = '%s'; ... }", text_color)
  # ║ • Pass dm$theme() in the render call so it re-renders on toggle          ║
  # ║                                                                          ║
  # ║ Example (not run — requires networkD3):                                  ║
  # ║                                                                          ║
  # ║   my_widget_function <- function(data, theme = my_theme()) {             ║
  # ║     text_color <- get_theme_colors(theme)$body_color                     ║
  # ║     widget %>%                                                           ║
  # ║       htmlwidgets::onRender(sprintf("                                    ║
  # ║         function(el) {                                                   ║
  # ║           el.querySelectorAll('text').forEach(function(node) {           ║
  # ║             node.style.fill = '%s';                                      ║
  # ║           });                                                            ║
  # ║         }", text_color))                                                 ║
  # ║   }                                                                      ║
  # ║                                                                          ║
  # ║   # In server:                                                           ║
  # ║   output$my_widget <- renderSankeyNetwork({                              ║
  # ║     my_widget_function(data, theme = dm$theme())                         ║
  # ║   })                                                                     ║
  # ╚════════════════════════════════════════════════════════════════════════════╝
}

# Run the application
shinyApp(ui = ui, server = server)
