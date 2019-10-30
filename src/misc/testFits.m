%


outputArray = {'RtAeroCp','CombRootMc1','RtAeroCt','RtTSR','GenPwr'};

[treatedStruct3,newOutList3] = FASTSweepUvsTIProcess(sweepStruct,outputArray,OutList);

s = size(treatedStruct3.matrixesUvsTI);
z = zeros(s);
for i = 1:s(1)
    for j = 1:s(2)
        
        if isnan(treatedStruct3.matrixesUvsTI{i,j})
            z(i,j) = nan(1);
            continue
        end
        
        z(i,j) = treatedStruct3.matrixesUvsTI{i,j}(1,3);
    end
end

[X, Y, Z] = prepareSurfaceData(treatedStruct3.UArray, treatedStruct3.TIArray, z);

fitType = 'poly51';

sft3 = fit([X,Y],Z,fitType);

figure(1)
plot(sft3,[X,Y],Z)

% figure(2)
% plot(sft2,[X2,Y2],Z2)
% 
% figure(3)
% plot(sft3,[X3,Y3],Z3)