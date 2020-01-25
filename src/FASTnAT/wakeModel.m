function [U,TI] = wakeModel(wakeModelType,Ct,V,X,Uinf,TIinf)
%% wakeModel
% This function applies the wake model "wakeModelType". For now it only has
% one wake model, but is is meant to allow a user to choose between
% different wake models.
% Ct is thrust coefficient of turbine N, U is mean wind velocity at turbine
% N rotor, V is mean wind velocity at turbine N-1 rotor, X is 
% downstream distance (multiple of rotor diameter), TI is turbulence
% intensity at turbine N rotor, Uinf is ambient wind velocity,
% and TIinf is ambient turbulence intensity.
%%

%If statement to choose the functions for a given wake model.
if strcmp(wakeModelType,'jensenCrespo')

    %If statement to check if V is less than the cut-in speed.
    if V < 3
        Ct = 0;
    end

    U = jensenModel(Ct,V,X,Uinf);
	TI = crespoHernandezModel(X,Ct,TIinf);
end

end