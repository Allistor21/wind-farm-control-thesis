function sweepStruct = FASTSweepUvsTI(theta,UInput,TIInput,TMax,controlModel)
%% FASTPitchSweep
% This function takes as input a vlaue of pitch setting (theta), and then simulates FAST
% for all pairs of values between UInput and TIInput, effectively sweeping this theta value for all
% results by changing the wind conditions. Must also be supplied the simulation time
% and the Simulink model.
%%

%Initialize the output struct sweepStruct, in which eveything is saved.
sweepStruct = struct('theta',theta,'UArray',UInput,'TIArray',TIInput,'matrixesUvsTI',{cell(length(UInput),length(TIInput))});

%Define pitch input.
global pitchInput errors
pitchInput = zeros(3,1);
pitchInput(:) = deg2rad(theta);

%Begin loop, for each pair (U,TI) from inputs.
for i = 1:length(UInput)
    U = UInput(i)

    for j = 1:length(TIInput)
        TI = TIInput(j)

        %Simulate a turbine with FAST, and save the resulting matrix in sweepStruct.
        try
            sweepStruct.matrixesUvsTI(i,j) = {turbineSim(U,TI,TMax,controlModel)};
            errors(i,j) = {nan(1)};
        catch ME
            errors(i,j) = {ME.message};
            sweepStruct.matrixesUvsTI(i,j) = {nan(1)};
        end
    end  
end

end