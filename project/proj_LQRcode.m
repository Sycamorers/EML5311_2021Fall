clc
clear

n = 9.1017e-4;
m = 1.66e-3;
x0 = [-3.1;-39.16;0.00002;0.0041];

A = [0 0 1 0;
     0 0 0 1;
     3*n^2 n 0 2*n;
     -n 0 -2*n 0];
B = [0 0;
     0 0;
     m 0;
     0 m];
C = [1 0 0 0;
     0 0 0 1];
D = [0 0;
     0 0];
Q = [1 0 0 0;
     0 1 0 0;
     0 0 1 0;
     0 0 0 2000];
R = 1;
K = lqr(A,B,Q,R) 

QB = [1 0 0 0;
      0 1 0 0;
      0 0 1 0;
      0 0 0 2000];
RB = 1;

L = lqr(A',C',QB,RB)';



s = tf('s');
actuator1  = 1/(0.1*s+1);
actuator2 = 1/(10*s+1);

%observer
AO=A-L*C;
BO=[B L];
CO=eye(4);
DO=zeros(4);
O=ss(AO,BO,CO,DO);

Q=eye(4);
Q(4,4)=1000;
Q(3,3)=1;
R=1;

K=lqr(A,B,Q,R);

K_mod=series(O,K);
C2=[1 0 0 0;0 0 0 1;0 0 0 0;0 0 0 0];
D2=zeros(4,2);
P2=ss(A,B(:,1),C2,D2(:,1));

s = tf('s');
F_lqr=series(1/s,P2);
open1=series(actuator1,F_lqr);
close1=feedback(open1,K_mod(1,:),1,1:4);

open2=series(actuator2,F_lqr);
close2=feedback(open2,K_mod(2,:),1,1:4);

%sensitivity
S_lqr1=1/(1+close1(1,1));
S_lqr2=1/(1+close2(2,1));

figure(1)
bode(S_lqr1) 
title('LQR Sensitivity wrt u1')

figure(2)
bode(S_lqr2) 
title('LQR Sensitivity wrt u2')