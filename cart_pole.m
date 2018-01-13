%  cart_pole:  Takes an action (0 or 1) and the current values of the
%              four state variables and updates their values by estimating
%              the state,
%              TAU seconds later.
function [thetaNext,thetaDotNext,xNext,xDotNext] = cart_pole(action,theta,thetaDot,x,xDot)
%Parameters of inverted pendulum
GRAVITY = 9.8;
MASSCART = 1;
MASSPOLE = 0.1;
TOTAL_MASS = (MASSPOLE + MASSCART);
LENGTH = 0.5;
POLEMASS_LENGTH = (MASSPOLE*LENGTH);
FORCE_MAG = 10;
TAU = 0.02;
FOURTHIRDS = 1.3333333333333;

if (action>0)
    force = FORCE_MAG;
else
    force = -FORCE_MAG;
end

temp = (force + POLEMASS_LENGTH*thetaDot*thetaDot*sin(theta))/TOTAL_MASS;

thetaacc = (GRAVITY*sin(theta) - cos(theta)*temp)/(LENGTH*(FOURTHIRDS - MASSPOLE*cos(theta)*cos(theta)/TOTAL_MASS));

xacc = temp - POLEMASS_LENGTH*thetaacc*cos(theta)/TOTAL_MASS;

%Update the four state variables, using Euler's method
xNext = x + TAU*xDot;
xDotNext = xDot + TAU*xacc;
thetaNext = theta + TAU*thetaDot;
thetaDotNext = thetaDot + TAU*thetaacc;

return;
