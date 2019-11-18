##################################################
## Project: Lab 7 - Programming in R 
## Script purpose:Linear Regression
## Date: 10/29/19
## Author: Hudson Chase
##################################################

#roads libary
library("tigris")
#Fed Data
library("FedData")
library("raster")
library("rgeos")
library("rgdal")


setwd("C:/R_Class/logisticR")

loudoun1992 <- raster("loudoun1992.tif")
loudoun2001 <- raster("loudoun2001.tif")

plot(loudoun1992)
plot(loudoun2001)

roads <- tigris::primary_secondary_roads("Virginia", 2011)


studyCRS <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23
+lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m
+no_defs +ellps=GRS80 +towgs84=0,0,0" 
  
NED <- FedData::get_ned(template = loudoun1992,
                        label = "Elev")

NEDProj <- projectRaster(NED, loudoun1992, res=30)

NEDProj <- raster::mask(NEDProj,loudoun1992)
plot(NEDProj)

RoadRas <- spTransform(roads,crs(loudoun1992))
RoadRas <- crop(RoadRas, loudoun1992)
data <- RoadRas@data
data <- data.frame(data, newid =1)
RoadRas@data <- data
RoadRaster <- rasterize(RoadRas,loudoun1992, field=RoadRas$newid)
plot(RoadRaster)

slope <- terrain(NEDProj, opt="slope", unit = "degrees")
plot(slope)

# from class 1(forest) to class 2(urban)
# formula >>> LC1992 x 10 + LC2000 --- 12 value is forest to urban

test <- loudoun1992*10+loudoun2001
m <- c(1,11, 0, 11,12, 1, 12, 80, NA)
rclmat <- matrix(m, ncol = 3, byrow= TRUE)
rc <- reclassify(test,rclmat, na.rm=T)
plot(rc)

dist <- distance(RoadRaster)

samp_loc <- sampleRandom(rc, 50000, na.rm=T, asRaster= T)

rasstack <- stack(rc, NEDProj, slope, dist, samp_loc)
df <- as.data.frame(rasstack)
colnames(df)<- c('y', 'elev', 'slope', 'dist', 'slocation')
dfsub <- df[!is.na(df$slocation),]
dfsub <- dfsub[!is.na(dfsub$slope),]

write.csv(dfsub, "C:/R_Class/logisticR/alldata.csv", row.names = FALSE)

alldata <- read.csv(file="alldata.csv", header=TRUE, sep=",")

glm<-glm(formula = y ~ elev + slope + dist, family = "binomial",  data = alldata)
summary(glm)

probRast <- exp(1.439e+00 + -1.283e-02*NEDProj + -1.798e-01*slope + -8.502e-04*dist)/(1+exp(1.439e+00 + -1.283e-02*NEDProj + -1.798e-01*slope + -8.502e-04*dist))

probmask <- mask(probRast,rc)