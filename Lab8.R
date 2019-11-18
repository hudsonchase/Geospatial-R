##################################################
## Project: Lab 8 - Programming in R 
## Script purpose: SWAT Lab
## Date: 11/7/19
## Author: Hudson Chase
##################################################

library("raster")
library("rgdal")
library("prism")
library("rgeos")
library("spatialEco")

setwd("C:/R_Class/Rswat/inputdata")

DEM <- raster("dem.tif")
NLCD <- raster("nlcd2001.tif")
watersheds <- readOGR("watersheds.shp")

#FTTP prism data
mydates <- c('2001/1/1', '2003/12/30')
dailyppt <- download.prism('ppt', mydates, time.step = "daily",
                            download.folder = getwd(), by.year = TRUE,
                            ftp.site = "ftp://prism.oregonstate.edu")

daily

#create folder for each unique HUC8 id
for (i in watersheds$HUC8){
  dir.create(paste("./w",i,sep=''))
}

for (i in 1:length(watersheds$HUC8)){
  DEMsub <- raster::mask(DEM,watersheds[i,])
  NLCDsub <- raster::mask(NLCD,watersheds[i,])
  
  filename1<-paste('./w',watersheds$HUC8[i],'/DEMsub.tif',sep='')
  filename2<-paste('./w',watersheds$HUC8[i],'/NLCDsub.tif',sep='')
  writeRaster(DEMsub, filename1, overwrite=T)
  writeRaster(NLCDsub, filename2, overwrite=T)
}

#centroids for each watershed
#for (i in 1:length(watersheds$HUC8))

centroids = gCentroid(watershed_p,byid=TRUE)


#download.prism(data.type, date.range, time.step = "monthly",
# download.folder = getwd(), by.year = FALSE, unzip.file = TRUE,
# ftp.site = "ftp://prism.oregonstate.edu")
# Arguments
# data.type Specify climate metric ('ppt','tmin','tmax','tmean')
# date.range A vector with start and end date in y/m/d format
# time.step Timestep of product ('daily'/'monthly')
# download.folder
# Local download directory, defaults to current working directory
# by.year Create a directory for each year (TRUE/FALSE)
# unzip.file Unzip file on download (TRUE/FALSE)
# ftp.site PRISM ftp address to use, default: ftp://prism.oregonstate.edu
# 
# 
# 
# 
# 







