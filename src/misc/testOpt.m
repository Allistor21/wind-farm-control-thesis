%


A = [];
b = [];
Aeq = [];
beq = [];
lb = [0];
ub = [5];

x0 = [1];

%fun = sweepFitObjStruct.fitObjMatrix{1,1};
fun = coeffsFitObjArray1{1};

x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub)