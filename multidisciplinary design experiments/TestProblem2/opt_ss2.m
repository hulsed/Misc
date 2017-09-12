function [x2_prop,obj_prop]=opt_ss2(x2_res,x1_cop, beta)
%state: * variable copy x2_cop sent from other subsystem to this subsystem.
    %constraint in other subsystem given x2_cop, all other copies
    %(represents budgetary rather than internal constraint
%agent finds min, and several other candidate points, and submits them to
%the integrator using softmax selection


%leniency
leniency=[0,0.25,0.5,0.75,1.0];

x0=100;
optimhist=[];
xhist=[];

options = optimset('Display', 'off', 'Outputfcn', @myoutput, 'Display', 'iter') ;
[x2_best,obj_res,exitflag, output]=fminsearch(@objective,x0,options);



    function totalobj=objective(x2)
        
        sys_grad1=2*x2;
        obj=sys_grad1*x2;
        
        con(1)=x1_cop+beta*x2-4.0;
        con(2)=2.0-beta*x1_cop-x2;
        
        for i=1:numel(con)
            if con(i)<0
                conviol(i)=0;
            else
                conviol=con(i);
            end
        end
        
        totalobj=obj+1000*sum(conviol(1));
        
    end

    function stop = myoutput(x,optimvalues,state);
        stop = false;
        if isequal(state,'iter')
          xhist = [xhist; x];
          optimhist=[optimhist;optimvalues.fval];
        end
    end


for ag=1:length(xhist)
   temp=max(abs(optimhist))/100;
   p1(ag)=exp(-optimhist(ag)/temp);
    
end
    p2=p1/sum(p1);
    chosenaction=randsample(1:numel(p2),1,true,p2);
    
    x2_prop=xhist(chosenaction);
    obj_prop=optimhist(chosenaction);
    
    
end
