% %script to plot constraint
% close all
% 
% 
% x = pitchArray;
% y = (6:2:20);
% z = errMap;
% 
% [X, Y, Z] = prepareSurfaceData(x, y, z);
% 
% fitType = 'poly31';
% 
% sft3 = fit([X,Y],Z,fitType);
% 
% figure
% plot(sft3,[X,Y],Z)

U = 8;
TI = 6;

valores(1) = fitFun(coeffsFitObjArray1,0,U,TI);
for i = 2:5
    Ct = fitFun(coeffsFitObjArrayCt,0,U,TI);
    [U,TI] = wakeModel('jensenCrespo',Ct,U,5,8,6);
    valores(i) = fitFun(coeffsFitObjArray1,0,U,TI);
end





