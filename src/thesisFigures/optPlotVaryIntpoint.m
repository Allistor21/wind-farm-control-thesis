%Script to plot the results from studying the effect of the initial point.
close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

intPoints = [0 1 2 3];
runName = 2;

pitchSize = [0 0 0.5 0.7];
fontSize = 18;
lineWidth = 1.8;
markerSize = 8;

clrs = { 'b-*','b:o','b--d';'r-*','r:o','r--d';'k-*','k:o','k--d';'c-*','c:o','c--d' };
clrs2 = { 'b-o','r-o','k-o','c-o';'b--*','r--*','k--*','c--*' };
clrs3 = { 'b-*','r-*','k-*','c-*' };

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to show beta vs turbine number, for all x0 & objectives.

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

ylabel(['\beta [' char(176) ']']);
xlabel('Turbine number');

legend('Location','southoutside','NumColumns',4);
legend('boxoff');

for i = 1:length(intPoints)
    wrkspace = ['opt_x0_' num2str(intPoints(i)) '.mat'];
    load(wrkspace)

    hold on

    for j = 1:length(objs)
        curStruct = struct_x0.resultArray{j};

        x = curStruct.turbineNumber;
        y = curStruct.pitchSettings;

        lgdEntry = ['x_{0}^{' num2str(intPoints(i)) '}, obj=' num2str(objs(j))];

        plot(x,y,clrs{i,j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);

        legend('-DynamicLegend')
    end

    hold off

    xticks(curStruct.turbineNumber);
end

filename = ['opt_varyIntpoint_betaVsTurbine_' num2str(runName)];
print(filename,'-depsc');

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to show turbine power vs turbine number, for all x0 & objectives.

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

ylabel('Average power [kW]')
xlabel('Turbine number');

legend('Location','southoutside','NumColumns',4);
legend('boxoff');

for i = 1:length(intPoints)
    wrkspace = ['opt_x0_' num2str(intPoints(i)) '.mat'];
    load(wrkspace)

    hold on

    for j = 1:length(objs)
        curStruct = struct_x0.resultArray{j};

        x = curStruct.turbineNumber;
        y = curStruct.turbinePower;

        lgdEntry = ['x_{0}^{' num2str(intPoints(i)) '}, obj=' num2str(objs(j))];

        plot(x,y,clrs{i,j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);

        legend('-DynamicLegend')
    end

    hold off

    xticks(curStruct.turbineNumber);
end

filename = ['opt_varyIntpoint_powerVsTurbine_' num2str(runName)];
print(filename,'-depsc');

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to show turbine loads vs turbine number, for all x0 & objectives.

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

ylabel('\sigma_{BM} [Nm]')
xlabel('Turbine number');

legend('Location','southoutside','NumColumns',4);
legend('boxoff');

for i = 1:length(intPoints)
    wrkspace = ['opt_x0_' num2str(intPoints(i)) '.mat'];
    load(wrkspace)

    hold on

    for j = 1:length(objs)
        curStruct = struct_x0.resultArray{j};

        x = curStruct.turbineNumber;
        y = curStruct.turbineLoads;

        lgdEntry = ['x_{0}^{' num2str(intPoints(i)) '}, obj=' num2str(objs(j))];

        plot(x,y,clrs{i,j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);

        legend('-DynamicLegend')
    end

    hold off

    xticks(curStruct.turbineNumber);
end

filename = ['opt_varyIntpoint_loadsVsTurbine_' num2str(runName)];
print(filename,'-depsc');

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to plot deltaP & deltaL.

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

legend('Location','southoutside','NumColumns',4);
legend('boxoff');

x = objs;

hold on

for i = 1:length(intPoints)
    wrkspace = ['opt_x0_' num2str(intPoints(i)) '.mat'];
    load(wrkspace)

    yyaxis left

    ylabel('\Delta P [%]');
    set(gca,'ycolor','k');
    ylim([6.5 7]); 

    y = struct_x0.deltaPArray;
    lgdEntry = ['\Delta P [%], x_{0}^{' num2str(intPoints(i)) '}' ];
    plot(x,y,clrs2{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);
    legend('-DynamicLegend')

    yyaxis right

    ylabel('\Delta L [%]');
    set(gca,'ycolor','k'); 
    %ylim([-0.95 -0.80]);

    y = struct_x0.deltaLArray;
    lgdEntry = ['\Delta L [%], x_{0}^{' num2str(intPoints(i)) '}' ];
    plot(x,y,clrs2{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);
    legend('-DynamicLegend')

end

hold off

xlim([1 3]);
xticks(objs);
xlabel('Optimisation objective')
xticklabels({'Maximise power','Minimise loads','Mixed'});

filename = ['opt_varyIntpoint_deltaPVsAlg_' num2str(runName)];
print(filename,'-depsc');

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to plot elapsedTime

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

legend('Location','southoutside','NumColumns',4);
legend('boxoff');

x = objs;

hold on

for i = 1:length(intPoints)
    wrkspace = ['opt_x0_' num2str(intPoints(i)) '.mat'];
    load(wrkspace)

    y = duration/3600;
    lgdEntry = ['x_{0}^{' num2str(intPoints(i)) '}'];
    plot(x,y,clrs3{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);
    legend('-DynamicLegend')

end

hold off

ylabel('Elapsed time [h]');

xlim([1 3]);
xticks(objs);
xlabel('Optimisation objective')
xticklabels({'Maximise power','Minimise loads','Mixed'});

filename = ['opt_varyIntpoint_elapsedTime_' num2str(runName)];
print(filename,'-depsc');