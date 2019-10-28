function U = jensenModel(X,Ct,Uinf)
%% jensenModel
% Function that applies the Jensen wake model. Based on 
% "Evaluating Wake Models for Wind Farm Control". Note that X is the 
% multiplier of the turbine's diameter.
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

%Apply Jensen model



end