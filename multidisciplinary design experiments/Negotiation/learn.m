function agents=learn(actions, agents,rewards, alpha)

    numAgents = numel(agents);
% Iterate through the variables
    for ag = 1:numel(agents)
        
        Vprev=agents{ag}(actions(ag));
        
        Vnow=Vprev+alpha*(rewards(ag)-Vprev);
        
        agents{ag}(actions(ag))=Vnow;
    end

end