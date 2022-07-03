%with noise and disturbance 
data = sim('proj_pid');
pidu2= data.get('u');
v = vecnorm(pidu2');
figure(1)
plot(v)

