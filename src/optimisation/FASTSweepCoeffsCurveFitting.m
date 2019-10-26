function coeffsFitObjArray = FASTSweepCoeffsCurveFitting(pitchArray,fitObjArray,fitType)
%% FASTSweepCoeffsCurveFitting
% This function takes an array of fit objects, resulting for fitting surfaces to the sweepUvsTI database, and
% fits a curve for each coefficient of the surface's equation. This is necessary to make the optimisation dominium continuous.
%%

%Initialise output variable.
coeffsFitObjArray = cell(length(coeffvalues(fitObjArray{1})),1);

%Initialise auxiliary matrix, that stores the coefficients.
auxMatrix = zeros(length(fitObjArray), length(coeffvalues(fitObjArray{1})));

%Loop, turn fit objects into arrays of values.
disp('Extracting coefficient values from surface fit...')
for i = 1:length(fitObjArray)
    auxMatrix(i,:) = coeffvalues(fitObjArray{i});
end

%Loop, fit a fitType curve for each coeffcient.
disp('Calculating curves...')
for j = 1:length(coeffvalues(fitObjArray{1}))
    [X,Y] = prepareCurveData(pitchArray,auxMatrix(:,j));
    coeffsFitObjArray{j} = fit(X,Y,fitType);
end


end