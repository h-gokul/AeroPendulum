% Based on the mathematical model correction and Feed back linearization,
% the transfer Function of the system was found to possess poles at 0 and
% 'z'. For the sake of analysis, lets consider a = 420 b=69 c=0 for the
% Second order system.

g=tf(1,[420 69 0])
rlocus(g)

% We analyse the Two extremes (under/overdamped) to initalise Kp , In order to find the optimal
% value by trial and error.

% Analysing step input response for a Kp of 0.1  (Presuming to be
% overdamped) 
step(0.2*g/(1+0.2*g),[0:0.1:1000])

% Analysing step input response for a Kp of 50 (Presuming to be underdamped)
step(50*g/(1+50*g),[0:0.1:100])

% However, The actual system TF varies depending on the physical parameters
% of the system.  By incorporating appropriate model parameters, one can
% Simulate and obtain the Kp constant with this experiment.