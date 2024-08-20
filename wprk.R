


# 1) select only complete time series of discharge on the territory of Czechia for the 
# calendar period 1981-2020; functional programming and the complete() 
# function applied after the nest() function application may be helpful 
# (see their help pages and a vignette)


# 2) for each selected water-gauging station, compute mean annual discharge for each year; 
# do not forget about arranging according to the year in an ascending order (otherwise, trend analysis is useless)



# 3) for each selected water-gauging station, perform a trend analysis using the linear model (function lm()); 
# do not forget about placing proper dates (similar to beginnings of months) to the lm model

library(tidyverse)


rm(list = ls())
setwd("C:/R_scripts/R_HT_o1")
# Завантаження даних
data <- read_rds("qdmeta2023.rds")
data2 <- read_rds("QDdata2023_gzipped.rds")


data <- data |> 
  mutate(PCR = as_date(PCR, format = "%Y/%m")) |> 
  filter(PCR >= as.Date("1981-01-01") & PCR <= as.Date("2020-12-31")) |> 
  mutate(Year = year(PCR))



nested <- data |> 
  group_by(STATION) |> 
  nest() |> 
  complete()


  

annual <- nested |> 
  mutate(annual_calc = map(data, ~ .x |> 
                                  group_by(Year) |> 
                                  summarize(Avg_Discharge = mean(A, na.rm = TRUE)) |>  # Розрахунок середнього витрату
                                  arrange(Year)  # Сортування за роком
  ))



model1 <- lm(Avg_Discharge ~ A,
             data = annual)



?lm
