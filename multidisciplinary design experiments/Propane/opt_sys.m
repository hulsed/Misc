function [z_opt,f_opt]=opt_sys()

R=10;
P=40;
K5=1;
K6=1;
K7=1;
K9=1;
K8=0.1;
K10=0.1;

%initpt=[2,1,20,1,1,0,0,1,1,1,1];
initpt=[2,1,20,1,1,0,0,1,5,1,30];

objective=@sys_obj;
constraint=@sys_con;

options=optimoptions('fmincon','Display','iter','Algorithm','interior-point','MaxFunEvals',1500);
%note: sqp and active-set approach do not seem to work as well farther from
%the min. interior point still stalls out close to the min, perhaps due to
%the inherent ill-conditioning of CO?
UB=[];
LB=[0,0,0,0,0,0,0,0,0,0,0.001];
LB=ones(1,11)*0.0001;

[z_opt,f_opt,exitflag,output]=fmincon(objective,initpt,[],[],[],[],LB,[],constraint, options)

%searchoptions=optimset('Display','iter','MaxIter',5000,'MaxFunEvals',10000)
%[z_opt,f_opt,exitflag,output]=fminsearch(objective,initpt,searchoptions)

    function [ineq,eq]=sys_con(z)
        
        f2=2*z(1)+z(2)+z(4)+z(7)+z(8)+z(9)+2*z(10)-R;
        f6=K6*sqrt(z(2)*z(4))-sqrt(z(1))*z(6)*sqrt(P/z(11));
        f7=K7*sqrt(z(1)*z(2))-sqrt(z(4))*z(7)*sqrt(P/z(11));
        f9=K9*z(1)*sqrt(z(3))-z(4)*z(8)*sqrt(P/z(11));
       
        c_ineq(1)=-f2;
        c_ineq(2)=-f6;
        c_ineq(3)=-f7;
        c_ineq(4)=-f9;
        
        J1=opt_ss1(z);
        J2=opt_ss2(z);
        J3=opt_ss3(z);
        
        ineq=[c_ineq];
        
       eq=[J1,J2,J3]; 
    end
    
    function obj=sys_obj(z)
        
        f2=2*z(1)+z(2)+z(4)+z(7)+z(8)+z(9)+2*z(10)-R;
        f6=K6*sqrt(z(2)*z(4))-sqrt(z(1))*z(6)*sqrt(P/z(11));
        f7=K7*sqrt(z(1)*z(2))-sqrt(z(4))*z(7)*sqrt(P/z(11));
        f9=K9*z(1)*sqrt(z(3))-z(4)*z(8)*sqrt(P/z(11));
        
        
        obj=f2+f6+f7+f9;
        

    end


end