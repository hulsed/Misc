function [x2_res,obj_res]=opt_ss2(x1_cop,x2_cop, beta)

x0=x2_cop;
options = optimset('Display', 'off') ;
[x2_res,obj_res,exitflag, output]=fmincon(@objective,x0,[],[],[],[],[],[],@constraint,options);


    function obj=objective(x2)

        dfdx1=2*x1_cop;
        dfdx2=2*x2;
        %obj=sys_grad1*x1_cop+sys_grad2*x2;
        
        dg2dx2=-1;
        dg2dx1=-beta;
        
        dg1dx2=beta;
        dg1dx1=1;
        
        obj=dfdx2*x2-(dfdx1*dg2dx1/dg2dx2)*x2;

    end

    function [con,ceq]=constraint(x2)
        %constraint g1
        con1=x1_cop+beta*x2-4.0;
        
        %constraint g2
        con2=2.0-beta*x1_cop-x2;
        
        con=[con1,con2];

        ceq=[];
    end

end
