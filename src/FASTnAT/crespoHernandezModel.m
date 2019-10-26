function TIout = crespoHernandezModel(X,Ct,TIinf)
%% crespoHernandezModel
% This function applies the Crespo-Hernandez wake model, to estimate the
% turbulence intensity of a turbine's wake at a X downstream distance. Note
% that X is the multiplier of the turbine's diameter. So, if the downstream
% distance to apply the model is 7D, X is 7.
%%

%Initialise variables.
syms A I;

%Calculate axial induction factor, through actuator disk theory. If the thrust coefficient is higher than 1,
%a is returned empty. If statement is there to limit a to 0.5,
if Ct >= 1
    a = 0.5;
else
    a = double(solve([ 4*A*(1-A) == Ct , A <= 0.5 ],A));
end

%Apply Crespo-Hernandez model.
TIinf = TIinf/100;
dI = 0.73*(a^0.8325)*(TIinf^0.0325)*(X^(-0.32));
TIout = double(solve([ dI == sqrt((I^2 - TIinf^2)) , I >= 0 ],I))*100;

end