%   getBox:  Given the current state, returns a number from 1 to 162
%             designating the region of the state space encompassing the current state.
%             Returns a value of -1 if a failure state is encountered.

function box = getBox5(theta,thetaDot,x,xDot)
theta = rad2deg(theta);
thetaDot = rad2deg(thetaDot);
if (x < -2.4 || x > 2.4  || theta < -12 || theta > 12)     
    box = 379;
else

if(theta>=-12 && theta<=-10)
    thetaBucket = 1;
elseif(theta>-10 && theta<=-8)
    thetaBucket = 2;
elseif(theta>-8 && theta<=-6)
    thetaBucket = 3;
elseif(theta>-6 && theta<=-4)
    thetaBucket = 4;
elseif(theta>-4 && theta<=-2)
    thetaBucket = 5;
elseif(theta>-2 && theta<=-1)
    thetaBucket = 6;
elseif(theta>-1 && theta<=0)
    thetaBucket = 7;
elseif(theta>0 && theta<=1)
    thetaBucket = 8;
elseif(theta>1 && theta<=2)
    thetaBucket = 9;
elseif(theta>2 && theta<=4)
    thetaBucket = 10;
elseif(theta>4 && theta<=6)
    thetaBucket = 11;
elseif(theta>6 && theta<=8)
    thetaBucket = 12;
elseif(theta>8 && theta<=10)
    thetaBucket = 13;
elseif(theta>10 && theta<=12)
    thetaBucket = 14;
end

if (x<-0.8&&x>=-2.4)
	xBucket = 1;
elseif (x<=0.8&&x>=-0.8)
	xBucket = 2;
elseif (x<=2.4&&x>0.8)
	xBucket = 3;
end

if (xDot<-0.5)
	xDotBucket = 1;
elseif (xDot>=-0.5&&xDot<=0.5)
	xDotBucket = 2;
else
	xDotBucket = 3;
end

if (thetaDot<-50)
	thetaDotBucket = 1;
elseif (thetaDot>=-50&&thetaDot<=50)
	thetaDotBucket = 2;
else
	thetaDotBucket = 3;
end

box = sub2ind([14,3,3,3],thetaBucket, thetaDotBucket,xBucket,xDotBucket);
end
return;