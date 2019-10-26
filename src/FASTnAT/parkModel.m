function U = parkModel(X,Ct,Uinf)
%% parkModel
% Function that applies the Park wake model. Based on 
% "Evaluating Wake Models for Wind Farm Control". Note that X is the 
% multiplier of the turbine's diameter. So, if the downstream distance 
% to apply the model is 7D, X is 7.
% VERY IMPORTANT NOTE For now, it ingores the radial position influence in
% the model (the expansion of the wake as it travels downstream). Assumes
% complete overlap between wake and downstream turbine.
%%

%Initialise variables.
k = 0.06;
D = 126;
x = X*D;
syms A;

%Calculate axial induction factor, through actuator disk theory. If the thrust coefficient is higher than 1,
%a is returned empty. If statement is there to limit a to 0.5,
if Ct >= 1
    a = 0.5;
else
    a = double(solve([ 4*A*(1-A) == Ct , A <= 0.5 ],A));
end

%Apply Park model, to calculate velocity at distance x. For now, it
%ingores the radial position influence in the model (the expansion of the
%wake as it travels downstream).
dU = 2*a*(( D/( D+2*k*x ) )^2);
U = Uinf*(1-dU);

end