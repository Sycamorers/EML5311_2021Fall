clc
clear 


n = 9.1017e-4;
m = 1.66e-3;
initialstate= [-3.1;-39.16;0.00002;0.0041];

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

kp1 = 4.5;
ki1 = 1.7;
kd1 = 500;

kp2 = 1.35;
ki2 = 0.005;
kd2 = 150.643;

s = tf('s');

actuator1  = 1/(0.1*s+1);
Plant1=ss(A,B(:,1),C(1,:),0);
piterms1=s/(s*kp1+ki1) - 1/kp1;
kdkpterm1=parallel(series(kd1,s),kp1);
KA1=series(kdkpterm1,actuator1);
actu1=feedback(KA1,piterms1,1,1);
open1=series(actu1,Plant1);
close1=feedback(open1,1,1,1);

S_pid1=1/(1+close1); %sensitivity

figure
bode(S_pid1) %bandwidth plot
title('Sensitivity of u_{1}')
b1 = bandwidth(close1)

figure
margin(close1) %gm/pm plot



%u2
actuator2 = 1/(10*s+1);
Plant2=ss(A,B(:,2),C(2,:),0);
piterms2=s/(s*kp2+ki2) - 1/kp2;
kdkptem1=parallel(series(kd2,s),kp2);
KA2=series(kdkptem1,actuator2);
actu2=feedback(KA2,piterms2,1,1);
open2=series(actu2,Plant2);
close2=feedback(open2,1,1,1);

S_pid2=1/(1+close2); %sensitivity

figure
bode(S_pid2) %bandwidth plot
title('Sensitivity of u_{2}')

figure
margin(close2) %gm/pm plot
b2 = bandwidth(close2)

