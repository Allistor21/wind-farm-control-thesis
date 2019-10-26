function [newSweepStruct,newOutList] = FASTSweepUvsTIProcess(sweepStruct,outputArray,outList)
% FASTSweepUvsTIProcess - Description
% Function that processes the result of a FASTSweepUvsTI, acessing its result
% matrixes, applies a time filter, and calculates the mean&SD of the desired
% outputs in outputArray. 
%%

%Initialise variables.
newSweepStruct = sweepStruct;
newOutList = outList;

%Begin a loop, one iteration per result matrix in the sweep.
s = size(sweepStruct.matrixesUvsTI);
for i = 1:s(1)
    for j = 1:s(2)
        
        %If there were any errors in the simulation, no processing is done.
        %A NaN value is placed instead.
        if isnan(sweepStruct.matrixesUvsTI{i,j})
            sweepStruct.matrixesUvsTI{i,j} = nan(1);
            continue
        end

        %Process the result matrix, and substitute it in the new sweepSctruct
        %by the analysis matrix that results from outDataProcess,
        [newSweepStruct.matrixesUvsTI{i,j},newOutList] = outDataProcess(outputArray,sweepStruct.matrixesUvsTI{i,j},outList,sweepStruct.UArray(i));
        
    end
end

end