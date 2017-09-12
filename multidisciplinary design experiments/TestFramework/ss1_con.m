function g1_con=ss1_con(b1,z2_cop,z_sys)

z1_nc=(b1-2.5)+(z_sys-2.0)-0.4*z2_cop;
z1=(b1-2.5)+(z_sys-2.0)-0.5*z2_cop;

g1_con=1-z1;

end