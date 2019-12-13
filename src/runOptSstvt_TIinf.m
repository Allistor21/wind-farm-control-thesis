%Script to run a sensitivity analysis on the FASTnAT optmiser
clear all

%------------------------------------------------USER INPUT-----------------------------------------------------------------------------------------------

%Choose parameter to run sensitivity analysis from. The rest of the script is dynamic to this choice.
%Options are: N; Uinf; TIinf; X.
prmtr = 'TIinf'

%Define base conditions for sensitivity analysis.
N = 6;
Uinf = 8;
TIinf = 8;
X = 7;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

%Define domain for each parameter.
vecN = [2 4 6 8 10];
vecU = [6 7 8 9 10];
vecTI = [4 6 8 10 12];
vecX = [5 6 7 8 9];

%---------------------------------------------------------------------------------------------------------------------------------------------------------

%Define tag for the coresponding parameter
tag = ['sstvt' prmtr];

%Create specific build folder for this run and load surface fits.
cd C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis
status1 = rmdir(['build_' tag],'s');
status2 = mkdir(['build_' tag]);
status3 = addpath(['build_' tag]);
status4 = cd(['build_' tag]);
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

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

%Begin optimisations.
tic
struct_sstvt = struct('parameter',prmtr,'analysisDomain',sstvtArray,'resultArray',{cell(length(sstvtArray),length(objs))},'deltaPArray',zeros(length(sstvtArray),length(objs)),'deltaLArray',zeros(length(sstvtArray),length(objs)));
duration = zeros(length(sstvtArray),length(objs));
for i = 1:length(sstvtArray)
    for j = 1:length(objs)

        tStart = tic;
        if strcmp(prmtr,'N')
            [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(tag,sstvtArray(i),Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        elseif strcmp(prmtr,'Uinf')
            [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(tag,N,sstvtArray(i),TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        elseif strcmp(prmtr,'TIinf')
            [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(tag,N,Uinf,sstvtArray(i),X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        elseif strcmp(prmtr,'X')
            [optimiserOut,deltaP,deltaL] = FASTnATOptimiser(tag,N,Uinf,TIinf,sstvtArray(i),wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objs(j))
        end
        duration(i,j) = toc(tStart)

        struct_sstvt.resultArray{i,j} = optimiserOut;
        struct_sstvt.deltaPArray(i,j) = deltaP;
        struct_sstvt.deltaLArray(i,j) = deltaL;
    end   
end

elapsedTime = toc;

diary off