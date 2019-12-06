%run optimisations 
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\build'
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

diary log__VaryX

%------------------------------

N = 5;
Uinf = 8;
TIinf = 6;
X = 7;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);
x0 = ones(1,N)*0.1;

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
        [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,vecX(i),wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,x0,objs(j))

        if j == 1 & i == 1
            duration(i,j) = toc;
        else
            duration(i,j) = toc;
            for t = 1:(i-1)
                if t == i
                    for f = 1:(j-1)
                        duration(i,j) = duration(i,j) - duration(t,f);
                    end
                else
                    for f = 1:3
                        duration(i,j) = duration(i,j) - duration(t,f);
                    end
                end
            end
        end

        structX.resultArray{i,j} = optimiserOut;
        structX.deltaPArray(i,j) = deltaP;
        structX.deltaLArray(i,j) = deltaL;

        name = ['VaryX__N_' num2str(vecX(i)) '_obj_' num2str(objs(j)) '.png'];
        saveas(gcf,name)
    end   
end

diary off

elapsedTime = toc;