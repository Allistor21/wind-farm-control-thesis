%Script to run the FASTnAT optimiser.
clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

%----------------------------


N = 5;
Uinf = 8;
TIinf = 6;
X = 7;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);


[optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,1)


%---------------------------------

% N = 5;
% Uinf = 8;
% TIinf = 6;
% X = 5;
% wakeModelType = 'jensenCrespo';
% objs = [1 2 3];
% 
% 
% structGebraad = struct('resultArray',{cell(1,length(objs))},'deltaPArray',zeros(1,length(objs)),'deltaLArray',zeros(1,length(objs)));
% 
% for i = 1:3
%     [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(i))
%     structGebraad.resultArray{i} = optimiserOut;
%     structGebraad.deltaPArray(i) = deltaP;
%     structGebraad.deltaLArray(i) = deltaL;
% end

%------------------------------



elapsedTime = toc;