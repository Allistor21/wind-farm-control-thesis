%Script to run the FASTnAT optimiser.
clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

%---------------------------------

N = 5;
Uinf = 8;
TIinf = 6;
X = 5;
wakeModelType = 'jensenCrespo';
objs = [1 2 3];


structGebraad = struct('resultArray',{cell(1,length(objs))},'deltaPArray',zeros(1,length(objs)),'deltaLArray',zeros(1,length(objs)));

for i = 1:3
    [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(i))
    structGebraad.resultArray{i} = optimiserOut;
    structGebraad.deltaPArray(i) = deltaP;
    structGebraad.deltaLArray(i) = deltaL;
end

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


structX = struct('XArray',vecX,'resultArray',{cell(length(vecX),length(objs))},'deltaPArray',zeros(length(vecX),length(objs)),'deltaLArray',zeros(length(vecX),length(objs)));

for i = 1:length(vecX)
    for j = 1:length(objs)
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,vecX(i),wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        structX.resultArray{i,j} = optimiserOut;
        structX.deltaPArray(i,j) = deltaP;
        structX.deltaLArray(i,j) = deltaL;
    end   
end


structN = struct('NArray',vecN,'resultArray',{cell(length(vecN),length(objs))},'deltaPArray',zeros(length(vecN),length(objs)),'deltaLArray',zeros(length(vecN),length(objs)));

for i = 1:length(vecN)
    for j = 1:length(objs)
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(vecN(i),Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        structX.resultArray{i,j} = optimiserOut;
        structX.deltaPArray(i,j) = deltaP;
        structX.deltaLArray(i,j) = deltaL;
    end   
end


structU = struct('UArray',vecU,'resultArray',{cell(length(vecU),length(objs))},'deltaPArray',zeros(length(vecU),length(objs)),'deltaLArray',zeros(length(vecU),length(objs)));

for i = 1:length(vecU)
    for j = 1:length(objs)
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,vecU(i),TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        structX.resultArray{i,j} = optimiserOut;
        structX.deltaPArray(i,j) = deltaP;
        structX.deltaLArray(i,j) = deltaL;
    end   
end


structTI = struct('TIArray',vecTI,'resultArray',{cell(length(vecTI),length(objs))},'deltaPArray',zeros(length(vecTI),length(objs)),'deltaLArray',zeros(length(vecTI),length(objs)));

for i = 1:length(vecTI)
    for j = 1:length(objs)
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,vecTI(i),X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        structX.resultArray{i,j} = optimiserOut;
        structX.deltaPArray(i,j) = deltaP;
        structX.deltaLArray(i,j) = deltaL;
    end   
end



elapsedTime = toc;