RequiredPackages <- c( # "Rtools",
  "renv", "remotes"
)
for (pkg in RequiredPackages) {
  if (!(pkg %in% rownames(installed.packages()))) {
    install.packages(pkg)
  }
}

# RequiredPakPackages <- c(#"Rtools",
#   "remotes")
# for (pkg in RequiredPackages) {
#   if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
# }

# This will need to be updated if you update R or switch OSs


rm(RequiredPackages)

# remotes::install_github("rkabacoff/qacDR")

# renv::restore()


# I am not coding this in base R and you cannot make me
library(tidyverse)
library(tidymodels)


# This beeps when stuff is done so I can do other stuff instead of babysitting my code
library(beepr)

# This is for good luck
library(fortunes)

# Api calls
# library(httr)
# library(jsonlite)

### Time Series Related Libraries

# for forecasting from Forecasting Principles
library(fpp3)

# This is for one of the models in fable
library(seasonal)

# These are for easier ML forecasting
# library(modeltime)
# library(timetk)
# library(finetune)
# library(tidymodels)

# These are for the tidy modeling /  modeltime
# library(h2o)
# library(modeltime)
# library(timetk)
# library(lubridate)
# library(poissonreg)
# library(rules)
# library(discrim)
# library(baguette)
#
# # This is to explain models
# library(DALEX)

# library(modeltime.h2o)

# DevOps Related Libraries

# This is for more easily saving models and versioning data, still haven't decided if it's the best.
library(pins)




# Geocoding
# library(zipcodeR)

# Graphing

# This is for maps
# library(sf)
# This is for interactive plots
library(plotly)

# This is for census data
library(tidycensus)

# This is for saving keys
# install.packages("pak")
# pak::pak("keyring")

# Misc

# this usually isn't used in the code, but for quick checks it's super useful (and less annoying if I have it preloaded)
library(qacBase)
# library(GGalley)
# This sets a seed so any randomized stuff is consistent. I don't know if I need this, but it's a good habit to just do it at the beginning of projects to be safe (for when you add stuff without thinking)
set.seed(1552)

# This gets the date for saving things later
CurrentDate <- as.character(Sys.Date())
startrun <- TRUE
