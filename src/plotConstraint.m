%script to plot constraint
close all


x = pitchArray;
y = (6:2:20);
z = errMap;

[X, Y, Z] = prepareSurfaceData(x, y, z);

fitType = 'poly31';

sft3 = fit([X,Y],Z,fitType);

figure
plot(sft3,[X,Y],Z)





