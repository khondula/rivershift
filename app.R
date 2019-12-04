#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("NWIS data for sites with all 3 parameters"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("site_no",
                        "Site ID:",
                        choices = sites_all3), width = 2
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("summary", tableOutput("summary_table")),
                tabPanel("data", tableOutput("site_data_df")),
                tabPanel("plots", plotOutput("ts_plots", height = "800px")))
            )
        )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$summary_table <- renderTable({
        readr::read_csv(file = glue::glue("data/nwis_site_summaries/nwis-summary_{input$site_no}.csv"),
                        col_types = c("ciiincccccc")) %>%
            dplyr::select(srsname, parameter_nm, parameter_units, date_range_yrs, n_count, min_year, max_year)
    })
    
    site_data <- reactive({
        readr::read_csv(file = glue::glue("data/nwis_site_data/nwis-data_{input$site_no}.csv"),
                        col_types = cols_only(
                            agency_cd = col_character(),
                            site_no = col_character(),
                            sample_dt = col_date(format = ""),
                            sample_tm = col_time(format = ""),
                            sample_start_time_datum_cd = col_character(),
                            parm_cd = col_character(),
                            result_va = col_double(),
                            startDateTime = col_character()
                        )) %>%
            mutate(start_datetime = as.POSIXct(startDateTime))
    })
    
    output$site_data_df <- renderTable({
        # head(site_data())
        # site_data() %>% mutate(startDateTime = as.POSIXct(startDateTime))
        readr::read_csv(file = glue::glue("data/nwis_site_data/nwis-data_{input$site_no}.csv"),
                        col_types = cols_only(
                            agency_cd = col_character(),
                            site_no = col_character(),
                            sample_dt = col_date(format = ""),
                            sample_tm = col_time(format = ""),
                            sample_start_time_datum_cd = col_character(),
                            parm_cd = col_character(),
                            result_va = col_double(),
                            startDateTime = col_character()
                        )) %>%
            mutate(start_datetime = as.POSIXct(startDateTime))
    })
    
    output$ts_plots <- renderPlot({
        site_plot_data <- site_data() %>% 
            left_join(npc_codes_df, by = c("parm_cd" = "parameter_cd")) %>%
            dplyr::select(parm_cd, result_va, start_datetime, parameter_nm, category) 
        
       site_plot_data %>%
            ggplot(aes(x = start_datetime, y = result_va)) +
            geom_point(aes(fill = category), pch = 21, size = 2) +
            facet_wrap(vars(parameter_nm), scales = "free_y") +
            theme(legend.position = "none")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
