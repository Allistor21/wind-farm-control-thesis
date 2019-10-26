%This is a script to help make the constraint for the FASTnATOptimiser.
clear all

pitchArray = (0:0.5:5);
errMap = ones(length(pitchArray),8)*3;

for t = 1:length(pitchArray)
    pitch = pitchArray(t)
    str = [ 'C:\Users\mfram\Documents\GitHub\wind-farm-thesis\NREL5MW_AxialCase\simulations\sweepUvsTIdataset_updt\theta__' num2str(pitch) '.mat'  ]
    load(str,'sweepStruct','OutList');

    for j = 1:length(sweepStruct.TIArray)
        for i = 1:length(sweepStruct.UArray)
            if isnan(sweepStruct.matrixesUvsTI{i,j})
                errMap(t,j) = sweepStruct.UArray(i);
                break
            end
        end
    end

end


%-----------------------------------------------------------------------------------



