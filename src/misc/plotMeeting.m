% 
% loads = {'RtAeroCp','CombRootMc1'};
% 
% 
% [treatedStruct,newOutList] = FASTSweepUvsTIProcess(sweepStruct,loads,OutList);
% 
% s = size(treatedStruct.matrixesUvsTI);
% aux1 = zeros(s);
% aux2 = zeros(s);
% 
% for i = 1:s(1)
%     for j = 1:s(2)
%         power = treatedStruct.matrixesUvsTI{i,j}(:,1);
%         power = power .* ( 0.5 * 1.225 * (treatedStruct.UArray(i)^3) * ( pi*63^2 ) );
%         treatedStruct.matrixesUvsTI{i,j}(:,1) = power;
%         aux1(i,j) = treatedStruct.matrixesUvsTI{i,j}(1,1);
%         aux2(i,j) = treatedStruct.matrixesUvsTI{i,j}(2,2);
%     end
% end
% 
% figure(1)
% 
% surf(treatedStruct.TIArray, treatedStruct.UArray, aux1   );
% 
% figure(2)
% 
% surf(treatedStruct.TIArray, treatedStruct.UArray, aux2   );
close all

clrs = {'b-^','b--o','b-.d';'r-^','r--o','r-.d'};

figure('units','normalized','position',[0 0 0.7 0.7])

x = (1:1:5);

hold on

for i = 1:3
    
    yyaxis left
    y1 = structX.resultArray{2,i}.turbinePower;
    plot(x,y1,clrs{1,i});
    
    yyaxis right
    y2 = structX.resultArray{2,i}.turbineLoads;
    plot(x,y2,clrs{2,i});
end

hold off

legend('Power, obj = maxPower','Power, obj = minLoads','Power, obj = mixed','Load, obj = maxPower','Load, obj = minLoads','Load, obj = mixed')


LLLL = minLoads(structX.resultArray{2,3}.pitchSettings,N,Uinf,TIinf,8,wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt)

result = zeros(2,3);

for i = 1:3
    result(1,i) = maxPower(structX.resultArray{2,i}.pitchSettings,N,Uinf,TIinf,8,wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt)

    result(2,i) = minLoads(structX.resultArray{2,i}.pitchSettings,N,Uinf,TIinf,8,wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt)
end