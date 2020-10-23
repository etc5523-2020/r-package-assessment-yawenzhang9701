
<!-- README.md is generated from README.Rmd. Please edit that file -->

# 📦 COVIDworld

<!-- badges: start -->

[![R build
status](https://github.com/etc5523-2020/r-package-assessment-yawenzhang9701/workflows/R-CMD-check/badge.svg)](https://github.com/etc5523-2020/r-package-assessment-yawenzhang9701/actions)
[![License:
GPL](https://img.shields.io/badge/License-GPL-3.svg)](http://www.gnu.org/licenses/gpl-3.0.en.html)
[![GitHub
commit](https://img.shields.io/github/last-commit/etc5523-2020/r-package-assessment-yawenzhang9701)](https://github.com/etc5523-2020/r-package-assessment-yawenzhang9701/commit/master)

<!-- badges: end -->

## Overview 📖

The goal of `{COVIDworld}` R package is to provide datasets and
functions to run Shiny dashboard which aim to help users to get a deeper
understanding of the 2019 Novel Coronavirus COVID-19 (2019-nCoV)
epidemic in the worldwide.

The package includes the following four datasets:

  - `df` - The 2019 Novel Coronavirus COVID-19 (2019-nCoV) Dataset in
    Countries and Province/States.
  - `df_recent` - The 2019 Novel Coronavirus COVID-19 (2019-nCoV) in
    2020-10-07 (last day in the data set).
  - `df_daily` - The 2019 Novel Coronavirus COVID-19 (2019-nCoV) Daily
    and Cumulative Cases around the world.
  - `df_tree` - The 2019 Novel Coronavirus COVID-19 (2019-nCoV) Dataset
    in each country.

More information about the shiny dashboard available
[here](https://etc5523-yawen-zhang-blog.netlify.app/post/shiny-app-introduction/)
and supporting dashboard available
[here](https://yawen.shinyapps.io/shiny-assessment-yawenzhang9701/)

Data Source: [Johns Hopkins University
GitHub](https://github.com/CSSEGISandData/COVID-19)

[<img src="man/figures/map.png" width="100%" />](https://etc5523-2020.github.io/r-package-assessment-yawenzhang9701/)

## Get Started 🙌

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("etc5523-2020/r-package-assessment-yawenzhang9701")
```

## How to launch the Shiny Dashboard? 🗺

In order to make the dashboard easier, I created a function called
`launch_app()` to run the shiny dashboard. This app aims to track and
visualize the spread by providing several interactive plots and tables,
including the timeline function and the ability to overlay past
outbreaks.

    library(COVIDworld)
    
    launch_app()

The screenshot plots visualizing several interesting aspects of the
COVID-19 pandemic progression.
[<img src="man/figures/graphs.png" width="100%" />](https://yawen.shinyapps.io/shiny-assessment-yawenzhang9701/)

Besides, there are three other functions inside the package, which are:

  - `silder_date` - Constructs a slider widget to select the minimum
    date and maximum date from a range.
  - `add_menu` - Add menu bar for the shiny dashboard.
  - `df_daily` - Filter different countries, type of cases, time period
    from the raw data

## Usage 📖

### Plotting the confirmed cases

``` r
data(df)

head(df)
#>         date province     country      lat     long      type cases
#> 1 2020-01-22          Afghanistan 33.93911 67.70995 confirmed     0
#> 2 2020-01-23          Afghanistan 33.93911 67.70995 confirmed     0
#> 3 2020-01-24          Afghanistan 33.93911 67.70995 confirmed     0
#> 4 2020-01-25          Afghanistan 33.93911 67.70995 confirmed     0
#> 5 2020-01-26          Afghanistan 33.93911 67.70995 confirmed     0
#> 6 2020-01-27          Afghanistan 33.93911 67.70995 confirmed     0
```

``` r
library(tidyverse)
df %>%
  filter(type == "confirmed", country == "China") %>%
  ggplot(aes(x = date, y = cases)) +
  geom_col(color = "#E41317", fill = "#E41317") +
  ggtitle("China Daily Confirmed Cases") +
  xlab("Confirmed") +
  ylab("Number of Cases")+
  theme(panel.background = element_rect(fill = 'white', colour = 'black'))+
  theme(panel.grid.major=element_line(colour=NA))
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

### Plotting different type of cases in the world

``` r
data(df_daily)
head(df_daily)
#> # A tibble: 6 x 9
#>   date       confirmed death recovered active confirmed_cum death_cum
#>   <date>         <int> <int>     <int>  <int>         <int>     <int>
#> 1 2020-01-22       555    17        28    510           555        17
#> 2 2020-01-23        99     1         2     96           654        18
#> 3 2020-01-24       287     8         6    273           941        26
#> 4 2020-01-25       493    16         3    474          1434        42
#> 5 2020-01-26       684    14        13    657          2118        56
#> 6 2020-01-27       809    26         9    774          2927        82
#> # … with 2 more variables: recovered_cum <int>, active_cum <int>
```

``` r
df_daily %>%
  select(date, confirmed_cum, death_cum, recovered_cum, active_cum) %>%
  rename("Confirmed" = confirmed_cum,
         "Recovered" = recovered_cum,
         "Death"  = death_cum,
         "Active" = active_cum) %>%
  pivot_longer(cols = -date, names_to = "type", values_to = "total") %>%
  ggplot(aes(x = date, y = total, color = type)) +
  geom_line() +
  ggtitle("Active, Confirmed, Death and Recovered Cases in the world") +
  xlab("Date") +
  ylab("Number") +
  theme(panel.background = element_rect(fill = 'white', colour = 'black'))+
  theme(panel.grid.major=element_line(colour=NA))
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />
