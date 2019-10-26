function c = myNLcon(theta,N,Uinf,TIinf,X,coeffsFitObjArrayCt,wakeModelType)

auxC = zeros(N,2);
U = zeros(1,N); U(1) = Uinf;
TI = zeros(1,N); TI(1) = TIinf;

constWS = @(theta,ws) theta - ws + 1;
constTI = @(tetha,turb) theta - 0.25turb

auxC(1,1) = constWS(theta(1),Uinf);
auxC(1,2) = constTI(theta(1),TIinf);
for i = 2:N
    Ct = fitFun(coeffsFitObjArrayCt,theta(i),U(i-1),TI(i-1));
    [U(i) , TI(i)] = wakeModel(wakeModelType,X,Ct,Uinf,TIinf);

    auxC(i,1) = constWS(theta(i),U(i-1));
    auxC(i,2) = constTI(theta(i),TI(i-1));
end

c = @(theta) auxC;