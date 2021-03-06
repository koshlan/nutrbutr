#' evaluate raster values contained within polygons
#' 
#' @depends raster
#' @param raster_input a raster object
#' @param polygon_input a SpatialPolygonsDataFrame object
#' @param task a function to peform on the many raster values
#' @return the list of values associated with the function operated on the raster contents of each polygon
#' 
#' 
evaluate_polygon_contents <- function(raster_input,polygon_input, task = raster::modal){
  if (is.na(proj4string(raster_input))){
    stop("No projection specified for raster input")
  }
  if (is.na(proj4string(polygon_input))){
    stop("No projection specified for polygon input")
  }
  if ( proj4string(polygon_input) != proj4string(raster_input) ){
    stop("The projection differs between the raster and polygon inputs")
  }
  V <- raster::extract(raster_input, polygon_input, fun = task)
  #V.task <- unlist(lapply(V,function(x) if (!is.null(x)) task(x) else NA))
  return(as.vector(V))
}

# Evaluating Polygon Contents in chunks to avoid memory overload
#' 
#' @depends raster
#' @param raster_object a raster object
#' @param SpPolyDF a SpatialPolygonsDataFrame object
#' @param breaks the number of chunks in which to process the operation
#' @return storage a vector values generated by running evaluate_polygon_contents
#' 
evaluate_polygon_contents_by_chunks <- function(raster_input,polygon_input, chunk_size = n, task = raster::modal){
  n = dim(polygon_input)[1] 
  # Check the dimension of the of teh SpatialPolygonDataFrame, 
  #note R's lazy evaluation defaults to a single chunk 
  x = 1:n # Create and index
  x = split(x, ceiling(seq_along(x)/chunk_size)) # Split that index into a set of subindex
  storage = c() # initiatlize a storage vector
  for (i in x){
    message(paste("evaluating polygons starting with", i[1]))
    partial_results = evaluate_polygon_contents(raster_input = raster_input, 
                                                polygon_input = polygon_input[i ,], 
                                                task = task)
    storage <- c(storage, partial_results)
  } 
  return(storage)
}

