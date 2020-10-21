#' Add Menu
#'
#' @description Add menu for shiny dashboard
#'
#' @param x Sidebar menu which be used for a Shiny input value
#' @param y The name of a tab that this menu item will activate
#' @param z The available icons
#'
#'
#' @examples
#' \dontrun{
#' add_menu("Map", "Map", "map-marked-alt")
#' }
#'
#' @source You can see lists of all available icons here:
#' <https://fontawesome.com/icons?from=io>
#'
#' @export
add_menu <- function(x, y, z){
  shinydashboard::menuItem(x, tabName = y, icon = icon(z))
}
