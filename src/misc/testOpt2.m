%Script to test optimisation functions.

%theta = sym('theta',[1 3])
N = 4;
U = [8,6.5,5.8,5];
TI = [10,12.2,15.5,16];

A = [];
b = [];
Aeq = [];
beq = [];
lb = [0,0,0,0];
ub = [5,5,5,5];

x0 = [1,1,1,1];

func = @(theta) deltaVar(coeffsFitObjArray2,N,theta,U,TI);

x = fmincon(func,x0,A,b,Aeq,beq,lb,ub);