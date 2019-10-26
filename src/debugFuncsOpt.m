%çqjrnvçdsfj vda

clear all

load C:\Users\mfram\Documents\GitHub\wind-farm-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_5.mat

% load C:\Users\mfram\Documents\GitHub\wind-farm-thesis\NREL5MW_AxialCase\simulations\sweepUvsTIdataset_updt\theta__2.mat
% outputArray = {'Power','CombRootMc1'};
% 
% [newSweep,newOutList] = FASTSweepUvsTIProcess(sweepStruct,outputArray,OutList);



% load C:\Users\mfram\Documents\GitHub\wind-farm-thesis\results\modelValidation\windFarm\fig421workspace.mat
% 
% offset = (0:1:4);
% pitchs = zeros(1,N);
% 
% for i = 1:length(FAST2ATArray)
%     pitchs(1) = offset(i);
%     Us = FAST2ATArray{i}.turbineU;
%     TIs = FAST2ATArray{i}.turbineTI;
%     
%     realLds1(i) = FAST2ATArray{i}.turbineData{1}(2,2);
%     realLds2(i) = FAST2ATArray{i}.turbineData{2}(2,2);
%     sum(i) = realLds1(i) + realLds2(i);
%     
%     sumPwrs(i) = sumVar(pitchs,N,Us,TIs,coeffsFitObjArray1);
%     sumLds(i) = sumVar(pitchs,N,Us,TIs,coeffsFitObjArray2);
%     
%     lds1(i) = fitFun(coeffsFitObjArray2,pitchs(1),Us(1),TIs(1));
%     lds2(i) = fitFun(coeffsFitObjArray2,pitchs(2),Us(2),TIs(2));
%     
% end






load C:\Users\mfram\Documents\GitHub\wind-farm-thesis\results\modelValidation\windFarm\FAST10ATsim.mat

outputArray = {'Power','CombRootMc1'};

[FAST10AT,newOutList] = FASTnATprocess(FAST10AT,outputArray,OutList);

pitchs = FAST10AT.pitchSettings;
Us = FAST10AT.turbineU;
TIs = FAST10AT.turbineTI;
N = 10;
U = 8;
TI = 8;
X = 7;

sumPwrs = 0;
for i = 1:length(pitchs)
    sumPwrs = sumPwrs + FAST10AT.turbineData{i}(1,1)
end

f = totalVarFun(pitchs,N,X,U,TI,coeffsFitObjArray1,coeffsFitObjArrayCt,'parkCrespo')

% 
% for i = 1:length(pitchs)
%     pwrs(i,1) = fitFun(coeffsFitObjArray1,pitchs(i),Us(i),TIs(i));
%     lds(i,1) = fitFun(coeffsFitObjArray2,pitchs(i),Us(i),TIs(i));
%     cts(i,1) = fitFun(coeffsFitObjArrayCt,pitchs(i),Us(i),TIs(i));
% end
% 
% 
% powrsTot = sumVar(pitchs,N,Us,TIs,coeffsFitObjArray1)