#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

data_dir <- "/nfs/rivershift-data"
sites_all3_streams <- readr::read_csv("/nfs/rivershift-data/us-data/sites_all3_streams.csv", col_types = "c")

    
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("NWIS data for sites with all 3 parameters"),

    # Sidebar  
    sidebarLayout(
        sidebarPanel(
            selectInput("site_no",
                        "Site ID:",
                        choices = sites_all3_streams$site_no),
            width = 2
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("summary", tableOutput("summary_table")),
                tabPanel("data", tableOutput("site_data_df")),
                tabPanel("plots", plotOutput("ts_plots", height = "2000px")),
                tabPanel("site", tableOutput("site_info")))
            )
        )
    )

# Define server logic 
server <- function(input, output) {

    output$summary_table <- renderTable({
        readr::read_csv(file = glue::glue("{data_dir}/us-data/nwis_site_summaries_1990s/nwis-summary_1990s{input$site_no}.csv"),
                        col_types = c("ciiincccccc")) %>%
            dplyr::select(srsname, parameter_nm, parameter_units, date_range_yrs, n_count, min_year, max_year)
    })
    
    site_data <- reactive({
        readr::read_csv(file = glue::glue("{data_dir}/us-data/nwis_site_data_1990s/nwis-data_1990s{input$site_no}.csv"),
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
        readr::read_csv(file = glue::glue("{data_dir}/us-data/nwis_site_data_1990s/nwis-data_1990s{input$site_no}.csv"),
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
           arrange(category) %>%
            ggplot(aes(x = start_datetime, y = result_va)) +
            geom_point(aes(fill = category), pch = 21, size = 2) +
            facet_wrap(vars(parameter_nm), scales = "free_y", ncol = 1) +
            theme(legend.position = "none")
    })
    
    output$site_info <- renderTable({
        dataRetrieval::readNWISsite(input$site_no) %>% 
            t() %>% as.data.frame() %>% tibble::rownames_to_column()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
