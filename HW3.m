
mishra11=@(x) ((abs(x(1))+abs(x(2))+abs(x(3))+abs(x(4)))/4 - (abs(x(1))*abs(x(2))*abs(x(3))*abs(x(4)))^(1/4))^2


UB=[10,10,10,10]
LB=[-10,-10,-10,-10]


gaoptions=optimoptions(@ga,'FunctionTolerance', 1e-3000) %'PlotFcn', @gaplotbestf)
[x_ga,fval_ga]=ga(mishra11,4,[],[],[],[], LB,UB,[],[],gaoptions)

saoptions=optimoptions(@simulannealbnd, 'FunctionTolerance', 1e-3000, 'TemperatureFcn', @temperatureboltz) %'PlotFcn', @gaplotbestf)
initpt=rand(1,4)*20-10
[x_sa,fval_sa]=simulannealbnd(mishra11,initpt,LB,UB,saoptions)

