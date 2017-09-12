function z2_res=opt_ss2(z1_cop,z_sys)

b0=1;
options = optimset('Display', 'off') ;
[b2_res,obj_res,exitflag, output]=fmincon(@objective,b0,[],[],[],[],[],[],@constraint,options);

z2_res=(b2_res-3.0)+(z_sys-2.0)-0.7*z1_cop;

    function obj=objective(b1)

        obj=ss2_obj(b1,z1_cop,z_sys);

    end

    function [con,ceq]=constraint(b1)
        
        con=ss2_con(b1,z1_cop,z_sys);
        ceq=[];
    end

end