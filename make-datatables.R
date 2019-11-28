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
  datatable(rownames = FALSE, filter = "top")

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
  datatable(rownames = FALSE, filter = "top")

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
  datatable(rownames = FALSE, filter = "top")

