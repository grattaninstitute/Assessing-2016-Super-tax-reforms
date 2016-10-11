

diff_word_files <- function(file1, file2, difffile = "difffile.tex"){
  
  file1.tex <- gsub("\\.docx$", ".tex", file1, perl = TRUE)
  file2.tex <- gsub("\\.docx$", ".tex", file2, perl = TRUE)
  system(paste("pandoc", "-s", file1, "-o", file1.tex))
  system(paste("pandoc", "-s", file2, "-o", file2.tex))
  
  system(paste("latexdiff", file1.tex, file2.tex, ">", difffile))
  
  system(paste("pdflatex -interaction=batchmode", difffile))
}