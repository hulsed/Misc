function sys_obj=opt_subsystems(z)

z=ones(11,1);
obj=[];
dfdx2=[];
dfdx4=[];
dfdx8=[];
dfdx10=[];
dfdx5=[] ;
dfdx9=[] ;
dfdx11=[];
dA2dx2=[];
dA2dx4=[];
dA2dx2=[];
dA2dx4=[];
dA1dx8=[];
dA1dx10=[];
dA3dx8=[];
dA3dx10=[];
dA1dx5=[] ;
dA1dx9=[] ;
dA1dx11=[];
dA2dx5=[] ;
dA2dx9=[] ;
dA2dx11=[];
dx2da1=[] ;
dx4da1=[];
dx8da2=[] ;
dx10da2=[];
dx5da3=[] ;
dx9da3=[] ;
dx11da3=[];

R=10;
P=40;
K5=1;
K6=1;
K7=1;
K9=1;
K8=0.1;
K10=0.1;

    function obj=ss1_obj(x)
        z(2)=x(1);
        z(4)=x(2);
                
        [dfdx2,dfdx4]=dfda1(z);
        obj=dfdx2*z(2)+dfdx4*z(4)
        
    end

    function obj=ss2_obj(x)
        z(8)=x(1);
        z(10)=x(2);
    end

    function obj=ss3_obj(x)
        z(5)=x(1);
        z(9)=x(2);
        z(11)=x(3);
    end



%% Direct Sensitivites - Partial derivitives of objective with respect to 
%% subsystem variables
    %direct sensitivity of global objective to ss1 variables
    function [dfdx2,dfdx4]=dfda1(z)
        %dfdx2 -- sensitivity of global objective to x2
        dfdx2=1+0.5*K6*sqrt(z(4))/sqrt(z(2))+0.5*K7*sqrt(z(1))/sqrt(z(2));
        %dfdx4 -- sensitivity of global objective to x4
        dfdx4=1+0.5*K6*sqrt(z(2))/sqrt(z(4))-0.5*z(7)*sqrt(P/z(1))/sqrt(z(4));
    end
    %direct sensitivity of global objective to ss2 variables
    function [dfdx8, dfdx10]=dfda2(z)
        dfdx8=1-z(4)*sqrt(P/z(11));
        dfdx10=2;
    end
    %direct sensitivity of global objective to ss3 variables
    function [dfdx5, dfdx9, dfdx11]=dfda3(z)
        dfdx5=0;
        dfdx9=1;
        dfdx11=0.5*sqrt(z(1))*z(6)*sqrt(P)/z(11)^(3/2)+...
            0.5*sqrt(z(4))*z(7)*sqrt(P)/z(11)^(3/2)+...
            0.5*z(4)*z(8)*sqrt(P)/z(11)^(3/2);
    end
%% Sensitivities of subsystem constraints with respect to outside variables
    %sensitivity of a2 to a1 vars
    function [dA2dx2,dA2dx4]=da2dss1(z)
        %df8, df10
        dA2dx2=[0,0];
        dA2dx4=[-z(8)*P/z(11), 0];
    end
    %sensitivity of a3 to a1 vars
    function [dA2dx2,dA2dx4]=da3dss1(z)
       %df3, df4, df11
       dA2dx2=[2, 0, -1];
       dA2dx4=[0, 0, -1];
    end
    %sensitivity of a1 to a2 vars
    function [dA1dx8,dA1dx10]=da1dss2(z)
        %df1, df5
        dA1dx8=[0,0];
        dA1dx10=[0,0];
    end
    %sensitivity of a3 to a2
    function [dA3dx8,dA3dx10]=da3dss2(z)
        %df3, df4, df11
        dA3dx8=[0,0,-1];
        dA3dx10=[0,0,-1];
    end
    %sensitivity of a1 to a3
    function [dA1dx5, dA1dx9, dA1dx11]=da1dss3(z)
        %df1, df5
        dA1dx5=[0, -z(1)];
        dA1dx9=[0,0];
        dA1dx11=[0,0];
        
    end
    %sensitivity of a2 to a3
    function [dA2dx5, dA2dx9, dA2dx11]=da2dss3(z)
        %df8, df10
        dA2dx5=[0,0];
        dA2dx9=[0,0];
        dA2dx11=[z(4)*z(8)/z(11)^2, z(4)^2*z(10)*P/z(11)^2];
    end

%% Sensitivities of subsystem variables with respect to constraints
    function [dx2da1, dx4da1]=dss1da1(z)
        %f1, f5
        dx2da1=[1,1];
        dx4da1=[K5*z(4),K5*z(2)];
    end
    function [dx8da2, dx10da2]=dss2da2(z)
        %f8, f10
        dx8da2=[-z(4)*P/z(11),-2*z(4)*z(10)*P/z(11)];
        dx10da2=[0,-z(4)^2*P/z(11)];
    end
    function [dx5da3, dx9da3, dx11da3]=dss3da3(z)
        %f3,f4,f11
        dx5da3=[2, 0, -1]; 
        dx9da3=[0, 1, -1];
        dx11da3=[0, 0, 1];
    end
%% Sensitivities of objective to system variables
    %function

end