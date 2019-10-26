%% findBestPitch
% This script utilizes turbineSim to test several pitch settings in control
% region 2, and calculates the ratio Cp/Ct of each pitch
% setting. For this, I created FBPOpenLoop.mdl, which is a copy of
% OpenLoop.mdl that takes an input of pitch settings.
% The range of pitch settings that are tested is based on the figure about
% axial induction control on article "Comparison of Actuation Methods 
% for Wake Control in Wind Plants". Meant to be run from main repository
% folder.
%%

%Clear workspace.
clear all

%Change to case folder
cd C:\Users\mfram\Documents\GitHub\wind-farm-control-investigation\NREL5MW_AxialCase

%Create build folder.
rmdir build s
copyfile ..\src\templates\* build
addpath build
cd build

%This script requires OutList to be loaded.
load('..\data\OutList.mat');

%Define simulation input parameters.
meanWS = 8;
TI = 6;
TMax = 300;
model = 'FBPOpenLoop.mdl';

%This variable contains the labeling of the columns of variable resultData.
resultList = {'pitchSetting';'RtAeroCp';'RtAeroCt';'Cp/Ct'};

%Initialize pitchInput variable for Simulink, and define the pitch settings
%to be tested.
pitchInput = zeros(1,3);
pitchSettings = [0:0.5:8];


%Initialize variables.
outDataCell = cell(length(pitchSettings),1);
resultData = zeros(length(pitchSettings),4);

%Loop to test all pitch settings.
for i = 1:length(pitchSettings)
    
    %Simulate a turbine. Save results on outDataCell
	pitchInput(1,:) = deg2rad(pitchSettings(i));
	data = turbineSim(meanWS,TI,TMax,model);
    outDataCell{i,1} = data;
    
    %Record Cp and Ct on variable resultData. Calculate Cp/Ct ratio.
	resultData(i,1) = pitchSettings(i);
	n = findLineNumber('RtAeroCp',OutList);
	resultData(i,2) = mean(data(:,n));
	n = findLineNumber('RtAeroCt',OutList);
	resultData(i,3) = mean(data(:,n));
	resultData(i,4) = resultData(i,2)/resultData(i,3);
end