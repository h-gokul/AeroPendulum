M = 0.5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

% Define the System Model 
q = (M+m)*(I+m*l^2)-(m*l)^2;
s = tf('s');
P_pend = (m*l*s/q)/(s^3 + (b*(I + m*l^2))*s^2/q - ((M + m)*m*g*l)*s/q - b*m*g*l/q);

% Plot root locus for the pendulum
rlocus(P_pend)
title('Root Locus of Plant (under Proportional Control)')
% Inference from Plot: there will be a branch of root locus entirely on the
% right half of the s plane. Thus inherently unstable. we could remove this
% by adding a pole at origin (integrate)


% Plot root locus for the pendulum with an integral control
C = 1/s;
rlocus(C*P_pend)
title('Root Locus with Integral Control')
zeros = zero(C*P_pend)
poles = pole(C*P_pend)
%Inference from Plot : There are still branches on the right half of the s plane. 
% There is one Zero and four poles in this Tf. By adding zeros to the controller strategically, 
% one can eliminate cancel the right half zeros. Thus adding zeros -3,-4.
% This addition of zeros and poles with a gain constitutes a PID Controller. 

z = [-3 -4];
p = 0;
k = 1;
C = zpk(z,p,k);
rlocus(C*P_pend)
title('Root Locus with PID Controller')
%Inference from the Plot: Upon inspecting the plot it was possible for the
%system requirements(desitred settling time <5 secs) to be met with this controller.
% Hence we need to figure out the gain of the system at the stable left half of s plane. 

% Select a point in the plot at left half(stable region) and type [k,poles] = rlocfind(C*P_pend)
% It was inferred that K is almost equal to 20. Let's experiment the
% impulse response at 20

K = 20;
T = feedback(P_pend,K*C);
impulse(T)
title('Impulse  Response of Pendulum Angle under PID Control');
% Inference from the Plot: System settles appropriately


%The same controller was experimented for the cart's movement too
P_cart = (((I+m*l^2)/q)*s^2 - (m*g*l/q))/(s^4 + (b*(I + m*l^2))*s^3/q - ((M + m)*m*g*l)*s^2/q - b*m*g*l*s/q);
T2 = feedback(1,P_pend*C)*P_cart;
t = 0:0.01:8.5;
impulse(T2, t);
title('Impulse Disturbance Response of Cart Position under PID Control');
% It was seen that the system went unstable for the cart. It is not
% feasible to implement the same system for both Pendulum and the cart as a
% SIMO system. However, Root locus is studied.