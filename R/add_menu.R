#' Dashboard Menu
#'
#' @description Add menu for shiny dashboard
#'
#' @param id Sidebar menu which be used for a Shiny input value
#' @param text_name The name of a tab that this menu item will activate
#' @param icon_name The available icons
#'
#'
#' @examples
#' add_menu("Map", "Map", "map-marked-alt")
#'
#' @source You can see lists of all available icons here:
#' <https://fontawesome.com/icons?from=io>
#'
#' @export
add_menu <- function(id, text_name, icon_name){
  shinydashboard::menuItem(id, tabName = text_name, icon = icon(icon_name))
}
