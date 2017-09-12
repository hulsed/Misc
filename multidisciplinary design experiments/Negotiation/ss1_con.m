function [con1,ceq]=ss1_con(x1,x2,beta)

con1(1)=x1+beta*x2-4.0;

%secondary "budget constraint" given by context 
con1(2)=2.0-beta*x1-x2;

ceq=[];

end