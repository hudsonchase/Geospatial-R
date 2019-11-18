install.packages("GISTools")
install.packages("rgdal")
install.packages("raster")
install.packages("randomForest")
install.packages("prettymapr")

library(GISTools)
library(rgdal)
library(raster)
library(randomForest)
library(prettymapr)

setwd("C:/R_Class/lab4_landsat")

training <- readOGR(".", layer = "trainingdata")

imagery <- raster("landsat.tif")
band1<-raster('landsat.tif',band=1)   #read band1
band2<-raster('landsat.tif',band=2)   #read band2
band3<-raster('landsat.tif',band=3)   #read band3
band4<-raster('landsat.tif',band=4)   #read band4
band5<-raster('landsat.tif',band=5)   #read band5
band6<-raster('landsat.tif',band=6)   #read band6          

trainingraster <- rasterize(training, band1, field=training$Id)

train_band1 <- band1[trainingraster>0]
train_band2 <- band2[trainingraster>0]
train_band3 <- band3[trainingraster>0]
train_band4 <- band4[trainingraster>0]
train_band5 <- band5[trainingraster>0]
train_band6 <- band6[trainingraster>0]

y<-trainingraster[trainingraster>0]

alltraining<-data.frame(y,band1=train_band1,band2=train_band2,band3=train_band3, band4=train_band4, band5=train_band5, band6 = train_band6)

rfmodel <- randomForest(as.factor(y) ~. , data = alltraining)

all_band1 <- band1[band1>=0]
all_band2 <- band2[band2>=0]
all_band3 <- band3[band3>=0]
all_band4 <- band4[band4>=0]
all_band5 <- band5[band5>=0]
all_band6 <- band6[band6>=0]

alldata_df <- data.frame(band1=all_band1,band2=all_band2,band3=all_band3,band4=all_band4,band5=all_band5,band6=all_band6)

rf_pred <- predict(rfmodel, alldata_df)

output <- setValues(band1, rf_pred)
plot(output,col=c("red","yellow","darkgreen","blue"))

legend("topright",legend= c("Urban","Cropland", "Forest", "Water"), col=c("red","yellow","darkgreen","blue"), bg="gray", lwd = 3, cex = .6)
addnortharrow(pos = "bottomright", scale = .7)
addscalebar(pos="bottomleft")

freq(output, value = 1)