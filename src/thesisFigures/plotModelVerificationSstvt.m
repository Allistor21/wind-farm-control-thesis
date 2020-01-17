%Script to plot figures for the model verification.

close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\modelValidation\windFarmVerification'


prmtrList = {'N','Uinf','TIinf','X'};
prmtrUnitsList = {'[-]','[m/s]','[%]','[m]'};
outputArray = {'Power','CombRootMc1'};

figSize1 = [0 0 900 600];
powerLimArray = {[0 10]; [0 20]; [0 10]; [0 10]};
loadsLimArray = {[0 200]; [0 500]; [0 200]; [0 200]};

fontSize = 22;
lineWidth = 1.8;
markerSize = 9;

for l = 1:length(prmtrList)
    load(['sstvt_' prmtrList{l} '.mat'])

%---------------------- Farm performance vs. parameter -----------------------------------------------------------------------------

    farmEnergyArray = zeros(1,length(struct_sstvt.analysisDomain));
    farmLoadsArray = zeros(1,length(struct_sstvt.analysisDomain));
    for i = 1:length(struct_sstvt.resultArray)

        curResult = struct_sstvt.resultArray{i}{1};
        [curResult,newOutList] = FASTnATprocess(curResult,outputArray,OutList);
        powerArray = zeros(1,length(curResult.turbineNumber));
        loadsArray = zeros(1,length(curResult.turbineNumber));

        for j = 1:length(curResult.turbineNumber)
        
            powerArray(j) = curResult.turbineData{j}(1);
            loadsArray(j) = curResult.turbineData{j}(2);
        end

        farmEnergyArray(i) = sum(powerArray);
        farmLoadsArray(i) = rssq(loadsArray);
    end

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    xlabel([struct_sstvt.parameter ' ' prmtrUnitsList{l}]);
    xticks(struct_sstvt.analysisDomain);
    x = struct_sstvt.analysisDomain;

    hold on

    yyaxis left

    ylabel('Farm-wide energy production [MW]')
    ylim(powerLimArray{l});
    set(gca,'ycolor','k')
    plot(x,farmEnergyArray/1000,'k-*','LineWidth', lineWidth,'MarkerSize',markerSize)

    yyaxis right

    ylabel('Farm-wide fatigue loads [Nm]')
    ylim(loadsLimArray{l});
    set(gca,'ycolor','k') 
    plot(x,farmLoadsArray,'k--x','LineWidth', lineWidth,'MarkerSize',markerSize)

    hold off

    grid on

%----------------- Normalised wind speed at each turbine, for all values in sensitivity domain -------------------------------------------------------------
    
    clrsArray = {'r-x';'b-x';'m-x';'g-x';'k-x'};

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    legend('-DynamicLegend');
    legend('Location','eastoutside');
    legend('boxoff');

    ylabel('U/U_{\infty}');

    xlabel('Turbine number');

    hold on

    for i = 1:length(struct_sstvt.resultArray)

        curResult = struct_sstvt.resultArray{i}{1};

        x = curResult.turbineNumber;
        y = curResult.turbineU/curResult.turbineU(1);

        lgdEntry = [prmtrList{l} '=' num2str(struct_sstvt.analysisDomain(i)) ' ' prmtrUnitsList{l}];
        plot(x,y,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

        %xlim(curResult.turbineNumber);
        xticks(curResult.turbineNumber);
    end

    hold off

    grid on

%----------------- Normalised turbulence intensity at each turbine, for all values in sensitivity domain ------------------------------------------
    
    clrsArray = {'r-x';'b-x';'m-x';'g-x';'k-x'};

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    legend('-DynamicLegend');
    legend('Location','eastoutside');
    legend('boxoff');

    ylabel('TI/TI_{\infty}');

    xlabel('Turbine number');

    hold on

    for i = 1:length(struct_sstvt.resultArray)

        curResult = struct_sstvt.resultArray{i}{1};

        x = curResult.turbineNumber;
        y = curResult.turbineTI/curResult.turbineTI(1);

        lgdEntry = [prmtrList{l} '=' num2str(struct_sstvt.analysisDomain(i)) ' ' prmtrUnitsList{l}];
        plot(x,y,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

        %xlim(curResult.turbineNumber);
        xticks(curResult.turbineNumber);
    end

    hold off

    grid on


end