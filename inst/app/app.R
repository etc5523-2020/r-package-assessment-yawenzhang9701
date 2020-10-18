library(shiny)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(plotly)
library(kableExtra)
library(leaflet)
library(DT)
library(scales)
library(shinydashboard)

load(here::here('data/df.rda'))
load(here::here('data/df_daily.rda'))
load(here::here('data/df_tree.rda'))
load(here::here('data/df_recent.rda'))


# df <- read.csv("data/coronavirus_new.csv", stringsAsFactors = FALSE) %>%
#   mutate(country = ifelse(country == "United Arab Emirates", "UAE", country),
#                 country = ifelse(country == "Mainland China", "China", country),
#                 country = ifelse(country == "North Macedonia", "N.Macedonia", country),
#                 country = trimws(country),
#                 country = factor(country, levels = unique(country))) %>%
#   mutate(date = as.Date(date))
# df_daily <- df %>%
#   group_by(date, type) %>%
#   mutate(as.Date(date)) %>%
#   summarise(total = sum(cases, na.rm = TRUE),
#                    .groups = "drop") %>%
#   pivot_wider(names_from = type,
#                      values_from = total) %>%
#   arrange(date) %>%
#   ungroup() %>%
#   mutate(active =  confirmed - death - recovered) %>%
#   mutate(confirmed_cum = cumsum(confirmed),
#                 death_cum = cumsum(death),
#                 recovered_cum = cumsum(recovered),
#                 active_cum = cumsum(active))
# df_tree <- df %>%
#   group_by(country, type) %>%
#   summarise(total = sum(cases), .groups = "drop") %>%
#   mutate(type = ifelse(type == "confirmed", "Confirmed", type),
#                 type = ifelse(type == "recovered", "Recovered", type),
#                 type = ifelse(type == "death", "Death", type)) %>%
#   pivot_wider(names_from = type, values_from = total) %>%
#   mutate(Active = Confirmed - Death - Recovered) %>%
#   pivot_longer(cols = -country, names_to = "type", values_to = "total")
# # df_world <- df_tree %>%
# #   group_by(type) %>%
# #   summarise(total = sum(total), .groups = "drop") %>%
# #   pivot_wider(names_from = type, values_from = total)
# # names(df_world) <- tolower(names(df_world))
#
# df_recent <- df %>%
#   filter(date == "2020-10-07") %>%
#   # filter(type == "recovered") %>%
#   # select(-province) %>%
#   pivot_wider(id_cols = c("date", "country", "lat", "long", "province"), names_from = type, values_from = cases)

data_atDate <- function(inputDate) {
  df[which(df$date == inputDate),] %>%
    distinct() %>%
    pivot_wider(id_cols = c("province", "country", "date", "lat", "long"), names_from = type, values_from = cases) %>%
    filter(confirmed > 0 |
             recovered > 0 |
             death > 0)
}

ui <- dashboardPage(
  dashboardHeader(title = "The COVID-19 Global Situation"),
  dashboardSidebar(sidebarMenu(
    menuItem("Map", tabName = "Map", icon = icon("map-marked-alt")),
    menuItem("Graphs", tabName = "Graphs", icon = icon("chart-bar")),
    menuItem("About", tabName = "About",icon = icon("info-circle") )
    )
  ),
  dashboardBody(
    tabItems(
  tabItem(tabName = "Map",
          fluidRow(
            class = "details",
            column(
              box(
                width = 12,
                leafletOutput("overview_map")
              ),
              class = "map",
              width = 8,
              style = 'padding:0px;'
            ),
            column(
              uiOutput("summaryTables"),
              class = "summary",
              width = 4,
              style = 'padding:0px;'
            ),
            column(
              sliderInput(
                "timeSlider",
                label      = "Select date",
                min        = min(df$date),
                max        = max(df$date),
                value      = max(df$date),
                width      = "100%",
                timeFormat = "%d.%m.%Y",
                animate    = animationOptions(loop = TRUE)
              ),
              class = "slider",
              width = 12,
              style = 'padding-left:15px; padding-right:15px; font-size:20px'
            ),
            column(
              h4(strong("Brief Explanation"), style = 'font-size:20px; '),
              "This map section of the dashboard shows the most important key figures and visualizations of the COVID-19 pandemic, such as the world map and a list of countries with their respective number of confirmed, recovered and deaths cases.
              A time-lapse feature with a simple slider is included to get an idea about the development of the pandemic.",
              style = 'font-size:17px',
              width = 12,
            )
          )),
  tabItem(tabName = "Graphs",
          fluidRow(
            # box(plotlyOutput("countryplot", height = 350)),
            box(
              title = "New Cases in each Country",
              plotlyOutput("countryplot"),
              column(
                selectizeInput("countryInput", "Country",
                               choices = unique(df_tree$country),
                               selected="US", multiple =FALSE), width = 3),
              column(
                checkboxGroupInput("typeInput", "Metrics",
                                   choices = c("confirmed",
                                               "death",
                                               "recovered"),
                                   selected = c("confirmed")), width = 3),
              column(
                sliderInput("dateInput", "Date:",
                            min = as.Date("2020-01-22", "%Y-%m-%d"),
                            max = as.Date("2020-10-07", "%Y-%m-%d"),
                            value = c(as.Date("2020-01-22"), as.Date("2020-10-07"))),width = 6),
              column(
                h4(strong("Brief Explanation"), style = 'font-size:20px'),
                "The bar chart shows the global evaluation of new confirmed, recovered and deaths cases from 2020-01-22 to 2020-10-07.",
                     tags$br(),
                 "Users can manually select the countries she or he is interested. By default, the US with the most confirmed cases in recent days is chosen in the plots.
                 Also, you could click the checkbox to select confirmed, recovered, and deaths at the same time.
                 Sometimes, you may interest in the changes in the coronavirus situation in a certain period. You could slide the time progress bar to select a specific date period as you like.",
                style = 'font-size:17px',
                width = 12
                # style = "padding: 15px"
              )
            ),
            fluidRow(
              box(
                title = "Evolution of Cases since Outbreak",
                plotlyOutput("case_evolution"),
                br(), br(),
                tableOutput("click"),
                column(
                  checkboxInput("checkbox_logCaseEvolution", label = "Logarithmic Y-Axis", value = FALSE),
                  width = 4,
                  style = "float: right; padding: 10px; margin-right: 50px"
                ),
                column(
                  h4(strong("Brief Explanation"), style = 'font-size:20px',),
                  "This plot shows global evolution of cases from 2020-01-22 to 2020-10-07. We add active cases to measure the global COVID-19 in a day. Active cases could remove deaths and recoveries from daily new cases.",
                       tags$br(),
                  "At the bottom, there is a checkbox with which the y-axis can be switched to a logarithmic scale.",
                  tags$br(),
                  "Last, when you click each plot, it will generate a table to summarize each plot stands for.",
                  style = 'font-size:17px',
                  width = 12
                ),
                width = 6
              )
            )
          )
  ),
  tabItem(tabName = "About",
          fluidRow(
            fluidRow(
              column(
                box(
                  title = div("About this Shiny App", style = "padding-left: 25px", class = "h2"),
                  column(
                    "This Coronavirus shiny app provides an overview of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
                    The shiny package could display this pandemic's development, which is easy to build interactive web apps straight from R.
                    The code behind the dashboard available ",
                    tags$a(href = "https://github.com/etc5523-2020/shiny-assessment-yawenzhang9701", "here"),".
                    The latest version on the COVID-19 spread is displayed in a map, summary table, figures, and plots.",
                    tags$br(),
                    h3("Motivations"),
                    "A novel coronavirus outbreak was first documented in Wuhan, Hubei Province, China in December 2019. These were caused by a new type of coronavirus, and the disease is now commonly referred to as COVID-19. The COVID-19 pandemic has been an unavoidable topic for several months. The number of COVID-19 cases started to escalate more quickly in mid-January, and the virus soon spread beyond China’s broad. As of writing this, it has now been confirmed on six continents and in more than 100 countries.",
                    tags$br(),
                    tags$br(),
                    "Only look at the data, it is hard to interpret how fast is the virus spreading, and how does the situation in each country. Then, I created this dashboard to track and visualize the spread by providing several interactive plots and tables, including the timeline function and the ability to overlay past outbreaks. By looking through this dashboard, I hope it is possible to get deeper understanding of this pandemic.",
                    tags$br(),
                    h3("Data"),
                    "The input data for this dashboard is from the ",
                    tags$a(href = "https://github.com/RamiKrispin/coronavirus", "R package"), ". The raw data pulled from the Johns Hopkins University Center for Systems Science and Engineering (JHU CCSE) Coronavirus
                    (",
                    tags$a(href = "https://github.com/CSSEGISandData/COVID-19", "Johns Hopkins COVID-19"), ")",
                    h3("Creator"),
                    "Yawen Zhang | Master of Business Analystics student in Monash University @",
                    tags$a(href = "https://etc5523-yawen-zhang-blog.netlify.app/", "Yawen Zhang Blog"), "|",
                    tags$a(href = "https://github.com/etc5523-2020/shiny-assessment-yawenzhang9701", "Github"),
                    h3("References"),
                    "Chang, Winston, and Barbara Borges Ribeiro. 2018. Shinydashboard: Create Dashboards with ’Shiny’. https://CRAN.R-project.org/package=shinydashboard.",
                    tags$br(),
                    tags$br(),
                    "Chang, Winston, Joe Cheng, JJ Allaire, Yihui Xie, and Jonathan McPherson. 2020. Shiny: Web Application Framework for R. https://CRAN.R-project.org/package=shiny.",
                    tags$br(),
                    tags$br(),
                    "Cheng, Joe, Bhaskar Karambelkar, and Yihui Xie. 2019. Leaflet: Create Interactive Web Maps with the Javascript ’Leaflet’ Library. https://CRAN.R-project.org/package=leaflet.",
                    tags$br(),
                    tags$br(),
                    "ramikrispin. 2020. “Coronavirus.” https://github.com/RamiKrispin/coronavirus.",
                    tags$br(),
                    tags$br(),
                    "Sievert, Carson. 2020. Interactive Web-Based Data Visualization with R, Plotly, and Shiny. Chapman; Hall/CRC. https://plotly-r.com.",
                    tags$br(),
                    tags$br(),
                    "University, Johns Hopkins. 2020. “COVID-19 Data Repository by the Center for Systems Science and Engineering (Csse) at Johns Hopkins University.” https://github.com/CSSEGISandData/COVID-19.",
                    tags$br(),
                    tags$br(),
                    "Wickham, Hadley. 2016. Ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York. https://ggplot2.tidyverse.org.",
                    tags$br(),
                    tags$br(),
                    "Wickham, Hadley, Mara Averick, Jennifer Bryan, Winston Chang, Lucy D’Agostino McGowan, Romain François, Garrett Grolemund, et al. 2019. “Welcome to the tidyverse.” Journal of Open Source Software 4 (43): 1686. https://doi.org/10.21105/joss.01686.",
                    tags$br(),
                    tags$br(),
                    "Wickham, Hadley, Romain François, Lionel Henry, and Kirill Müller. 2020. Dplyr: A Grammar of Data Manipulation. https://CRAN.R-project.org/package=dplyr.",
                    tags$br(),
                    tags$br(),
                    "Wickham, Hadley, and Dana Seidel. 2020. Scales: Scale Functions for Visualization. https://CRAN.R-project.org/package=scales.",
                    tags$br(),
                    tags$br(),
                    "Xie, Yihui, Joe Cheng, and Xianying Tan. 2020. DT: A Wrapper of the Javascript Library ’Datatables’. https://CRAN.R-project.org/package=DT.",
                    tags$br(),
                    tags$br(),
                    "Zhu, Hao. 2019. KableExtra: Construct Complex Table with ’Kable’ and Pipe Syntax. https://CRAN.R-project.org/package=kableExtra.",
                    width = 12,
                    style = "padding-left: 20px; padding-right: 20px; padding-bottom: 40px; margin-top: -15px"
                  ),
                  width = 12,
                ),
                width = 12,
                style = "padding: 20px"
              )
            )
          ))
  )
)
)



server <- function(input, output) {
    d <- reactive({
      df %>%
        filter(country == input$countryInput,
               type %in% input$typeInput,
               date >= input$dateInput[1],
               date <= input$dateInput[2]) %>%
        mutate(Date = as.Date(date)) %>%
        rename("Amount" = cases) %>%
        # mutate(Amount = comma(Amount, big.mark = ",", digits = 0)) %>%
        rename("Type" = type)
    })

    output$countryplot <- renderPlotly({

      # plot_ly(data = df, x = ~date, y = ~cases, color = ~type, type = 'bar') %>%
      #   layout(
      #     yaxis = list(title = "# New Cases"),
      #     xaxis = list(title = "Date"))

      ggplot(d(), aes(x=Date, y = Amount, fill = Type)) +
        geom_col() +
        theme_bw() +
        xlab("date") +
        ylab("new cases") +
        ggtitle("Cases over time")
        # layout(legend = orientation = "h", y = -0.3) +
        # config(displayModeBar = F)
    })

    output$case_evolution <- renderPlotly({
      d2 <- df_daily %>%
        select(date, confirmed_cum, death_cum, recovered_cum, active_cum) %>%
        rename("Confirmed" = confirmed_cum,
               "Recovered" = recovered_cum,
               "Death"  = death_cum,
               "Active" = active_cum) %>%
        pivot_longer(cols = -date, names_to = "type", values_to = "total")

      p <- plot_ly(
        d2,
        x     = ~as.Date(date),
        y     = ~total,
        # name  = sapply(data$var, capFirst),
        color = ~type,
        type  = 'scatter',
        mode  = 'markers',
        source = "B") %>%
        layout(
          yaxis = list(title = "Number of Cases"),
          xaxis = list(title = "Date"),
          legend = list(orientation = "h", y = -0.3)
        ) %>%
        config(displayModeBar = F)

      if (input$checkbox_logCaseEvolution) {
        p <- layout(p, yaxis = list(type = "log"))
      }
      return(p)

    })

    output$click <- renderPrint({
      click_d <- event_data("plotly_click", source = "B")
      # table <- click_d %>% select(x, y)
      # dd <- filter(date==click_d$x, total==click_d$y)
      if (is.null(click_d)) "Click events appear here (double-click to clear)" else data.frame(click_d) %>%
        select(x, y) %>%
        mutate(y = scales::comma(y)) %>%
        rename(Date = x, Amount = y) %>%
        kable("html", escape = F) %>%
        kable_styling(bootstrap_options = c("striped", "condensed","hover"))
    })


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

    map <- leaflet(addLabel(df_recent)) %>%
      setMaxBounds(-180, -90, 180, 90) %>%
      setView(0, 20, zoom = 2) %>%
      addTiles() %>%
      addLayersControl(
        # baseGroups    = c("Light", "Satellite"),
        overlayGroups = c("confirmed", "recovered", "death")
      ) %>%
      hideGroup("recovered") %>%
      hideGroup("death") %>%
      addEasyButton(easyButton(
        icon    = "glyphicon glyphicon-globe", title = "Reset zoom",
        onClick = JS("function(btn, map){ map.setView([20, 0], 2); }")))

    observe({
      req(input$timeSlider, input$overview_map_zoom)
      zoomLevel               <- input$overview_map_zoom
      data                    <- data_atDate(input$timeSlider) %>% addLabel()

      leafletProxy("overview_map", data = data) %>%
        clearMarkers() %>%
        addCircleMarkers(
          lng          = ~long,
          lat          = ~lat,
          radius       = ~log(confirmed^(zoomLevel / 1)),
          stroke       = FALSE,
          color        = "#E7590B",
          fillOpacity  = 0.5,
          label        = ~label,
          labelOptions = labelOptions(textsize = 15),
          group        = "confirmed"
        ) %>%
        addCircleMarkers(
          lng          = ~long,
          lat          = ~lat,
          radius       = ~log(recovered^(zoomLevel)),
          stroke       = FALSE,
          color        = "#005900",
          fillOpacity  = 0.5,
          label        = ~label,
          labelOptions = labelOptions(textsize = 15),
          group = "recovered"
        ) %>%
        addCircleMarkers(
          lng          = ~long,
          lat          = ~lat,
          radius       = ~log(death^(zoomLevel)),
          stroke       = FALSE,
          # color        = "#E7590B",
          fillOpacity  = 0.5,
          label        = ~label,
          labelOptions = labelOptions(textsize = 15),
          group        = "death"
        ) %>%
        addCircleMarkers(
          lng          = ~long,
          lat          = ~lat,
          radius       = ~log(death^(zoomLevel / 2)),
          stroke       = FALSE,
          color        = "#f49e19",
          fillOpacity  = 0.5,
          label        = ~label,
          labelOptions = labelOptions(textsize = 15),
          group        = "death"
        )
    })

    output$overview_map <- renderLeaflet(map)

    output$summaryTables <- renderUI({
      tabBox(
        tabPanel("Country",
                 div(
                   dataTableOutput("summaryDT_country"),
                   style = "margin-top: -10px")
        ),
        width = 12
      )
    })

    output$summaryDT_country <- renderDataTable(getSummaryDT(data_atDate("2020-10-07"), "country", selectable = FALSE))
    proxy_summaryDT_country  <- dataTableProxy("summaryDT_country")

    observeEvent(input$timeSlider, {
      data <- data_atDate(input$timeSlider)
      replaceData(proxy_summaryDT_country, summariseData(data, "country"), rownames = FALSE)
    }, ignoreInit = TRUE, ignoreNULL = TRUE)


    summariseData <- function(df, groupBy) {
      df %>%
        group_by(!!sym(groupBy)) %>%
        summarise(
          "confirmed" = sum(confirmed, na.rm = T),
          "recovered" = sum(recovered, na.rm = T),
          "death" = sum(death, na.rm = T)
        ) %>%
        as.data.frame()
    }

    getSummaryDT <- function(data, groupBy, selectable = FALSE) {
      datatable(
        na.omit(summariseData(data, groupBy)),
        rownames  = FALSE,
        options   = list(
          order          = list(1, "desc"),
          scrollX        = TRUE,
          scrollY        = "37vh",
          scrollCollapse = T,
          dom            = 'ft',
          paging         = FALSE
        ),
        selection = ifelse(selectable, "single", "none")
      ) %>%
        formatCurrency("confirmed", currency = "", interval = 3, mark = ",", digits = 0) %>%
        formatCurrency("recovered", currency = "", interval = 3, mark = ",", digits = 0) %>%
        formatCurrency("death", currency = "", interval = 3, mark = ",", digits = 0)
    }



}

shinyApp(ui, server)
