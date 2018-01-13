%**********************************************************************************
% Learning to balance an inverted pendulum system using Reinforcement Learning
% Temporal Difference Algorithm - SARSA is used here to train the Neural Network.
%     The code involves the following functions:
%        main :             controls simulation interations and implements 
%                           the learning system.
% 
%        cart_pole:     the cart and pole dynamics; given action and
%                           current state, estimates next state
% 
%        getBox:           The cart-pole's state space is divided into 162
%                           boxes.  get_box returns the index of the box into
%                           which the current state appears.
%
% Learning parameters: 
% x: cart position, meters
% xDot: cart velocity
% theta: pole angle, radians
% thetaDot: pole angular velocity
% w: vector of action weights
% v: vector of critic weights
% e: vector of action weight eligibilities
% xBar: vector of critic weight eligibilities
%**********************************************************************************
clc;
clear all;
close all;
% System Constants
N_BOXES = 162;       % Number of discrete boxes of state space
ALPHA = 1000;        % Learning rate for action weights, w 
BETA = 0.5;          % Learning rate for critic weights, v
GAMMA = 0.95;        % Discount factor for critic
LAMDAw = 0.9;        % Decay rate for w eligibility trace
LAMDAv = 0.8;        % Decay rate for v eligibility trace 
MAX_FAILURES = 1000; % Termination criterion
MAX_STEPS = 100000; 

% Flags and variables
steps = 0;
failures = 0;
thetaPlot = 0;
xPlot = 0;
%Initialize action and heuristic critic weights and traces
w = zeros(N_BOXES,1);
v = zeros(N_BOXES,1);
xBar = zeros(N_BOXES,1);
e = zeros(N_BOXES,1);

%Starting state
theta = 0;
thetaDot = 0;
x = 0;
xDot = 0;

box = getBox(theta,thetaDot,x,xDot);

while(steps < MAX_STEPS && failures < MAX_FAILURES)
    steps = steps + 1;
    % Choose action randomly, biased by current weight
    y = (rand < probPushRight(w(box)));
    
    % Update traces
    e(box) = e(box) + (1 - LAMDAw)*(y - 0.5); % test
    xBar(box) = xBar(box) + (1 - LAMDAv);
    
    % Remember prediction of failure for current state
    oldp = v(box);
   
    %Apply action to the simulated cart pole
    [thetaNext,thetaDotNext,xNext,xDotNext] = cart_pole(y,theta,thetaDot,x,xDot);
    thetaPlot(end + 1) = thetaNext;
    xPlot(end + 1) = xNext;
    %Get box of state space containing the resulting state
    box = getBox(thetaNext,thetaDotNext,xNext,xDotNext);
    theta = thetaNext;
    thetaDot = thetaDotNext;
    x = xNext;
    xDot = xDotNext;
    
    if (box < 0)
        %Failure occurred
        failed = 1;
        failures = failures + 1;
        fprintf('Trial %d was %d steps. \n',failures,steps);
        figure(1);
        plot(failures,steps,'r*');
        hold on;
        figure(2);
        plot((1:length(thetaPlot)),thetaPlot,'-ob');
        figure(3);
        plot((1:length(xPlot)),xPlot,'-og');
        thetaPlot = 0;
        xPlot = 0;
       
        steps = 0;
        
        %Reset state to [0 0 0 0]. Find the box.
        theta = 0;
        thetaDot = 0;
        x = 0;
        xDot = 0;
        box = getBox(theta,thetaDot,x,xDot);
        
        %Reinforcement upon failure is adaptive. Prediction of failure is 0.
        r = -1;
        p = 0;
        
       
    else
        %Not a failure
        failed = 0;
        
        %Reinforcement is 0. Prediction of failure is given by v weight.
        r = 0;
        p = v(box);
%         figure(failures + 2);
%         plot(steps,theta,'*b');
%         hold on;
        
    end
    
    %  Heuristic reinforcement is:   
    %  current reinforcement + gamma * new failure prediction - previous failure prediction 
    rhat = r + GAMMA*p - oldp;

    
    for i = 1:N_BOXES,
        % Update weights

        w(i) = w(i) + ALPHA*rhat*e(i);
        v(i) = v(i) + BETA*rhat*xBar(i);
        
        if (failed)
            %If failure, zero all traces
            e(i) = 0;
            xBar(i) = 0;
        else
            %Otherwise update (decay) the traces
            e(i) = e(i)*LAMDAw;
            xBar(i) = xBar(i)*LAMDAv;
        end
    end
    
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








