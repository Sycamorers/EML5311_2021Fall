%with noise and disturbance 
data = sim('proj_lqr');
lqru= data.get('ulqr');
vlqr = vecnorm(lqru');
figure(1)
plot(vlqr)