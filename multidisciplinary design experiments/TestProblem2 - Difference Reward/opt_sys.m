clear all
close all
clc

beta=1;

x1_cop=-5;
x2_cop=10;

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

x1=linspace(min(ptx)-1,max(ptx)+1);
x2=linspace(min(pty)-1,max(pty)+1);
[X1,X2]=meshgrid(x1,x2);

f1=X1.^2+X2.^2;

[C,h]=contour(X1,X2,f1,15, '--');
clabel(C,h);

hold on

g1=(4-x1)/beta;
plot(x1,g1, 'color','b');

g2=2-beta*x1;
plot(x1,g2, 'color','b');

%relaxed min
plot(0,0,'*')
%min
plot(1,1,'o')
%solution
plot(ptx(1), pty(1), '+')
plot(ptx,pty, 'color','r')

grid on
grid minor

title(['Shankar problem with Beta =', num2str(beta)])

legend('f(x1,x2)','g1','g2','relaxed min', 'constrained min', 'starting point', ' solution path')
xlabel('x1')
ylabel('y1')


% Plot solution
