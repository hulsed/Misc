
using PyPlot
a=1
b=2

a+b

a*b

z=ones(1,20)
x=ones(1,20)

for i=1:20
  z[i]=i/sum(z)
  x[i]=i;
end

plot(x',z',color="red", linewidth=10.0, linestyle="--")
