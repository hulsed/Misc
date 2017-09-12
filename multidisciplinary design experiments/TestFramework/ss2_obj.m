function obj=ss2_obj(b2,z1_cop,z_sys)

z2_nc=(b2-3.0)+(z_sys-2.0)-0.6*z1_cop;
z2=(b2-3.0)+(z_sys-2.0)-0.7*z1_cop;

sys_grad_z2=2*(z2-0.5)*z2;
obj=sys_grad_z2*z2;

end