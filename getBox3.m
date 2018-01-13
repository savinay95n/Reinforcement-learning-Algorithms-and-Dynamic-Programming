%   getBox:  Given the current state, returns a number from 1 to 162
%             designating the region of the state space encompassing the current state.
%             Returns a value of -1 if a failure state is encountered.

function box = getBox3(theta,thetaDot,x,xDot)
theta = rad2deg(theta);
thetaDot = rad2deg(thetaDot);
if (x < -1 || x > 1  || theta < -8 || theta > 8)     
    box = -1;
else


if (theta<-1&&theta>=-8)
	thetaBucket = 1;
elseif (theta<0&&theta>=-1)
	thetaBucket = 2;
elseif (theta<1&&theta>=0)	% zero included
	thetaBucket = 3;
elseif (theta<8&&theta>=1)
	thetaBucket = 4;
end

if (x<-0.8&&x>=-1)
	xBucket = 1;
elseif (x<=0.8&&x>=-0.8)
	xBucket = 2;
elseif (x<=1&&x>0.8)
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

box = sub2ind([4,3,3,3],thetaBucket, thetaDotBucket,xBucket,xDotBucket);
end
return;