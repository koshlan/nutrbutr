# nutr A SpatialPolygonsDataFrame of all 2014 permitted agricultural plots in Kern County, CA
# The data includes crop cover classifications extracted from 
# 300 meter resolution raster data from 2007-2014
nutr <- readRDS("/Users/koshlan/Dropbox/KernCounty/nutrbutr_example_polygons.rds")
t <- sort(table(nutr@data[,c(22,28)])["75",], decreasing= T)[1:10]
d<- as.data.frame(cbind(names(t),rep("75A",10),t))
g<-graph.data.frame(d, directed=T)
plot(g)

sort(table(nutr@data[,c(28)]), decreasing = T)
sort(table(nutr@data[,c(22)]), decreasing = T)

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


