## code to prepare `coronavirus_world_province` dataset goes here

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

coronavirus_world_province <- read.csv("data/coronavirus_new.csv", stringsAsFactors = FALSE) %>%
  mutate(country = ifelse(country == "United Arab Emirates", "UAE", country),
         country = ifelse(country == "Mainland China", "China", country),
         country = ifelse(country == "North Macedonia", "N.Macedonia", country),
         country = trimws(country),
         country = factor(country, levels = unique(country))) %>%
  mutate(date = as.Date(date))

daily <- coronavirus_world_province %>%
  group_by(date, type) %>%
  mutate(as.Date(date)) %>%
  summarise(total = sum(cases, na.rm = TRUE),
            .groups = "drop") %>%
  pivot_wider(names_from = type,
              values_from = total) %>%
  arrange(date) %>%
  ungroup() %>%
  mutate(active =  confirmed - death - recovered) %>%
  mutate(confirmed_cum = cumsum(confirmed),
         death_cum = cumsum(death),
         recovered_cum = cumsum(recovered),
         active_cum = cumsum(active))

total_type <- coronavirus_world_province %>%
  group_by(country, type) %>%
  summarise(total = sum(cases), .groups = "drop") %>%
  mutate(type = ifelse(type == "confirmed", "Confirmed", type),
         type = ifelse(type == "recovered", "Recovered", type),
         type = ifelse(type == "death", "Death", type)) %>%
  pivot_wider(names_from = type, values_from = total) %>%
  mutate(Active = Confirmed - Death - Recovered) %>%
  pivot_longer(cols = -country, names_to = "type", values_to = "total")

recent <- coronavirus_world_province %>%
  filter(date == "2020-10-07") %>%
  pivot_wider(id_cols = c("date", "country", "lat", "long", "province"), names_from = type, values_from = cases)

usethis::use_data(recent, overwrite = TRUE)
