#' Slider Date
#'
#' @description This function constructs a slider widget to select the minimum date and maximum date from a range.
#'
#' @param inputid The input slot that will be used to access the value
#' @param inputDisplay Display label for the control
#' @param date The minimum and maximum date can be selected
#'
#'
#' @examples
#' \dontrun{
#' slider_date("dateInput", "Date:", df$date)
#' }
#'
#' @export
slider_date <- function(inputid, inputDisplay, date){
  sliderInput(inputid, inputDisplay,
              min = min(date),
              max = max(date),
              value = c(min(date), max(date)))
}
