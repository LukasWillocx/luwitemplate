# Vertical Sidebar Navigation App Template
library(luwitemplate)

# UI
ui <- bslib::page_sidebar(
  title = "My Report Application",
  theme = my_theme(),

  # Vertical navigation sidebar
  sidebar = sidebar(
    open = "always",
    navset_pill_list(
      id = "sidebar_nav",
      nav_panel("Step 1: Overview", value = "step1"),
      nav_panel("Step 2: Analysis", value = "step2")
    )
  ),

  # Main content area
  navset_hidden(
    id = "main_content",

    # Tab 1
    nav_panel_hidden(
      value = "step1",
      layout_columns(
        col_widths = c(6, 6, 6, 6),
        row_heights = c("calc(50vh - 75px)", "calc(50vh - 75px)"),
        card(
          card_header("Card 1"),
          card_body()
        ),
        card(
          card_header("Card 2"),
          card_body()
        ),
        card(
          card_header("Card 3"),
          card_body()
        ),
        card(
          card_header("Card 4"),
          card_body()
        )
      )
    ),

    # Tab 2
    nav_panel_hidden(
      value = "step2",
      layout_columns(
        col_widths = c(6, 6, 6, 6),
        row_heights = c("calc(50vh - 75px)", "calc(50vh - 75px)"),
        card(
          card_header("Card 5"),
          card_body()
        ),
        card(
          card_header("Card 6"),
          card_body()
        ),
        card(
          card_header("Card 7"),
          card_body()
        ),
        card(
          card_header("Card 8"),
          card_body()
        )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  # Sync sidebar navigation with main content
  observeEvent(input$sidebar_nav, {
    nav_select("main_content", selected = input$sidebar_nav)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
