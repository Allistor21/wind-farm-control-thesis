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

vecX = [3 5 7 9 11];
vecN = [2 5 10];
vecU = [6 7 8 9 10 11];
vecTI = [6 10 14];


structN = struct('NArray',vecN,'resultArray',{cell(length(vecN),length(objs))},'deltaPArray',zeros(length(vecN),length(objs)),'deltaLArray',zeros(length(vecN),length(objs)));

for i = 1:length(vecN)
    for j = 1:length(objs)
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(vecN(i),Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        structX.resultArray{i,j} = optimiserOut;
        structX.deltaPArray(i,j) = deltaP;
        structX.deltaLArray(i,j) = deltaL;
    end   
end

elapsedTime = toc;