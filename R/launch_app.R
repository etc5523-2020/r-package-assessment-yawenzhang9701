#' Launch the Shiny app
#'
#' @description Load the shiny application of COVID-19
#'
#' @import shiny
#'
#' @examples
#' \dontrun{
#' launch_app()
#' }
#'
#' @export
launch_app <- function() {
  appDir <- system.file("app",package = "COVIDworld")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `COVIDworld`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
