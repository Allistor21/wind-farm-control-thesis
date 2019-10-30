function [] = checkFit()
%% checkFit
%
%%

cd C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\src\misc\fitFigs

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_31.mat

outputArray = {'Power','CombRootMc1','RtAeroCt'};
pitchs = (0:0.5:5);
turbs = [8 12 16 20];
turbCol = [2 4 6 8];

FASTClrs = {'-k','-r','-g','-b'};
fitClrs = {'--k','--r','--g','--b'};

pNames = (0:5:50);

lbls = {'Power [kW]','CBRBM [Nm]','Ct'};
lims = {[0 6000],[0 2000],[0.5 1.2]};
tcks = {[0:1000:6000],[0:400:2000],[0.5:0.1:1.2]};

for p = 1:length(pitchs)
    FASTAux = cell(1,length(turbCol));

    str = [ 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\simulations\sweepUvsTIdataset_updt\theta__' num2str(pitchs(p)) '.mat'  ];
    load(str,'sweepStruct','OutList');

    [sweepStruct,newOutList] = FASTSweepUvsTIProcess(sweepStruct,outputArray,OutList);

    for j = 1:length(turbCol)
        mat = nan(length(sweepStruct.UArray),length(turbCol));
        for i = 1:length(sweepStruct.UArray)
            
            if isnan(sweepStruct.matrixesUvsTI{i,turbCol(j)})
                continue
            else
                mat(i,1) = sweepStruct.matrixesUvsTI{i,turbCol(j)}(1,1);
                mat(i,2) = sweepStruct.matrixesUvsTI{i,turbCol(j)}(2,2);
                mat(i,3) = sweepStruct.matrixesUvsTI{i,turbCol(j)}(1,3);
            end
        end

        FASTAux(j) = {mat};
    end


    fitAux = cell(1,length(turbs));

    for t = 1:length(turbs)
        mat = nan(length(sweepStruct.UArray),length(turbs));

        for f = 1:length(sweepStruct.UArray)
            
            if isnan(sweepStruct.UArray(f))
                continue
            else
                mat(f,1) = fitFun31(coeffsFitObjArray1,pitchs(p),sweepStruct.UArray(f),turbs(t));
                mat(f,2) = fitFun31(coeffsFitObjArray2,pitchs(p),sweepStruct.UArray(f),turbs(t));
                mat(f,3) = fitFun31(coeffsFitObjArrayCt,pitchs(p),sweepStruct.UArray(f),turbs(t));
            end
        end

        fitAux(t) = {mat};
    end



    name = ['pitch_' num2str(pitchs(p))];
    figure('Name',name,'units','normalized','position',[0 0 1 1])

    for a = 1:3

        subplot(1,3,a)

        xlabel('Wind speed [m/s');
        xlim([3 12]);
        xticks((3:1:12));

        ylabel(lbls{a});
        %ylim(lims{a});
        %yticks(tcks{a});
        
        for b = 1:length(turbCol)

            x = sweepStruct.UArray;
            yFAST = FASTAux{b}(:,a);
            yFit = fitAux{b}(:,a);

            hold on

            plot(x,yFAST,FASTClrs{b})
            plot(x,yFit,fitClrs{b})

            hold off

        end

        legend('FAST TI=8','fit TI=8','FAST TI=12','fit TI=12','FAST TI=16','fit TI=16','FAST TI=20','fit TI=20')
        legend('boxoff');

    end

    filename = ['pitch_' num2str(pNames(p)) '_31'];
    print(filename,'-dpng');


end

    
end