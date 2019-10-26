function newOutData = outDataFilterOnset(timeFilter,data)
%% outDataFilterOnset
% This function filter the first timeFilter seconds of
% an outData matrix.
%%

%Initialize variables for loop.
line = 1;
auxTime = 0;

%Begin loop, find the line number of the time 
%value to filter timeFilter.
while auxTime ~= timeFilter
    auxTime = data(line,1);
    line = line + 1;
end

%Eliminate all lines before timeFilter. Output treated matrix.
data(1:line,:) = [];
newOutData = data;

end