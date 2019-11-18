install.packages('rgdal')
install.packages('raster')	
install.packages("GISTools")

#change later on my machine
setwd("D:/R_Class/lab1_R")

library(raster)
library(rgdal)
library(GISTools)

pophu<-readOGR('.',layer='y2010_51_pophu')

plot(pophu)

#plot(a)
#plot(pophd_p, add=TRUE)

choropleth(pophu,pophu$POP10)
choropleth(pophu,pophu$HOUSING10)

pophu_sub <- pophu[pophu$POP10>100,]
plot(pophu_sub)

pophu_sub <- pophu[pophu$POP10>100&pophu$HOUSING10>100,]
plot(pophu_sub)

counties <- readOGR('.', layer='counties.shp')

combinedcounties1 <- counties[counties$NAME == 'Montgomery',]
combinedcounties2 <- counties[counties$NAME == 'Pulaski',]

plot(combinedcounties1)
plot(combinedcounties2, add=TRUE)
