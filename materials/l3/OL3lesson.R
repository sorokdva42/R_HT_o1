####
# R and Python in Geosciences (2024)
# lesson: Dates, times and spatial data in R
# author: O. Ledvinka
# date: 2024-04-16
####

# This is only the script we created during the third lesson
# Please, read the OL3lesson.html document for completeness!

# We assume we are working withing the R project we established during our first lesson
# Therefore, we are able to use relative paths and other advantages of using R projects


# Dates and times ---------------------------------------------------------

# as usual, loading the necessary packages first
library(tidyverse)

# we again load our tables
# we can also use the following trick with the readClipbaord() function
# but, first, we need to have the path to the file copied in our clipboard (may be done e.g. in Total Commander)
qd <- read_rds("QDdata2023_gzipped.rds")

tab <- read_rds("qdmeta2023.rds")


# print the beginnings of the tables in the Console
qd

tab

# although we have functions like as.Date(), as.POSIXct(), strptime(), ISOdate() or ISOdatetime() in base R, we will use the functions from the lubridate package
?as.Date

# the basic lubridate functions for creating date vectors
# their usage depends on the situation are facing
?make_date # creates dates from individual components

?as_date # creates dates from one character string based on the defined format

# there are also shortcuts that try to guess from the string structure
?ymd

?ym

# there are also shortcuts for datetime
?ymd_hms

# we will convert the PCR column of the tab object to a date column
# but first, we check if the string length is the same at every row
tab |> 
  count(length = str_length(PCR))

# count() is the shortcut for the following
# so, in fact, there is grouping by a newly created variable representing the lengths of the strings (was not properly explained during the lesson!)
# function n() simply gives the number of occurrences in a group
tab |> 
  group_by(length = str_length(PCR)) |> 
             summarize(n = n())

# as we see that every water gauge has 7 characters, we may guess that the structure is the same everywhere and we may proceed to mutating the PCR column
# we need to define the format, where %Y means a long format of the year (e.g. four characters) and %m means the month
# it is not necessary to define days (they are automatically guessed)
tab <- tab |> 
  mutate(PCR = as_date(PCR,
                       format = "%Y/%m"))

# in the second table, with mean daily discharges, the situation is different (we have three columns/components)
qd <- qd |> 
  mutate(date = make_date(year = YEAR,
                          month = MONTH,
                          day = DAY))

# as we forgot about the .after and .before arguments in mutate(), we can then use the function relocate() for moving the column
qd <- qd |> 
  relocate(date, .after = MI)

# for the next demonstration, remove the three columns bringing the individual date components
qd <- qd |> 
  select(-c(YEAR:DAY))

# for extracting date components we have many functions in lubridate
?year # for year in a long format
?month# for months
?mday # for days in months
?yday # for days in years (so-called Julian days)

# but there are many more functions working with days in weeks, quarters, etc.; study the help pages

# date components are returned as numeric values, not the character strings
qd <- qd |> 
  mutate(year = year(date),
         month = month(date),
         day = mday(date),
         julian = yday(date))

# based on the date components, we can apply the functions group_by() and summarize()
# here, for instance, we compute the mean monthly discharges from the daily values
# siginf() 'rounds' to a given number of significant digits (Czech national standard requires the values of discharge to be shown using three significant digits)
# number1 variable represents the number of really present mean daily discharges in the dataset
qm <- qd |> 
  group_by(ID, year, month) |> 
  summarize(val_num = mean(VAL_NUM) |> 
              signif(3),
            number1 = n())

# if we need to retain only rows with mean monthly discharges where the computations took all needed daily values, the function days_in_month comes in handy
qm <- qm |> 
  mutate(number2 = days_in_month(make_date(year = year,
                                           month = month)))

# now, we can remove the undesired rows using the filter() function
# a new object is created because we want to leave qm intact (everyone makes mistakes and wants to reduce a risk of creating the objects above again:-) )
qm2 <- qm |> 
  filter(number1 == number2)

# we can also compare the numbers of rows in both objects
nrow(qm2) - nrow(qm) # we lost 64 rows

# let us plot the monthly time series of gauge 000400, which is quite short
# distinguish properly the pipe and plus operators!
# fortunately, ggplot suggests changing these operators if we make mistake
ggplot(data = qm2 |> 
         filter(ID == "000400") |> 
         mutate(date = make_date(year = year,
                          month = month))) + 
  geom_line(aes(x = date,
                y = val_num),
            col = "blue",
            linewidth = 1.5) + # can be also defined as the lwd argument used in the base-R plotting system
  geom_point(aes(x = date,
                 y = val_num),
             pch = 15, # can be also defined as the shape argument in terms of the ggplot arguments
             size = 2,
             col = "blue") +
  scale_x_date(date_labels = "%Y-%m-%d") + # this is needed because of fine tuning the labels of the date axis (e.g. instead of using the Czech locale)
  labs(x = "time in months",
       y = "mean monthly discharge ["~m^3~""~s^-1~"]",
       title = "Labský důl gauge - mean monthly discharges",
       caption = "data source: CHMI")

# still, we do not have the date in the qm2 object:-)
# let us add it
qm2 <- qm2 |> 
  mutate(date = make_date(year = year,
                          month = month))

# but we may also add the hours, minutes and seconds (incl. a time zone)
# for this purpose, we have the function make_datetime() here, where adding hours suffices to have minutes and seconds as well
# usually we use midnight if there is no other hour at hand
# UTC time zone is important because no daylight saving time is applied in its case
qm2 <- qm2 |> 
  mutate(datetime = make_datetime(year = year,
                                  month = month,
                                  day = 1,
                                  hour = 0,
                                  tz = "UTC"))

qm2

# normally, the time zone is not shown when being in the table
# but vectors show the time zone
# if time is midnight, it is not necessary to show it
qm2$datetime[1:10]

# but we may add some hours
qm2$datetime[1:10] + hours(2)

# also, be careful when using functions with_tz() and force_tz()
(qm2$datetime[1:10] + hours(2)) |> 
  with_tz("Europe/Prague") # Olson names of time zones are preferred

(qm2$datetime[1:10] + hours(2)) |> 
  force_tz("Europe/Prague")

# we can compute time differences as well
# surprisingly, there is no need for quotes in the ymd() function
ymd(20240416) - ymd(20240101)


# Geodata in R ------------------------------------------------------------

# when working with vector data, the sf() package is needed
library(sf)

# read the downloaded and unzipped shapefile
# we downloaded a zipped file representing water reservoirs in Czechia from https://www.dibavod.cz/
# we also created a new subfolder under our R project
# by default, UTF-8 encoding of characters is expected, but if we need a different encoding not defined in a CPG file, we need to set the driver options
# instead of forward slashes, we may use double backslahes in the paths (but this is a general behavior of R)
reservoirs <- read_sf("geodata\\dib_A05_Vodni_nadrze\\A05_Vodni_nadrze.shp",
                      options = "ENCODING=WINDOWS-1250")

# the result is a tibble, but with a special geometry column
# observe also the header showing the crs and bounding box (x and y minima and maxima)
reservoirs

# we have also other possibilities of loading geodata
# e.g. the RCzechia package comes with functions for loading vector and raster geodata
# load e.g. the vector layer with polygons representing the 14 administrative regions in Czechia
regions <- RCzechia::kraje()

# but regions are not in a tibble type
regions |> 
  class()

# this is how to convert to a tibble and then to a sf
regions <- regions |> 
  as_tibble() |> 
  st_sf()

# for next analyses, let us demonstrate how to transform from one to another crs
regions <- regions |> 
  st_transform("EPSG:32633") # but in case of EPSG codes, the number suffices (otherwise, it is advisable to use strings in the form 'authority:number'; e.g. 'ESRI:54024' for the Bonne projection)

# there is also a different function st_as_sf() through which we can create point vector layers from known coordinates stored in a table
tab_geog <- tab |> 
  st_as_sf(coords = c("UTM_X", "UTM_Y"),
           crs = 32633) # we know in advance we have this crs in the table

# for getting the attributes from one vector layer to another, based on spatial relationships, there is the st_join() function
?st_join

# by default, st_intersects() is applied as the option in st_join()
tab_geog <- tab_geog |> 
  st_join(regions |> 
            select(NAZ_CZNUTS3))

# using this tibble sf, we can create a boxplot visualization of catchment area variability conditioned by administrative regions
ggplot(data = tab_geog) +
  geom_boxplot(aes(y = NAZ_CZNUTS3,
                   x = log10(A), # some logarithm is necessary because of positive skewness of the catchment area distribution
                   fill = NAZ_CZNUTS3)) # but, usually, the color would be used for some other variable

# of course, labs() should also make the visualization better
# note that instead of log-transforming the catchment area, we could play around with the scale of the x-axis (see the package scales)

# by using ggplot2 functions, we can also create a static map
ggplot() + 
  geom_sf(data = regions,
          col = "purple",
          fill = NA) +
  geom_sf(data = tab_geog,
          col = "blue",
          size = 1.5)

# probably, the annotation functions from the package ggspatial work best in order to add a scale bar and a north arrow