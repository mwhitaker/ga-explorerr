# ga-explorerr

Super simple way to get the data from the GA Query Explorer directly into R.

1) Build and run the query at the [Query Explorer](https://ga-dev-tools.appspot.com/query-explorer/)

2) Copy the **API QUERY URI**, making sure the `access token` is included:

![GA Explorer](R/ga_explorer.png)

3) Load and source function and load required libraries:

```{r}
library(tidyverse)
library(httr)

ga_explorer <- function() {
  results <- httr::GET(ga_url)
  httr::stop_for_status(results)
  res <- httr::content(results)
  colheaders <- purrr::map_chr(res$columnHeaders, "name") %>% sub("ga:","",.)
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
    res[["date"]] <- as.Date(res[["date"]], format = "%Y%m%d")
  }
  res
}
```

4) Call the function `ga_explorer(ga_url)` and paste in the URI as the argument. You'll get a nicely formatted `tibble` back with all columns having the right format.

```{r}
my_data <- ga_explorer("https://www.googleapis.com/analytics/v3/data/ga?ids=ga%3A123456789...")
```