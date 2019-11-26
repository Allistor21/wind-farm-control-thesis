%


outputArray = {'Power','CombRootMc1','RtAeroCt'};
pitchs = [0 2.5 5];
turbs = [8 12 16];
turbCol = [1 3 5];
pitchCellFAST = cell(1,length(pitchs));


for p = 1:length(pitchs)
    turbAux = cell(1,length(pitchs))

    str = [ 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\simulations\sweepUvsTIdataset_updt\theta__' num2str(pitchs(p)) '.mat'  ];
    load(str,'sweepStruct','OutList');

    [sweepStruct,newOutList] = FASTSweepUvsTIProcess(sweepStruct,outputArray,OutList);

    for j = 1:length(turbCol)
        mat = nan(12,3)
        for i = 1:length(sweepStruct.UArray)
            
            
            if isnan(sweepStruct.matrixesUvsTI{i,turbCol(j)})
                continue
            else
                mat(i,1) = sweepStruct.matrixesUvsTI{i,turbCol(j)}(1,1);
                mat(i,2) = sweepStruct.matrixesUvsTI{i,turbCol(j)}(2,2);
                mat(i,3) = sweepStruct.matrixesUvsTI{i,turbCol(j)}(1,3);
            end
        end

        turbAux(j) = {mat}
    end

    pitchCellFAST(p) = {turbAux}
end

%Calcular com fits

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

pitchCellPoli = cell(1,length(pitchs));

Vs = sweepStruct.UArray;

for r = 1:length(pitchs)

    turbAux = cell(1,length(pitchs))

    for t = 1:length(turbs)
        mat = nan(12,3)

        for f = 1:length(sweepStruct.UArray)
            mat(f,1) = fitFun(coeffsFitObjArray1,pitchs(r),sweepStruct.UArray(f),turbs(t));
            mat(f,2) = fitFun(coeffsFitObjArray2,pitchs(r),sweepStruct.UArray(f),turbs(t));
            mat(f,3) = fitFun(coeffsFitObjArrayCt,pitchs(r),sweepStruct.UArray(f),turbs(t));
        end
        turbAux(t) = {mat}
    end

    pitchCellPoli(r) = {turbAux}
end