%Swing Up Model using Euler's Approximation

function[thetaNext,thetaDotNext,xNext,xDotNext] = SwingUpController(theta,thetaDot,x,xDot)
ua = 5;
lamda = 1;
m = 0.1;
M = 1;
l = 0.5;
Ip = 4*m*l*l/3;
g = 9.8;
tau = 0.02;
Ep = 0.5*Ip*thetaDot*thetaDot + m*g*l*(cos(theta) - 1);

u = ua*(Ep*cos(theta)*thetaDot - lamda*xDot);
thetaDotDot = (g*sin(theta) - u*cos(theta))/(4*l/3);

thetaDotNext = thetaDot + tau*thetaDotDot;
thetaNext = theta + tau*thetaDot;
xDotNext = xDot + tau*u;
xNext = x + tau*xDot;
return;
