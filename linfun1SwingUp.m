clear all;
close all;
clc;
NUM_STATES = 162;
MAX_EP = 1000;
NUM_FAILED_STATES = 1;
NUM_ACTIONS = 2;
Q = zeros(NUM_STATES+NUM_FAILED_STATES,NUM_ACTIONS);
ep = 1;
samerep = 0;
z = 0;
gamma = 0.992; % late reward contribution
alpha = 0.07; % learning rate
lambda = 0; % eligibility decay
epsilon = 0; % amount of randomness/greediness
% states - 1 to 162+1 (failed state)
% actions - 1 to 2
thetaPlot = 0;
xplot = 0;
fail = 0;
jv = 0;

% APPROX
w = zeros(4,2);

while (ep < MAX_EP)
	% init S and A
	%S = 82;
    %realS = [0,0,0,0];
	xSA = [0,0,0,0]; % First 4 for action 0; 
	
	%[qp,A] = max(Q(S,:));%eGreedy(Q(S,:),epsilon);
	% End of Episode flag
	EOE = 0;
	
	
	%qHat = xSA*w;
	
	% Episodic loop
    c = 0;
    j = 0;
    %thetaPlot = 0;
	while (~EOE)
        c = c + 1;
		
		
		% Take action:
		%[Qpi, A] = eGreedy(Q(S,:),epsilon); %max(Q(Snew,:));
		A = xSA*w(:,2) > xSA*w(:,1);
		qHat = xSA*w(:,A+1);
		
		%[R,Snew,realSnew] = takeAction(realS,S,A);
		xSAnew = takeAction2(xSA,A+1);
        %disp('---');
        thetaPlot(end+1) = xSAnew(1);
        xplot(end +1) = xSAnew(3);
		% Choose Anew using some<greedy> policy
% 		[Qpi, Anew] = eGreedy(Q(Snew,:),epsilon); %max(Q(Snew,:));
		%[Qpigr, Anew] = max(Q(Snew,:));
		
		
		
		
		% Reward and Eligibility for taking a step
        if (abs(xSAnew(1)) > 12*pi/180 || abs(xSAnew(3)) > 2.4)
            xSAnew = [-pi,0,0,0];
            theta = xSAnew(1);
            thetaDot = xSAnew(2);
            x = xSAnew(3);
            xDot = xSAnew(4);
            thetaacc = 0;
            while((theta<=(-12*pi/180) || theta>=(12*pi/180)))
            z = z+1;
            F = SwingUpController2(theta,thetaDot,thetaacc,x,xDot);
            [thetaNext,thetaDotNext,thetaaccNext,xNext,xDotNext] = cart_pole2(F,theta,thetaDot,x,xDot);
            theta = thetaNext;
            thetaDot = thetaDotNext;
            x = xNext;
            xDot = xDotNext;
            thetaacc = thetaaccNext;
            
            theta = wrapToPi(theta);

            end
            xSAnew = [theta,thetaDot,x,xDot];
			R = -1;
			w(:,A+1) = w(:,A+1) + alpha.*(R - qHat).*xSA';
            fail = 1;
        else
			Anew = xSAnew*w(:,2) > xSAnew*w(:,1);
			
			% APPROX value function
			qHatNew = xSAnew*w(:,Anew+1);
			R = 0;
			
			w(:,A+1) = w(:,A+1) + alpha.*(R + gamma.*qHatNew - qHat).*xSA';
			%disp('w is: ');
            %disp(w);
        end
% 		del = R + gamma*Q(Snew,Anew)-Q(S,A);
		%Q(S,A) = Q(S,A) + alpha*(R + gamma*max(Q(Snew,:))-Q(S,A));
% 		if S == Snew
%             jv = jv + 1;
%             disp(jv);
%         else
%             jv = 0;
%         end
		%S = Snew;
		%realS = realSnew;
		
		xSA = xSAnew;
		qHat = qHatNew;
		%disp(c);
		% Check if End of Episode
% 		if (S == NUM_STATES+NUM_FAILED_STATES || c > 10000)
        if (fail == 1 || c > 100000)
			EOE = 1;
            fail = 0;
            
%             figure(1);
%             plot(0,0,'r*');
        end
    end
    figure(2);
    plot(1:c,thetaPlot(1:c),'-ob');
    thetaPlot = 0;
    fprintf('Trial %d was %d steps. \n',ep,c);
    figure(3);
    plot(1:c,xplot(1:c),'-og');
    xplot = 0;
    fprintf('Trial %d was %d steps. \n',ep,c);
%      if ep == 75
%          pause(10);
%      end
    if (c > 100000)
        fprintf('Balanced for %d steps. \n',c);
        break;
    end
    ep = ep + 1;
    figure(1);
    plot(ep,c,'r*');
    hold on;
    c = 0;
end
ep = ep + 1;
figure(1);
plot(ep,c,'r*');
hold on;

		% Update all Qs
%         if samerep == 0
%             E(S,A) = E(S,A) + 1;
%             for s = 1:NUM_STATES
%                 for a = 1:NUM_ACTIONS
%                     Q(s,a) = Q(s,a) + alpha*del*E(s,a);
%                     E(s,a) = gamma*lambda*E(s,a);
%                 end
%             end
%         end
		