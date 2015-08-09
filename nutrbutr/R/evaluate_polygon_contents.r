#' evaluate raster values contained within polygons
#' 
#' @depends raster
#' @param raster_input a raster object
#' @param polygon_input a SpatialPolygonsDataFrame object
#' @param task a function to peform on the many raster values
#' @return the list of values associated with the function operated on the raster contents of each polygon
#' 
#' 
evaluate_polygon_contents <- function(raster_input,polygon_input, task = mean){
  if (is.na(proj4string(raster_input))){
    stop("No projection specified for raster input")
  }
  if (is.na(proj4string(polygon_input))){
    stop("No projection specified for polygon input")
  }
  if ( proj4string(polygon_input) != proj4string(raster_input) ){
    stop("The projection differs between the raster and polygon inputs")
  }
  V <- raster::extract(raster_input, polygon_input)
  V.task <- unlist(lapply(V,function(x) if (!is.null(x)) task(x) else NA))
  return(V.task)
}