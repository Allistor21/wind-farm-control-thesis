%Script to test optimisation functions.

diary myDiaryFile.txt

clear all

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

N = 1;
Uinf = 8;
TIinf = 6;
X = 7;
wakeModelType = 'jensenCrespo';
objs = 1;
x0 = ones(1,N)*0.1;
alg = 'trust-region-reflective';

options = optimoptions(@fmincon,'Algorithm',alg,'Display','iter','PlotFcn','optimplotfval')

[optOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,x0,objs,options);


diary off