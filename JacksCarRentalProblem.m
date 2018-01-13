%********************************************* JACK'S CAR RENTAL PROBLEM ********************************************************
% Code written by : Nikhil P V S and Savinay Nagendra
% Date            : 30-01-2017
%********************************************************************************************************************************
% Problem parameters: State      : No. of cars at each location at the end of each day
%                     Actions    : Net number of cars moved between the two locations overnight
%                     Rewards    : 10$ for each request and -2$ for moving cars between locations overnight
%                     Time Steps : Days
%                     Transition Probability: Number of cars requested and returned at each location are Poisson random variables
%********************************************************************************************************************************

% initialization
clc;
clear all;
MZIC = 1;			% MATLAB Zero Index Correction
gamma = 0.9;		% Discounting factor
max_cars = 20;		% Maximum number of cars at a particular location
max_transfers = 5;	% Maximum cars that can be transfered between two locations overnight

% lamda = Expected value for Transition Probability
% P(n) = (lamda^n)*(exp(-lamda))/(n!) where n is number of cars requested or returned
lamdaAreq = 3;
lamdaAret = 3;
lamdaBreq = 4;
lamdaBret = 2;

% Pre-calculation of Rewards and Transition Probabilities for all states
[Ra,Pa] = cmpt_P_and_R(lamdaAreq,lamdaAret,max_cars,max_transfers);
[Rb,Pb] = cmpt_P_and_R(lamdaBreq,lamdaBret,max_cars,max_transfers);

theta = 1e-6;									% Error convergence limit
delta = inf;									% Error
MAX_ITER = 20;									% Maximum number of iterations
V = zeros(max_cars+MZIC,max_cars+MZIC);			% State value functions
policy_pi = zeros(max_cars+MZIC,max_cars+MZIC);	% Policy
Tot_states = (max_cars+MZIC)^2;					% Total number of states
policy_stable = 0;								% Flag - Is the optimal policy achieved

while(policy_stable == 0)
	
	% POLICY EVALUATION
	% *****************
	
	% plot the current policy: 
	figure; imagesc( 0:max_cars, 0:max_cars, policy_pi ); colorbar; xlabel( 'num at B' ); ylabel( 'num at A' ); 
	title('Current Policy'); axis xy; drawnow;
	%fn=sprintf('policy_iter_%d.eps',iterNum); saveas( gcf, fn, 'eps2' ); 
	
	disp('begin policy evaluation...');
	iter_count = 0;
	
    while(delta>theta && iter_count < MAX_ITER)
        delta = 0;

        for s = 1:Tot_states
            [na1,nb1] = ind2sub([max_cars+MZIC,max_cars+MZIC] , s);			% Array index to matrix index
            na = na1 - 1 ; nb = nb1 - 1;									% Actual number of cars

            transfers = policy_pi(na1,nb1);									% Action
            v = V(na1,nb1);													% Value of being at state (na1,nb1)
			
            % restrict this action: 
            transfers = max(-nb,min(transfers,na)); 
            transfers = max(-max_transfers,min(max_transfers,transfers));
            
			vtemp = -2*abs(transfers);										% Value of each transition in a state
			na_morning = na1 - transfers;
			nb_morning = nb1 + transfers;
			
			% Policy evaluation algorithm
            for s_pri_A = 1: max_cars+1			% MZIC included here
                for s_pri_B = 1:max_cars+1		% MZIC included here
                    vtemp = vtemp + Pa(na_morning,s_pri_A)*Pb(nb_morning,s_pri_B)*(Ra(na_morning)+Rb(nb_morning)+gamma*V(s_pri_A,s_pri_B));
                end
            end
            V(na1,nb1) = vtemp;
            delta = max([delta , abs(v - V(na1,nb1))]);
        end 
        iter_count = iter_count + 1;
        fprintf('iteration number = %5d, delta = %10.8f \n',iter_count,delta);
    end
    
    disp('end of policy evaluation');
	% End of policy evaluation
	
	figure; imagesc( 0:max_cars, 0:max_cars, V ); colorbar; 
	xlabel( 'num at B' ); ylabel( 'num at A' ); 
	title( 'current state-value function' ); axis xy; drawnow; 
	%fn=sprintf('state_value_fn_iter_%d.eps',iterNum); saveas( gcf, fn, 'eps2' ); 
  
    % POLICY IMPROVEMENT
	% ******************
    
	disp('policy improvement beginning');
    policy_stable = 1;
    for s = 1:Tot_states
        [na1,nb1] = ind2sub([max_cars+MZIC,max_cars+MZIC] , s);		% Array index to matrix index
        na = na1 - 1 ; nb = nb1 - 1;
        old_policy = policy_pi(na1,nb1);

		% Possible actions
        possActInA = min(na,max_transfers);	
        possActInB = min(nb,max_transfers);
        TotPosAct = [-possActInB:possActInA];
        num = length(TotPosAct);
		
        Q = -Inf*ones(1,num);										% Value function for policy improvement

        for k = 1:num
            transfers = TotPosAct(k);
            vtemp = -2*abs(transfers);
            % restrict this action: 
            transfers = max(-nb,min(transfers,na)); 
            transfers = max(-max_transfers,min(max_transfers,transfers));
			
			na_morning = na1 - transfers;
			nb_morning = nb1 + transfers;
			% Policy improvement algorithm
            for s_pri_A = 1: max_cars+1
                for s_pri_B = 1:max_cars+1
                    vtemp = vtemp + Pa(na_morning,s_pri_A)*Pb(nb_morning,s_pri_B)*(Ra(na_morning)+Rb(nb_morning)+gamma*V(s_pri_A,s_pri_B));
                end
            end
            Q(k) = vtemp;
        end

		% Maximizing over value, and selecting corresponding action
        [max_val,max_ind] = max(Q);
        maxPosAct = TotPosAct(max_ind);

		% Condition for improving policy
        if (maxPosAct ~= old_policy)
            policy_stable = 0;
            policy_pi(na1,nb1) = maxPosAct;
        end
    end
    disp('end of policy_improvement');
end