#' Function to provide help to users 
#' who might not know how to respond to R/knitr
#' error messages. 
#' 
#' Nested if statements are used in order to 
#' supply one and only one error message, if required.

portability <- function(){
  if (!requireNamespace("taxstats", quietly = TRUE)) {
    install.packages("taxstats", type = "source", repos = "https://hughparsonage.github.io/drat/")
  }
  
  if (!requireNamespace("dplyr", quietly = TRUE) || packageVersion("dplyr") != package_version("0.5.0")) {
    devtools::install_version("dplyr", version = 0.5.0", repos = "http://cran.us.r-project.org")
  }
  
  requiredPackages <- c("assertthat", "bitops", "chron", "colorspace", "cowplot", "crayon", 
                        "data.table", "DBI", "devtools", "digest", "dplyr", "dtplyr", 
                        "forecast", "fracdiff", "ggplot2", "grattan", "gridExtra", "gtable", 
                        "knitr", "labeling", "lattice", "lazyeval", "lubridate", "magrittr", 
                        "memoise", "munsell", "nnet", "plyr", "quadprog", "R6", "Rcpp", 
                        "RCurl", "readr", "readxl", "reshape2", "rsconnect", "rsdmx", 
                        "rstudioapi", "scales", "showtext", "showtextdb", "stringi", 
                        "stringr", "sysfonts", "taxstats", "testthat", "tibble", "tidyr", 
                        "timeDate", "tseries", "withr", "XML", "xtable", "zoo")
  
  PackagesRequiredByUser <- setdiff(requiredPackages, installed.packages())
  
  if (Sys.getenv("CI") == "true" && Sys.getenv("TRAVIS") == "true") {
    if (length(PackagesRequiredByUser) != 0){
      install.packages(c("assertthat", "bitops", "chron", "colorspace", "cowplot", "crayon", 
                         "data.table", "DBI", "devtools", "digest", "dplyr", "dtplyr", 
                         "forecast", "fracdiff", "ggplot2", "grattan", "gridExtra", "gtable", 
                         "knitr", "labeling", "lattice", "lazyeval", "lubridate", "magrittr", 
                         "memoise", "munsell", "nnet", "plyr", "quadprog", "R6", "Rcpp", 
                         "RCurl", "readr", "readxl", "reshape2", "rsconnect", "rsdmx", 
                         "rstudioapi", "scales", "showtext", "showtextdb", "stringi", 
                         "stringr", "sysfonts", "testthat", "tibble", "tidyr", 
                         "timeDate", "tseries", "withr", "XML", "xtable", "zoo"))
      devtools::install_github(c("hughparsonage/grattan", "hughparsonage/taxstats"))
    }
    
  }
  
  if (length(PackagesRequiredByUser) == 0){
    if (packageVersion("grattan") >= package_version("0.3.0.8")){
      # break out and start compilation
      return(invisible(NULL))
    } else {
      stop("Your grattan package is out-of-date.", "\n", 
           "Please run", "\n\t", 
           "devtools::install_github('hughparsonage/grattan')")
    }
  } else {
    HughPackagesRequired <- intersect(PackagesRequiredByUser, c("taxstats", "grattan"))
    OtherPackages <- deparse(dput(setdiff(PackagesRequiredByUser, HughPackagesRequired)))
    
    if (length(HughPackagesRequired) == 0L){
      stop("You need to install additional packages to compile this document.", "\n", 
           "Please enter", "\n", 
           "install.packages(", OtherPackages, ")", "\n",
           "in your console.")
    } else {
      if (length(HughPackagesRequired) == 1L){
        if (length(PackagesRequiredByUser) == 1L){
          if ("taxstats" == PackagesRequiredByUser){
            stop("The taxstats package is required. ",  
                 "Please run the following line in your console and try again. ", "\n\t", 
                 "devtools::install_github('hughparsonage/taxstats')", "\n", 
                 "Note that this package is > 250MB")
          } else {
            stop("The grattan package is required. ", "Please run the following line in your console and try again.", "\n\t", 
                 "devtools::install_github('hughparsonage/grattan')")
          }
        } else {
          stop("You need to install additional packages to compile this document.", "Please run the following line in your console and try again.", "\n\t", 
               "install.packages(", OtherPackages, "); devtools:install_github('hughparsonage/", HughPackagesRequired, "')", "\n",
               "in your console.")
        }
      } else {
        if (length(HughPackagesRequired) == 2L){ 
          # Next most plausible option
          if (length(PackagesRequiredByUser) == 2L){
            stop("The taxstats and grattan packages are required. ", "Please run the following line in your console and try again.", "\n\t",  "\n\t", 
                 "devtools::install_github(c('hughparsonage/taxstats', 'hughparsonage/grattan')")
          } else {
            stop("Additional packages are required. ", "Please run the following line in your console and try again.", "\n\t",  "\n\t", 
                 "install.packages(", OtherPackages, ");", "devtools::install_github(c('hughparsonage/taxstats', 'hughparsonage/grattan')")
          }
        }
      }
    }
    
  }
  
}
