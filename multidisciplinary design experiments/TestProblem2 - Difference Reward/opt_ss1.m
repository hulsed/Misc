function [x1_res,obj_res]=opt_ss1(x1_cop,x2_cop, beta)

x0=x1_cop;
options = optimset('Display', 'off') ;
[x1_res,obj_res,exitflag, output]=fmincon(@objective,x0,[],[],[],[],[],[],@constraint,options);



    function obj=objective(x1)

        dfdx1=2*x1;
        dfdx2=2*x2_cop;
        
        dg2dx2=-1;
        dg2dx1=-beta;
        
        dg1dx2=beta;
        dg1dx1=1;
        
        obj=dfdx1*x1-(dfdx2*dg2dx1/dg2dx2)*x1;
    end

    function [con,ceq]=constraint(x1)
        %constraint g1
        con1=x1+beta*x2_cop-4.0;
        %constraint g2
        con2=2.0-beta*x1-x2_cop;
        
        con=[con1,con2];
        
        ceq=[];
    end

end

