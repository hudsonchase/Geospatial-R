library('raster')
library('rgdal')
library('mapview')

a <- raster('elev.tif')
plot(a)

b <- raster('landcover.tif')
plot(b)

c <- raster('ndvi.tif')
plot(c)


m <- matrix(c(1,2,3,3,2,1), nrow=3, ncol=2)

x1 <- rnorm(100)
y1 <- rnorm(100)

plot(x1,y1)

plot(x1,y1,pch=1,col='red')

x2 <- seq(0,6,len=100)
y2 <- sin(x2)
plot(x2,y2,type='l',lwd=3,col='darkgreen')

y2r <- y2+rnorm(100,0,0.1)
points(x2,y2r,pch=16,col='darkred')

mapview(a)
