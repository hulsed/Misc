beta=1;

x1_cop=-10;
x2_cop=20;
i=1;
converged=false;
while converged==false
i=i+1
    [x1_res1,obj_res1]=opt_ss1(x1_cop,x2_cop, beta);

    [x2_res2,obj_res2]=opt_ss2(x1_cop,x2_cop, beta);

%x1_cop=x1_res1;
%x2_cop=x2_res2;
    
    

%ss1 constraint cases
counter(1)=x1_cop+beta*x2_cop-4.0;
both(1)= x1_res1+beta*x2_res2-4.0;
ss1(1)= x1_res1+beta*x2_cop-4.0;
ss2(1)= x1_cop+beta*x2_res2-4.0;

%ss2 constraint cases
counter(2)=2.0-beta*x1_cop-x2_cop;
both(2)= 2.0-beta*x1_res1-x2_res2;
ss1(2)= 2.0-beta*x1_res1-x2_cop;
ss2(2)= 2.0-beta*x1_cop-x2_res2;

%objectives
counter(3)=x1_cop^2+x2_cop^2;
both(3)=x1_res1^2+x2_res2^2;
ss1(3)=x1_res1^2+x2_cop^2;
ss2(3)=x1_cop^2+x2_res2^2;

%values of each
valcount=counter(3)+1000*viol(counter(1))+1000*viol(counter(2));
valboth=both(3)+1000*viol(both(1))+1000*viol(both(2));
valss1=ss1(3)+1000*viol(ss1(1))+1000*viol(ss1(2));
valss2=ss2(3)+1000*viol(ss2(1))+1000*viol(ss2(2));

values=[valcount,valboth,valss1,valss2];

for ag=1:length(values)
   temp=max(abs(values))/10;
   p1(ag)=exp(-values(ag)/temp);
    
end
    p2=p1/sum(p1)
    %chosenaction=randsample(1:numel(p2),1,true,p2);
    chosenaction=randi(4,1);
switch chosenaction
    case 1
        
    case 2
       x1_cop=x1_res1;
       x2_cop=x2_res2;
    case 3
        x1_cop=x1_res1;
    case 4
        x2_cop=x2_res2;
end
    
    

if i==100
    converged=true
end

end


