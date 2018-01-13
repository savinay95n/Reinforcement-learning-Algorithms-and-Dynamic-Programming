%Swing Up Model using Euler's Approximation

function F = SwingUpController2(theta,thetaDot,thetaDotDot,x,xDot)
ua = 5;
lamda = 2;
m = 0.1;
M = 1;
l = 0.5;
Ip = 4*m*l*l/3;
g = 9.8;
Ep = 0.5*Ip*thetaDot*thetaDot + m*g*l*(cos(theta) - 1);

u = ua*(Ep*cos(theta)*thetaDot - lamda*xDot);
F = (M + m)*u - m*l*thetaDot*thetaDot*sin(theta) + m*l*cos(theta)*thetaDotDot;

return;
