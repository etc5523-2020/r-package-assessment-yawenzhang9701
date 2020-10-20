#' Launch the Shiny app
#'
#' @description Load the shiny application of COVID-19
#'
#' @import shiny
#'
#' @export
launch_app <- function(){
  shiny::runApp('inst/app')
}
