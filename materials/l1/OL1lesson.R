####
# R and Python in Geosciences (2024)
# lesson: Intro to R and RStudio
# author: O. Ledvinka
# date: 2024-02-20
####
sadas
# This is only the script we created during the first lesson
# Please, read the OL1lesson.html document for completeness!

# we demonstrated how to make the R script structure better by sectioning
# to create the sections, we use the keyboard shortcut CTRL + SHIFT + R
# also, we will use the new pipe operator |> instead of the old pipe operator %>% that still can be found in internet fora and in some function help pages
# to use the shortcut CTRL + SHIFT + M for new pipe, we need to switch in Tool/Global Options...


# Beginning ---------------------------------------------------------------

# after we have installed the xfun package, we can load other packages and optionally install them as follows

xfun::pkg_attach("tidyverse",
                 "readxl",
                 "writexl",
                 install = T)

# however, the best way of installing packages is using the respective buttons in the RStudio tab Packages

# programmatically, installing packages with their dependencies may be done as follows

install.packages("xfun",
                 depend = T)

# sometimes, we need also to update the packages programatically

update.packages()

# installation of packages that are not on CRAN but are e.g. on GitHub may be performed as follows

remotes::install_github("yonghah/esri2sf") # of course, we need the package remotes installed

# if we do not know the function our friend uses in his/her advanced code, we can study the help page by pressing F1 or employing the question mark operator before the function name

?pkg_attach

# if we do not know the name of the function, it may be helpful to use the double question mark operator
# this works only with functions of packages we have installed

??'linear models'

# in addition, the function sos::findFn() may be extremely helpful when looking for the expression throughout the help pages

# library() loads the packages one by one (no quotes needed) after installing them

library(sos)

# by using findFn(), we can find if there is a package with a function we would need

findFn("{pycnophylactic interpolation}")

# yet, there is another approach to load only selected functions from the packages

import::from(sos, findFn) # of course, the import package must be installed

# pay attention to the warnings thrown by R
# we have over 20k packages on CRAN now and the function names may be the same, eve though they do totally different job and expect different arguments

library(terra)

# there is a function extract() in the tidyr package (part of tidyverse) that is masked by the terra::extract() function


# Middle ------------------------------------------------------------------

# creating vectors (here by assigning to the name vec - see what happened in the Environment)

vec <- c(1, 2, 3)

# demonstrating object classes and pipes (when a chain of functions is applied to the same objects)
# we can select only a part of the code before the pipe and run it (as usual, by pressing CTRL + ENTER) to observe what is returned in the console

vec |> 
  class() |> 
  length() |> 
  sqrt()

# studying object classes is very important because the other functions expect only some classes as inputs

vec2 <- seq(from = 1,
            to = 10,
            by = 1)

# class() as well as str() and dplyr::glipmse() may be used for studying such details

vec2 |> 
  as.integer() |> 
  class()

vec2 |> 
  glimpse()

vec2 |> 
  str()

# vectors may compose a table (i.e. data frames in terms of base R or tibbles in terms of the tidyverse approach)
# we can name the columns and create the vectors inside other functions (here tibble::tibble())
# otherwise, table columns take the names of vectors

tab <- tibble(one = vec2,
              two = 10:1)

# we already met as.integer(), but there are many other similar functions whose purpose is to transform from one class to another

as.character(vec2) # notice the quotes surrounding the strings (vector may look as numeric or integer, but is character)

as.character(vec2) |> 
  is.character()

# we have reserved letters for missing values - NA (meaning Not Available)

vec3 <- c(1, NA, NA)

# since TRUEs may be terated as ones and FALSEs as zeros, we apply the function sum() to find the number of missing values

vec3 |> 
  is.na() |> 
  sum()

# similar to NAs, we may also run into infinities - Inf (or -Inf)
# we have also NaNs in R (meaning Not a Number; emerge e.g. after dividing zeros by zeros)

vec4 <- c(-Inf, vec3)

vec4 |> 
  is.infinite()

is.nan(0 / 0)

# we can combine the questions, e.g. by & (meaning 'and'; i.e. intersection) or by | (meaning 'or'; i.e. union)

is.infinite(vec4) | is.na(vec4)

is.infinite(vec4) & is.na(vec4)

# exclamation mark means negation

!(is.infinite(vec4) | is.na(vec4))


# End ---------------------------------------------------------------------

# extracting elements of vectors, tables and lists; square brackets, dollar sign

# based on positive integers (negative remove those elements)

vec4[1]

vec4[1:2]

vec4[c(1, 4)]

# based on logical vectors

vec4[c(T, T, F, F)]

# in case of tables, it is good to specify the row index and column index (separated by comma)
# be careful regarding different behaviour of tibbles and data frames when subsetting the elements by square brackets

tab[1, 1]

tab[1, ]

tab[, 1]

tab[1, 1] |> 
  class()

as.data.frame(tab)[1, 1] |> 
  class()

# or, we can combine the dollar sign and square brackets

tab$one[1] |> 
  class()

# list creation (elements may be objects of a different class and type)

lst <- list(vec4 = vec4,
            tab = tab)

# when using the dollar operator, there must be names elements in the list

lst$vec4 |> 
  class()

# here, we have different results when applying simple square brackets vs. double square brackets

lst[1] |> 
  class()

lst[[1]] |> 
  class()
