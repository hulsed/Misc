function obj=ss1_obj(b1,z2_cop,z_sys,sys_grad_z1)

z1_nc=(b1-2.5)+(z_sys-2.0)-0.4*z2_cop;
z1=(b1-2.5)+(z_sys-2.0)-0.5*z2_cop;


obj=sys_grad_z1*z1;

end