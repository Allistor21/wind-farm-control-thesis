%Script to run necessary fit functions, to output the fits for the
%optimisation step.

%time script
tic;

%Define pitch values array, and output names array, necessary for
%FASTSweepSurfFitting.
pitchArray = (0:0.5:5);
outputArray = {'Power','CombRootMc1','RtAeroCt'};

%For now, this fit type cannot be changed, it is hardcoded in optimisation
%functions.
fitType = 'poly31';

%Run sweep surfaces fitting.
sweepFitObjStruct = FASTSweepSurfFitting(pitchArray,outputArray,fitType);

%I determined that a linear interpolation is best for all coefficients,
%there is no patterned behaviour.
fitType = 'linearinterp';

%Run a sweep surface coefficients curve fit, for both outputs.
fitObjArray = sweepFitObjStruct.fitObjMatrix(:,1);
coeffsFitObjArray1 = FASTSweepCoeffsCurveFitting(sweepFitObjStruct.pitchArray,fitObjArray,fitType);
fitObjArray = sweepFitObjStruct.fitObjMatrix(:,2);
coeffsFitObjArray2 = FASTSweepCoeffsCurveFitting(sweepFitObjStruct.pitchArray,fitObjArray,fitType);

%Save results on a structure, prepared to be used by the optimisation
%script.
outputArray = {'Power','CombRootMc1'};
coeffsFitObjStruct = struct( 'outputNames',{outputArray},'coeffsFitObjMatrix',{horzcat(coeffsFitObjArray1,coeffsFitObjArray2)} );

%Run a sweep surface coefficients curve fit, for thrust coefficient. To be
%used by optimiser for including the effect of pitch on thrust.

fitObjArray = sweepFitObjStruct.fitObjMatrix(:,3);
coeffsFitObjArrayCt = FASTSweepCoeffsCurveFitting(sweepFitObjStruct.pitchArray,fitObjArray,fitType);


%time script
elapsedTime = toc;