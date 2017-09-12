function [con2,ceq]=ss2_con(x1,x2,beta)

con2(1)=2.0-beta*x1-x2;
%secondary "budget constraint" given by context 
con2(2)=x1+beta*x2-4.0;


ceq=[];

end