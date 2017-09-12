function [con2,ceq]=ss2_con(x1,x2,x2_cop,beta)

con2(1)=2.0-beta*x1-x2;
con2(2)=x2-x2_cop;

ceq=[];

end