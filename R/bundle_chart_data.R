if (requireNamespace("xlsx") && requireNamespace("readr")){
  library(readr)
  library(xlsx)
  
  bundle_chart_data <- function(){
    charts <- list.files(path = "atlas/", pattern = "csv", full.names = TRUE)
    
    get_create_time <- function(file){
      file.info(file)$ctime
    }
    
    figure_numbers <- 
      charts %>%
      lapply(get_create_time) %>%
      unlist %>%
      order
    
    max_width <- 
      charts %>%
      lapply(read_csv) %>%
      lapply(ncol) %>%
      unlist %>%
      max
    
    wb <- createWorkbook()
    headerStyle <- CellStyle(wb) + Font(wb, isBold=TRUE) + Border()
    
    for (cc in seq_along(charts[figure_numbers])){
      base_name <-gsub("\\.csv$", "", (charts[figure_numbers])[[cc]])
      the_png <- paste0(base_name, "-1.png")
      the_csv <- paste0(base_name, ".csv")
      the_sheet <- createSheet(wb, paste0("Figure ", cc, " ", gsub("atlas/", "", base_name)))
      addDataFrame(read_csv(the_csv), sheet = the_sheet, row.names = TRUE, colnamesStyle = headerStyle)
      addPicture(the_png, sheet = the_sheet, startRow = 2, startColumn = max_width + 2, scale = 0.33)
    }
    saveWorkbook(wb, file = "atlas/bundled-chart-data-with-pictures.xlsx")
    
    name_sheets_as_Figure <- function(list){
      names(list) <- paste("Figure", seq_along(list))
      list
    }
    
    charts[figure_numbers] %>%
      lapply(read_csv) %>%
      name_sheets_as_Figure %>%
      openxlsx::write.xlsx("atlas/bundled-chart-data.xlsx")
  }
} else {
  message("Unable to bundle chart data due to absence of 'xlsx' package")
  bundle_chart_data <- function() NULL
}