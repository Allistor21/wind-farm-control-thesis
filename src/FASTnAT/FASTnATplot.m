function [] = FASTnATplot(FASTnATout,outputArray,outList,timeFilter)
%% plotFASTnAT
%
%% 

%If no time filter value is supplied, it is 100 seconds.
if nargin < 4
    timeFilter = 10;
end

[FASTnATout,newOutList] = FASTnATprocess(FASTnATout,outputArray,outList,timeFilter);

x = FASTnATout.turbineNumber;
y = zeros(length(x),1);
y2 = zeros(length(x),1);
for i = 1:length(x)
    y(i) = FASTnATout.turbineData{i}(1,1);
    y2(i) = FASTnATout.turbineData{i}(2,2);
end

%-------------------------------------------

figure



plot(x,y)





end