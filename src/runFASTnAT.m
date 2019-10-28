%% runFASTnAT
% Script to run a case. Meant to be run with main repository folder as
% current folder.
%%
clear all

%time script
tic;

%Change to case folder
cd C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase

rmdir build s
copyfile C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\src\templates\* build
addpath build
cd build

global pitchInput TMax

N = 2;
U = 8;
TI = 6;
Xn = 7;
TMax = 600;
wakeModelType = 'jensenCrespo';
pitchs = zeros(1,N);

% FAST10AT = FASTnAT(N,pitchs,U,TI,Xn,TMax,wakeModelType);

offset = (0:1:5);

for i = 1:length(offset)
    pitchs(1) = offset(i)
    
    FAST2ATArray{i} = FASTnAT(N,pitchs,U,TI,Xn,TMax,wakeModelType);
end



%time script
elapsedTime = toc;


