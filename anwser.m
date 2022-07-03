clc
clear
k0 = 29; %（when overshoot is 10%, 50% and 100%, I used 29, 93 and 191 as the initial value = k, and I got those numbers by testing）
overshoot = 0;
while overshoot < 0.1%(choose 0.1, 0.5 and 1 respectively to setup what I want) 
    k0 = k0 + 0.01
    t = 0:000.1:10;
    s = tf('s');
    K = k0*10 /(s+10);
    P = 1/(s^2+10*s+5);
    X = AnalysisPoint('X');
    LG = K*P;
    FBS = feedback(K*P,X); %feedback system
   
    y = step(FBS,t);

    OverShootValue = max(y);
    ys=y(length(t));
    overshoot = (OverShootValue - ys)/ys
end

    T = getCompSensitivity(FBS,'X');
    S = getSensitivity(FBS,'X');
    
    y = step(FBS,t);
    
    figure('name','loopgain');
    margin(LG,'r')
    figure('name','complementary sensitivity');
    margin(T,'r')
    figure('name','sensitivity');
    margin(S,'r')
    figure('name','output')
    plot(t,y) %output 
    grid on;

    


