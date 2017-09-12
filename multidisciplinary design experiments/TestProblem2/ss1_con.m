function [con1,ceq]=ss1_con(x1,x2,x1_cop,beta)

con1(1)=x1+beta*x2-4.0;
con1(2)=x1_cop-x1;
ceq=[];

end