%run optimisations 

clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

%------------------------------

N = 5;
Uinf = 8;
TIinf = 6;
X = 7;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

vecX = [5 8 11];
vecN = [2 5 10];
vecU = [6 8 10];
vecTI = [6 10 14];


structTI = struct('TIArray',vecTI,'resultArray',{cell(length(vecTI),length(objs))},'deltaPArray',zeros(length(vecTI),length(objs)),'deltaLArray',zeros(length(vecTI),length(objs)));

for i = 1:length(vecTI)
    for j = 1:length(objs)
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,vecTI(i),X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        structTI.resultArray{i,j} = optimiserOut;
        structTI.deltaPArray(i,j) = deltaP;
        structTI.deltaLArray(i,j) = deltaL;
    end   
end

elapsedTime = toc;