%run optimisation, and vary a weight
clear all

tic

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\build'
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

diary log__Weight

%------------------------------

N = 5;
Uinf = 8;
TIinf = 8;
X = 7;
wakeModelType = 'jensenCrespo';

%------------------------------

objs = 4;
x0 = ones(1,N)*0.1;

weights = [0.3 0.5 0.7];

%------------------------------

struct_weight = struct('weights',weights,'resultArray',{cell(1,length(weights))},'deltaPArray',zeros(1,length(weights)),'deltaLArray',zeros(1,length(weights)));
duration = zeros(1,length(weights));
for j = 1:length(weights)
    tStart = tic;
    [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,x0,objs,weights(j))
    duration(j) = toc(tStart);

    struct_x0.resultArray{j} = optimiserOut;
    struct_x0.deltaPArray(j) = deltaP;
    struct_x0.deltaLArray(j) = deltaL;

    name = ['Weight_' num2str(weights(j)*100) '.png'];
    saveas(gcf,name)
end

diary off

elapsedTime = toc;