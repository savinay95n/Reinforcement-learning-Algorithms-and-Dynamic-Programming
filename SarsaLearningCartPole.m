%**************************************************************************
% SARSA Learning applied to Cart-Pole balancing problem.
% The environment of the learning system is a black box, from which it has
% several lines and a reinforcement line. Its task is to learn to give
% responses which maximize the scalar signals on its reinforcement line.
% The Q-value update is the following, if the system takes action a from     
%   state s at time t, and arrives at state ss with feedback r at time t+1:  
%                                                                              
%   Q(t+1, s, a) = Q(t, s, a)                                                  
%                  + alpha (r + gamma *Q(t,ss, b) - Q(t, s, a)) 


% get_box:  Given the current state, returns a number from 1 to 162
%           designating the region of the state space encompassing the current 
%           state.
%           Returns a value of -1 if a failure state is encountered.

% cart_pole2: The cart and pole dynamics; given the Force and
%             current state, estimates next state

%Code written by: Savinay Nagendra
%email id:        nagsavi17@gmail.com 
%**************************************************************************
clc;
clear all;
close all;
% Initialization

NUM_BOXES = 163;
ALPHA = 0.5;             % Learning rate parameter
GAMMA = 0.999;           % Discount factor for future reinf
Q = zeros(NUM_BOXES,2);  % State-Action Values
action = [10 -10];
MAX_FAILURES = 2000;
MAX_STEPS = 150000;
epsilon = 0;
steps = 0;
failures = 0;
thetaPlot = 0;
xPlot = 0;
%Pendulum state initialization
theta = 0;
thetaDot = 0;
x = 0;
xDot = 0;
box = getBox4(theta,thetaDot,x,xDot);
if(rand>epsilon)       % exploit
    [~,actionMax] = max(Q(box,:));
    currentAction = action(actionMax);
else                   % explore
    currentAction = datasample(action,1);
end
actionIndex1 = find(action == currentAction);

while(steps<=MAX_STEPS && failures<+MAX_FAILURES)
    steps = steps + 1;
    [thetaNext,thetaDotNext,thetaacc,xNext,xDotNext] = cart_pole2(currentAction,theta,thetaDot,x,xDot);
    thetaPlot(end + 1) = thetaNext;
    xPlot(end + 1) = xNext;
    newBox = getBox4(thetaNext,thetaDotNext,xNext,xDotNext);
    theta = thetaNext;
    thetaDot = thetaDotNext;
    x = xNext;
    xDot = xDotNext;
    if(newBox == 163)
        r = -1;
        Q(newBox,:) = 0;
        figure(2);
        plot((1:length(thetaPlot)),thetaPlot,'-ob');
        figure(3);
        plot((1:length(xPlot)),xPlot,'-og');
        thetaPlot = 0;
        xPlot = 0;
        %Swing Up. Find the box.
        theta = 0;
        thetaDot = 0;
        x = 0;
        xDot = 0;
        
        newBox = getBox4(theta,thetaDot,x,xDot);
        failures = failures + 1;
        fprintf('Trial %d was %d steps. \n',failures,steps);
        figure(1);
        plot(failures,steps,'-or');
        hold on;
        steps = 0;
    else
        r = 0;
    end
    if(rand > epsilon)  %exploit
        [~,newActionMax] = max(Q(newBox,:));
        newAction = action(newActionMax);
    else                %explore
        newAction = datasample(action,1);
    end
    actionIndex2 = find(action == newAction);
    Q(box,actionIndex1) = Q(box,actionIndex1) + ALPHA*(r + GAMMA*Q(newBox,actionIndex2) - Q(box,actionIndex1));
    box = newBox;
    currentAction = newAction;
    actionIndex1 = actionIndex2;
end

if(failures == MAX_FAILURES)
    fprintf('Pole not balanced. Stopping after %d failures.',failures);
else
    fprintf('Pole balanced successfully for at least %d steps\n', steps);
    figure(1);
    plot(failures+1,steps,'-or');
    hold on;
    figure(2);
    plot((1:length(thetaPlot)),thetaPlot,'-ob');
    figure(3);
    plot((1:length(xPlot)),xPlot,'-og');
    figure(4);
    plot((1:301),thetaPlot(1:301),'-ob');
    hold on;
    figure(5);
    plot((1:301),xPlot(1:301),'-og');
    hold on;
end