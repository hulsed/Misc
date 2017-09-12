function [x1,obj_res]=opt_ss1(x1_cop,x2_cop, action, beta)

x0=[1];
oppdir=0;

switch action
    case 0
        options = optimset('Display', 'off') ;
        [x_res,obj_res,exitflag, output]=fmincon(@objective,x0,[],[],[],[],[],[],@constraint,options);
         x1=x_res(1);
    case 1
         x1=x1_cop;
         obj_res=objective(x1_cop);
    case 2
        x1=x1_cop+1;
         obj_res=objective(x1)+1000*viol(constraint(x1));
    case 3
        options = optimset('Display', 'off') ;
        [x_res,obj_res,exitflag, output]=fmincon(@objective,x0,[],[],[],[],[],[],@constraint,options);
         x1=x_res(1);
    case 4
        x1=x1_cop-1;
         obj_res=objective(x1)+1000*viol(constraint(x1));
        
        %         options = optimset('Display', 'off','MaxIter',5) ;
%         
%         oppdir=1;
%         
%         [x_res,obj_res,exitflag, output]=fmincon(@objective,x0,[],[],[],[],[],[],@constraint,options);
%          x1=x_res(1);
%          obj_res=-obj_res
        
end


    function obj=objective(x)
        if oppdir==0
        obj=ss1_obj(x(1),x2_cop);
        else
        obj=-ss1_obj(x(1),x2_cop);
        end

    end

    function [con,ceq]=constraint(x)
        
        con=ss1_con(x(1),x2_cop,beta);
        ceq=[];
    end

end

