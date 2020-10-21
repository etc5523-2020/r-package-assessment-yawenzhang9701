#' Add Circle
#' @description add circle
#' @importFrom rlang enquo
#' @importFrom rlang .data
#' @param var variable
#' @param data data
#' @param color color
#' @param group group
#'
#' @export
# add_circle <- function(data, var, color, group){
#   data <- data_atDate(input$timeSlider) %>% addLabel()
#   # var <- quo_name(enquo(var))
#   data %>%
#     addCircleMarkers(
#       lng          = ~long,
#       lat          = ~lat,
#       radius       = ~log(.data$var^(zoomLevel)),
#       stroke       = FALSE,
#       color        = color,
#       fillOpacity  = 0.5,
#       label        = ~label,
#       labelOptions = labelOptions(textsize = 15),
#       group = group
#     )
# }
