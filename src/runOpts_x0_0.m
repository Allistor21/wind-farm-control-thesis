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

x0 = ones(1,N)*0.1;

%------------------------------

tic
struct_x0 = struct('x0',x0,'resultArray',{cell(1,length(objs))},'deltaPArray',zeros(1,length(objs)),'deltaLArray',zeros(1,length(objs)));
duration = zeros(1,length(objs));
for j = 1:length(objs)
    [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,x0,objs(j))

    if j == 1
        duration(j) = toc;
    else
        duration(j) = toc;
        for i = 1:(j-1)
            duration(j) = duration(j) - duration(i);
        end
    end

    struct_x0.resultArray{j} = optimiserOut;
    struct_x0.deltaPArray(j) = deltaP;
    struct_x0.deltaLArray(j) = deltaL;

    name = ['x0_0__obj_' num2str(objs(j)) '.png'];
    saveas(gcf,name)
end

diary off

elapsedTime = toc;