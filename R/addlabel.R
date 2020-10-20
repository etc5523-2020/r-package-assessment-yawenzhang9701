#' Label the leaflet map
#'
#' @description add label for the leaflet map
#'
#' @export
addLabel <- function(data) {
  data$label <- paste0(
    '<b>', data$country, '</b><br>
    <table style="width:120px;">
    <tr><td>confirmed:</td><td align="right">', data$confirmed, '</td></tr>
    <tr><td>recovered:</td><td align="right">', data$recovered, '</td></tr>
    <tr><td>death:</td><td align="right">', data$death, '</td></tr>
    </table>'
  )
  data$label <- lapply(data$label, HTML)

  return(data)
}
