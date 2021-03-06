clear all
close all
clc

beta=1;

x1_cop=0.25;
x2_cop=3.5;

ptx(1)=x1_cop;
pty(1)=x2_cop;
k=1

converged=false;
while converged==false
    
     x2_cop_prev=x2_cop;
     x1_cop_prev=x1_cop;

    [x1_res1,obj_res1]=opt_ss1(x1_cop,x2_cop, beta);
    
    ptx(k)=x1_cop;
    pty(k)=x2_cop;
    k=k+1;
    
    x1_cop=x1_res1;

    [x2_res2,obj_res2]=opt_ss2(x1_cop,x2_cop, beta);
    
    ptx(k)=x1_cop;
    pty(k)=x2_cop;
    k=k+1;
    
    x2_cop=x2_res2;


    
    if x2_cop_prev-x2_cop<=0.0001 && x1_cop_prev-x1_cop<=0.0001  %&& x1_cop_prev==x1_cop
     converged=true;
     break
    end
        
end

% Plot problem
beta=1;

minx=0;
miny=0
maxx=1.5
maxy=4

x1=linspace(minx,maxx, 20);
x2=linspace(miny,maxy, 20);
[X1,X2]=meshgrid(x1,x2);

f1=X1.^2+X2.^2;


[C,h]=contour(X1,X2,f1,[0.5,1,1.5,2,4,8, 12], '--', 'linewidth',1.0);
clabel(C,h);
xlim([minx,maxx])
ylim([miny,maxy])

hold on

g1=(4-x1)/beta;
plot(x1,g1, 'color','b', 'linewidth', 2, 'marker', '<', 'markersize', 2);

g2=2-beta*x1;
plot(x1,g2, 'color','b', 'linewidth', 2, 'marker', '>', 'markersize', 2);

%relaxed min
%plot(0,0,'*')

%beginning
plot(ptx(1), pty(1), '+', 'linewidth', 3, 'markersize', 10)
plot(ptx,pty, 'color','r', 'linewidth', 2)
%end
plot(ptx(end), pty(end), 'x', 'linewidth', 3, 'markersize', 10)
%min
plot(1,1,'o', 'linewidth', 3, 'markersize', 10)

grid on
grid minor

title(['Shankar problem with Beta =', num2str(beta)])

legend('f(x_1,x_2)','g_1','g_2', 'x_0', ' path', 'found "min"','real min')
xlabel('x_1')
ylabel('x_2')


% Plot solution
