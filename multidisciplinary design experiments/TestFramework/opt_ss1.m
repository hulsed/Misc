function z1_res=opt_ss1(z2_cop,z_sys)

b0=1;
options = optimset('Display', 'off') ;
[b1_res,obj_res,exitflag, output]=fmincon(@objective,b0,[],[],[],[],[],[],@constraint,options);

z1_res=(b1_res-2.5)+(z_sys-2.0)-0.5*z2_cop;

    function obj=objective(b1)

        obj=ss1_obj(b1,z2_cop,z_sys);

    end

    function [con,ceq]=constraint(b1)
        
        con=ss1_con(b1,z2_cop,z_sys);
        ceq=[];
    end

end