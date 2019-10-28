%Script to run the FASTnAT optimiser.
clear all

tic

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_5.mat

N = 2;
TIinf = 6;
wakeModelType = 'jensenCrespo';
X = 7;
Uinf = 8;
obj = 1;


% [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,obj);

% N = [5 10];
% obj = [1 2 3];
% optimiserArr = cell(3,1);
% deltaPArr = zeros(3,1);
% deltaLArr = zeros(3,1);
% 
% for j = 1:2
%     for i = 1:3
%         [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(N(j),U,TI,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,obj(i));
% 
%         optimiserArr{i} = optimiserOut;
%         deltaPArr(i) = deltaP;
%         deltaLArr(i) = deltaL;
%     end
% end

elapsedTime = toc;