ga_explorer <- function() {
  results <- httr::GET(ga_url)
  httr::stop_for_status(results)
  res <- httr::content(results)
  colheaders <- purrr::map_chr(res$columnHeaders, "name") %>% stringr::str_replace("ga:","")
  coltypes <- purrr::map_chr(res$columnHeaders, "dataType")
  res <- purrr::map(res$rows, ~ purrr::set_names(.x, colheaders )) %>% dplyr::bind_rows()
  dataType <- function(x, type) {
    switch(type,
         INTEGER = as.integer(x),
         STRING = as.character(x),
         CURRENCY = as.numeric(x),
         PERCENT = as.numeric(x))
  }
  res <- purrr::map2_df(res, coltypes, dataType)
  if(!is.null(res[["date"]])) {
    res[["date"]] <- lubridate::ymd(res[["date"]])
  }
  res
}