%run optimisation, and vary inicial point
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\build'
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

diary log__x0_0

%------------------------------

N = 5;
Uinf = 8;
TIinf = 8;
X = 7;
wakeModelType = 'jensenCrespo';

%------------------------------

objs = [1 2 3];

%------------------------------

tic
struct_test = struct('resultArray',{cell(1,length(objs))},'deltaPArray',zeros(1,length(objs)),'deltaLArray',zeros(1,length(objs)));
duration = zeros(1,length(objs));
for j = 1:length(objs)
    tStart = tic;
    [optimiserOut,deltaP,deltaL] = FASTnATOptimiser_alt(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
    duration(j) = toc(tStart);

    struct_x0.resultArray{j} = optimiserOut;
    struct_x0.deltaPArray(j) = deltaP;
    struct_x0.deltaLArray(j) = deltaL;

    name = ['x0_0__obj_' num2str(objs(j)) '.png'];
    saveas(gcf,name)
end

diary off

elapsedTime = toc;