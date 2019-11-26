function [optimiserOutput,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsStruct,coeffsArrayCt,objective,weight)
%% FASTnATOptimiser
% This function utilises function fmincon, from Optimisation toolbox, to optimise pitch settings in a FASTnAT scenario,
% composed of N aligned turbines, with the objective of minimising loads, while maximising power (defined by variable objFun).
% Takes as input the free-stream conditions Uinf and TIinf (wind velocity & turbulence intensity in percentage), the distance between
% each turbine X, as multiple of the diameter. Must be supplied with a structure with curve fits for the surface coefficients,
% obtained by running a fit study, and also an array for a fit sutdy output for the thrust coefficient.
% The supplied weight is the relativ importance of maximising power, and must be a number between 0 and 1.
%%

%If no weight is given, it will be a nan value.
if nargin < 9
    weight = nan(1);
end

%Initialise variables.
optimiserOutput = struct('turbineNumber',(1:1:N),'turbineU',zeros(1,N),'turbineTI',zeros(1,N),'pitchSettings',zeros(1,N),'turbinePower',zeros(1,N),'turbineLoads',zeros(1,N));
optimiserOutput.turbineU(1) = Uinf;
optimiserOutput.turbineTI(1) = TIinf;
z = zeros(1,N);

%Define constraints and bounds for function fmincon.
A = [];
b = [];
Aeq = [];
beq = [];
lb = zeros(1,N);
ub = ones(1,N).*5;
x0 = zeros(1,N);
con = @(theta) NLConstraint(theta,N,Uinf,TIinf,X,wakeModelType,coeffsArrayCt);

%--------------------------------------------------Define objective function-------------------------------------------------


if objective == 1     % Maximise power on wind farm.
    objFun = @(theta) - ( sumPower(theta,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt) - sumPower(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt) ) / sumPower(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt);
elseif objective == 2 % Minimise loads on wind farm.
    objFun = @(theta) ( rssLoads(theta,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt) - rssLoads(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt) ) / rssLoads(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt);
elseif objective == 3 % Minimise loads, while maximising power.
    objFun = @(theta) (( rssLoads(theta,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt) - rssLoads(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt) ) / rssLoads(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt)) - (( sumPower(theta,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt) - sumPower(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt) ) / sumPower(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt));
elseif objective == 4 % Minimise loads, while maximising power, wih a specified weight.
    if isnan(weight) | weight < 0 | weight > 1
        ME = MException('MyError:weightNotValid','Weight must be a number between 0 and 1.');
        throw(ME);
    else
        objFun = @(theta) (1-weight)*(( rssLoads(theta,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt) - rssLoads(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt) ) / rssLoads(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt)) - weight*(( sumPower(theta,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt) - sumPower(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt) ) / sumPower(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt));
    end
end

%----------------------------------------------------------------------------------------------------------------------------

%Run optimisation.
disp('--------------------------------------------------------------------------------------------------------------------')
disp('-------------------------------------------- Running fmincon.... ---------------------------------------------------')
disp('--------------------------------------------------------------------------------------------------------------------')
optimiserOutput.pitchSettings = fmincon(objFun,x0,A,b,Aeq,beq,lb,ub,con);

%Update optimiserOutput with the wind conditions if there was no wind farm control on, which is also necessary
%to calculate the power in that situation.
disp('--------------------------------------------------------------------------------------------------------------------')
disp('------------------------------------------ Processing results.... --------------------------------------------------')
disp('--------------------------------------------------------------------------------------------------------------------')
for i = 2:N
    funCt = @(theta) fitFun(coeffsArrayCt,theta,optimiserOutput.turbineU(i-1),optimiserOutput.turbineTI(i-1));
    [optimiserOutput.turbineU(i),optimiserOutput.turbineTI(i)] = wakeModel(wakeModelType,funCt(optimiserOutput.pitchSettings(i-1)),optimiserOutput.turbineU(i-1),X,Uinf,TIinf);
end

%Calculate the difference it made to apply the result pitch settings onto the turbines, and output it.
deltaP  = 100 * (sumPower(optimiserOutput.pitchSettings,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt) - sumPower(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt))/sumPower(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,1),coeffsArrayCt);
deltaL  = 100 * (rssLoads(optimiserOutput.pitchSettings,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt) - rssLoads(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt))/rssLoads(z,N,Uinf,TIinf,X,wakeModelType,coeffsStruct.coeffsFitObjMatrix(:,2),coeffsArrayCt);

%Calculate the power & load on each individual turbine, and output it.
for i = 1:N
    optimiserOutput.turbinePower(i) = fitFun(coeffsStruct.coeffsFitObjMatrix(:,1),optimiserOutput.pitchSettings(i),optimiserOutput.turbineU(i),optimiserOutput.turbineTI(i));
    optimiserOutput.turbineLoads(i) = fitFun(coeffsStruct.coeffsFitObjMatrix(:,2),optimiserOutput.pitchSettings(i),optimiserOutput.turbineU(i),optimiserOutput.turbineTI(i));
end

disp('--------------------------------------------------------------------------------------------------------------------')
disp('-------------------------------------------- Finished optimising. --------------------------------------------------')
disp('--------------------------------------------------------------------------------------------------------------------')

end