#' Summarize Data Frame
#'
#' @description summarize data and transfer it into dataframe.
#'
#' @param df the data called 'df'
#' @param groupBy group by each columns
#'
#'
#' @export
summariseData <- function(df, groupBy) {
  df %>%
    group_by(!!sym(groupBy)) %>%
    summarise(
      "confirmed" = sum(confirmed, na.rm = T),
      "recovered" = sum(recovered, na.rm = T),
      "death" = sum(death, na.rm = T)
    ) %>%
    as.data.frame()
}
