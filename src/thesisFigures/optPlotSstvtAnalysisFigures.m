%Script to plot the optimiser's sensitivity analysis figures, after a run.

close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'
%%
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

%Define generic properties for figures.
prmtrList = {'N','Uinf','TIinf','X'};

clrs = { 'b-*','k-*','r-*';'b--x','k--x','r--x' };
%clrs2 = { 'b-^','b:o','b--d';'k-^','k:o','k--d';'k-^','k:o','k--d';'r-^','r:o','r--d';'r-^','r:o','r--d' };
clrs2 = { 'b-^','k-^','r-^';'b:o','k:o','r:o';'b:o','k:o','r:o';'b--d','k--d','r--d';'b--d','k--d','r--d' };

clrs3 = { 'b-*','k-*','k-*','r-*','r-*';'b--x','k--x','k--x','r--x','r--x' };

figSize1 = [0 0 1100 700]; figOutSize1 = [0 0 0.6 0.8];
figSize2 = [0 0 900 900]; figOutSize2 = [0 0 0.6 0.8];
figSize3 = [0 0 0.85 0.9];figOutSize3 = [0 0 0.95 1];

UTIylimU = [0.5 1];
UTIylimTI = [1 3.5];

objFuncYlimP = [2000 16000];
objFuncYlimL = [1000 8000];

fontSize = 22;
lineWidth = 1.8;
markerSize = 9;


%%

%Begin loop, a set of figures for each parameter.
for f = 1:length(prmtrList)
    load(['opt_sstvt' prmtrList{f} '_' num2str(runNumber) '.mat']);

    %--------- Figure: Pitch vs turbine number---------------------------------------------------------------------------------

    figure('position',figSize1)

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

            xticks(x);
        end   
    end
    
    hold off
    
    print(['opt_' tag '_pitch_' num2str(runNumber)],'-depsc');

    %--------- Figures: (U & TI) vs Turbine number ----------------------------------------------------------------------------

    for i = (1:2:5)
        turbNN = length(struct_sstvt.resultArray{i,1}.turbineNumber);
        
        UArray = zeros(turbNN,1); TIArray = zeros(turbNN,1); CtArray = zeros(turbNN,1);
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

        figure('position',figSize1)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);

        xlabel('Turbine number');
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);
    
        legend('Location','southoutside','NumColumns',2);
        legend('boxoff');

        hold on

        yyaxis left
        
        ylabel('U_{\infty} [m/s]')
        ylim(UTIylimU);
        set(gca,'ycolor','k')

        yyaxis right

        ylabel('TI_{\infty} [%]')
        ylim(UTIylimTI);
        set(gca,'ycolor','k') 

        for j = 1:length(objs)
        
            yyaxis left
             
            lgdEntry = ['U,obj=' struct_sstvt.resultArray{i,j}.objective];
            plot(x,struct_sstvt.resultArray{i,j}.turbineU/UArray(1),clrs{1,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
            legend('-DynamicLegend')

            yyaxis right

            lgdEntry = ['TI,obj=' struct_sstvt.resultArray{i,j}.objective];
            plot(x,struct_sstvt.resultArray{i,j}.turbineTI/TIArray(1),clrs{2,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
            legend('-DynamicLegend')

        end

        yyaxis left
        
        lgdEntry = 'U,No control';
        plot(x,UArray/UArray(1),'c-*','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

        yyaxis right

        lgdEntry = 'TI,No control';
        plot(x,TIArray/TIArray(1),'c--x','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')


        hold off

        print(['opt_' tag '_turbineUTI_' num2str(i) '_' num2str(runNumber)],'-depsc');


    end

    %-------- Power & loads vs parameter ----------------------------------------------------------------------------------------

    baseDistrP = zeros(length(struct_sstvt.analysisDomain),1);
    baseDistrL = zeros(length(struct_sstvt.analysisDomain),1);

    optDistrP = zeros(length(struct_sstvt.analysisDomain),length(objs));
    optDistrL = zeros(length(struct_sstvt.analysisDomain),length(objs));

    optDeltaP = zeros(length(struct_sstvt.analysisDomain),length(objs));
    optDeltaL = zeros(length(struct_sstvt.analysisDomain),length(objs));

    for i = 1:length(struct_sstvt.analysisDomain)

        NN = length(struct_sstvt.resultArray{i,1}.turbineNumber);
        UU = struct_sstvt.resultArray{i,1}.turbineU(1);
        TT = struct_sstvt.resultArray{i,1}.turbineTI(1);
        z = zeros(NN,1);

        if strcmp(struct_sstvt.parameter,'X')
            Pfunc = @(theta) sumPower(theta,NN,UU,TT,struct_sstvt.analysisDomain(i),wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
            Lfunc = @(theta) sumPower(theta,NN,UU,TT,struct_sstvt.analysisDomain(i),wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);
        else
            Pfunc = @(theta) sumPower(theta,NN,UU,TT,X,wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
            Lfunc = @(theta) sumPower(theta,NN,UU,TT,X,wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);
        end
    
        baseDistrP(i) = Pfunc(z);
        baseDistrL(i) = Lfunc(z);

        for j = 1:length(objs)
            optDistrP(i,j) = Pfunc(struct_sstvt.resultArray{i,j}.pitchSettings);
            optDistrL(i,j) = Lfunc(struct_sstvt.resultArray{i,j}.pitchSettings);

            optDeltaP(i,j) = 100*((optDistrP(i,j) - baseDistrP(i))/baseDistrP(i));
            optDeltaL(i,j) = 100*((optDistrL(i,j) - baseDistrL(i))/baseDistrL(i));
        end
    end

    figure('position',figSize2)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);
    
    xlabel(struct_sstvt.parameter);
    xticks(struct_sstvt.analysisDomain);

    legend('Location','southoutside','NumColumns',4);
    legend('boxoff');


    x = struct_sstvt.analysisDomain;

    hold on

    for j = 1:length(objs)
        
        yyaxis left
         
        lgdEntry = ['sum(P),obj=' struct_sstvt.resultArray{i,j}.objective];
        plot(x,optDistrP(:,j),clrs{1,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

        yyaxis right

        lgdEntry = ['RSSQ(Loads),obj=' struct_sstvt.resultArray{i,j}.objective];
        plot(x,optDistrL(:,j),clrs{2,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

    end

    yyaxis left

    ylabel('Total avg. power [kW]')
    ylim(objFuncYlimP);
    set(gca,'ycolor','k')
    lgdEntry = 'No control';
    plot(x,baseDistrP,'c-*','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right

    ylabel('RSSQ of BRBM [Nm]')
    ylim(objFuncYlimL);
    set(gca,'ycolor','k') 
    lgdEntry = 'No control';
    plot(x,baseDistrL,'c--x','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    hold off

    print(['opt_' tag '_objFunc_'  num2str(runNumber)],'-depsc');



    %-------- deltaP & deltaL vs parameter ----------------------------------------------------------------------------------------
%% deltaP & deltaL vs parameter
    figure('position',figSize2)

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
        %plot(x,optDeltaP(:,j),clrs{1,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

        yyaxis right

        lgdEntry = ['\Delta L,obj=' struct_sstvt.resultArray{i,j}.objective];
        plot(x,struct_sstvt.deltaLArray(:,j),clrs{2,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        %plot(x,optDeltaL(:,j),clrs{2,j},'LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        legend('-DynamicLegend')

    end

    hold off

    print(['opt_' tag '_deltas_'  num2str(runNumber)],'-depsc');


end
%%