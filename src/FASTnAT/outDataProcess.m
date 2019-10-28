function [analysisMatrix,newOutList] = outDataProcess(outputArray,data,outList,timeFilter)
%% OutDataProcess - Description
% This function applies the functions OutDataFilterOnset and
% OutDataAnalyse, to process an FAST output matrix and calculates
% the mean&SD of the relevant loads & power, supplied in outputArray.
%%

%If no time filter value is supplied, it is 20 seconds.
if nargin < 4
    timeFilter = 20;
end

%Run OutDataFilterOnset and OutDataAnalyse on FAST results.
data = outDataFilterOnset(timeFilter,data);
[data,newOutList] = outDataCombineLoads(data,outList);
analysisMatrix = outDataAnalyse(outputArray,data,newOutList);
    
end