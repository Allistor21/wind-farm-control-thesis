%run optimisations 
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\build'
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

diary log__VaryTI_alt

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
structTI = struct('TIArray',vecTI,'resultArray',{cell(length(vecTI),length(objs))},'deltaPArray',zeros(length(vecTI),length(objs)),'deltaLArray',zeros(length(vecTI),length(objs)));
duration = zeros(length(vecTI),length(objs));
for i = 1:length(vecTI)
    for j = 1:length(objs)
        tStart = tic;
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser_alt(N,Uinf,vecTI(i),X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        duration(i,j) = toc(tStart);

        structTI.resultArray{i,j} = optimiserOut;
        structTI.deltaPArray(i,j) = deltaP;
        structTI.deltaLArray(i,j) = deltaL;

        name = ['VaryTI__TI_' num2str(vecTI(i)) '_obj_' num2str(objs(j)) '_alt.png'];
        saveas(gcf,name)
    end   
end

elapsedTime = toc;

diary off