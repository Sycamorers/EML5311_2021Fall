clc 
clear
double m c k r1 r2 q
%state space
A = [0 1 0;
    -k/m -c/m 0;
    -1 0 0];
B = [0;1/m;0];

Q =[r1 0 0;
     0 r2 0;
     0 0 100];
R = q;


K= lqr(A,B,Q,R)
