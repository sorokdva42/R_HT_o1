####
# R and Python in Geosciences (2024)
# lesson: Tidyverse fundamentals
# author: O. Ledvinka
# date: 2024-04-09
####

# This is only the script we created during the second lesson
# Please, read the OL2lesson.html document for completeness!

# We assume we are working withing the R project we established during our first lesson
# Therefore, we are able to use relative paths and other advantages of using R projects

# loading of the most important set of packages under core tidyverse
library(tidyverse)
setwd("C:/R_scripts/R_HT_o1/materials/l2")
# again, we load the RDS file with metadata that we saved from Classroom during previous lesson to the project subfolder
# there is no need to respect the case of letters within the quotes defining the path to the file
tab <- read_rds("qdmeta2023.rds")

# we also demonstrated loading of another file, this time with discharge time series
# this file is uploaded to the Classroom (OL2 lesson)
# loading takes longer since this is a huge table
qd <- read_rds("QDdata2023_gzipped.rds")

# what is the class of just loaded object?
qd |>  
  class()

# observe the advantages of printing this sort of data frames (tibbles)
qd

# we are going to demonstrate the functions pivot_wider() and pivot_longer()
# please, forget about using melt() and other old-fashioned functions()

# excuse this usage of the unknown function select(), we will come to it again
# this is just for the demonstration; we want to use only two columns
# since R does not like numbers at the beginnings of column names, it is advisable to use prefixes if we create column names from a column composed of numbers (or something which resembles them)
tab_wide <- tab |>
  select(ID, A) |> 
  pivot_wider(names_from = ID,
             values_from = A,
             names_prefix = "st_")

# we have one-row wide table now
# sometimes it is necessary to have such tables for further processing
tab_wide

# we are going back to a long form of the table
tab_long <- tab_wide |> 
  pivot_longer(cols = 1:ncol(tab_wide),
               names_to = "id",
               values_to = "val_num")

tab_long

# we can, again, specify the prefix to get rid of it in the first column
tab_long <- tab_wide |> 
  pivot_longer(cols = 1:ncol(tab_wide), # if we are lazy and do not want to read the number of columns, we use the ncol() function
               names_to = "id", # quotes are needed here! (may be simple instead of double)
               values_to = "val_num", # this way, we can make up our own names of new columns instead of the default names
               names_prefix = "st_")

tab_long

# now to the selection of columns again
# if we are interested in a small number of columns, we can name them within the select() function
tab |>
  select(ID, A)

# however, negation is sometimes more practical to get rid of unnecessary columns
# negation is indicated by a minus sign or by the exclamation mark (!)
# ranges are allowed even if we are working with the names of columns
# we can also create vectors of column names by using the c() function
tab |> 
  select(-c(BRANCH, UTM_X:UTM_Y, SOUV))

# renaming is also allowed during selection
# equality sign separates new names on the left and old names on the right
# case sensitivity applies here
tab |> 
  select(id = ID,
         st = STATION,
         river = RIVER,
         branch = BRANCH)

# we can also select based on indices and their ranges defined by a colon
tab |> 
  select(1:3)

# if there are lots of columns, the colnames() function may help
colnames(tab)

colnames(tab_wide)

# for getting the subsets of rows, the filter() function is recommended
# it requires logical vectors being created by various questions within round brackets after the function name
# in the next, only rows containing the string "Labe" in the RIVER column remain
# nrow() finds the number of gauges located on the Labe River
tab |> 
  filter(RIVER == "Labe") |> 
  nrow()

# if we want to include also Male Labe, we do it in different ways
# either by using the 'or' sign
tab |> 
  filter(RIVER == "Labe" | RIVER == "Malé Labe")

# or by using a vector into which the column names should fall
tab |> 
  filter(RIVER %in% c("Labe", "Malé Labe"))

# negation may be indicated by the exclamation mark
tab |> 
  filter(RIVER != "Labe")

# of course, other combined questions are allowed
# note that & may be substituted by a comma
# also, the between() function exists, in which we must specify the column and ranges separated by a comma
# here, we get catchments of gauges located on the Labe River whose areas are between 10000 and 30000 km2
tab |> 
  filter(RIVER == "Labe",
         between(A, 10000, 30000))

# we can use several helper functions together with select()

# starts_with()

# ends_with()

# contains()

# matches() is a more general helper function, and it can be used instead of the three above-mentioned functions if one knows regular expressions

# we can even combine the exact selection and the approximate selection
tab |> 
  select(ID, starts_with("UTM"))

tab |> 
  select(ID, ends_with("NK"))

tab |> 
  select(ID, contains("A"))

# in regular expressions, ^ says that the string must start with something, $ says that the string must end with something, and the vertical bar means 'or'
tab |> 
  select(ID, matches("^UTM|NK$"))

# for filtering, str_detect() may be considered a helper function that uses regular expressions
# let us find how many gauges that are maintained by the CHMI regional office whose abbreviation starts with 'H' do not IDs starting with zero
# there is also the negate argument in str_detect()
tab |> 
  filter(str_detect(BRANCH, "^H"),
         str_detect(ID, "^0", negate = T))

# since the slice() function uses row indices, it is not much practical
tab |> 
  slice(100:105)

# however, its variants may be useful in finding extremes, and especially when it comes to grouping (shown later)
tab |> 
  slice_max(n = 5,
            order_by = A)

tab |> 
  slice_min(n = 10,
          order_by = A)

# so, there must be a function used for arranging
# by default, the arrange function() uses the ascending order
tab |> 
  arrange(A)

# if we want to have the table arranged in descending order (according to some column or columns)
tab |> 
  arrange(-A) # works for numeric columns only!

# this works for every type
tab |> 
  arrange(desc(A))

# we can combine
tab |> 
  arrange(desc(A), UTM_X)

# here, an error occurs, because we are trying to arrange a character-string vector
tab |> 
  arrange(-RIVER)

# but this works
tab |> 
  arrange(desc(RIVER))

# distinct() function may be used to find the number of distinct rivers with a gauge
tab |> 
  distinct(RIVER)

# if there is no column selected, distinct() works with all columns
tab |> 
  distinct()

# using the combination of group_by() and mutate() function, we can compute so-called z-scores from the catchment area
# here, we are grouping by the CHMI regional office and placing the new column after the A columns
# kindly study further arguments of the mutate() function
# note also that we can create new grouping variables within the group_by() function and that there is also the ungroup() function
tab |> 
  group_by(BRANCH) |> 
  mutate(A_zscores = (A - mean(A)) / sd(A),
         .after = A)

# mutate() also modifies existing columns, and we may modify multiple column at once using the anonymous function (also called lambda)
# columns are modified if we use the names of the original ones, as it is also the case of anonymous functions by default
# suppose, for instance, we want to convert the UTM coordinates to string and then replace the decimal dot with comma
# pipes can be used within the functions as well
# as the dot is the reserved symbol, we need to escape it by a double backslash!
tab |> 
  mutate(across(matches("^UTM"), \(x) as.character(x) |> 
                  str_replace("\\.", ",")))

# this is for replacing all occurrences (if there were some)
tab |> 
  mutate(across(matches("^UTM"), \(x) as.character(x) |> 
                  str_replace_all("\\.", ",")))

# grouping is frequently used when summarizing using the summarize() function
# this way, we can compute the mean, median and coefficient of variation from catchment area, grouped by the CHMI regional offices
tab |> 
  group_by(branch = BRANCH) |> 
  summarize(mean = mean(A),
            median = median(A),
            cv = sd(A) / mean(A))
