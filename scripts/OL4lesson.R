####
# R and Python in Geosciences (2024)
# lesson: Raster geodata in R; basics of functional programming in R
# author: O. Ledvinka
# date: 2024-04-23
####

# This is only the script we created during the four lesson
# Please, read the OL4lesson.html document for completeness!

# We assume we are working within the R project we established during our first lesson
# Therefore, we are able to use relative paths and other advantages of using R projects
# Here, we download a lot of geodata, so also a good internet connection is required


# First steps - getting raster geodata and saving them --------------------

# we load the packages we think we will certainly need
library(tidyverse)
library(RCzechia) # package sf is loaded automatically with this package
library(terra) # the state-of-the-art package for manipulating raster geodata in current R

# the rast() function is very interesting
# we can read rasters from files using this function, but it can do much more (e.g. make the raster empty without values, with defined geometry only)
# study the help page of the function
?rast

# but we have also functions in several other packages that can download and read (from temporary files or really downloaded files)
# for instance the following gets a DEM of Czechia
# function vyskopis() is included in the RCzechia package
czdem1 <- vyskopis(format = "actual")

# observe the information about the raster layer printed in the Console
# we now know about the crs, extent, dimension (i.e. number of cells along the x-axis, along the y-axis, and the number of layers)
# we also see the horizontal resolution (in respective units) and that the layers is loaded from memory
czdem1

# writeRaster function writes the layer to a locally stored file
# by defining the suffix, we choose the right driver for writing (here, we have a TIF file)
writeRaster(czdem1,
            "geodata/czdem1.tif", # relative path to the file, incl. the suffix of the file
            overwrite = T) # for cases we already have the file of the same name in the folder we selected

# the file may be read using the function rast()
czdem1 <- rast("geodata/czdem1.tif")

# now we see that the source of the object changed
czdem1

# there is another package for obtaining geodata, incl. raster geodata
library(geodata)

# we can download and load another DEM for Czechia
# this function, however, does not allow us to give the name to the downloaded file
# therefore it suffices to specify the folder to which we want to download, the name of the file is chosen automatically according to what happens with the file
czdem2 <- elevation_30s(country = "CZE", # country code here
                        path = "geodata")

# we may plot the situation
# for plotting purposes, we also load the polygon with the territory of Czechia
czechia <- republika()

# and we may also doewload the vector layer with administrative regions in Czechia
regions <- kraje()

czechia

regions

# we may convert those vector layers to tibble-sf
czechia <- czechia |> 
  as_tibble() |> 
  st_sf()

regions <- regions |> 
  as_tibble() |> 
  st_sf()

# look at the function through which we can get the extent of a raster
ext(czdem1)

# of course, the pipe construct is valid
czdem2 |> 
  ext()

# for vector geodata, we have a similar function, that is, st_bbox()
st_bbox(regions)

st_bbox(czechia)


# Plotting raster layers with tidyterra functions -------------------------

# load the tidyterra package
# the ggspatial package is for placing scale bars to static maps created by ggplot2; but it can do much more (e.g. north arrow, etc.)
library(tidyterra) # unfortunately, tidyterra does not automatically load terra
library(ggspatial)

ggplot() +
  geom_spatraster(data = czdem1) + # basic tidyterra function for plotting raster layers
  scale_fill_hypso_tint_c(palette = "wiki-schwarzwald-cont", # one of the color palettes for plotting elevation rasters
                          na.value = NA, # otherwise, there would be unwanted NA values plotted as well
                          limits = c(20, 1603), # elevation limits for the legend
                          breaks = c(20, 400, 800, 1200, 1603)) + # elevation breaks for the legend
  labs(fill = "elevation\n[m n.m.]", # we can put units on a new line by using the \n separator in the string
       title = "Elevation in the territory of Czechia",
       caption = "data source: R package RCzechia") +
  geom_sf(data = czechia, # we add also the polygon with the territory of Czechia
          col = "purple",
          fill = NA,
          linewidth = 1) +
  annotation_scale()

# almost the same plot, but with the second DEM and different scale bar
ggplot() +
  geom_spatraster(data = czdem2) +
  scale_fill_hypso_tint_c(palette = "wiki-schwarzwald-cont",
                          na.value = NA,
                          limits = c(20, 1603),
                          breaks = c(20, 400, 800, 1200, 1603)) +
  labs(fill = "elevation\n[m n.m.]",
       title = "Elevation in the territory of Czechia",
       caption = "data source: R packages geodata and RCzechia") +
  geom_sf(data = czechia,
          col = "purple",
          fill = NA,
          linewidth = 1) +
  annotation_scale(style = "ticks")


# Raster geodata with multiple layers -------------------------------------

# we will make use of the geodata offered by the geodata package
# let us focus on the long-term average air temperature for each month (period 1971-2000; see https://www.worldclim.org/data/worldclim21.html)
tavg <- worldclim_country(country = "CZE",
                          var = "tavg",
                          path = "geodata") # sometimes, the geodata functions create subfolders when downloading

# observe that we have more than one layer here
tavg

# SpatRaster objects behave similarly to lists when it comes to subsetting the layers
# we can use double square bracket for subsetting
tavg[[1]]

# having loaded the tidyterra package, we can also employ the function select(), but currently this approach is very slow!
tavg |> 
  select(1)

# let us plot the January layer with corresponding color palette and its direction
ggplot() +
  geom_spatraster(data = tavg[[1]]) +
  scale_fill_distiller(palette = "YlOrRd", # another function using the geographer Brewer nice color palettes
                       direction = 1) +
  geom_sf(data = czechia,
          linewidth = 1,
          fill = NA)

# we can see that we have a wider raster layer than we need
# therefore, the crop() and mask() function are very useful if we need to limit ourselves to some area such as the polygon with Czechia
?crop

?mask

# regarding the function arguments, usually, first, the raster layer(s) come, then, vector geodata for cutting out the geographic subset
tavg_cropped <- crop(tavg,
                     czechia)

# let us plot the new situation with January temperature only
ggplot() +
  geom_spatraster(data = tavg_cropped[[1]]) +
  scale_fill_distiller(palette = "YlOrRd",
                       direction = 1) +
  geom_sf(data = czechia,
          linewidth = 1,
          fill = NA)

# although we have a separate function for masking, there is a shortcut if we use the same vector layer for cropping and masking
tavg_masked <- crop(tavg,
                    republika(),
                    mask = T)

ggplot() +
  geom_spatraster(data = tavg_masked[[1]]) +
  scale_fill_distiller(palette = "YlOrRd",
                       direction = 1,
                       na.value = NA) +
  geom_sf(data = czechia,
          linewidth = 1,
          fill = NA)


# Applying functions over layers ------------------------------------------

# there an important function for doing that in terra
# however, the functions has also some shortcuts, such as mean()
?app

# we can create any anonymous function within app()
# here, note that the function app() has another possibility for removing missing values; please, study the help page
# by the way, think about using the weighted mean considering the number of days in different months; the anonymous function would be more complex!
tavg_annual <- app(tavg,
                   fun = \(x) mean(x, na.rm = T))

tavg_annual

# also, we can use pipes and other functions that follow in defining the anonymous functions
# for instance, here, we directly round the raster values resulting from the averaging
tavg_annual <- app(tavg,
                   fun = \(x) mean(x, na.rm = T) |> 
                     round(1))

tavg_annual

# easier approaches may be used if we have named functions at hand
tavg_annual <- app(tavg,
                   fun = mean,
                   na.rm = T)


# Zonal statistics --------------------------------------------------------

# probably, the most important function here is the function extract()
?extract

# here, we can set up another averaging anonymous function, but, this time, for getting the average air temperature over regions defined by polygons
tavg_annual_regions <- extract(tavg_annual,
                               regions,
                               fun = \(x) mean(x,
                                               na.rm = T))

# identification of regions is missing in the results
tavg_annual_regions

# we can take this information from the regions sf object
regions

# because the order of the row is respected in the results of extract(), we can use the function bind_cols()
regions_tavg <- regions |> 
  st_drop_geometry() |> 
  select(NAZ_CZNUTS3) |> 
  bind_cols(tavg_annual_regions) |> 
  rename(tavg = mean)

regions_tavg

# we can add some other results to following columns
regions_tavg_elv <- regions_tavg |> 
  bind_cols(extract(czdem2,
                    regions,
                    ID = F,
                    fun = \(x) mean(x, na.rm = T))) |> 
  rename(elv = CZE_elv_msk)

regions_tavg_elv


# Tidying up the linear models --------------------------------------------

# based on the results in the regions_tavg_elv object, we can construct linear and other regression models
model1 <- lm(tavg ~ elv,
             data = regions_tavg_elv)

model1 |> 
  summary()

# let us tidy up this model using the tidy() function included in the broom package
library(broom)

# we may apply filer() to limit ourselves to rows we are interested in (being usually rows related to the slope of regression line)
model1 |> 
  tidy() |> 
  filter(term == "elv")

# from the p-value, we see that the dependence of air temperature on elevation is significant even at the 0.001 level
# the dependence is negative according to the slope and according to the t statistic of having the (central) Student distribution


# Basics of functional programming in R -----------------------------------

# in tidyverse, mainly the purrr package and its functions map(), walk() and their variants are used for functional programming
# generally speaking, such functions effectively mimic the for cycles when one needs to loop over many subjects or groups applying the same function (or function with changing arguments)
# observe also the variants of the map() function
?map

# in functional programming, we loop over vectors or lists, and the results are usually also the lists
# pipes and anonymous functions within map() are applied here a lot
# sometimes, it is a good strategy to create such lists as a new columns of tibbles by placing map() inside the mutate() function
# run also vignette("nest") about the nest() function to better imagine the practical purposes 

# imagine we want to compute more statistics at once from the terrain of Czechia, and to have these statistics aggregated for individual administrative regions
# we may loop over a vector of the names of the functions used for the computation of zonal statistics
# within the map() function, we create an anonymous function making use the terra::extract() function where the argument fun equals to some general variable (say x)
result <- c("sd",
            "mean",
            "median") |> 
  map(\(x) extract(czdem1,
                   regions,
                   fun = x,
                   ID = T,
                   na.rm = T))

# the result is a list, which may be reformatted to a tibble if we want
result

# using other functions from purrr, we may proceed as follows
nms <- c("sd",
         "mean",
         "median")

result <- result |> 
  set_names(nms) |> 
  list_rbind(names_to = "stat")

result <- result |> 
  rename(region = ID,
         val_num = Band_1) |> 
  mutate(val_num = round(val_num, 1))

result

# and we can further plot, group, build new models, etc.


# Remark to the homework --------------------------------------------------

# while working with 539 time series from Czech water-gauging stations, we may employ grouping, nesting, functional programming and the function complete()
?complete

# but other strategies do exist as well