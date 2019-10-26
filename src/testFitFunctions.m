%Script to test my new fit functions.

pitchArray = [0:0.5:5];

outputArray = {'RtAeroCp','CombRootMc1'};

fitType = 'poly31';

sweepFitObjStruct = FASTSweepSurfFitting(pitchArray,outputArray,fitType);



