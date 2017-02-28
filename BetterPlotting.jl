using Gadfly
using DataFrames

#define dataframe as vectors
a=linspace(1,10)
b=a.^2
dat=DataFrame(A=a,B=b)
#plot dataset
pl=plot(dat, x=:A, y=:B, Geom.line)

#plotting anonymous function
func=function (z)
  sin(z)+cos(z)
end

al=plot(func,0,2*pi)

#plotting already defined vectors

vectorx=linspace(1,10)
vectory=vectorx.^0.5

zl=plot(x=vectorx,y=vectory)

#saving a plot
draw(SVG("gadflyplot.svg", 15cm, 9cm), pl)

#Note: Gadfly only saves in .SVG, to fix from julia, use Cairo package

using Cairo
draw(PNG("gadflyplot.png", 15cm, 9cm), pl)
