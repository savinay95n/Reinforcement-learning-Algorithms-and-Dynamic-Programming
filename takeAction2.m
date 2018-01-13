function [xSAnew] = takeAction2(xSA,A)
	MAX_FORCE = -10;
	% Convert force: A = [1,2] to F = [-MAX_FORCE,MAX_FORCE]
	F = ((A*2)-3)*MAX_FORCE;
	
	% apply signal on plant model
	xSAnew = cartPole(F,xSA);
	
	% convert to boxes system/discrete states
	%[Snew,R] = getBox(realSnew);
	
end