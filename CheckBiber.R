if (any(grepl("WARN", readLines("Assessing-the-2016-super-tax-reforms.blg")) && !grepl("2000--2015", readLines("Assessing-the-2016-super-tax-reforms.blg"))))
  stop("biber emitted warnings.")
