function obj=ss1_obj(x1,x2)

sys_grad1=2*x1;
sys_grad2=2*x2;
obj=sys_grad1*x1+sys_grad2*x2;

end