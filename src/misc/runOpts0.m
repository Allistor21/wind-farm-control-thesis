%run optimisations 

clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

%------------------------------

N = 5;
Uinf = 8;
TIinf = 6;
X = 5;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

vecX = [5 8 11];
vecN = [2 5 10];
vecU = [6 8 10];
vecTI = [6 10 14];


structX = struct('XArray',vecX,'resultArray',{cell(length(vecX),length(objs))},'deltaPArray',zeros(length(vecX),length(objs)),'deltaLArray',zeros(length(vecX),length(objs)));

for i = 1:length(vecX)
    for j = 1:length(objs)
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,vecX(i),wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        structX.resultArray{i,j} = optimiserOut;
        structX.deltaPArray(i,j) = deltaP;
        structX.deltaLArray(i,j) = deltaL;
    end   
end

elapsedTime = toc;