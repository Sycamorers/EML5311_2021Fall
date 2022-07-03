clc
clear

syms s gamma alpha beta 
k1 = alpha/(s+alpha);
k2 = (s-alpha)/(s+beta);
k3 = (s+gamma)/(s-gamma);
p = (s-gamma)/(s+alpha);

t = k1*k2*k3*p/(k2*k3*p+k3*p+1);

T = simplify(t)
solves = ((alpha + s)*(alpha*beta - alpha*gamma + beta*gamma + 2*beta*s + 2*gamma*s + 3*s^2))
% roots = solve(solves,s)
% sr = simplify(roots)