%Script to plot figures for the model verification.

close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\modelValidation\windFarmVerification'

syms A

prmtrList = {'N','Uinf','TIinf','X'};
lgdPrmtrList = {'N','U_{\infty}','TI_{\infty}','X'};
prmtrUnitsList = {' [-]',' [m/s]',' [%]','D [m]'};
outputArray = {'Power','CombRootMc1','RtAeroCt'};
legendLocation = {'southeast','southeast','southeast','northwest'};
clrsArray = {'r-x';'b-p';'m-d';'g-o';'k-s'};

figSize1 = [0 0 900 820];
figSize2 = [0 0 1200 600];
powerLimArray = {[0 10]; [0 20]; [0 10]; [0 10]};
loadsLimArray = {[0.5 2.5]; [1 2.5]; [1.3 1.6]; [1.3 1.6]};
ULimArray = {[4 8];[2 12];[4 8];[3 8]};
TILimAray = {[5 20];[5 25];[4 20];[8 40]};

fontSize = 35;
lineWidth = 4;
markerSize = 16;

for l = 1:length(prmtrList)
    load(['sstvt_' prmtrList{l} '2.mat'])

%----------------- Pre-process data -------------------------------------------------------------------------------------------------

    farmEnergyArray = zeros(1,length(struct_sstvt.analysisDomain));
    farmLoadsArray = zeros(1,length(struct_sstvt.analysisDomain));
    axialCells = cell(1,length(struct_sstvt.resultArray));
    CtCells = cell(1,length(struct_sstvt.resultArray));
    energyCells = cell(1,length(struct_sstvt.resultArray));
    loadsCells = cell(1,length(struct_sstvt.resultArray));

    for i = 1:length(struct_sstvt.resultArray)

        curResult = struct_sstvt.resultArray{i}{1};
        [curResult,newOutList] = FASTnATprocess(curResult,outputArray,OutList);
        powerArray = zeros(1,length(curResult.turbineNumber));
        loadsArray = zeros(1,length(curResult.turbineNumber));
        axialArray = zeros(1,length(curResult.turbineNumber));
        CtArray = zeros(1,length(curResult.turbineNumber));

        for j = 1:length(curResult.turbineNumber)

            if isnan(curResult.turbineData{j})
                continue
            end
        
            powerArray(j) = curResult.turbineData{j}(1,1);
            loadsArray(j) = curResult.turbineData{j}(2,2);
            CtArray(j) = curResult.turbineData{j}(1,3);

            a = 0;
            Ct = curResult.turbineData{j}(1,3);
            if Ct >= 1
                a = 0.5;
            else
                a = double(solve([ 4*A*(1-A) == Ct , A <= 0.5 ],A));
            end

            axialArray(j) = a;
        end

        farmEnergyArray(i) = sum(powerArray);
        farmLoadsArray(i) = rssq(loadsArray);
        axialCells{i} = axialArray;
        CtCells{i} = CtArray;
        energyCells{i} = powerArray;
        loadsCells{i} = loadsArray;
    end

%---------------------- Farm performance vs. parameter -----------------------------------------------------------------------------

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    xlabel([struct_sstvt.parameter ' ' prmtrUnitsList{l}]);
    xlim([struct_sstvt.analysisDomain(1) struct_sstvt.analysisDomain(length(struct_sstvt.analysisDomain))]);
    xticks(struct_sstvt.analysisDomain);
    x = struct_sstvt.analysisDomain;

    hold on

    yyaxis left

    ylabel('FWEP [MW]')
    ylim(powerLimArray{l});
    set(gca,'ycolor','k')
    plot(x,farmEnergyArray/1000,'k-*','LineWidth', lineWidth,'MarkerSize',markerSize)

    yyaxis right

    ylabel('FWFL [kNm]')
    ylim(loadsLimArray{l});
    set(gca,'ycolor','k') 
    plot(x,farmLoadsArray/1000,'k--x','LineWidth', lineWidth,'MarkerSize',markerSize)

    hold off

    grid on

    print(['verifFarmPerformance_' prmtrList{l} '_2'],'-depsc');

%----------------- Wind speed at each turbine, for all values in sensitivity domain -------------------------------------------------------------

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    %legend('-DynamicLegend');
    %legend('Location','southoutside','NumColumns',length(struct_sstvt.resultArray));
    %legend('boxoff');

    ylabel('U [m/s]');
    ylim(ULimArray{l});

    xlabel('Turbine number');

    hold on

    for i = 1:length(struct_sstvt.resultArray)

        curResult = struct_sstvt.resultArray{i}{1};

        x = curResult.turbineNumber;
        y = curResult.turbineU;

        %lgdEntry = [lgdPrmtrList{l} '=' num2str(struct_sstvt.analysisDomain(i)) ' ' prmtrUnitsList{l}];
        %plot(x,y,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        plot(x,y,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize)

    end

    hold off

    xticks(curResult.turbineNumber);
    xlim([1 curResult.turbineNumber(length(curResult.turbineNumber))]);

    grid on

    print(['verifDistrWS_' prmtrList{l} '_2'],'-depsc');

%----------------- Turbulence intensity at each turbine, for all values in sensitivity domain ------------------------------------------

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    legend('-DynamicLegend');
    legend('Location',legendLocation{l},'NumColumns',2);
    legend('boxoff');

    ylabel('TI [%]');
    ylim(TILimAray{l});

    xlabel('Turbine number');

    hold on

    for i = 1:length(struct_sstvt.resultArray)

        curResult = struct_sstvt.resultArray{i}{1};

        x = curResult.turbineNumber;
        y = curResult.turbineTI;

        lgdEntry = [lgdPrmtrList{l} '= ' num2str(struct_sstvt.analysisDomain(i)) prmtrUnitsList{l}];
        plot(x,y,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

    end

    hold off

    xticks(curResult.turbineNumber);
    xlim([1 curResult.turbineNumber(length(curResult.turbineNumber))]);

    grid on

    print(['verifDistrTI_' prmtrList{l} '_2'],'-depsc');

%----------------- Axial induction factor (calculated from Ct) at each turbine, for all values in sensitivity domain ------------------------------------------

    figure('position',figSize2)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    legend('-DynamicLegend');
    %legend('Location','southoutside','NumColumns',length(struct_sstvt.resultArray));
    legend('Location','eastoutside');
    legend('boxoff');

    ylabel('a [-]');
    %ylim(TILimAray{l});

    xlabel('Turbine number');

    hold on

    for i = 1:length(struct_sstvt.resultArray)

        curResult = struct_sstvt.resultArray{i}{1};

        x = curResult.turbineNumber;
        y = axialCells{i};

        lgdEntry = [lgdPrmtrList{l} '= ' num2str(struct_sstvt.analysisDomain(i)) prmtrUnitsList{l}];
        plot(x,y,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

    end

    hold off

    xticks(curResult.turbineNumber);
    xlim([1 curResult.turbineNumber(length(curResult.turbineNumber))]);

    grid on

    print(['verifDistrInduc_' prmtrList{l} '_2'],'-depsc');

end