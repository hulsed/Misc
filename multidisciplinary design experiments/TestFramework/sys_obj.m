function obj=sys_obj(z_sys)

z1_cop=10;
z2_cop=10;

converged=false;

while converged==false
z1_res=opt_ss1(z2_cop,z_sys);
z2_res=opt_ss2(z1_cop,z_sys);



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