%% runFASTSweep
% Script to run a sweepUvsTI function.
%%
clear all

%time script
tic;

%Change to case folder
cd C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase

%Clear build folder
rmdir build s
copyfile C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\src\templates\* build
%Get all turbSim files.
copyfile C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\turbSimFiles\* build
addpath build
cd build


%Define variables.
theta = 5;
UInput3 = [3 4 5 6 7 7.84 8 9 10 10.45 11 11.4];
TIInput3 = [6 8];
TMax = 600;
model = 'PitchOpenLoop.mdl';

%Declare variable pitchInput and errors as global.
global pitchInput errors
errors = cell(length(UInput3),length(TIInput3));

%Run sweep.
addStruct = FASTSweepUvsTI(theta,UInput3,TIInput3,TMax,model);

addErrors = errors;

%time script
elapsedTime = toc;