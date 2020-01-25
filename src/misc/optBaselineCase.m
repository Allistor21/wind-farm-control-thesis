%Script to calculate power production for baseline case, for comparison with gebraad in chapter 5.

clear all

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

N = 5;
Uinf = 8;
TIinf = 6;
X = 5;

power = zeros(N,1); wind = zeros(N,1); turb = zeros(N,1);

power(1) = fitFun(coeffsFitObjArray1,0,Uinf,TIinf);
wind(1) = Uinf; turb(1) = TIinf;

U = Uinf; TI = TIinf;

for i = 2:N

    Ct = fitFun(coeffsFitObjArrayCt,0,U,TI);
    [U,TI] = wakeModel('jensenCrespo',Ct,U,X,Uinf,TIinf);
    
    power(i) = fitFun(coeffsFitObjArray1,0,U,TI);
    wind(i) = U; turb(i) = TI;
end