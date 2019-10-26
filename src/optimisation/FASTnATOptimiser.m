function [optimiserOutput,deltaP,deltaL] = FASTnATOptimiser(N,Uinf,TIinf,X,wakeModelType,coeffsFitObjStruct,coeffsFitObjArrayCt,objective)
%% FASTnATOptimiser
% This function utilises function fmincon, from Optimisation toolbox, to optimise pitch settings in a FASTnAT scenario,
% composed of N aligned turbines, with the objective of minimising loads, while maximising power (defined by variable objFun).
% Takes as input the free-stream conditions Uinf and TIinf (wind velocity & turbulence intensity in percentage), the distance between
% each turbine X, as multiple of the diameter. Must be supplied with a structure with curve fits for the surface coefficients,
% obtained by running a fit study, and also an array for a fit sutdy output for the thrust coefficient.
%%

%Initialise output variable optimiserOutput.
optimiserOutput = struct('turbineNumber',(1:1:N),'turbineU',zeros(1,N),'turbineTI',zeros(1,N),'pitchSettings',zeros(1,N),'turbinePower',zeros(1,N),'turbineLoads',zeros(1,N));
optimiserOutput.turbineU(1) = Uinf;
optimiserOutput.turbineTI(1) = TIinf;

%Define constraints and bounds for function fmincon.

A = [];
b = [];
Aeq = [];
beq = [];
lb = zeros(1,N);
ub = ones(1,N).*5;
x0 = zeros(1,N);

%--------------------------------------------------Define objective function-------------------------------------------------


if objective == 1     % Minimise loads on wind farm.
    %objFun = @(theta) totalVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,2),coeffsFitObjArrayCt,wakeModelType);
    objFun = @(theta) deltaVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,2),coeffsFitObjArrayCt,wakeModelType);
elseif objective == 2 % Maximise power on wind farm.
    %objFun = @(theta) - totalVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,1),coeffsFitObjArrayCt,wakeModelType);
    objFun = @(theta) deltaVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,1),coeffsFitObjArrayCt,wakeModelType);
elseif objective == 3 % Minimise loads, while maximising power.
    %totalVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,2),coeffsFitObjArrayCt,wakeModelType) - totalVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,1),coeffsFitObjArrayCt,wakeModelType);
    objFun = @(theta) deltaVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,2),coeffsFitObjArrayCt,wakeModelType) - deltaVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,1),coeffsFitObjArrayCt,wakeModelType);
end

%----------------------------------------------------------------------------------------------------------------------------

%Run optimisation.
disp('--------------------------------------------------------------------------------------------------------------------')
disp('-------------------------------------------- Running fmincon.... ---------------------------------------------------')
disp('--------------------------------------------------------------------------------------------------------------------')
%con = @(theta) myNLcon(theta,N,Uinf,TIinf,X,coeffsFitObjArrayCt,wakeModelType);
optimiserOutput.pitchSettings = fmincon(objFun,x0,A,b,Aeq,beq,lb,ub);

%Update optimiserOutput, for outputting. Also calculate the wind conditions if there was no wind farm control on, which is necessary
%to calculate the power in that situation.
disp('--------------------------------------------------------------------------------------------------------------------')
disp('------------------------------------------ Processing results.... --------------------------------------------------')
disp('--------------------------------------------------------------------------------------------------------------------')
U = zeros(1,N); U(1) = Uinf;
TI = zeros(1,N); TI(1) = TIinf;
for i = 2:N
    funCt = @(theta) fitFun(coeffsFitObjArrayCt,theta,optimiserOutput.turbineU(i-1),optimiserOutput.turbineTI(i-1));
    [optimiserOutput.turbineU(i),optimiserOutput.turbineTI(i)] = wakeModel(wakeModelType,X,funCt(optimiserOutput.pitchSettings(i-1)),Uinf,TIinf);

    funCt = @(theta) fitFun(coeffsFitObjArrayCt,theta,U(i-1),TI(i-1));
    [U(i),TI(i)] = wakeModel(wakeModelType,X,funCt(0),U(i-1),TI(i-1));
end

%Calculate the difference it made to apply the result pitch settings onto the turbines, and output it.
z = zeros(1,N);
deltaP  = 100 * ( sumVar(optimiserOutput.pitchSettings,N,optimiserOutput.turbineU,optimiserOutput.turbineTI,coeffsFitObjStruct.coeffsFitObjMatrix(:,1)) - sumVar(z,N,U,TI,coeffsFitObjStruct.coeffsFitObjMatrix(:,1)) )/( sumVar(z,N,U,TI,coeffsFitObjStruct.coeffsFitObjMatrix(:,1)) );
deltaL  = 100 * ( sumVar(optimiserOutput.pitchSettings,N,optimiserOutput.turbineU,optimiserOutput.turbineTI,coeffsFitObjStruct.coeffsFitObjMatrix(:,2)) - sumVar(z,N,U,TI,coeffsFitObjStruct.coeffsFitObjMatrix(:,2)) )/( sumVar(z,N,U,TI,coeffsFitObjStruct.coeffsFitObjMatrix(:,2)) );

%Calculate the power & load on each individual turbine, and output it.
for i = 1:N
    power = @(theta) fitFun(coeffsFitObjStruct.coeffsFitObjMatrix(:,1),theta,optimiserOutput.turbineU(i),optimiserOutput.turbineTI(i));
    optimiserOutput.turbinePower(i) = power(optimiserOutput.pitchSettings(i));

    loads = @(theta) fitFun(coeffsFitObjStruct.coeffsFitObjMatrix(:,2),theta,optimiserOutput.turbineU(i),optimiserOutput.turbineTI(i));
    optimiserOutput.turbineLoads(i) = loads(optimiserOutput.pitchSettings(i)); 
end

%Alternative for post processing

% deltaL = deltaVarFun(optimiserOutput.pitchSettings,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,2),coeffsFitObjArrayCt,wakeModelType);
% 
% deltaP = deltaVarFun(optimiserOutput.pitchSettings,N,X,Uinf,TIinf,coeffsFitObjStruct.coeffsFitObjMatrix(:,1),coeffsFitObjArrayCt,wakeModelType);















disp('--------------------------------------------------------------------------------------------------------------------')
disp('-------------------------------------------- Finished optimising. --------------------------------------------------')
disp('--------------------------------------------------------------------------------------------------------------------')

end

%----------------------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------------------

function Ct = interpCt(U,TI,swpData)
%% interpCt
% Function that interpolates a Ct value for (U,TI), based on the data gathered on a UvsTI sweep, supplied with input variable swpData.
% If query values (U,TI) fall inside domain of interpoalted data, an interpolation is made. Otherwise, an extrapolation is made.
%%

%Define interpolation intervals, within which the point (U,TI) lies.
X = [ (ceil(U)-1) ceil(U) ];
if mod(ceil(TI),2) == 0 %This if statement here is necessary because the turbulence intensity points are spaced by 2%.
    Y = [ (ceil(TI)-2) ceil(TI) ];
else
    Y = [ (ceil(TI)-1) (ceil(TI)+1) ];
end
V = zeros(length(Y),length(X));

%If either input fall outside the domain of interpolated data, then at least one boundary of an interpolation interval will also
%do so as well. This if statement verifies if any interpolation interval boundary is outside domain, and corrects the intervals 
%accordingly.
if any(X <= swpData.sweepStruct.UArray(1)) | any(X >= swpData.sweepStruct.UArray(end)) | any(Y <= swpData.sweepStruct.TIArray(1)) | any(Y >= swpData.sweepStruct.TIArray(end))
    
    %Set wind velocity interval to the first or last values of domain, accordingly.
    if any(X <= swpData.sweepStruct.UArray(1))
        X = swpData.sweepStruct.UArray([1 2]);
    elseif any(X >= swpData.sweepStruct.UArray(end))
        X(2) = swpData.sweepStruct.UArray(end);
        X(1) = swpData.sweepStruct.UArray(end-1);
    end

    %Set turbulence intensity to frist or last values of domain, accordingly.
    if any(Y <= swpData.sweepStruct.TIArray(1))
        Y = swpData.sweepStruct.TIArray([1 2]);
    elseif any(Y >= swpData.sweepStruct.TIArray(end))
        Y(2) = swpData.sweepStruct.TIArray(end);
        Y(1) = swpData.sweepStruct.TIArray(end-1);
    end

    %Run MATLAB function interp2 with option 'spline', so extrapolation is possible.
    Ct = runInterp2(X,Y,V,U,TI,swpData,'spline');

else %If query values are inside domain...
    %Run MATLAB function interp2 with option 'linear'.
    Ct = runInterp2(X,Y,V,U,TI,swpData,'linear');

end

end

%----------------------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------------------

function Ct = runInterp2(X,Y,V,U,TI,swpData,option)
%% runInterp2 - Description
%
%%

%Calculate the Ct for each pair (U(i),TI(i)), and save in variable V. Usage of MATLAB function interp2 
%requires length(Y) rows and length(X) columns in V.
n = findLineNumber('RtAeroCt',swpData.OutList);
for i = 1:length(Y)
    y = find(swpData.sweepStruct.TIArray == Y(i));
    for j = 1:length(X)
       x = find(swpData.sweepStruct.UArray == X(j));
        V(i,j) = mean(swpData.sweepStruct.matrixesUvsTI{x,y}(:,n));
    end
end

%Interpolate Ct value for (U,TI) with MATLAB function interp2.
Ct = interp2(X,Y,V,U,TI,option);

end