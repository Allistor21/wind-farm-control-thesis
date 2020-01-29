%% runFASTnAT
% Script to run a case. Meant to be run with main repository folder as
% current folder.
%%
clear all

%time script
tic;

%Change to case folder
cd C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase

rmdir build2 s
copyfile C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\src\templates\* build2
addpath build2
cd build2

global pitchInput TMax

N = 5;
U = 4;
TI = 8;
X = 7;
wakeModelType = 'jensenCrespo';
pitchs = zeros(1,N);
TMax = 300;

U4out2 = FASTnAT(N,pitchs,U,TI,X,TMax,wakeModelType);




%time script
elapsedTime = toc;


