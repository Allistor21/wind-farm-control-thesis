%Script to run a sensitivity analysis on FASTnAT
clear all

global pitchInput TMax

%------------------------------------------------USER INPUT-----------------------------------------------------------------------------------------------

%Choose parameter to run sensitivity analysis from. The rest of the script is dynamic to this choice.
%Options are: N; Uinf; TIinf; X.
prmtr = 'TIinf'

%Define base conditions for sensitivity analysis.
N = 5;
Uinf = 8;
TIinf = 8;
X = 7;
wakeModelType = 'jensenCrespo';
pitchs = zeros(1,N);
TMax = 300;

%Define domain for each parameter.
vecN = [2 4 6 8 10];
vecU = [4 6 8 10 12];
vecTI = [4 6 8 10 12];
vecX = [5 6 7 8 9];

%---------------------------------------------------------------------------------------------------------------------------------------------------------

%Define tag for the corresponding parameter
tag = ['sstvt_' prmtr];

%Create specific build folder for this run.
cd C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase
status1 = rmdir(['build_' tag],'s');
status2 = copyfile('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\src\templates\*',['build_' tag]);
status3 = addpath(['build_' tag]);
status4 = cd(['build_' tag]);

diary(['log_' tag])

%Logic to define approriate sensitivity domain.
if strcmp(prmtr,'N')
    sstvtArray = vecN
elseif strcmp(prmtr,'Uinf')
    sstvtArray = vecU
elseif strcmp(prmtr,'TIinf')
    sstvtArray = vecTI
elseif strcmp(prmtr,'X')
    sstvtArray = vecX
else
    ME = MException('MyError:parameterNotValid','Must select a valid parameter. Options are N; Uinf; TIinf; X.');
    throw(ME);
end

%Begin FASTnATs.
struct_sstvt = struct('parameter',prmtr,'analysisDomain',sstvtArray,'resultArray',{cell(1,length(sstvtArray))});
for i = 1:length(sstvtArray)

    if strcmp(prmtr,'N')
        pitchs = zeros(1,vecN(i));
        output = {FASTnAT(vecN(i),pitchs,Uinf,TIinf,X,TMax,wakeModelType)}
    elseif strcmp(prmtr,'Uinf')
        output = {FASTnAT(N,pitchs,vecU(i),TIinf,X,TMax,wakeModelType)}
    elseif strcmp(prmtr,'TIinf')
        output = {FASTnAT(N,pitchs,Uinf,vecTI(i),X,TMax,wakeModelType)}
    elseif strcmp(prmtr,'X')
        output = {FASTnAT(N,pitchs,Uinf,TIinf,vecX(i),TMax,wakeModelType)}
    end

    struct_sstvt.resultArray{i} = output;
end

diary off