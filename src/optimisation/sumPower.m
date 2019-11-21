function sums = sumPower(theta,N,Uinf,TIinf,X,wakeModelType,coeffsArrayPower,coeffsArrayCt)
%% maxPower
% Cost function for FASTnATOptimiser, with the objective of maximising power.
% Calculates the sum of the time-average turbine power, for all N turbines.
%%

%Initialise variables.
sums = 0;
U = Uinf; TI = TIinf;

%Loop for each turbine, sum its power to total, and then apply wake model.
for i = 1:N
    sums = sums + fitFun(coeffsArrayPower,theta(i),U,TI);

    Ct = fitFun(coeffsArrayCt,theta(i),U,TI);
    [U,TI] = wakeModel(wakeModelType,Ct,U,X,Uinf,TIinf);
end

end