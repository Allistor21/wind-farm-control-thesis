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


structN = struct('NArray',vecN,'resultArray',{cell(length(vecN),length(objs))},'deltaPArray',zeros(length(vecN),length(objs)),'deltaLArray',zeros(length(vecN),length(objs)));

for i = 1:length(vecN)
    for j = 1:length(objs)
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(vecN(i),Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        structN.resultArray{i,j} = optimiserOut;
        structN.deltaPArray(i,j) = deltaP;
        structN.deltaLArray(i,j) = deltaL;
    end   
end

elapsedTime = toc;