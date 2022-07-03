clc 
clear
%state space
A = [-0.0064 9.2250 0 -9.8100 -0.8960;
    -0.0234 -5.1414 0 0 0.9519;
    0 25.000 0 -24.9836 0;
    0 0 0 0 1;
    0.7047 -485.6225 0 0 -31.4645];
B = [-0.0520;0.1016;0;0;116.3];
C = [0 0 1 0 0; 
    0 0 0 1 0; 
    0 0 0 0 1];
D = [0;0;0]; 
P = ss(A,B,C,D);
Acuator = tf(20,[1 20]);
AP = series(Acuator,P);
%
%loop1
KQ = pid(1,40,0.01);
QA = series(KQ,Acuator);
QAP = series(QA,P);
QAPfeedback = feedback(QAP,1,1,3);
% 
% %loop2
Ktheta = pid(20,10,0.01);
TQAP = series(Ktheta,QAPfeedback);
TQAPfeedback = feedback(TQAP,1,1,2);
%
% %%loop3
Kh = pid(0.08,0.05,0.04);
HTQAP = series(-Kh,TQAPfeedback);
HTQAPfeedback = feedback(HTQAP,1,1,1);

opt = stepDataOptions('InputOffset',100,'StepAmplitude',100);
t = 0:.01:10;
[y1,t1] = step(QAPfeedback(3),t);
[y2,t2] = step(TQAPfeedback(2),t);
[y3,t3] = step(HTQAPfeedback(1),t);
[y4,t4] = step(HTQAPfeedback(1),opt);
%to get information of performance
S3 = stepinfo(y3,t3)


figure
plot(t1,y1,'r',t2,y2,'g',t3,y3,'b')
legend('q','\theta','h')
figure
plot(t4,y4,'color',[0.625, 0.124,0.9375])
figure
rlocus(AP(1))
figure
rlocus(AP(2))
figure
rlocus(AP(3))

