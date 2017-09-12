function obj=sys_obj(z_sys)

z1_cop=100;
z2_cop=10;

converged=false;


while converged==false

sys_grad_z1=2*(z1_cop-0.5)*z1_cop;
sys_grad_z2=2*(z2_cop-0.5)*z2_cop;

    
z1_res=opt_ss1(z2_cop,z_sys,sys_grad_z1);
z2_res=opt_ss2(z1_cop,z_sys,sys_grad_z2);



    if abs(z2_res-z2_cop)<=0.1 && abs(z1_res-z1_cop)<=0.1
       converged=true;
    end
    
    if z1_res<z1_cop
        z1_cop=z1_res;
    end

    if z2_res<z2_cop
       z2_cop=z2_res;
    end



end

obj=(z1_res-0.5)^2+(z2_res-0.5)^2;

end