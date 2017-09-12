function actions=choose_actions(agents, epsilon)

    % initialize vector of integers corresponding to the choices for each
    % parameter
    numAgents = numel(agents);
    actions = uint8(zeros(numAgents, 1));
% Iterate through the variables
    for ag = 1:numel(agents)
        
        
            agent = agents{ag};
            
            dice=rand;
            if dice>epsilon
                                      
                [val,ChosenAction]=max(agent);

            else
                ChosenAction=randi(numel(agent));
            end
            
            
            actions(ag) = ChosenAction;   
            clear p
    end

end