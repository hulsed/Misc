
mishra11=@(x) ((abs(x(1))+abs(x(2))+abs(x(3))+abs(x(4)))/4 - (abs(x(1))*abs(x(2))*abs(x(3))*abs(x(4)))^(1/4))^2;


UB=[10,10,10,10];
LB=[-10,-10,-10,-10];


%gaoptions=optimoptions(@ga,'FunctionTolerance', 0); %'PlotFcn', @gaplotbestf)
%[x_ga,fval_ga,exitflag,output]=ga(mishra11,4,[],[],[],[], LB,UB,[],[],gaoptions)
evals=output.funccount

saoptions=optimoptions(@simulannealbnd, 'FunctionTolerance', 0, 'TemperatureFcn', @temperatureboltz) %'PlotFcn', @gaplotbestf)
initpt=rand(1,4)*20-10
[x_sa,fval_sa,exitflag output]=simulannealbnd(mishra11,initpt,LB,UB,saoptions)
evals=output.funccount

