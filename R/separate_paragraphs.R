
separate_paragraphs <- function(filename){
  lines <- readLines(filename)
  writeLines(paste0(lines, "\n"), filename)
}