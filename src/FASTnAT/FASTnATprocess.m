function [FASTnATout,newOutList] = FASTnATprocess(FASTnATin,outputArray,outList,timeFilter)
%% analyseFASTnAT
% This function analyses the outputs coming FASTnAT scenario simulation.
%%

%If no time filter value is supplied, it is 100 seconds.
if nargin < 4
    timeFilter = 10;
end

%Initialise output variable.
FASTnATout = FASTnATin;

%Run a loop, for each turbine, and apply the process functions.
for i = 1:length(FASTnATin.turbineNumber)
    [FASTnATout.turbineData{i},newOutList] = outDataProcess(outputArray,FASTnATout.turbineData{i},outList);
end

end