function [c,ceq] = NLConstraint(theta,N,Uinf,TIinf,X,wakeModelType,coeffsArrayCt)
%% NLConstraint
% This function represents a non linear constraint. For low wind speed and turbulence,
% FAST can give out an error for sufficiently high pitch values. This constraint
% will ensure that the FASTnATOptimiser does not select pitch values in wind 
% conditions that produce an error.
% NOTE that this constraint is specific for the database I built for the thesis,
% with all its assumptions.
%%

%Initialise variables.
c = -1; ceq = [];
U = Uinf; TI = TIinf;
conU = zeros(N,1); conTI = zeros(N,1);

%Loop for each turbine, calculate the constraint.
%Constraints where formulated in the form "theta-A*(U,TI)+B<=0".
for i = 1:N
    conU(i) = theta(i) - (U/2) - 1;
    conTI(i) = theta(i) + 0.107*TI - 4.64;

    Ct = fitFun(coeffsArrayCt,theta(i),U,TI);
    [U,TI] = wakeModel(wakeModelType,Ct,U,X,Uinf,TIinf);
end

%If any constraint is violated, c is outputed as 1.
for i = 1:N
    if conU(i) > 0 | conTI(i) > 0
        c = 1;
        break
    end
end

end