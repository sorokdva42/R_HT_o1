remotes::install_github("yonghah/esri2sf")
library(esri2sf)
xfun::pkg_attach("remotes",
                 "import",
                 install = TRUE)
# from now on, we will use T instead of TRUE
# the opposite will be F (like FALSE)

library(sos)

import::from(sos, findFn)

findFn ("{temperature}")

library(dplyr)



# creating and assigning the object to a name
vec <- c(T, F)

# class() function is not too verbose
class(vec)
import::from(dplyr,glimpse)
glimpse (vec)
length(vec) 

vec %>% 
  glimpse()

vec |>
  length()

vec %>% 
  class() %>% 
  length()


vec %>% 
  length() %>% 
  class()


class(length(vec))
vec


sequence <- seq( from = 1,
                 to = 10,
                 by = 1
)

sequence2 <- 1:10

identical(sequence,sequence2)

identical(as.integer(sequence),sequence2)



?identical


a = F
b = FALSE

identical(a,b)

rand <- list(sample(1:10, size = 10, replace = T))
rand


# natural logarithm
rep(log(sequence),
    times = 2)


vec <- c(1,-Inf,NA)
is.na(vec)


sequence %>% 
  quantile(
    probs = c(.25, 0.5, .75)
  ) 


quartiles <- quantile(sequence,
                      probs = c(.25, 0.5, .75))

quartiles

col1 <- 1:3
col2 <- 3:1
tab2 <- tibble(col1,col2)
tab2

tba1 <- tibble(forward = 1:3,
         backward = 3:1)
tba1


rm(list = ls())




mat <- matrix(1:9,
              nrow = 3,
              ncol = 3,
              byrow =T
            )

mat[,3] <- c('one','two','there')


# however, tibbles behave in other way
tab <- matrix(1:9,
              nrow = 3,
              byrow = T)
library(stringr)
# str_c() comes from the stringr package and is similar to c(), but it concatenates characters strings
colnames(tab) <- str_c("V", 1:3)

tab <- tab |> 
  as_tibble()

tab$V3 <- c("one", "two", "three")

tab



library(tidyverse)
library(readxl)
library(writexl)

qdmeta <- read_rds("QDmeta2023.rds")

qdmeta |> 
  write_xlsx("data/water_gauging_stations_Czechia.xlsx")


qdmeta_xlsx |> 
  write_csv("data/water_gauging_stations_Czechia.csv",
            eol = "\r\n")


qdmeta |> 
  class()

qdmeta |> 
  str()

qdmeta |> 
  glimpse()
qdmeta[,1]



qdmeta2 <- qdmeta |> 
  as.data.frame()

circle <- function(x=2){
  return((x/2)^2*pi)
}
circle(x=1:10)



# same effect in newer versions of R (shortened), but not allowing negative diameter lengths
circle2 <- \(x = 2) {
  if (all(x >= 0)) {
    return((x / 2)^2 * pi)
  }
  else
    print("Diameter must be zero or positive!")
}

circle2(x = 1:9)



q()

