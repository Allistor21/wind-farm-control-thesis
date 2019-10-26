function data = turbineSim(meanWS,TI,TMax,controlModel)
%% turbineSim
% Function that simulates a turbine with FAST, given the average wind speed
% of the incoming wind "meanWS", turbulence intentisity "TI", and a
% Simulink model "controlModel". Requires a template input file
% turbine.fst.
%%

%Generate the turbulent wind profile to be used in the simulation.
oldFile = ['turbSimFile_U' num2str(meanWS) '_T' num2str(TI) '.bts'];
%Check if .bts file already exists.
if isfile(oldFile)
    disp([oldFile ' already generated.']);
else
    %Generate appropriate .bts TurbSim file, based on turbSimFile.inp
    %template.
    disp('Generating TurbSim full field binary file...');
    newFile = ['turbSimFile_U' num2str(meanWS) '_T' num2str(TI) '.inp'];
    status = copyfile('turbSimFile.inp','turbSimFileAux.inp');
    status2 = movefile('turbSimFileAux.inp',newFile);
    generateTurbSim(meanWS,TI,TMax,newFile);
    disp('Done generating TurbSim full field binary file');
end

%Update the InflowWind input file, to use the generated .bts file.
%workFile = NRELOffshrBsline5MW_InflowWind_Work.dat;
disp('Updating InflowWind input file...');
delete 'NRELOffshrBsline5MW_InflowWind_Work.dat';
status3 = copyfile('NRELOffshrBsline5MW_InflowWind_Base.dat','NRELOffshrBsline5MW_InflowWind_Work.dat');
writeInflowWindFile(meanWS,TI,'NRELOffshrBsline5MW_InflowWind_Work.dat');

%Update ElastoDyn input file, so simulation is with correct rotor speed.
%NOTE THAT turbines parameters are hardcoded (TSR, R).
disp('Updating ElastoDyn input file...');
delete 'NRELOffshrBsline5MW_OC3Monopile_ElastoDyn_Work.dat';
status4 = copyfile('NRELOffshrBsline5MW_OC3Monopile_ElastoDyn_Base.dat','NRELOffshrBsline5MW_OC3Monopile_ElastoDyn_Work.dat');
writeElastoDynFile(meanWS,'NRELOffshrBsline5MW_OC3Monopile_ElastoDyn_Work.dat');


%Run FAST with "controlModel".
disp('******************************************************************');
disp('                        Initialising FAST...                      ');
disp('******************************************************************');
%The variables FAST_InputFileName and TMax have to be in the base workspace
%in order to have the block SFunc of Simulink read them.
assignin('base','FAST_InputFileName','turbine.fst');
assignin('base','TMax',TMax);
sim(controlModel,[0,TMax]);
disp(['Done simulating wind turbine for mean wind speed ' num2str(meanWS) ' m/s, turbulence' ]);
disp(['intensity ' num2str(TI) '%, for Simulink model ' controlModel '.']);

data = OutData;
end

%------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------

function [] = writeElastoDynFile(meanWS,elastoDynFile)
%% writeElastoDynFile - Description
% Function that updates the ElastoDyn input file elastoDynFile, so simulation uses correct 
% rotor speed for a given wind speed meanWS, so turbine operates in optimal TSR.
%%

%The rotor speed has a lower boundary, the cut-in speed, of 6.9 rpm. Until that speed, the control
%behaviour is start up, and the generator torque controler enforces this minimum,
%making the generator speed rise linearly from 670 rpm (the value corresponding to the 
%cut-in rotor speed) and 871 rpm. The rotor speed also has an upper boundary, the rated rotor speed,
%of 12.1 rpm. In the trasition region between control regions 2 and 3 (region 2 1/2), the rotor speed
%goes up linearly from 99% of the rated rotor speed, to the rated rotor speed. The following code detects in which control region
%is the current wind speed, and makes the rotor speed scale linearly accordingly. If the control is on region 2,
%then the rotor speed it the one that makes the TSR optimal.
TSR = 7.55;
R = 126/2;
gearboxRatio = 97;
%Linear regression for control region 1 1/2.
regionBoundary = 7.8424; %Wind speed boundary between control region 1 1/2 (start-up) and control region 2.
slope = 41.5289; %Slope of relation between generator speed and wind speed.
intercept = 545.5132; %Intercept of relation between generator speed and wind speed.
%Linear regression for control region 2 1/2.
regionBoundary2 = 10.46; %Wind speed boundary between control region 2 and control region 2 1/2.
slope2 = 0.1287; %Slope of relation between rotor speed and wind speed.
intercept2 = 10.63; %Intercept of relation between rotor speed and wind speed.

if meanWS < regionBoundary
    omega = (slope*meanWS + intercept)/gearboxRatio;
elseif meanWS > regionBoundary2
    omega = slope2*meanWS + intercept2;
else
    omega = (60/(2*pi))*(TSR*meanWS/R);
end

InputFile = elastoDynFile;
OutputFile = elastoDynFile;
SearchString = "<@ROTSPEED@>   RotSpeed";
ReplaceString = strcat(num2str(omega), "   RotSpeed");
func_replace_string(InputFile, OutputFile, SearchString, ReplaceString);
    
end

%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------

function [] = writeInflowWindFile(meanWS,TI,inflowWindFile)
%% writeInflowWindFile
% Function that updates the InflowWind input file inflowWindFile to read a
% TurbSim .bts file, that was generated for wind speed meanWS, and turbulence
% intensity TI.
%%

fileName = ['turbSimFile_U' num2str(meanWS) '_T' num2str(TI) '.bts'];
InputFile = inflowWindFile;
OutputFile = inflowWindFile;
SearchString = "<@FILE@>    Filename";
ReplaceString = strcat(fileName,"    Filename");
func_replace_string(InputFile, OutputFile, SearchString, ReplaceString);

end

%----------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------

% I pulled this function off the internet. It searches for SearchsString in
% InputFile, and replaces it with ReplaceString in OutputFile. In InputFile
% and OutputFile are the same file, the file is overwritten.
function [] = func_replace_string(InputFile, OutputFile, SearchString, ReplaceString)
%%change data [e.g. initial conditions] in model file
% InputFile - string
% OutputFile - string
% SearchString - string
% ReplaceString - string

% read whole model file data into cell array
fid = fopen(InputFile);
data = textscan(fid, '%s', 'Delimiter', '\n', 'CollectOutput', true);
fclose(fid);
% modify the cell array
% find the position where changes need to be applied and insert new data
for I = 1:length(data{1})
    tf = strcmp(data{1}{I}, SearchString); % search for this string in the array
    if tf == 1
        data{1}{I} = ReplaceString; % replace with this string
    end
end
% write the modified cell array into the text file
fid = fopen(OutputFile, 'w');
for I = 1:length(data{1})
    fprintf(fid, '%s\n', char(data{1}{I}));
end
fclose(fid);
end

