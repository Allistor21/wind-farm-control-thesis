%script to plot constraint
close all
clear all

load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\errorMapRun3.mat');

x = pitchArray;
y = (6:2:20);
z = errMap;

[X, Y, Z] = prepareSurfaceData(x, y, z);

fitType = 'linearinterp';

sft3 = fit([X,Y],Z,fitType);

figure

plot(sft3,[X,Y],Z)
ylabel('Turbulence intensity [%]');
xlabel('Pitch Setting');
zlabel('Wind Speed [m/s]');


% U = FAST10AT.turbineU;
% TI = FAST10AT.turbineTI;
% 
% for i = 1:10
%     valores(i) = fitFun(coeffsFitObjArrayCt,0,U(i),TI(i));
% end





