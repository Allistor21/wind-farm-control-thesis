%

fitObjArray = sweepFitObjStruct.fitObjMatrix(:,1);

fitType = 'linearinterp';

coeffsFitObjArray1 = FASTSweepCoeffsCurveFitting(sweepFitObjStruct.pitchArray,fitObjArray,fitType);

fitObjArray = sweepFitObjStruct.fitObjMatrix(:,2);

coeffsFitObjArray2 = FASTSweepCoeffsCurveFitting(sweepFitObjStruct.pitchArray,fitObjArray,fitType);

