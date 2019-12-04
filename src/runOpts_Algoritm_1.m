%Script to run the FASTnAT optimiser.
clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

%---------------------------------

N = 3;
Uinf = 8;
TIinf = 6;
X = 7;
wakeModelType = 'jensenCrespo';
x0 = ones(1,N);

objs = [1 2 3];
algs = 'active-set';

structAlgs = struct('Algorithm',algs,'resultArray',{cell(1,length(objs))},'deltaPArray',zeros(1,length(objs)),'deltaLArray',zeros(1,length(objs)));


for j = 1:length(objs)
    [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,x0,objs(j))
    structAlgs.resultArray{j} = optimiserOut;
    structAlgs.deltaPArray(j) = deltaP;
    structAlgs.deltaLArray(j) = deltaL;
end  



elapsedTime = toc;