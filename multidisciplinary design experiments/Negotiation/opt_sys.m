beta=1;
%initialize variables
x1_cop=100;
x2_cop=20;
epsilon=0.3;
alpha=0.1;
obj_prev=100000;
agents{1}=ones(1,4)+0.01*rand(1,4);
agents{2}=ones(1,4)+0.01*rand(1,4);

obj1_prev=10000;
obj2_prev=10000;

converged=false;
count=1;
while converged==false

%action selection
actions=choose_actions(agents, epsilon);

%run optimization based on chosen action
[x1_prop11,obj_prop11]=opt_ss1(x1_cop,x2_cop, actions(1), beta);
[x2_prop22,obj_prop22]=opt_ss2(x1_cop,x2_cop, actions(2), beta);

%try value optimization in other subsystem (should these have actions too?)
%[x1_prop21,obj_prop21]=opt_ss1(x1_prop11,x2_cop,0, beta);
%[x2_prop12,obj_prop12]=opt_ss2(x1_cop,x2_prop22,0, beta);

%try agent 1 action in agent 2 ss
%check2=ss2_obj(x2_cop,x1_prop11);
check2=ss2_con(x1_prop11,x2_cop,beta);

%try agent 2 action in agent 1 ss
%check1=ss1_obj(x1_cop,x2_prop22);
check1=ss1_con(x1_cop,x2_prop22,beta);

%try both
checkboth1=ss1_con(x1_prop11,x2_prop22,beta);

checkbothobj=ss2_obj(x1_prop11,x2_prop22)+ss1_obj(x1_prop11,x2_prop22);

checkboth2=ss2_con(x1_prop11,x2_prop22,beta);

%choose agent 1's action only
%choose agent 2's action only
%choose both
%choose neither

obj1=obj_prop11+obj2_prev+1000*viol(check2);
obj2=obj_prop22+obj1_prev+1000*viol(check1);

objboth=checkbothobj+1000*(viol(checkboth1(1))+viol(checkboth1(2)))+1000*(viol(checkboth2(1))+viol(checkboth2(1)));

[minimum,loc]=min([obj1,obj2,objboth,obj_prev]);

%if rand<0.1
%    choice=randi(4);
%else
%    choice=loc;
%end

switch loc
    case 1
        x1_cop=x1_prop11;
        rewards(1)=1;%obj_prev-obj1;
        rewards(2)=0;
        obj1_prev=obj_prop11;
        obj_prev=obj1;
    case 2
        x2_cop=x2_prop22;
        rewards(1)=0;
        rewards(2)=1;%obj_prev-obj2;
        obj2_prev=obj_prop22;
        obj_prev=obj2;
    case 3
        x1_cop=x1_prop11;
        x2_cop=x2_prop22;
        rewards(1)=1;%obj_prev-objboth;
        rewards(2)=1;%obj_prev-objboth;
        obj_prev=objboth
        
    case 4
        rewards(1)=0;
        rewards(2)=0;  
end

agents=learn(actions,agents,rewards, alpha);
%loc
[x1_cop,x2_cop]
%[obj1, obj2]
%rewards;

count=count+1;
if count>1000
    converged=true;
end




end


