%Script to plot the results from studying the effect of the fmincon algorithm on the optimisation.
close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

algs = [0 1 2 3];

pitchSize = [0 0 0.5 0.7];
fontSize = 18;
lineWidth = 1.8;
markerSize = 8;

clrs = { 'b-*','b:o','b--d';'r-*','r:o','r--d';'k-*','k:o','k--d';'c-*','c:o','c--d' };
clrs2 = { 'b-o','r-o','k-o','c-o';'b--*','r--*','k--*','c--*' };
clrs3 = { 'b-*','r-*','k-*','c-*' };

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to show beta vs turbine number, for all algorithms & objectives.

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

ylabel(['\beta [' char(176) ']']);
xlabel('Turbine number');

legend('Location','southoutside','NumColumns',3);
legend('boxoff');

for i = 1:length(algs)
    wrkspace = ['opt_Algorithm_' num2str(algs(i)) '.mat'];
    load(wrkspace)

    hold on

    for j = 1:length(objs)
        curStruct = struct_Algorithm.resultArray{j};

        x = curStruct.turbineNumber;
        y = curStruct.pitchSettings;

        lgdEntry = ['Alg.=' struct_Algorithm.Algorithm ', obj=' num2str(objs(j))];

        plot(x,y,clrs{i,j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);

        legend('-DynamicLegend')
    end

    hold off

    xticks(curStruct.turbineNumber);
end

print('opt_varyAlg_betaVsTurbine','-depsc');

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to show turbine power vs turbine number, for all algorithms & objectives.

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

ylabel('Average power [kW]')
xlabel('Turbine number');

legend('Location','southoutside','NumColumns',3);
legend('boxoff');

for i = 1:length(algs)
    wrkspace = ['opt_Algorithm_' num2str(algs(i)) '.mat'];
    load(wrkspace)

    hold on

    for j = 1:length(objs)
        curStruct = struct_Algorithm.resultArray{j};

        x = curStruct.turbineNumber;
        y = curStruct.turbinePower;

        lgdEntry = ['Alg.=' struct_Algorithm.Algorithm ', obj=' num2str(objs(j))];

        plot(x,y,clrs{i,j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);

        legend('-DynamicLegend')
    end

    hold off

    xticks(curStruct.turbineNumber);
end

print('opt_varyAlg_powerVsTurbine','-depsc');

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to show turbine loads vs turbine number, for all algorithms & objectives.

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

ylabel('\sigma_{BM} [Nm]')
xlabel('Turbine number');

legend('Location','southoutside','NumColumns',3);
legend('boxoff');

for i = 1:length(algs)
    wrkspace = ['opt_Algorithm_' num2str(algs(i)) '.mat'];
    load(wrkspace)

    hold on

    for j = 1:length(objs)
        curStruct = struct_Algorithm.resultArray{j};

        x = curStruct.turbineNumber;
        y = curStruct.turbineLoads;

        lgdEntry = ['Alg.=' struct_Algorithm.Algorithm ', obj=' num2str(objs(j))];

        plot(x,y,clrs{i,j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);

        legend('-DynamicLegend')
    end

    hold off

    xticks(curStruct.turbineNumber);
end

print('opt_varyAlg_loadsVsTurbine','-depsc');

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to plot deltaP & deltaL.

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

legend('Location','southoutside','NumColumns',2);
legend('boxoff');

x = objs;

hold on

for i = 1:length(algs)
    wrkspace = ['opt_Algorithm_' num2str(algs(i)) '.mat'];
    load(wrkspace)

    yyaxis left

    ylabel('\Delta P [%]');
    set(gca,'ycolor','k'); 

    y = struct_Algorithm.deltaPArray;
    lgdEntry = ['\Delta P [%], alg.=' struct_Algorithm.Algorithm ];
    plot(x,y,clrs2{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);
    legend('-DynamicLegend')

    yyaxis right

    ylabel('\Delta L [%]');
    set(gca,'ycolor','k'); 
    ylim([-0.95 -0.80]);

    y = struct_Algorithm.deltaLArray;
    lgdEntry = ['\Delta L [%], alg.=' struct_Algorithm.Algorithm ];
    plot(x,y,clrs2{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);
    legend('-DynamicLegend')

end

hold off

xlim([1 3]);
xticks(objs);
xlabel('Optimisation objective')
xticklabels({'Maximise power','Minimise loads','Mixed'});

print('opt_varyAlg_deltaPVsAlg','-depsc');

%----------------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------
%Figure to plot elapsedTime

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

legend('Location','southoutside','NumColumns',3);
legend('boxoff');

x = objs;

hold on

for i = 1:length(algs)
    wrkspace = ['opt_Algorithm_' num2str(algs(i)) '.mat'];
    load(wrkspace)

    y = duration/3600;
    lgdEntry = ['Alg.=' struct_Algorithm.Algorithm ];
    plot(x,y,clrs3{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);
    legend('-DynamicLegend')

end

hold off

ylabel('Elapsed time [h]');

xlim([1 3]);
xticks(objs);
xlabel('Optimisation objective')
xticklabels({'Maximise power','Minimise loads','Mixed'});

print('opt_varyAlg_elapsedTime','-depsc');