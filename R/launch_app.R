#' Launch the Shiny app
#'
#' @description This function used to load the coronavirus pandemic shiny application.
#'
#' @import shiny
#'
#' @details
#' The novel coronavirus has been an unavoidable topic for several months.
#' This coronavirus outbreak was first documented in Wuhan, Hubei Province, China in December 2019.
#' These were caused by a new type of coronavirus,
#' and the disease is now commonly referred to as COVID-19.
#' The number of COVID-19 cases started to escalate more quickly in mid-January,
#' and the virus soon spread beyond China’s broad.
#' Now, it has now been confirmed on six continents and in more than 100 countries.
#' Therefore, this dashboard aims track and visualize the spread of COVID-19.
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
