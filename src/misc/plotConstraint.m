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

figure('position',[0 0 900 600])

plot(sft3,[X,Y],Z)
ylabel('TI [%]');
xlabel(['\beta [' char(176) ']']);
zlabel('U [m/s]');


set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(findall(gcf,'-property','FontSize'),'FontSize',22)