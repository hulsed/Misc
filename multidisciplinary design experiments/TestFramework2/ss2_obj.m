function obj=ss2_obj(b2,z1_cop,z_sys,sys_grad_z2)

z2_nc=(b2-3.0)+(z_sys-2.0)-0.6*z1_cop;
z2=(b2-3.0)+(z_sys-2.0)-0.7*z1_cop;

obj=sys_grad_z2*z2;

end