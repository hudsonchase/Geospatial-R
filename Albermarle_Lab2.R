setwd("C:/R_Class/lab2_wui")

install.packages('raster')
install.packages('rgdal')
install.packages('GISTools')
install.packages('prettymapr')

library(raster)
library(rgdal)
library(GISTools)
library(prettymapr)

nlcd<-raster('./raster/nlcd_va_utm17.tif')
plot(nlcd)

crs(nlcd)

pophu<-readOGR("C:/R_Class/lab2_wui/shapefile/tabblock2010_51_pophu.shp")

pophu_p <- spTransform(pophu, crs(nlcd))

mydata<-pophu_p@data

mydata<-cbind(mydata,newid=1:length(pophu_p))

block_area<-gArea(pophu_p,byid=TRUE)/1000000

hd<-pophu_p$HOUSING10/block_area

mydata<-cbind(mydata,housingden=hd)

pophu_p@data<-mydata

#choropleth(pophu_p,pophu_p$housingden)

nlcd[nlcd==41|nlcd==42|nlcd==43|nlcd==52|nlcd==71|nlcd==90|nlcd==95]=1
nlcd[nlcd!=1]= 0
#plot(nlcd)

pophu_raster <- rasterize(pophu_p, nlcd, field = pophu_p$newid)
#plot(pophu_raster)

veg_mean<-zonal(nlcd, pophu_raster, fun='mean')

colnames(veg_mean)[1]<-'newid'
colnames(veg_mean)[2]<-'pveg'

output2<-merge(pophu_p,veg_mean,by='newid')
output2$pveg

#recode NA to -9999
output2$pveg[is.na(output2$pveg)]<- -9999

#output to shapefile
writeOGR(obj=outpu2t, dsn=".", layer='output', driver="ESRI Shapefile",overwrite_layer=T)

#create wui with expression
wui<-output2[output2$pveg>0.5& output2$housingden>6.17,]

plot(nlcd, main = "WUI map for Albemarle County")
plot(wui,add=TRUE)

addnortharrow(pos = "bottomright")
addscalebar()

#write wui output to shapefile
writeOGR(obj=wui, dsn=".", layer='wui', driver="ESRI Shapefile",overwrite_layer=T)




