clear,clc
A = [-0.0064 9.255 0 -9.81 -0.896;
    -0.0234 -5.1414 0 0 0.9519;
    0 25 0 -24.9836 0;
    0 0 0 0 1;
    0.7047 -485.6225 0 0 -31.4645];
B = [-0.0520;0.1016;0;0;116.3];
%Added a 0 row to C and a 1 to D to
C = eye(5);
D = [0;0;0;0;0];
%Creating the state space model
P = ss(A,B,C,D);

%Creating plant model
Acu = tf(20,[1 20]);
PA = series(P,Acu);
%Abar 6X6
Abar = [A zeros(5,1);0 0 -1 0 0 0];

%Bbar 6X1
Bbar = [B;0];

%Q is 6X6
Q = [1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 1 0 0 0;
    0 0 0 1 0 0;
    0 0 0 0 1 0;
    0 0 0 0 0 100];

%Regulator
R = 1;
%LQR controller
K = lqr(Abar,Bbar,Q,R);
I = tf(1,[1 0]);
T = feedback(PA,K(1:5),1,[1:5]);
G = series(I,-K(6));
S = series(G,T);
Altitude = feedback(S,1,1,3);

t = 0:.01:10;
%plot the step
[y1,t1] = step(Altitude,t);
plot(t1,y1(:,3));






