# Raw code for generating 
# "./data/Kern_2014_major_plots_timeseries.rds")
#s "./data/Kern_2014_major_plots_timeseries.Rda")


require(raster)
require(sp)
devtools::load_all() # need nutrbutr functions

kern2014fn <- "/Users/koshlan/Dropbox/KernCounty/CDL_2014_06029.tif"
kern2013fn <- "/Users/koshlan/Dropbox/KernCounty/CDL_2013_06029.tif"
kern2012fn <- "/Users/koshlan/Dropbox/KernCounty/CDL_2012_06029.tif"
kern2011fn <- "/Users/koshlan/Dropbox/KernCounty/CDL_2011_06029.tif"
kern2010fn <- "/Users/koshlan/Dropbox/KernCounty/CDL_2010_06029.tif"
kern2009fn <- "/Users/koshlan/Dropbox/KernCounty/CDL_2009_06029.tif"
kern2008fn <- "/Users/koshlan/Dropbox/KernCounty/CDL_2008_06029.tif"
kern2007fn <- "/Users/koshlan/Dropbox/KernCounty/CDL_2007_06029.tif"
# Filenames are placed in a list
filenames <- c(kern2014fn, kern2013fn, kern2012fn,
               kern2011fn, kern2010fn, kern2009fn,
               kern2008fn, kern2007fn)

# This code prepares my boundaries object, alligns coordinate systems, and 
# focusing only on major plots of over 50 Acres.
filename = "/Users/koshlan/Dropbox/KernCounty/kern2014/kern2014.shp"
kern_boundaries <- maptools::readShapePoly(filename)
string = "+proj=lcc +lat_1=34.03333333333333 +lat_2=35.46666666666667 +lat_0=33.5 +lon_0=-118 +x_0=2000000 +y_0=500000.0000000002 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192"
sp::proj4string(kern_boundaries) <- CRS(string)

filename = "/Users/koshlan/Dropbox/KernCounty/CDL_2014_06029.tif"
kern2014 <- raster(filename)
kern_boundaries.t <- sp::spTransform(kern_boundaries, proj4string(kern2014))
kern.boundaries.t.major <- kern_boundaries.t[kern_boundaries.t$ACRES > 50 ,]

# Initialized a List to contain the final summary values
final_contents <- list()

for (f in filenames){
  # Load The Geotiff 
  message(f)
  raster_object <- raster(f)
  # Aggregate pixels to lower resolution (30m to 300m)
  low_res <-raster::aggregate(raster_object,10,modal)
  saveRDS(low_res, paste(f,".low_res.rds", sep = ""))
  # Then in chunks of 100, Run Opperation to Discover What is in each 2014 boundary
  contents  <- nutrbutr::evaluate_polygon_contents_by_chunks(low_res,kern.boundaries.t.major, 500)
  saveRDS(contents, paste(f,".contents.rds", sep = ""))
  final_contents[[f]] <- contents
}
# Then we can add this to the @data slot of our original polygons object 
# and save it for further analysis.
kern.boundaries.t.major@data <- cbind(kern.boundaries.t.major@data, final_contents)

saveRDS(kern.boundaries.t.major, "/Users/koshlan/Dropbox/KernCounty/examined_polygons.rds")
saveRDS(kern.boundaries.t.major, "./data/Kern_2014_major_plots_timeseries.rds")
save(kern.boundaries.t.major, file="./data/Kern_2014_major_plots_timeseries.Rda")
