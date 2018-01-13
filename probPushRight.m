function output = probPushRight(s)
output = 1/(1 + exp(-max(-50, min(s, 50))));
return
