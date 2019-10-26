%Script to test curve fits for coeffs of surface fits of sweeps.

a = sweepFitObjStruct.fitObjMatrix(:,1);

matrix = zeros(length(a), length(coeffvalues(a{1})));

for i = 1:length(a)
    matrix(i,:) = coeffvalues(a{i});
end

x = (0:0.5:5);
y = matrix(:,7);

[X,Y] = prepareCurveData(x,y);

cfit = fit(X,Y,'linearinterp');

plot(cfit,X,Y)