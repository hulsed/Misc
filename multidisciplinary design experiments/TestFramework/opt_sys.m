
z_sys0=1;
func=@sys_obj;

[zsys_res,obj_res,exitflag, output]=fmincon(func,z_sys0)