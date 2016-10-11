library(magrittr)
library(data.table)
library(dplyr)
library(dtplyr)
library(readr)

if (!file.exists("warnings/style/hyphens.tsv")){
  if (!dir.exists("warnings")){
    dir.create("warnings")
  }
  
  if (!dir.exists("warnings/style")){
    dir.create("warnings/style")
  }
  
  file.create("warnings/style/hyphens.tsv")
}

hyphen_checker <- function(lines){
  hyphen_warn_table <- 
    data.table(line_nos = seq_along(lines), 
               lines = lines) %>%
    mutate(tax_free_warn = grepl("tax\\s+free", lines, perl = TRUE, ignore.case = TRUE),
           tax_free_context = if_else(tax_free_warn, gsub("(\\b\\w+\\b)?\\stax\\s+free\\s+(\\b\\w+\\b)?", 
                                                          "\\1 tax free \\2",
                                                          lines, 
                                                          perl = TRUE, ignore.case = TRUE), 
                                      NA_character_),
           # ignore case = FALSE and [Hh] [Ll] because Low Income Tax Offset permitted
           highlow_income_warn = grepl("(([Hh]igh)|([Ll]ow))\\s+income\\b", lines, perl = TRUE, ignore.case = FALSE), 
           highlow_context = if_else(highlow_income_warn, gsub("^.*(\\b\\w+\\b)?\\s+((?:[Hh]igh)|(?:[Ll]ow))\\s+income\\b(\\w+\\b)?.*$", 
                                                               "\\1 \\2 income \\3",
                                                               lines, 
                                                               perl = TRUE, ignore.case = TRUE), 
                                      NA_character_), 
           carryfwd_warn = grepl("carry-forward", lines, perl = TRUE, ignore.case = TRUE),
           carryfwd_context = gsub("^.*(\\s[A-Za-z]+\\s+)?carry-forward\\s+([A-Za-z]+\\s)?.*$", 
                                   "\\1 carry foward \\2", 
                                   lines, 
                                   perl = TRUE, 
                                   ignore.case = TRUE),
           
           TYPE = if_else(tax_free_warn, "Tax free", 
                          if_else(highlow_income_warn, "high/low income", 
                                  if_else(carryfwd_warn, "carry forward",
                                          NA_character_)))
           ) %>%
    # http://stackoverflow.com/questions/39237123/combine-column-with-nas?noredirect=1&lq=1
    mutate(CONTEXT = coalesce(tax_free_context, highlow_context, carryfwd_context)) %>%
    filter(tax_free_warn | highlow_income_warn | carryfwd_warn) %>%
    select(line_nos, TYPE, CONTEXT, full_line = lines) 
  
  write_tsv(hyphen_warn_table, path = "warnings/style/hyphens.tsv")
}

file.create("warnings/style/consecutive-words.txt")

consecutive_words <- function(pdffilename){
  origwd <- getwd()
  tryCatch({
    file.remove(file.path("warnings", "style", pdffilename))
    file.copy(pdffilename, file.path("warnings", "style", pdffilename))
    setwd("warnings/style")
    system(paste0("pdftotext -layout ", pdffilename))
    
    typeset_lines <- 
      readLines(gsub(".pdf", ".txt", pdffilename, fixed = TRUE))
    
    bad_lines <- 
      typeset_lines[
        # :punct: for post-tax etc
        gsub("^([A-Za-z-])+\\s.*$", "\\1", typeset_lines) == gsub("^([A-Za-z-])+\\s.*$", "\\1", lag(typeset_lines, default = "x")) |
          # Second column appears on same line
          gsub("^.*\\s{5,}([A-Za-z-])+\\s.*$", "\\1", typeset_lines) == gsub("^.*\\s{5,}([A-Za-z-])+\\s.*$", "\\1", lag(typeset_lines, default = "x")) | 
          gsub("^(\\w|[[:punct:]])+\\s.*$", "\\1", typeset_lines) == gsub("^([A-Za-z-])+\\s.*$", "\\1", lag(typeset_lines, n = 2,  default = "x")) | 
          gsub("^.*\\s{5,}([A-Za-z-])+\\s.*$", "\\1", typeset_lines) == gsub("^.*\\s{5,}([A-Za-z-])+\\s.*$", "\\1", lag(typeset_lines, n = 2, default = "x"))
        ]
    
    writeLines(bad_lines, "consecutive-words.txt")
  }, 
  
  finally = setwd(origwd))
}



style_checker <- function(filename){
  lines <- readLines(filename)
  hyphen_checker(lines)
}