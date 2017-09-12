function J1=opt_ss1(z)

K5=1;
initpt=[z(2),z(4)];
options = optimset('Display', 'off') ;
LB=[0,0];
[xopt,J1,exitflag,output]=fmincon(@ss1_obj,initpt,[],[],[],[],LB,[],@ss1_con,options);

    function obj=ss1_obj(x)
        z(2)=x(1);
        z(4)=x(2);
                
        [dfdx2,dfdx4]=dfda1(z);
        obj=dfdx2*x2+dfdx4*x4
        
    end
    
    %direct sensitivity of global objective to ss1 variables
    function=[dfdx2,dfdx4]=dfda1(z)
        %dfdx2 -- sensitivity of global objective to x2
        dfdx2=1+0.5*K6*sqrt(z(4))/sqrt(z(2))+0.5*K7*sqrt(z(1))/sqrt(z(2));
        %dfdx4 -- sensitivity of global objective to x4
        dfdx4=1+0.5*K6*sqrt(z(2))/sqrt(z(4))-0.5*z(7)*sqrt(P/z(1))/sqrt(z(4));
    end
    
    function [dfA2dx2,dfA2dx4]=da2da1(z)
        
        
        
    end

    function [cineq,ceq]=ss1_con(x)
        x2=x(1);
        x4=x(2);
        
        f1=z(1)+x4-3;
        f5=K5*x2*x4-z(1)*z(5);
        
        ceq=[f1,f5];
        cineq=[];
        
    end


end