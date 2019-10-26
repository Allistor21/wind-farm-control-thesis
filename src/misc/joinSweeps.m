function [newSweepStruct,newErrors] = joinSweeps(oldSweepStruct,addSweepStruct,oldErrors,addErrors)
%joinSweeps - Description
%
%Auxiliary function, to aid me in joining new simulations with old ones.
%
% Long description

newSweepStruct = oldSweepStruct;

newSweepStruct.TIArray = cat(2,addSweepStruct.TIArray,newSweepStruct.TIArray);

newSweepStruct.matrixesUvsTI = horzcat(addSweepStruct.matrixesUvsTI,newSweepStruct.matrixesUvsTI); %concatenate matrixes

newErrors = oldErrors;

newErrors = horzcat(addErrors,newErrors);
    
end