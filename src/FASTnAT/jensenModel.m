function U = jensenModel(Ct,V,X,Uinf)
%% jensenModel
% Function that applies the Jensen wake model, for multiple wake interaction.
% Based on article "A note on wind generator interaction". Assumes full
% wake overlap. Ignores radial coordinate of model.
% Ct is thrust coefficient of turbine N, U is mean wind velocity at turbine
% N rotor, V is mean wind velocity at turbine N-1 rotor, X is 
% downstream distance (multiple of rotor diameter), and Uinf is ambient 
% wind velocity.
%%

%Initialise variables.
k = 0.06;
D = 126;
x = X*D;
syms A;

%Calculate axial induction factor, through actuator disk theory.
% If the thrust coefficient is higher than 1,
%a is returned empty. If statement limits induction factor to 0.5,
if Ct >= 1
    a = 0.5;
else
    a = double(solve([ 4*A*(1-A) == Ct , A <= 0.5 ],A));
end

%Apply Jensen model.
Y =  1 - ( 1 - (1-2*a)*(V/Uinf) )*(( D/( D + 2*k*x ) )^2);
U = Y * Uinf;
end