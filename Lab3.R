setwd("C:/R_Class/forestfire")
install.packages('GISTools')
install.packages('rgdal')
install.packages('raster')
install.packages("prettymapr")

library(GISTools)
library(rgdal)
library(raster)
library(prettymapr)

ndvi <- raster('ndvi.tif')

mtx <- c(0,200,0, 200,255,1)
rclmtx <- matrix(mtx, 2, byrow=TRUE)
rc <- reclassify(ndvi,rclmtx)
#plot(rc)

lndcvr <- raster('landcover.tif')

lndcvr[lndcvr==8 | lndcvr==9 | lndcvr==10 | lndcvr==11 | lndcvr==12 | lndcvr==13] <- 1
lndcvr[lndcvr!=1] <- 0
testlndcvr <- lndcvr 
testlndcvr <-resample(testlndcvr,rc)

elev <- raster('elev.tif')
steepslope <- terrain(elev, opt="slope", unit = 'degrees')
steepslope[steepslope == 1] <-0
steepslope[steepslope > 35] <-1
steepslope[steepslope != 1] <-0
steepslope<-resample(steepslope,rc)

asp <- terrain(elev, opt="aspect", unit = 'degrees')
asp[asp >=180 & asp <= 270] <-1
asp[asp != 1] <-0
asp<-resample(asp,rc)

trail <- readOGR(dsn = ".", layer ='roads' )
trailbuff <- buffer(trail, width = 150)
trailbuff <- rasterize(trailbuff,rc)
trailbuff[is.na(trailbuff)] <- 0
trailbuff<- resample(trailbuff,rc)



lndcvr <- raster('landcover.tif')
lndcvr[lndcvr != 1 ] <- NA
lndcvr[lndcvr == 1] <- 1
water = lndcvr
waterbuff <- buffer(water, width=500)
waterbuff[waterbuff == 1] <- 0
waterbuff[is.na(waterbuff)] <- 1
waterbuff<-resample(waterbuff,rc)

output <- (testlndcvr*(25)+rc*(25)+steepslope*(10)+asp*(10)+trailbuff*(20)+waterbuff*(10))
plot(output)

reclass_df <- c(0,33, 1, 33,66,2, 66,100,3)
reclass_m <- matrix(reclass_df, ncol = 3, byrow =TRUE)
classified <- reclassify(output,reclass_m)
classified[classified == 0] <- NA


plot(classified, legend = FALSE, col = chm_col, axes = TRUE, box = FALSE, main = "Classified Model for High Fire Potential Areas in Glacier National Park")
legend("bottomright", legend = c("Low Potential", "Medium Potential", "High Potential"), fill = chm_col, border = FALSE,bty = "n", bg = "gray")

addnortharrow("topright")
addscalebar()