function f = sumVar(theta,N,U,TI,coeffsFitObjArray)
%% sumVar
% Function that defines the total of a target study output, as the summation of the respective values for
% all turbines. Such values are calculated with function fitFun.
%%

f = fitFun(coeffsFitObjArray,theta(1),U(1),TI(1));
for i = 2:N
    f = f + fitFun(coeffsFitObjArray,theta(i),U(i),TI(i));
end

end