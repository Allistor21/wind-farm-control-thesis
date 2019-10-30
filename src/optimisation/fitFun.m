function f = fitFun(coeffsFitObjArray,theta,U,TI)
%% fitFun
% Function that builds a polynomial function of type 'poly31' for a target study output. Associates each coefficient
% of the polynomial with the respective curve fit object in coeffsFitObjArray. 
%IMPORTANT NOTE: The fact that a target study output is modeled by a poly31 surface is VERY MUCH hardcoded, here.
%%

f = coeffsFitObjArray{1}(theta) + coeffsFitObjArray{2}(theta)*U + coeffsFitObjArray{3}(theta)*TI + coeffsFitObjArray{4}(theta)*(U^2) + coeffsFitObjArray{5}(theta)*U*TI + coeffsFitObjArray{6}(theta)*(U^3) + coeffsFitObjArray{7}(theta)*(U^2)*TI + coeffsFitObjArray{8}(theta)*(U^4) + coeffsFitObjArray{9}(theta)*(U^3)*TI + coeffsFitObjArray{10}(theta)*(U^5) + coeffsFitObjArray{11}(theta)*(U^4)*TI;


end