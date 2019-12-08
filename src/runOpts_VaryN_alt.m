%run optimisations 
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\build'
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

diary log__VaryN_alt

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
structN = struct('NArray',vecN,'resultArray',{cell(length(vecN),length(objs))},'deltaPArray',zeros(length(vecN),length(objs)),'deltaLArray',zeros(length(vecN),length(objs)));
duration = zeros(length(vecN),length(objs));
for i = 1:length(vecN)
    for j = 1:length(objs)
        tStart = tic;
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser_alt(vecN(i),Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        duration(i,j) = toc(tStart);

        structN.resultArray{i,j} = optimiserOut;
        structN.deltaPArray(i,j) = deltaP;
        structN.deltaLArray(i,j) = deltaL;

        name = ['VaryN__N_' num2str(vecN(i)) '_obj_' num2str(objs(j)) '_alt.png'];
        saveas(gcf,name)
    end   
end

elapsedTime = toc;

diary off