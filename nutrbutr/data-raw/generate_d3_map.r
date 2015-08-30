# Generate Simple Map for D3
# Helpful links
# http://bl.ocks.org/darrenjaworski/5874214
# http://recology.info/2015/01/geojson-topojson-io/

# The goal is to prepare any shapefile for use with D3.

# Here we go. 
filename = "/Users/koshlan/Dropbox/KernCounty/kern2014/kern2014.shp"
kern_boundaries <- maptools::readShapePoly(filename)
string = "+proj=lcc +lat_1=34.03333333333333 +lat_2=35.46666666666667 +lat_0=33.5 +lon_0=-118 +x_0=2000000 +y_0=500000.0000000002 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192"
sp::proj4string(kern_boundaries) <- CRS(string)
# This is pretty complicated so lets make a simplified version for now
kern200 <- kern_boundaries[kern_boundaries$ACRES > 200 ,]
# The projection is non-standard
sp::transform()
