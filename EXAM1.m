sys m c k r1 r2 q
A = [-k/m -c/m;0 1];
B = [1/m;0];

Q = [r1 0;0 r2];
R = q;
K = lqr(A,B,Q,R)