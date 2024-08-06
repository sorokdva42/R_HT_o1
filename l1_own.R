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


