function [newOutData,newOutList] = outDataCombineLoads(outData,outList)
%% combineLoads
% This function treats the results of a FAST simulation,
% combining loads by means of root-sum-square, for yaw bearing and tower and blade root,
% both forces and moments, as suggested in article
% "Evaluating Wake Models for Wind Farm Control" (Annoni 2014).
%%

%Initialize a variable containing the labels of the relevant loads to
%treat. Initialise outputs.
loadNames = {'RootFxc1','RootFyc1','CombRootFc1';'RootMxc1','RootMyc1','CombRootMc1';'TwrBsFxt','TwrBsFyt','CombTwrBsFt'; 'TwrBsMxt','TwrBsMyt','CombTwrBsMt'; 'YawBrFxp','YawBrFyp','CombYawBrFp'; 'YawBrMxp','YawBrMyp','CombYawBrMp'};
newOutList = outList;
newOutData = outData;
    
%Loop, for each load
for i=1:length(loadNames)
        
        %Find which line in OutList (and therefore which column in OutData)
        %a given load is registered.
        n1 = findLineNumber(loadNames(i,1),newOutList);
        n2 = findLineNumber(loadNames(i,2),newOutList);

        %Combine the loads by means of root-sum-square matlab function.
        aux(:,1) = newOutData(:,n1);
        aux(:,2) = newOutData(:,n2);
        aux = transpose( rssq( transpose(aux)));

        %Substitute the two columns of the two initial loads, by a column
        %with the combined load.
        newOutData(:,n1) = aux(:);
        newOutData(:,n2) = [];
       
        %Update Outlist, the same way as outData.
        newOutList{n1} = loadNames{i,3};
        newOutList(n2) = [];
end