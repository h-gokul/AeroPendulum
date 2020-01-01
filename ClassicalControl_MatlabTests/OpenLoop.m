
% This is an example snippet of data for input signal and the corresponding Output This was obtained by Open loop test done in Simulink 1 module. 
u_ss=[0 10 20 30 40 50 60 70 80 90 100 110 120 127];
theta_ss=[0 0 0 2.5 6.8 10.5 14 20 24.5  29.  33.4 38  42 43];

% The mathematical relationship of a pendulum shows a linear relationship between input
% and sine of the output.
sine_ss=sind(theta_ss);
figure
P =polyfit(sine_ss(3:14),u_ss(3:14),1) % Estimating Design parameters from the open loop response signal.
plot(sine_ss,u_ss,sine_ss(3:14), polyval(P,sine_ss(3:14)))
shg
legend('Practical','Linear Approximation')