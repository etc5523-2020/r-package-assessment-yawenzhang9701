#' Filter df table
#'
#' @description This function aim to filter different countries, type of cases, time period from the raw data.
#'
#' @param df Enter your origin data set.
#' @param country_name Countries you want to selected.
#' @param type_name Select different type cases in the dataframe, which includes confirmed, recovered and deaths.
#' @param date1 The starting point of the time period.
#' @param date2 The ending point of the time period.
#'
#'
#' @examples
#' df_Canada <- filter_table(df, "Canada",
#' "confirmed", lubridate::ymd("2020-01-22"), lubridate::ymd("2020-01-31"))
#' tibble::view(df_Canada)
#'
#' @export
filter_table <- function(df, country_name, type_name, date1, date2){
  df <- df %>%
    dplyr::mutate(Date = as.Date(date)) %>%
    dplyr::filter(country == country_name,
           type == type_name,
           date >= date1,
           date <= date2) %>%
    dplyr::rename("Amount" = cases) %>%
    dplyr::rename("Type" = type)
  return(df)
}
