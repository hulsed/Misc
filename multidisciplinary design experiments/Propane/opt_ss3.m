function J3=opt_ss3(z)

K8=0.1;
K10=0.1;
P=40;
R=10;
initpt=[z(5),z(9),z(10)];
LB=[0,0,0];
options = optimset('Display', 'off') ;
[xopt,J3,exitflag,output]=fmincon(@ss3_obj,initpt,[],[],[],[],LB,[],@ss3_con,options);

    function obj=ss3_obj(x)
        x5=x(1);
        x9=x(2);
        x11=x(3);
        
        %dfdx5 -- sensity of global objective to x5
        dfdx5=0;
        %dfdx9 -- sensity of global objective to x9
        dfdx9=1;
        %dfdx11 -- sensity of global objective to x11
        dfdx11=0.5*sqrt(z(1))*z(6)*sqrt(P)/x11^(3/2)+...
            0.5*sqrt(z(4))*z(7)*sqrt(P)/x11^(3/2)+...
            0.5*z(4)*z(8)*sqrt(P)/x11^(3/2);
        % -- sensitivity of global objective through ss1
        
        % -- sensitivity of global objective through ss2
        
    end

    function [cineq,ceq]=ss3_con(x)
        x5=x(1);
        x9=x(2);
        x11=x(3);
        
        
        f3=2*z(2)+2*x5+z(6)+z(7)-8;
        f4=2*z(3)+x9-4*R;
        f11=x11-(z(1)+z(2)+z(3)+z(4)+x5+z(6)+z(7)+z(8)+x9+z(10));
        
        ceq=[f3,f4,f11];
        cineq=[];
        
    end


end