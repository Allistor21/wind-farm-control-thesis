%run optimisations 

clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

%------------------------------

N = 3;
Uinf = 8;
TIinf = 6;
X = 7;
wakeModelType = 'jensenCrespo';

vec_X = [5 8 11];
objs = (1:1:3);
x0 = [1 3 5];


structX = struct('XArray',vec_X,'resultArray',{cell(length(vec_X),length(objs))},'deltaPArray',zeros(length(vec_X),length(objs)),'deltaLArray',zeros(length(vec_X),length(objs)));

for i = 1:length(vec_X)
    for j = 1:length(objs)
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,vec_X(i),wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,x0,objs(j))
        structX.resultArray{i,j} = optimiserOut;
        structX.deltaPArray(i,j) = deltaP;
        structX.deltaLArray(i,j) = deltaL;
    end   
end

elapsedTime = toc;