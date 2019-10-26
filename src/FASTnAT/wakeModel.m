function [meanWS,TI] = wakeModel(wakeModelType,X,Ct,Uinf,TIinf)
%% wakeModel
% This function applies the wake model "wakeModelType".  Note that X is the multiplier of the turbine's diameter. 
% So, if the downstream distance to apply the model is 7D, X is 7.
%%

%If statement to choose the functions for a given wake model.
if strcmp(wakeModelType,'parkCrespo')
    meanWS = parkModel(X,Ct,Uinf);
	TI = crespoHernandezModel(X,Ct,TIinf);
end

end