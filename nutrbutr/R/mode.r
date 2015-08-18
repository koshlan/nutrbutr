#' find the mode of a vector
#' 
#' @param x a vector
#' @return a number the most common element of the vector
#' 
mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
