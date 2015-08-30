require(rgdal)
spToGeoJSON <- function(x){
  # Return sp spatial object as geojson by writing a temporary file.
  # It seems the only way to convert sp objects to geojson is 
  # to write a file with OGCGeoJSON driver and read the file back in.
  # The R process must be allowed to write and delete temporoary files.
  #tf<-tempfile('tmp',fileext = '.geojson')
  tf<-tempfile()
  writeOGR(x, tf,layer = "geojson", driver = "GeoJSON")
  js <- paste(readLines(tf), collapse=" ")
  file.remove(tf)
  return(js)
}
js <- spToGeoJSON(kern_timeseries[1:8025,1:2])
require(RJSONIO)
write(js, "~/Desktop/kerntest.json")
plot(kern_timeseries[1: ,])

require(maptools)
filename = "/Users/koshlan/Dropbox/KernCounty/cb_2013_us_state_20m/cb_2013_us_state_20m.shp"
states <- readShapePoly(filename, proj4string=CRS("+proj=longlat"))
par(mfrow = c(1,1))
plot(states[1:5,])
js <- spToGeoJSON(states[1,])
require(RJSONIO)
write(js, "~/Desktop/kerntest.json")
plot(states[1,])
