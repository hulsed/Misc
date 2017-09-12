function g2_con=ss2_con(b2,z1_cop,z_sys)

z2_nc=(b2-3.0)+(z_sys-2.0)-0.6*z1_cop;
z2=(b2-3.0)+(z_sys-2.0)-0.7*z1_cop;

g2_con=1-z2;

end