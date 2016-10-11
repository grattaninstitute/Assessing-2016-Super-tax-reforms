
separate_sentences <- function(filename){
  library(dplyr)
  lines <- readLines(filename)
  
  knitr_start <- grepl(">>=", lines, fixed = TRUE)
  knitr_stop <- grepl("^@$", lines, perl = TRUE)
  
  stopifnot(length(knitr_start) == length(knitr_stop))
  
  in_knitr <- as.logical(cumsum(knitr_start) - cumsum(knitr_stop))
  
  if_else(in_knitr, lines, 
          gsub(".\\footnote", ".%\n\\footnote", fixed = TRUE,
               gsub("\\.\\s+([A-Z])", "\\.\n\\1", lines, perl = TRUE))) %>%
    writeLines(filename)
}