%step 0 - initialize variables
    
%step 1 - action selection
    % agents select which action to propose. (based on RL?), whether that
    % is:
        %1 at the beginning (the variable copy given to the other ss)
        %1 at the end
        %1 midway
        %1 in the opposite direction a few steps
        
%step 2 - proposal generation (based on action)       
    % agent 1 runs optimization with agent 2 variable copies and context
    % agent 2 runs optimization with agent 1 variable copies

%step 3 - proposal acceptance.
    % new optimizations?? (or just checking points?) are run with the proposed variables in the other
    % subspaces. (Agent 1 tries Agent 2's proposal in its subspace and vice versa)
    % this is a bidding process based on the improvement in both subspaces
        %if agent 1's proposal is better, it is accepted
        %if agent 2's proposal is better, it is accepted
    
    % give the reward: based on collective improvement of the objective 
%repeat steps 1-3???