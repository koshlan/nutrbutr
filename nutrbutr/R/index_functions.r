# Choose a single column, make an index of elements matching a list of keys

#' @param df is a dataframe
#' @param variable is a column name
#' @param match is the value or list of values that if matched that the index should yield true
#' @return ind is a vector of booleans 
simple_index <- function(df,variable,match){
  ind <- (df[[variable]] %in% match)
}
# bar <- simple_index(nutr@data, "2014_CLASS", c(75))

# Choose multiple columns, make a multicolum index of elements match list of keys

#' @param df is a dataframe
#' @param variables is a vector of column name
#' @param match is the key or vector of keys that if matched that the index should yield true
#' @return matrix of booleans 
multi_column_index <- function(df,variables, match){
  m <- sapply(variables, function(x) simple_index(df,x,match)) 
}

#' Provide matrix or dataframe, return true if any element of column matches a 
#' vector of keys
#' @param m matrix or dataframe
#' @param match is the key or vector of keys that if matched that the index should yield true
#' @return ind a vector of booleans
index_if_any_across_columns <- function(m,match){
  ind = apply(m, 1, function(x, m) any(x %in% m), m = match)
}

#'  Find first occurance of a value rowwise
find_first_occurance_of_a_value_rowwise <- function(d, key){
  apply(d ,1, function(x) which(x==key)[1])
}

# TEST
T= data.frame(V1= c(1,2,3), V2 = c(1,2,3), V3= c(3,1,1))
apply(T ,1, function(x) which(x==3)[1])
find_first_occurance_of_a_value_rowwise(T,3)
# Should Return [1]  3 NA  1



