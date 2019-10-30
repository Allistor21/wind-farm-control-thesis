%Script to run the FASTnAT optimiser.
clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_5.mat

N = 2;
TIinf = 6;
wakeModelType = 'jensenCrespo';
X = 7;
Uinf = 8;
obj = 3;


[optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,obj)



elapsedTime = toc;