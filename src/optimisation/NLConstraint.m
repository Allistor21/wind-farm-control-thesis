function c = NLConstraint(theta,N,Uinf,TIinf,X,wakeModelType,coeffsArrayCt)
%% NLConstraint
% This function represents a non linear constraint. For low wind speed and turbulence,
% FAST can give out an error for sufficiently high pitch values. This constraint
% will ensure that the FASTnATOptimiser does not select pitch values in wind 
% conditions that produce an error.
% NOTE that this constraint is specific for the database I built for the thesis,
% with all its assumptions.
%%

%Initialise variables.
aux = 1;
U = Uinf; TI = TIinf;

%Loop for each turbine, calculate the constraint. This formulation ensures that
%if at least one pitch value is invalid, the optimisation will not select that
%set of pitches. Constraints where formulated in the form "theta-A*(U,TI)+B<=0".
for i = 1:N
    aux = aux * ( theta(i) - U + 1)*(theta(i) - 0.25 * TI );

    Ct = fitFun(coeffsArrayCt,theta(i),U,TI);
    [U,TI] = wakeModel(wakeModelType,Ct,U,X,Uinf,TIinf);
end

%If product if less than zero, no constraint is violated, so function outputs -1.
%Otherwise, output 1. Check fmincon documentation for details.
if aux <= 0
    c = -1;
else
    c = 1;
end

end