library(DT)
library(readr)

read_csv("chl_nwis_ts.csv") %>% 
  dplyr::select(agency_cd,
                station_nm,
                site_no,
                site_tp_cd,
                parameter_nm,
                parameter_units,
                date_range_yrs,
                begin_date,
                end_date,
                count_nu,
                huc_cd,
                parm_cd
                ) %>%
    dplyr::mutate(date_range_yrs = round(date_range_yrs)) %>%
  datatable(rownames = FALSE, filter = "top") %>%
  htmltools::save_html("docs/nwis-chl.html")

read_csv("phos_nwis_ts.csv") %>% 
  dplyr::select(agency_cd,
                station_nm,
                site_no,
                site_tp_cd,
                parameter_nm,
                parameter_units,
                date_range_yrs,
                begin_date,
                end_date,
                count_nu,
                huc_cd,
                parm_cd
  ) %>%
  dplyr::mutate(date_range_yrs = round(date_range_yrs)) %>%
  datatable(rownames = FALSE, filter = "top") %>%
  htmltools::save_html("docs/nwis-phos.html")


read_csv("nitr_nwis_ts.csv") %>% 
  dplyr::select(agency_cd,
                station_nm,
                site_no,
                site_tp_cd,
                parameter_nm,
                parameter_units,
                date_range_yrs,
                begin_date,
                end_date,
                count_nu,
                huc_cd,
                parm_cd
  ) %>%
  dplyr::mutate(date_range_yrs = round(date_range_yrs)) %>%
  datatable(rownames = FALSE, filter = "top") %>%
  htmltools::save_html("docs/nwis-nitr.html")

read_csv("nitr_wqp_ts.csv") %>% 
  dplyr::select(MonitoringLocationIdentifier,
                CharacteristicName,
                ResultMeasure.MeasureUnitCode,
                count,
                station_nm,
                MonitoringLocationTypeName,
                StateCode,
                begin_date,
                end_date,
                date_range_yrs
  ) %>%
  dplyr::mutate(date_range_yrs = round(date_range_yrs)) %>%
  datatable(rownames = FALSE, filter = "top") %>%
  htmltools::save_html("wqp-nitr.html", lib = "lib")


read_csv("phos_wqp_ts.csv") %>% 
  dplyr::select(MonitoringLocationIdentifier,
                CharacteristicName,
                ResultMeasure.MeasureUnitCode,
                count,
                station_nm,
                MonitoringLocationTypeName,
                StateCode,
                begin_date,
                end_date,
                date_range_yrs
  ) %>%
  dplyr::mutate(date_range_yrs = round(date_range_yrs)) %>%
  datatable(rownames = FALSE, filter = "top") %>%
  htmltools::save_html("wqp-phos.html", lib = "lib")

read_csv("chl_wqp_ts.csv") %>% 
  dplyr::select(MonitoringLocationIdentifier,
                CharacteristicName,
                ResultMeasure.MeasureUnitCode,
                count,
                station_nm,
                MonitoringLocationTypeName,
                StateCode,
                begin_date,
                end_date,
                date_range_yrs
  ) %>%
  dplyr::mutate(date_range_yrs = round(date_range_yrs)) %>%
  datatable(rownames = FALSE, filter = "top") %>%
  htmltools::save_html("wqp-chl.html", lib = "lib")
