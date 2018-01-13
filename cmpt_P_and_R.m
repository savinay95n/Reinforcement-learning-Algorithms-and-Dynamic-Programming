% ********************************************************
% Function to compute rewards and transition probabilities
% ********************************************************
function [R,P] = cmpt_P_and_R(lambdaRequests,lambdaReturns,max_n_cars,max_num_cars_can_transfer)

% the number of possible cars at a location in the morning: 
nCM = 0:(max_n_cars+max_num_cars_can_transfer);

% return the average rewards: 
R = zeros(1,length(nCM));
for n = nCM,
  tmp = 0.0;
  for nreq = 0:(10*lambdaRequests), 
    for nret = 0:(10*lambdaReturns), 
      tmp = tmp + 10*min(n+nret,nreq)*poisspdf( nreq, lambdaRequests )*poisspdf( nret, lambdaReturns );
    end
  end
  R(n+1) = tmp; % because R(0) is not possible
end

% return the probabilities: 
P = zeros(length(nCM),max_n_cars+1); 
for nreq = 0:(10*lambdaRequests),  
  reqP = poisspdf( nreq, lambdaRequests ); 
  % for all possible returns:
  for nret = 0:(10*lambdaReturns),
    retP = poisspdf( nret, lambdaReturns ); 
    % for all possible morning states: 
    for n = nCM,
      sat_requests = min(n,nreq); 
      new_n = max( 0, min(max_n_cars,n+nret-sat_requests) ); % number of cars at a location by evening 
      P(n+1,new_n+1) = P(n+1,new_n+1) + reqP*retP; % transition probability that n/new_n cars were requested and returned
    end
  end
end