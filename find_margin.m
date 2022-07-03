    clc
    k0 = 29;
    t = 0:00.1:10;
    w = logspace(-1,3,200);
    s = tf('s');
    K = k0*10 /(s+10);
    P = 1/(s^2+10*s+5);
    K_TF = tf(K);
    P_TF = tf(P);
    FBS = feedback(K_TF*P_TF,1); %feedback system
   
    y = step(FBS,t);

    OverShootValue = max(y);
    ys=y(length(t));
    overshoot = (OverShootValue - ys)/ys

    
    y = step(FBS,t);
    FBS_bode = loopsens(K_TF, P_TF);
    figure('name','bode');
    bode(FBS_bode.Si,'b', FBS_bode.Ti,'g', FBS_bode.Li,'r')
    legend('Sensitivity','Complementary Sensitivity','Loop Transfer')
    figure('name','output')
    plot(t,y) %output 
    grid on;
%     margin() %直接画出来bode plot并且写出数据，所以其他的数据基本上也不需要在用bode画图了s
%     [Gm,Pm,Wcg,Wcp] = margin()

%如果要加干扰并联就行了（加号）
%写一个循环的函数就可以控制overshoot

% 关于干扰:

% syms t s 
% D = 0.5*sin(t)
% d = laplace(D)
