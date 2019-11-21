function sums = rssLoads(theta,N,Uinf,TIinf,X,wakeModelType,coeffsArrayLoad,coeffsArrayCt)
%% minLoad
% Cost function for FASTnATOptimiser, with the objective of minimising a load.
% Calculates the root-sum-square of a load for all N turbines.
%%

%Initilise variables.
sums = 0;
U = Uinf; TI = TIinf;
loadArray = zeros(N,1);

%Loop for each turbine, calculate load and save it, and then apply 
%wake model.
for i = 1:N
    loadArray(i) = fitFun(coeffsArrayLoad,theta(i),U,TI);

    Ct = fitFun(coeffsArrayCt,theta(i),U,TI);
    [U,TI] = wakeModel(wakeModelType,Ct,U,X,Uinf,TIinf);
end

%Determine the rssq of loads.
sums = rssq(loadArray);

end