function f = totalVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjArray,coeffsFitObjArrayCt,wakeModelType)
%% totalVarFun
% This function calculates the total amount of a given variable (power or a load) in a wind farm
% composed of N aligned turbines spaced X*D from eachother, on which the incoming wind has a wind 
% speed of Uinf and a turbulence intensity of TIinf. The selection of the variable is made
% by supplying the correct array of curve coefficients of surface coefficients. Applies a wake
% model of type wakeModelType in between each turbine.
%%

U = zeros(1,N); TI = zeros(1,N);
U(1) = Uinf; TI(1) = TIinf;

f = fitFun(coeffsFitObjArray,theta(1),U(1),TI(1));
for i = 2:N
    Ct = fitFun(coeffsFitObjArrayCt,theta(i),U(i-1),TI(i-1));
    [U(i) , TI(i)] = wakeModel(wakeModelType,X,Ct,Uinf,TIinf);
    f = f + fitFun(coeffsFitObjArray,theta(i),U(i),TI(i));
end

end