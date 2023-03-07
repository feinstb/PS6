library(tidyverse)
library(shiny)
# Set working directory and load data
data <- read_delim("UAH-lower-troposphere-long.csv.bz2")

# Define UI
ui <- fluidPage(
  # App title
  titlePanel("Shiny App for UAH Lower Troposphere Dataset"),
  
  # Sidebar with widgets for plot and table pages
  sidebarLayout(
    sidebarPanel(
      # Widget for plot page
      selectInput(inputId = "plot_type", label = "Select plot type:",
                  choices = c("Scatterplot", "Line plot")),
      # Widget for table page
      sliderInput(inputId = "num_rows", label = "Number of rows to display:",
                  min = 1, max = nrow(data), value = 10)
    ),
    
    # Main panel with tabs for different pages
    mainPanel(
      # Tabset for different pages
      tabsetPanel(
        # Opening page with general information
        tabPanel(title = "Information",
                 p("This Shiny app displays visualizations and tables for the UAH Lower Troposphere Dataset."),
                 p("The dataset contains monthly temperature anomalies in the lower troposphere, as measured by satellite."),
                 p("There are a total of", nrow(data), "observations in the dataset."),
                 br(),
                 p("Select the 'Plot' tab or the 'Table' tab to view visualizations or tables, respectively.")
        ),
        
        # Plot page
        tabPanel(title = "Plot",
                 plotOutput(outputId = "my_plot"),
                 br(),
                 p("Number of observations displayed:"),
                 verbatimTextOutput(outputId = "num_obs")
        ),
        
        # Table page
        tabPanel(title = "Table",
                 dataTableOutput(outputId = "my_table"),
                 br(),
                 p("Number of observations displayed:"),
                 verbatimTextOutput(outputId = "num_obs2")
        )
      )
    )
  )
)

# Define server
server <- function(input, output) {
  
  # Reactive function to create plot based on input widget
  output$my_plot <- renderPlot({
    if (input$plot_type == "Scatterplot") {
      ggplot(data, aes(x = year, y = temp)) +
        geom_point()
    } else {
      ggplot(data, aes(x = year, y = temp)) +
        geom_line()
    }
  })
  
  # Reactive function to create table based on input widget
  output$my_table <- renderDataTable({
    head(data, n = input$num_rows)
  })
  
  # Reactive function to display number of observations
  output$num_obs <- renderPrint({
    nrow(data)
  })
  
  # Reactive function to display number of observations based on table widget
  output$num_obs2 <- renderPrint({
    input$num_rows
  })
}

# Run the app
shinyApp(ui = ui, server = server)