function [] = generateTurbSim(meanWS,TI,TMax,turbSimFile)
%% generateTurbSim
% Function that runs TurbSim to generate a .bts file, to be used in a FAST
% simulation. Makes a wind profile with mean wind speed meanWS, a
% turbulence intensity TI, and usable simulation time TMax. Requires a
% template input file TurbSimFile.inp.
%%

%Write in TurbSimFile.inp the variables meanWS, TI and TMax.
disp('Writing wind inflow input parameters to TurbSim input file...');
writeTurbSim(meanWS,TI,TMax,turbSimFile)

%Run TurbSim.
disp('******************************************************************');
disp('                       Initialising TurbSim...                    ');
disp('******************************************************************');
command = ['C:\Users\mfram\Documents\CAETools\TurbSim\TurbSim64.exe ' turbSimFile];
status = system(command);
end

function [] = writeTurbSim(meanWS,TI,TMax,turbSimFile)
%% writeTurbSim
% Function that write in file TurbSimFile.inp the variables meanWS, TI and
% TMax. The variable TurbSimFile is a string that must be defined with
% quotation marks "".
%%

%Define the input variables that overwrite TurbSimFile, to write the usable
%simulation time.
disp('Writing usable time...');
InputFile = turbSimFile;
OutputFile = turbSimFile;
SearchString = "<@TIME@>       UsableTime";
ReplaceString = strcat(num2str(TMax),"       UsableTime");
func_replace_string(InputFile, OutputFile, SearchString, ReplaceString)
disp('Done');

%Define the input variables that overwrite TurbSimFile, to write the
%turbulence intensity.
disp('Writing turbulence intensity...');
InputFile = turbSimFile;
OutputFile = turbSimFile;
SearchString = "<@TURB@>            IECturbc";
ReplaceString = strcat(num2str(TI),"            IECturbc");
func_replace_string(InputFile, OutputFile, SearchString, ReplaceString)
disp('Done');

%Define the input variables that overwrite TurbSimFile, to write the
%average wind speed.
disp('Writing mean wind speed...');
InputFile = turbSimFile;
OutputFile = turbSimFile;
SearchString = "<@WS@>          URef";
ReplaceString = strcat(num2str(meanWS),"          URef");
func_replace_string(InputFile, OutputFile, SearchString, ReplaceString)
disp('Done');

end

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