site_id <- sites_all3[1]

site_data <- readr::read_csv(file = glue::glue("data/nwis_site_data/nwis-data_{site_id}.csv"),
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

readr::read_csv(file = glue::glue("data/nwis_site_data/nwis-data_{site_id}.csv"),
                col_types = cols_only(
                  agency_cd = col_character(),
                  site_no = col_character(),
                  sample_dt = col_date(format = ""),
                  sample_tm = col_time(format = ""),
                  sample_start_time_datum_cd = col_character(),
                  parm_cd = col_character(),
                  result_va = col_double(),
                  startDateTime = col_character()
                )) %>% head()

site_plot_data <- site_data %>% 
  left_join(npc_codes_df, by = c("parm_cd" = "parameter_cd")) %>%
  dplyr::select(parm_cd, result_va, start_datetime, parameter_nm, category) 

plots <- site_plot_data %>%
  ggplot(aes(x = start_datetime, y = result_va)) +
  geom_point(aes(fill = category), pch = 21, size = 2) +
  facet_wrap(vars(parameter_nm), scales = "free_y") +
  theme(legend.position = "none")

plotly::ggplotly(plots)
