%Run optimisation

clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

%------------------------------

N = 5;
Uinf = 8;
TIinf = 6;
X = 7;
wakeModelType = 'jensenCrespo';
objs = 4;

weightArray = [0.3 0.6 0.9];

structWeights = struct('weightArray',weightArray,'resultArray',{cell(length(weightArray),1)},'deltaPArray',zeros(length(weightArray),1),'deltaLArray',zeros(length(weightArray),1));

for i = 1:length(weightArray)
    [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs,weightArray(i));
    structWeights.resultArray{i} = optimiserOut;
    structWeights.deltaPArray(i) = deltaP;
    structWeights.deltaLArray(i) = deltaL;
end

elapsedTime = toc;