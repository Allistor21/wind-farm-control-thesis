%Script to plot the optimiser's sensitivity analysis figures, after a run.

close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

runNumber = 0;

%Define base conditions for sensitivity analysis.
N = 2;
Uinf = 8;
TIinf = 8;
X = 8;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

%Define domain for each parameter.
vecX = [6 10];
vecN = [2 3];
vecU = [6 10];
vecTI = [4 12];

prmtrList = {'N','Uinf','TIinf','X'};

clrs = { 'b-*','r-*','k-*';'b--x','r--x','k--x' };
clrs2 = { 'b-^','b:o','b--d';'r-^','r:o','r--d';'k-^','k:o','k--d' }; %TENHO DE CONSTRUIR AS CORES DINAMICAMENTE TAMBEM SHIT

figSize1 = [0 0 0.7 0.7];
quantSize = [0 0 0.5 0.7];
fontSize=22;
lineWidth = 1.8;
markerSize = 9;

%Calculate the baseline wind conditions.
UArray(1) = Uinf; TIArray(1) = TIinf; CtArray(1) = fitFun(coeffsFitObjArrayCt,0,Uinf,TIinf);

for i = 2:N
    CtArray(i) = fitFun(coeffsFitObjArrayCt,0,UArray(i-1),TIArray(i-1));
    [UArray(i),TIArray(i)] = wakeModel(wakeModelType,CtArray(i),UArray(i-1),8,Uinf,TIinf);
end



for f = 1:length(prmtrList)
    load(['opt_' tag '_' num2str(runNumber) '.mat']);

    %--------- Figure: Pitch vs turbine number---------------------------------------------------------------------------------
    domain = struct_sstvt.analysisDomain;

    figure('units','normalized','position',figSize1)

    set(gcf,'color','w'); %Set background color
    set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
    set(gca, 'FontSize', fontSize);
    
    ylabel(['\beta [' char(176) ']']);
    ylim([0 5]);
    xlabel('Turbine number');

    legend('Location','southoutside','NumColumns',3);
    legend('boxoff');
    
    hold on
    
    for i = 1:(1:2:5)
        for j = 1:length(objs)
            x = struct_sstvt.resultArray{i,j}.turbineNumber;
            y = struct_sstvt.resultArray{i,j}.pitchSettings;
            lgdEntry = [struct_sstvt.parameter '=' num2str(domain(i)) ',obj=' struct_sstvt.resultArray{i,j}.objective ];
            plot(x,y,clrs2{i,j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);
            legend('-DynamicLegend')

            xticks(struct_sstvt.resultArray{i,j}.turbineNumber);
        end   
    end
    
    hold off
    
    print(['opt' struct_sstvt.parameter 'pitch_' num2str(runNumber)],'-depsc');

    %--------- Figure: (U & TI) vs turbine number---------------------------------------------------------------------------------

    figure('units','normalized','position',figSize1)

    set(gcf,'color','w'); %Set background color
    set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
    set(gca, 'FontSize', fontSize);

    xlabel('Turbine number');

    legend('Location','southoutside','NumColumns',4);
    legend('boxoff');

    hold on

    yyaxis left
    ylabel('Wind speed [m/s]')
    %ylim([5 8]);
    set(gca,'ycolor','k') 
    plot(x,UArray,'c-*','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName','U,base')
    
    yyaxis right
    ylabel('Tubulence intensity [%]')
    %ylim([6 18])
    set(gca,'ycolor','k') 
    plot(x,TIArray,'c--x','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName','TI,base')
    
    for i = 1:length(objs)
        
        yyaxis left
        lgdEntry = ['U,obj=' num2str(objs(i))];
        plot(x,structX.resultArray{2,i}.turbineU,clrs{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')
    
        yyaxis right
        lgdEntry = ['TI,obj=' num2str(objs(i))];
        plot(x,structX.resultArray{2,i}.turbineTI,clrs{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')
    
    end
    
    hold off)    




















end