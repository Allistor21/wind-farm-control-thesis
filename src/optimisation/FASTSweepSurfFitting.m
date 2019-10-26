function sweepFitObjStruct = FASTSweepSurfFitting(pitchArray,outputArray,fitType)
%% FASTSweepSurfFitting
% This function fits a surface equation, of type fitType, to data saved in the Case\simulations\sweepUvsTIdataset_updt folder,
% which is basically the dataset on which optimisation will be performed. It fits a surface for each output in outputArray to be analysed.
% 
% NOTE: the number of workspaces in the dataset folder must match the input pitchArray. If required, I will change function to loop through
% all the files in the target folder.
%%

%Initialise function output variable.
sweepFitObjStruct = struct('fitType',fitType,'pitchArray',{pitchArray},'outputArray',{outputArray},'fitObjMatrix',{cell(length(pitchArray),length(outputArray))});

%Begin a loop, for each pitch sweepUvsTI.
auxFitObjMatrix = cell(length(pitchArray),length(outputArray));
for i = 1:length(pitchArray)

    %Load the sweeps Struct and Outlist, corresponding to a pitch value.
    pitch = pitchArray(i);
    str = [ 'C:\Users\mfram\Documents\GitHub\wind-farm-thesis\NREL5MW_AxialCase\simulations\sweepUvsTIdataset_updt\theta__' num2str(pitch) '.mat'  ];
    disp(['Loading UvsTI sweep for pitch = ' num2str(pitch) ' degrees']);
    load(str,'sweepStruct','OutList');
    
    %Process data in sweep, so the outData matrixes turn into mean&SD of relevant outputs in outputArray.
    disp('Processing sweep...')
    [treatedStruct,~] = FASTSweepUvsTIProcess(sweepStruct,outputArray,OutList);

    %Begin a loop, calculate a surface fit function for each output in outputArray.
    disp('Calculating surface fits...')
    auxFitVar = cell(1,length(outputArray));
    for j = 1:length(outputArray)

        %This if statement is to distinguish whether to calculate a surface fit for the mean 
        %(if output is power or thrust coefficient), or the SD (if it is a load).
        if strcmp(outputArray(j),'RtAeroCp') | strcmp(outputArray(j),'RtAeroCt') | strcmp(outputArray(j),'Power')
            line = 1; %If it's turbine power, or power or thrust coefficient, I will fit a surface to the mean.
        else
            line = 2; %If it's any other output (a load), I will fit a surface to the standard deviation.
        end

        %Construct matrix of Z values for surface fitting.
        s = size(treatedStruct.matrixesUvsTI);
        z = zeros(s);
        for t = 1:s(1)
            for f = 1:s(2)
                
                %It is useful to have NaN entries, corresponding to errors in FAST simulation, carry over
                %to this point, because function fit() ignores NaN entries.
                if isnan(treatedStruct.matrixesUvsTI{t,f})
                    z(t,f) = nan(1);
                    continue
                end
                
                z(t,f) = treatedStruct.matrixesUvsTI{t,f}(line,j);
            end
        end

        %Prepare data for fit, run fit, save fit object into auxiliary variable.
        [X, Y, Z] = prepareSurfaceData(treatedStruct.UArray, treatedStruct.TIArray, z);
        sft = fit([X,Y],Z,fitType);
        auxFitVar{j} = sft;
    end
    
    %Assign both fits into auxiliary fit object matrix.
    disp('Done calculating fits.')
    auxFitObjMatrix(i,:) = auxFitVar;
end

%Assign auxiliary fit object matrix to output structure.
sweepFitObjStruct.fitObjMatrix = auxFitObjMatrix;

end