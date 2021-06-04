#' Get csv file from OSF
#'
#' This function gets CSV file from OSF using httr GET method.
#'
#' @param address OSF address code () to be retrieved. Works for CSV files.
#' @param filename Filename (optional)
#' @return data
#' @import httr

get_OSF_csv <- function(address = NULL, filename = NULL) {
  
  GET <- write_disk <- NULL
  # patch together the address
  combined_address <-
    paste0('https://osf.io/', address, '/?action=download')
  
  # create a temporary filename if needed
  if (!is.null(filename)) {
    fn <- filename
  } else {
    fn <- tempfile()
  }
  
  # get the file using httr GET method
  invisible(GET(combined_address, write_disk(fn, overwrite = TRUE)))
  
  # read data
  data <- read.csv(fn, header = T, sep = ",")
  
  return <- data
  
}