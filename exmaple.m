function main_GetPerformanceOfStepResponse
clc
clear 
close all

global gTolerance
gTolerance=0.05;

%% test
clf;
n=[2];
m=[1 6 27];
g=tf(n,m);
t = 0:0.01:15;
y = step(g,t);

ys=y(length(t)) ;%求最终响应值
[OverShoot, RiseTime, PeakTime, AdjustTime, SteadyStateError] = GetPerformanceOfStepResponse(t, y, ys);

figure
plot(t,y)
grid on

line([PeakTime, PeakTime], [0, (1 + OverShoot/100)*ys], 'color', 'r')
text(PeakTime,ys*0.05, sprintf('峰值时间%.2f',PeakTime))
text(PeakTime, (1 + OverShoot/100 + 0.05)*ys, sprintf('超调量%.2f%%',OverShoot))

line([RiseTime, RiseTime], [0, ys], 'color', 'r')
text(RiseTime, -ys*0.05, sprintf('上升时间%.2f',RiseTime))

line([AdjustTime, AdjustTime], [0,ys*(1 + gTolerance)], 'color', 'r')
text(AdjustTime, ys*0.05, sprintf('调整时间%.2f',AdjustTime))

line([AdjustTime t(end)], ys*[(1 - gTolerance), (1 - gTolerance)], 'color', 'r', 'linestyle', '--')
text(AdjustTime, ys*(1 - gTolerance), sprintf('容许范围%.2f', 1 - gTolerance))
line([AdjustTime t(end)], ys*[(1 + gTolerance), (1 + gTolerance)], 'color', 'r', 'linestyle', '--')
text(AdjustTime, ys*(1 + gTolerance), sprintf('容许范围%.2f', 1 + gTolerance))
text(t(end)*0.9, ys*1.05, sprintf('稳态误差%f', SteadyStateError))

end

function [OverShoot, RiseTime, PeakTime, AdjustTime, SteadyStateError] = GetPerformanceOfStepResponse(t, y, ys)
% 超调量Mp:最大超调量规定为在暂态期间输出超过对应于输入的终值的最大偏离量
% 上升时间tr:在暂态过程中，输出第一次达到对应于输入的终值的时间（从t=0开始计时）
% 峰值时间tp:对应于最大超调量发生的时间（从t=0开始计时）
% 调整时间ts:输出与其对应于输入的终值之间的偏差达到容许范围（一般取5%或2%）所经历的暂态过程时间（从t=0开始计时）
% 稳态误差err:给定输入与稳态输出的差值

global gTolerance

% 超调量和峰值时间
[OSValue, OSIndex] = max(y);
ys=y(length(t)) ;
OverShoot = (OSValue - ys)/ys*100;
PeakTime = t(OSIndex);

% 上升时间
index = find(y >= ys, 1, 'first');
RiseTime = t(index);

% 调整时间和稳态误差
index1 = find(y <= ys*(1 - gTolerance), 1, 'last'); % 容许范围由全局变量指定
index2 = find(y >= ys*(1 + gTolerance), 1, 'last');

if isempty(index2) % 如果没有超调量，此值为空
    index0 = index1;
else
    index0 = max(index1, index2);
end

AdjustTime = t(index0);

SteadyStateError =1-mean(y(index0:end)) ; % 这里的稳态误差计算为调整时间后的数据平均值与给定输入的差，概念上是最后时刻的值与给定输入的差

end
