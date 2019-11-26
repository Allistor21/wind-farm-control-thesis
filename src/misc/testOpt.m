%
% 
% 
% A = [];
% b = [];
% Aeq = [];
% beq = [];
% lb = [0];
% ub = [5];
% 
% x0 = [1];
% 
% %fun = sweepFitObjStruct.fitObjMatrix{1,1};
% fun = coeffsFitObjArray1{1};
% 
% x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub)

clear all

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

N = 5;
Uinf = 8;
TIinf = 6;
X = 5;
wakeModelType = 'jensenCrespo';
objs = 1;

[gebraadOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs);
