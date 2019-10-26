
loads = {'RtAeroCp','CombRootMc1'};


[treatedStruct,newOutList] = FASTSweepUvsTIProcess(sweepStruct,loads,OutList);

s = size(treatedStruct.matrixesUvsTI);
aux1 = zeros(s);
aux2 = zeros(s);

for i = 1:s(1)
    for j = 1:s(2)
        power = treatedStruct.matrixesUvsTI{i,j}(:,1);
        power = power .* ( 0.5 * 1.225 * (treatedStruct.UArray(i)^3) * ( pi*63^2 ) );
        treatedStruct.matrixesUvsTI{i,j}(:,1) = power;
        aux1(i,j) = treatedStruct.matrixesUvsTI{i,j}(1,1);
        aux2(i,j) = treatedStruct.matrixesUvsTI{i,j}(2,2);
    end
end

figure(1)

surf(treatedStruct.TIArray, treatedStruct.UArray, aux1   );

figure(2)

surf(treatedStruct.TIArray, treatedStruct.UArray, aux2   );
