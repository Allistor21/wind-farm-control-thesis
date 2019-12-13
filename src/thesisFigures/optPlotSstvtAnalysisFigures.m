%Script to plot the optimiser's sensitivity analysis figures, after a run.

close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

%--------------------------------------------- INPUTS -------------------------------------------------------------

runNumber = 2;

%Define base conditions for sensitivity analysis.
N = 6;
Uinf = 8;
TIinf = 8;
X = 7;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

%Define domain for each parameter.
vecN = [2 4 6 8 10];
vecU = [6 7 8 9 10];
vecTI = [4 6 8 10 12];
vecX = [5 6 7 8 9];

%-------------------------------------------------------------------------------------------------------------------

prmtrList = {'N','Uinf','TIinf','X'};

clrs = { 'b-*','k-*','r-*';'b--x','k--x','r--x' };
clrs2 = { 'b-^','b:o','b--d';'k-^','k:o','k--d';'k-^','k:o','k--d';'r-^','r:o','r--d';'r-^','r:o','r--d' };

figSize1 = [0 0 0.7 0.7];
quantSize = [0 0 0.5 0.7];
fontSize = 22;
lineWidth = 1.8;
markerSize = 9;



for f = 1:length(prmtrList)
    load(['opt_sstvt' prmtrList{f} '_' num2str(runNumber) '.mat']);

    %--------- Figure: Pitch vs turbine number---------------------------------------------------------------------------------

    figure('units','normalized','position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);
    
    ylabel(['\beta [' char(176) ']']);
    ylim([0 5]);
    xlabel('Turbine number');

    legend('Location','southoutside','NumColumns',3);
    legend('boxoff');
    
    hold on
    
    for i = (1:2:5)
        for j = 1:length(objs)
            x = struct_sstvt.resultArray{i,j}.turbineNumber;
            y = struct_sstvt.resultArray{i,j}.pitchSettings;
            lgdEntry = [struct_sstvt.parameter '=' num2str(struct_sstvt.analysisDomain(i)) ',obj=' struct_sstvt.resultArray{i,j}.objective ];
            plot(x,y,clrs2{i,j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);
            legend('-DynamicLegend')

            xticks(struct_sstvt.resultArray{i,j}.turbineNumber);
        end   
    end
    
    hold off
    
    print(['opt_' tag '_pitch_' num2str(runNumber)],'-depsc');

    %--------- Figures: (U & TI) vs Turbine number ----------------------------------------------------------------------------

    for i = (1:2:5)
        turbNN = length(struct_sstvt.resultArray{i,1}.turbineNumber);
        
        UArray = zeros(turbNN,1); TIArray = zeros(turbNN,1);
        UArray(1) = struct_sstvt.resultArray{i,1}.turbineU(1);
        TIArray(1) = struct_sstvt.resultArray{i,1}.turbineTI(1);
        CtArray(1) = fitFun(coeffsFitObjArrayCt,0,UArray(1),TIArray(1));
        
        for t = 2:turbNN
            if strcmp(struct_sstvt.parameter,'X')
                [UArray(t),TIArray(t)] = wakeModel(wakeModelType,CtArray(t-1),UArray(t-1),struct_sstvt.analysisDomain(i),UArray(1),TIArray(1));
            else
                [UArray(t),TIArray(t)] = wakeModel(wakeModelType,CtArray(t-1),UArray(t-1),X,UArray(1),TIArray(1));
            end

            CtArray(t) = fitFun(coeffsFitObjArrayCt,0,UArray(t),TIArray(t));
        end

        x = struct_sstvt.resultArray{i,1}.turbineNumber;

        figure('units','normalized','position',figSize1)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);

        xlabel('Turbine number');
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);
    
        legend('Location','southoutside','NumColumns',4);
        legend('boxoff');

        hold on

        yyaxis left
        ylabel('U_{\infty} [m/s]')
        set(gca,'ycolor','k')
        lgdEntry = 'U,No control';
        plot(x,UArray,'c-*','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

        yyaxis right
        ylabel('TI_{\infty} [%]')
        set(gca,'ycolor','k') 
        lgdEntry = 'TI,No control';
        plot(x,TIArray,'c--x','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

        for j = 1:length(objs)
        
            yyaxis left 
            lgdEntry = ['U,obj=' struct_sstvt.resultArray{i,j}.objective];
            plot(x,struct_sstvt.resultArray{i,j}.turbineU,clrs{1,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
            legend('-DynamicLegend')

            yyaxis right
            lgdEntry = ['TI,obj=' struct_sstvt.resultArray{i,j}.objective];
            plot(x,struct_sstvt.resultArray{i,j}.turbineTI,clrs{2,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
            legend('-DynamicLegend')

        end

        hold off

        print(['opt_' tag '_turbineUTI_' prmtrList{f} num2str(struct_sstvt.analysisDomain(i)) '_' num2str(runNumber)],'-depsc');


    end


    %-------- Power & loads vs parameter ----------------------------------------------------------------------------------------

    baseDeltaP = zeros(length(struct_sstvt.analysisDomain),1);
    baseDeltaL = zeros(length(struct_sstvt.analysisDomain),1);

    for i = 1:length(struct_sstvt.analysisDomain)

        NN = length(struct_sstvt.resultArray{i,1}.turbineNumber);
        UU = struct_sstvt.resultArray{i,1}.turbineU(1);
        TT = struct_sstvt.resultArray{i,1}.turbineTI(1);
        z = zeros(NN,1);

        if strcmp(struct_sstvt.parameter,'X')
            deltaPfunc = @(theta) sumPower(theta,NN,UU,TT,struct_sstvt.analysisDomain(i),wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
            deltaLfunc = @(theta) sumPower(theta,NN,UU,TT,struct_sstvt.analysisDomain(i),wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);
        else
            deltaPfunc = @(theta) sumPower(theta,NN,UU,TT,X,wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
            deltaLfunc = @(theta) sumPower(theta,NN,UU,TT,X,wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);
        end
    
        baseDeltaP(i) = deltaPfunc(z);
        baseDeltaL(i) = deltaLfunc(z);
    end

    optDeltaP = zeros(length(struct_sstvt.analysisDomain),length(objs));
    optDeltaL = zeros(length(struct_sstvt.analysisDomain),length(objs));

    for j = 1:length(objs)
        for i = 1:length(struct_sstvt.analysisDomain)
            optDeltaP(i,j) = sum(struct_sstvt.resultArray{i,j}.turbinePower);
            optDeltaL(i,j) = rssq(struct_sstvt.resultArray{i,j}.turbineLoads);
        end
    end

    figure('units','normalized','position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);
    
    xlabel(struct_sstvt.parameter);
    xticks(struct_sstvt.analysisDomain);

    legend('Location','southoutside','NumColumns',4);
    legend('boxoff');


    x = struct_sstvt.analysisDomain;

    hold on

    yyaxis left
    ylabel('Total avg. power [kW]')
    set(gca,'ycolor','k')
    lgdEntry = 'No control';
    plot(x,baseDeltaP,'c-*','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right
    ylabel('RSSQ of BRBM [Nm]')
    set(gca,'ycolor','k') 
    lgdEntry = 'No control';
    plot(x,baseDeltaL,'c--x','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    for j = 1:length(objs)
        
        yyaxis left 
        lgdEntry = ['sum(P),obj=' struct_sstvt.resultArray{i,j}.objective];
        plot(x,optDeltaP(:,j),clrs{1,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

        yyaxis right
        lgdEntry = ['RSSQ(Loads),obj=' struct_sstvt.resultArray{i,j}.objective];
        plot(x,optDeltaL(:,j),clrs{2,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

    end

    hold off

    print(['opt_' tag '_objFunc_'  num2str(runNumber)],'-depsc');



    %-------- deltaP & deltaL vs parameter ----------------------------------------------------------------------------------------

    figure('units','normalized','position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);
    
    xlabel(struct_sstvt.parameter);
    xticks(struct_sstvt.analysisDomain);

    legend('Location','southoutside','NumColumns',3);
    legend('boxoff');


    x = struct_sstvt.analysisDomain;

    hold on

    yyaxis left
    ylabel('\Delta P [%]')
    set(gca,'ycolor','k')

    yyaxis right
    ylabel('\Delta L [%]')
    set(gca,'ycolor','k') 

    for j = 1:length(objs)
        
        yyaxis left 
        lgdEntry = ['\Delta P,obj=' struct_sstvt.resultArray{i,j}.objective];
        plot(x,struct_sstvt.deltaPArray(:,j),clrs{1,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

        yyaxis right
        lgdEntry = ['\Delta L,obj=' struct_sstvt.resultArray{i,j}.objective];
        plot(x,struct_sstvt.deltaLArray(:,j),clrs{2,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

    end

    hold off

    print(['opt_' tag '_deltas_'  num2str(runNumber)],'-depsc');


end