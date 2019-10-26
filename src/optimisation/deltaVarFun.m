function f = deltaVarFun(theta,N,X,Uinf,TIinf,coeffsFitObjArray,coeffsFitObjArrayCt,wakeModelType)
%% deltaVarfun
%
%%

Uwfc = zeros(1,N); Uwfc(1) = Uinf;
TIwfc = zeros(1,N); TIwfc(1) = TIinf;

Ubase = zeros(1,N); Ubase(1) = Uinf;
TIbase = zeros(1,N); TIbase(1) = TIinf;

z = zeros(1,N);

for i = 2:N
    funCt = @(auxTheta) fitFun(coeffsFitObjArrayCt,auxTheta,Uwfc(i-1),TIwfc(i-1));
    [Uwfc(i),TIwfc(i)] = wakeModel(wakeModelType,X,funCt(theta(i-1)),Uinf,TIinf);

    funCt = @(auxTheta) fitFun(coeffsFitObjArrayCt,auxTheta,Ubase(i-1),TIbase(i-1));
    [Ubase(i),TIbase(i)] = wakeModel(wakeModelType,X,funCt(0),Uinf,TIinf);
end

f  = 100 * ( sumVar(theta,N,Uwfc,TIwfc,coeffsFitObjArray) - sumVar(z,N,Ubase,TIbase,coeffsFitObjArray) )/( sumVar(z,N,Ubase,TIbase,coeffsFitObjArray) );


end