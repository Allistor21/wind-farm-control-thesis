%Script to run the FASTnAT optimiser.

clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

%----------------------------


N = 5;
Uinf = 8;
TIinf = 6;
X = 5;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

%[optimiserOut1,deltaP1,deltaL1] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,1)

%[optimiserOut2,deltaP2,deltaL2] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,2)

[optimiserOut3,deltaP3,deltaL3] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,3)



elapsedTime = toc;