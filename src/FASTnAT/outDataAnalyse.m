function analysisMatrix = outDataAnalyse(outputArray,outData,outList)
%% outDataAnalyse
% Function that calculates de mean%SD of the outputs listed in outputArray,
% and saves them in analysisMatrix. Lines of analysisMatrix are results, one
% column for each output. It is able to calculate the power, if supplied with
% input 'Power' in outputArray.
%%

if nargin < 4
    U = nan(1);
end

%Initialize variables.
analysisMatrix = zeros(2,length(outputArray));

%Loop, for every output in outputArray
for i = 1:length(outputArray)

    %Check if power is asked for, and calculate it if so.
    if strcmp(outputArray{i},'Power')
        %Find which line in in outList (and therefore which column in outData)
        %is a given output
        n1 = findLineNumber('RtAeroCp',outList);
        n2 = findLineNumber('Wind1VelX',outList);

        %Calculates mean&SD, save in analysisMatrix.
        analysisMatrix(1,i) = mean(outData(:,n1)) * ( 0.5 * 1.225 * (mean(outData(:,n2))^3) * ( pi*63^2 ) * (1/1000) );
        analysisMatrix(2,i) = std(outData(:,n1)) * ( 0.5 * 1.225 * (mean(outData(:,n2))^3) * ( pi*63^2 ) * (1/1000) );
    else
        %Find which line in in outList (and therefore which column in outData)
        %is a given output
        n = findLineNumber(outputArray{i},outList);

        %Calculates mean&SD, save in analysisMatrix.
        analysisMatrix(1,i) = mean(outData(:,n));
        analysisMatrix(2,i) = std(outData(:,n));
    end

    

end


end