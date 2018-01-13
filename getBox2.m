function[box,flag] = getBox2(theta,thetaDot,x,xDot)
theta = wrapTo180(rad2deg(theta));
thetaDot = rad2deg(thetaDot);
flag = 0;
if(theta>=-180&&theta<-150)
    thetaBucket = 1;
    flag = -1;
elseif(theta>=-150&&theta<-120)
    thetaBucket = 2;
    flag = -1;
elseif(theta>=-120&&theta<-90)
    thetaBucket = 3;
    flag = -1;
elseif(theta>=-90&&theta<-60)
    thetaBucket = 4;
    flag = -1;
elseif(theta>=-60&&theta<-30)
    thetaBucket = 5;
    flag = -1;
elseif(theta>=-30&&theta<-24)
    thetaBucket = 6;
    flag = -1;
elseif(theta>=-24&&theta<-18)
    thetaBucket = 7;
    flag = -1;
elseif(theta>=-18&&theta<-12)
    thetaBucket = 8;
    flag = -1;
elseif(theta>=-12&&theta<-6)
    thetaBucket = 9;
elseif(theta>=-6&&theta<-1)
    thetaBucket = 10;
elseif(theta>=-1&&theta<0)
    thetaBucket = 11;
elseif(theta>=0&&theta<1)
    thetaBucket  =12;
elseif(theta>=1&&theta<6)
    thetaBucket = 13;
elseif(theta>=6&&theta<12)
    thetaBucket = 14;
elseif(theta>=12&&theta<18)
    thetaBucket = 15;
    flag = -1;
elseif(theta>=18&&theta<24)
    thetaBucket = 16;
    flag = -1;
elseif(theta>=24&&theta<30)
    thetaBucket = 17;
    flag = -1;
elseif(theta>=30&&theta<60)
    thetaBucket = 18;
    flag = -1;
elseif(theta>=60&&theta<90)
    thetaBucket = 19;
    flag = -1;
elseif(theta>=90&&theta<120)
    thetaBucket = 20;
    flag = -1;
elseif(theta>=120&&theta<150)
    thetaBucket = 21;
    flag = -1;
elseif(theta>=150&&theta<=180)
    thetaBucket = 22;
    flag = -1;
end
if (x < -2.4 || x > 2.4)
    flag = -1;
    xBucket = 1;
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

box = sub2ind([22,3,3,3],thetaBucket,thetaDotBucket,xBucket,xDotBucket);

    


    