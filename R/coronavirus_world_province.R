#' The 2019 Novel Coronavirus COVID-19 (2019-nCoV) Dataset in Countries and Province/States
#'
#' Daily summary of the Coronavirus (COVID-19) cases by state/province from 2020-01-22 to 2020-10-07.
#'
#'
#' @format A data frame with 7 variables.
#' \describe{
#'   \item{date}{Date in YYYY-MM-DD format. The date from 2020-01-22 to 2020-10-07. }
#'   \item{province}{Name of province/state, for countries where data is
#'   provided split across multiple provinces/states.}
#'   \item{country}{Name of country/region.}
#'   \item{lat}{Latitude of center of geographic region, defined as either
#'   country or, if available, province.}
#'   \item{long}{Longitude of center of geographic region, defined as either
#'   country or, if available, province.}
#'   \item{type}{An indicator for the type of cases (confirmed, death,
#'   recovered).}
#'   \item{cases}{Number of cases on given date.}
#'   }
#'
#' @source
#' Johns Hopkins University Center for Systems Science and Engineering
#' (JHU CCSE) Coronavirus \href{https://systems.jhu.edu/research/public-health/ncov/}{website}.
#'
#' @keywords datasets coronavirus COVID19 in coutries and province/states
#'
#' @details The dataset contains the daily summary of Coronavirus cases
#' (confirmed, death, and recovered), by state/province.
#'
#' @examples
#'
#' require(dplyr)
#'
#' # Get the number of recovered cases in Canada by province
#' df %>%
#'   filter(type == "recovered", country == "Canada") %>%
#'   group_by(province) %>%
#'   summarise(total = sum(cases)) %>%
#'   arrange(-total)
"df"

#' The 2019 Novel Coronavirus COVID-19 (2019-nCoV) Daily and Cumulative Cases.
#'
#' Daily new confirmed, recovered, death and active cases with their cumulative cases from 2020-01-22 to 2020-10-07.
#'
#' @format A data frame with 9 variables.
#' \describe{
#'   \item{date}{Date in YYYY-MM-DD format. The date from 2020-01-22 to 2020-10-07. }
#'   \item{confirmed}{Daily new confirmed cases. }
#'   \item{death}{Daily new mortality cases. }
#'   \item{recovered}{Daily new recovered cases. }
#'   \item{active}{Daily new active cases, which could calculated by 'active cases = confirmed - deaths - recoveries'.}
#'   \item{confirmed_cum}{Cumulative confirmed cases from 2020-01-22 to 2020-10-07.}
#'   \item{death_cum}{Cumulative death cases from 2020-01-22 to 2020-10-07.}
#'   \item{recovered_cum}{Cumulative recovered cases from 2020-01-22 to 2020-10-07.}
#'   \item{active_cum}{Cumulative active cases from 2020-01-22 to 2020-10-07, which could calculated by 'cumulative active cases = cumulative confirmed - cumulative deaths - cumulative recoveries'}
#'   }
#'
#' @source
#' Johns Hopkins University Center for Systems Science and Engineering
#' (JHU CCSE) Coronavirus \href{https://systems.jhu.edu/research/public-health/ncov/}{website}.
#'
#' @keywords datasets coronavirus COVID19 in the world
#'
#' @details The dataset contains the daily summary of Coronavirus cases
#' (confirmed, death, and recovered), in global.
#'
#'
"df_daily"

#' The 2019 Novel Coronavirus COVID-19 (2019-nCoV) in 2020-10-07.
#'
#' Daily summary of the Coronavirus (COVID-19) cases by state/province in 2020-10-07.
#'
#' @format A data frame with 8 variables.
#' \describe{
#'   \item{date}{The Most Recent Date in YYYY-MM-DD format in 2020-10-07.}
#'   \item{country}{Name of country/region.}
#'   \item{lat}{Latitude of center of geographic region, defined as either
#'   country or, if available, province.}
#'   \item{long}{Longitude of center of geographic region, defined as either
#'   country or, if available, province.}
#'   \item{province}{Name of province/state, for countries where data is
#'   provided split across multiple provinces/states.}
#'   \item{confirmed}{Confirmed Cases in 2020-10-07.}
#'   \item{death}{Mortality Cases in 2020-10-07.}
#'   \item{recovered}{Recovered Cases in 2020-10-07.}
#'   }
#'
#' @source
#' Johns Hopkins University Center for Systems Science and Engineering
#' (JHU CCSE) Coronavirus \href{https://systems.jhu.edu/research/public-health/ncov/}{website}.
#'
#' @keywords 2020-10-07 coronavirus COVID19 in coutries and province/states
#'
#' @details The dataset contains the most recent summary Coronavirus cases
#' (confirmed, death, and recovered), by state/province when making this shiny app.
#'
"df_recent"

#' The 2019 Novel Coronavirus COVID-19 (2019-nCoV) Dataset for each country
#'
#' Cumulative Confirmed, Death, Recovered and Active Cases Dataset in Countries and Province/States
#'
#' @format A data frame with 3 variables.
#' \describe{
#'   \item{country}{Countries}
#'   \item{type}{Includes confirmed, recovered, death and active cases}
#'   \item{total}{Cumulative amount until 2020-10-07}
#'   }
#'
#' @source
#' Johns Hopkins University Center for Systems Science and Engineering
#' (JHU CCSE) Coronavirus \href{https://systems.jhu.edu/research/public-health/ncov/}{website}.
#'
#'
"df_tree"
