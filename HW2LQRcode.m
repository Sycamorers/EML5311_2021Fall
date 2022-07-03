clc 
clear
%state space
A = [-0.0064 9.2250 0 -9.8100 -0.8960;
    -0.0234 -5.1414 0 0 0.9519;
    0 25.000 0 -24.9836 0;
    0 0 0 0 1;
    0.7047 -485.6225 0 0 -31.4645];
B = [-0.0520;0.1016;0;0;116.3];
C =eye(5);
D = [0;0;0;0;0];
P = ss(A,B,C,D);
%actuator 
Ac = tf(20,[1 20]);
AP = series(P,Ac);

%controllability & observability
con = ctrb(A,B);
R1 = rank(con)
obs = obsv(A,C);
R2 = rank(obs)
%new state space model with error state
Abar = [A zeros(5,1);0 0 -1 0 0 0];
Bbar = [B;0];
%Q&R designing
Q = [1 0 0 0 0 0;
      0 1 0 0 0 0;
      0 0 1 0 0 0;
      0 0 0 1 0 0;
      0 0 0 0 1 0;
      0 0 0 0 0 100];
R1 = 1;
R2 = 150;

%LQR
K1 = lqr(Abar,Bbar,Q,R1);
K2 = lqr(Abar,Bbar,Q,R2);


I = tf(1,[1 0]);
%loop building
T1 = feedback(AP,K1(1:5),1,[1:5]);
G1 = series(I,-K1(6));
S1 = series(G1,T1);
X1 = feedback(S1,1,1,3);

T2 = feedback(AP,K2(1:5),1,[1:5]);
G2 = series(I,-K2(6));
S2 = series(G2,T2);
X2 = feedback(S2,1,1,3);

%making a 100 step
opt = stepDataOptions('InputOffset',100,'StepAmplitude',100);

[y1,t1] = step(X1,opt);
[y2,t2] = step(X2,opt);

S1 = stepinfo(y1(:,3),t1)
S2 = stepinfo(y2(:,3),t2)
plot(t1,y1(:,3),'b',t2,y2(:,3),'g')
legend('no regulation on actuator','with regulation on actuator')



