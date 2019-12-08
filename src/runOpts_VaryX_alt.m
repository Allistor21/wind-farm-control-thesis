%run optimisations 
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\build'
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

diary log__VaryX_alt

%------------------------------

N = 5;
Uinf = 8;
TIinf = 6;
X = 7;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

%-----------------------------

vecX = [5 8 11];
vecN = [2 5 10];
vecU = [6 8 10];
vecTI = [6 10 14];

%--------------------

tic
structX = struct('XArray',vecX,'resultArray',{cell(length(vecX),length(objs))},'deltaPArray',zeros(length(vecX),length(objs)),'deltaLArray',zeros(length(vecX),length(objs)));
duration = zeros(length(vecX),length(objs));
for i = 1:length(vecX)
    for j = 1:length(objs)
        tStart = tic;
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser_alt(N,Uinf,TIinf,vecX(i),wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        duration(i,j) = toc(tStart);

        structX.resultArray{i,j} = optimiserOut;
        structX.deltaPArray(i,j) = deltaP;
        structX.deltaLArray(i,j) = deltaL;

        name = ['VaryX__X_' num2str(vecX(i)) '_obj_' num2str(objs(j)) '_alt.png'];
        saveas(gcf,name)
    end   
end

elapsedTime = toc;

diary off