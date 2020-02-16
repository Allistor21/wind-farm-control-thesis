%Script to plot figures for case studies 2 and 3.

close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

%Required constants for data preprocessing.
rho = 1.225;
D = 126;
syms A

%-------------------------------------------------- INPUTS -------------------------------------------------------------

%Define base conditions for sensitivity analysis.
N = 5;
Uinf = 8;
TIinf = 6;
X = 5;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

%Define domain for each parameter.
vecN = [3 5 7];
vecU = [6 8 10];
vecTI = [2 6 10];
vecX = [5 7 9];

%------------------------------------------- FIGURE PROPERTIES ----------------------------------------------------------

figSize1 = [0 0 900 600];
figSize2 = [0 0 900 900];
fontSize = 30;
lineWidth = 2.5;
markerSize = 10;

clrsArray = {'r-s'; 'b-p'; 'k-x'}; 
clrsArray2 = {'r-s','r--s'; 'b-p','b--p'; 'k-x','k--x'}; 

lgdList = {'[%]'; '[m/s]'; '[-]'; '[-]'}; 

%----------------------------------------------- CODE TO GENERATE FIGURES ----------------------------------------------------------

names = dir('caseStudy*.mat');
names = {names.name};

for f = 1:length(names)
    load(names{f});

    %------------------------------------ Performance figures ------------------------------------------------------------

    for i = 1:2:3
        
        if (i == 1 & strcmp(prmtr,'X'))
            i = 2;
        end

        %----------------------------------------- Data preprocessing. ------------------------------------------------------------

        %Initialise variables.
        power = zeros(length(struct_sstvt.resultArray{i,1}.turbineNumber),1); 
        loads = zeros(length(struct_sstvt.resultArray{i,1}.turbineNumber),1); 
        wind = zeros(length(struct_sstvt.resultArray{i,1}.turbineNumber),1); 
        turb = zeros(length(struct_sstvt.resultArray{i,1}.turbineNumber),1); 
        baseCps = zeros(length(struct_sstvt.resultArray{i,1}.turbineNumber),1); 
        baseAI = zeros(length(struct_sstvt.resultArray{i,1}.turbineNumber),1); 
        baseCts = zeros(length(struct_sstvt.resultArray{i,1}.turbineNumber),1); 

        power(1) = fitFun(coeffsFitObjArray1,0,struct_sstvt.resultArray{i,1}.turbineU(1),struct_sstvt.resultArray{i,1}.turbineTI(1));
        loads(1) = fitFun(coeffsFitObjArray2,0,struct_sstvt.resultArray{i,1}.turbineU(1),struct_sstvt.resultArray{i,1}.turbineTI(1));
        wind(1) = struct_sstvt.resultArray{i,1}.turbineU(1); 
        turb(1) = struct_sstvt.resultArray{i,1}.turbineTI(1);
        baseCps(1) = power(1)*1000/(0.5*rho*(wind(1)^3)*(pi()*(D^2)/4));
        baseAI(1)  = double(solve([ 4*A*((1-A)^2) == baseCps(1) , A <= 0.5 ],A));
        baseCts(1) = 4*baseAI(1)*(1-baseAI(1));


        U = wind(1); TI = turb(1);
        for b = 2:length(struct_sstvt.resultArray{i,1}.turbineNumber)

            Ct = fitFun(coeffsFitObjArrayCt,0,U,TI);

            if strcmp(prmtr,'X')
                [U,TI] = wakeModel('jensenCrespo',Ct,U,struct_sstvt.analysisDomain(i),wind(1),turb(1));
            else
                [U,TI] = wakeModel('jensenCrespo',Ct,U,X,wind(1),turb(1));
            end
            
            power(b) = fitFun(coeffsFitObjArray1,0,U,TI);
            loads(b) = fitFun(coeffsFitObjArray2,0,U,TI);
            wind(b) = U; 
            turb(b) = TI;

            baseCps(b) = power(b)*1000/(0.5*rho*(U^3)*(pi()*(D^2)/4));
            baseAI(b)  = double(solve([ 4*A*((1-A)^2) == baseCps(b) , A <= 0.5 ],A));
            baseCts(b) = 4*baseAI(b)*(1-baseAI(b));
        end
        
        %----------------------------------------- Pitch vs turbine number --------------------------------------------------------

        figure('position',figSize1)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);

        if ( strcmp(prmtr,'Uinf') & i == 3 ) | ( strcmp(prmtr,'TIinf') & i == 3 ) | ( strcmp(prmtr,'N') & i == 3 ) | ( strcmp(prmtr,'X') & i == 3 )
            legend('-DynamicLegend');
            legend('Location','best');
            legend('boxoff');
        end

        ylim([0 5]);
        ylabel(['\beta_{i} [' char(176) ']']);

        xlabel('Turbine number');
        xlim([1 struct_sstvt.resultArray{i,1}.turbineNumber(length(struct_sstvt.resultArray{i,1}.turbineNumber))]);
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);

        x = struct_sstvt.resultArray{i,1}.turbineNumber;

        hold on

        for j = 1:length(objs)
            
            lgdEntry = ['Obj.=' struct_sstvt.resultArray{i,j}.objective];
            plot(x,struct_sstvt.resultArray{i,j}.pitchSettings,clrsArray{j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry);

        end

        hold off

        grid on

        print(['caseStudy23_' prmtr '_' num2str(i)  '_turbinePitch'],'-depsc');

        %------------------------------------------- Turbine U & TI vs turbine number --------------------------------------------------

        figure('position',figSize2)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);

        xlabel('Turbine number');
        xlim([1 struct_sstvt.resultArray{i,1}.turbineNumber(length(struct_sstvt.resultArray{i,1}.turbineNumber))]);
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);

        x = struct_sstvt.resultArray{i,1}.turbineNumber;

        hold on

        yyaxis left

        set(gca,'ycolor','k')

        ylabel('U [m/s]');
        if (i==2 & strcmp(prmtr,'X')) | (i==3 & strcmp(prmtr,'X'))
            ylim([6.4 8]);
        end

        plot(x,wind,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize)

        for j = 1:length(objs)
            plot(x,struct_sstvt.resultArray{i,j}.turbineU,clrsArray2{j,1},'LineWidth', lineWidth,'MarkerSize',markerSize)
        end

        yyaxis right

        set(gca,'ycolor','k')

        ylabel('TI [%]');
        if (i==1 & strcmp(prmtr,'N'))
            ylim([6 18]);
        elseif (i==2 & strcmp(prmtr,'X')) | (i==3 & strcmp(prmtr,'X'))
            ylim([6 16]);
        end

        lgdEntry = 'Baseline';
        plot(x,turb,'g--o','LineWidth', lineWidth,'MarkerSize',markerSize)

        for j = 1:length(objs)
            plot(x,struct_sstvt.resultArray{i,j}.turbineTI,clrsArray2{j,2},'LineWidth', lineWidth,'MarkerSize',markerSize)
        end

        hold off

        grid on

        print(['caseStudy23_' prmtr '_' num2str(i)  '_turbineUTI'],'-depsc');

        %------------------------------------------- Turbine power & loads vs turbine number --------------------------------------------------

        figure('position',figSize2)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);

        xlabel('Turbine number');
        xlim([1 struct_sstvt.resultArray{i,1}.turbineNumber(length(struct_sstvt.resultArray{i,1}.turbineNumber))]);
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);

        x = struct_sstvt.resultArray{i,1}.turbineNumber;

        hold on

        if ( strcmp(prmtr,'Uinf') & i == 3 )
            legend('Location','northeast');
            legend('boxoff');
            legend('AutoUpdate','off');
            L1 = plot(nan, nan, 'go','LineWidth', lineWidth,'MarkerSize',markerSize);
            L2 = plot(nan, nan, 'rs','LineWidth', lineWidth,'MarkerSize',markerSize);
            L3 = plot(nan, nan, 'bp','LineWidth', lineWidth,'MarkerSize',markerSize);
            L4 = plot(nan, nan, 'kx','LineWidth', lineWidth,'MarkerSize',markerSize);
            legend([L1, L2, L3, L4], {'Baseline','Obj.=Max. power','Obj.=Min. loads','Obj.=Mixed'});
        elseif ( strcmp(prmtr,'N') & i == 3 ) | ( strcmp(prmtr,'X') & i == 3 ) | ( strcmp(prmtr,'TIinf') & i == 3 )
            legend('Location','east');
            legend('boxoff');
            legend('AutoUpdate','off');
            L1 = plot(nan, nan, 'go','LineWidth', lineWidth,'MarkerSize',markerSize);
            L2 = plot(nan, nan, 'rs','LineWidth', lineWidth,'MarkerSize',markerSize);
            L3 = plot(nan, nan, 'bp','LineWidth', lineWidth,'MarkerSize',markerSize);
            L4 = plot(nan, nan, 'kx','LineWidth', lineWidth,'MarkerSize',markerSize);
            legend([L1, L2, L3, L4], {'Baseline','Obj.=Max. power','Obj.=Min. loads','Obj.=Mixed'});
        end

        yyaxis left

        set(gca,'ycolor','k')

        ylabel('Average power [MW]');
        if (i==2 & strcmp(prmtr,'X')) | (i==3 & strcmp(prmtr,'X'))
            ylim([0.8 2]);
        end

        plot(x,power/1000,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize)

        for j = 1:length(objs)
            plot(x,struct_sstvt.resultArray{i,j}.turbinePower/1000,clrsArray2{j,1},'LineWidth', lineWidth,'MarkerSize',markerSize)
        end

        yyaxis right

        set(gca,'ycolor','k')

        ylabel('\sigma_{BRBM_{i}} [Nm]');
        if (i==3 & strcmp(prmtr,'TIinf'))
            ylim([500 770]);
        end

        plot(x,loads,'g--o','LineWidth', lineWidth,'MarkerSize',markerSize)

        for j = 1:length(objs)
            plot(x,struct_sstvt.resultArray{i,j}.turbineLoads,clrsArray2{j,2},'LineWidth', lineWidth,'MarkerSize',markerSize)
        end

        hold off

        grid on

        print(['caseStudy23_' prmtr '_' num2str(i)  '_turbinePowerLoads'],'-depsc');

    end

    %--------------------------------- Delta P vs parameter---------------------------------------------------------------------------------------

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    ylabel('\Delta P_{WF} [%]');

    xlabel([struct_sstvt.parameter ' ' lgdList{f}]);
    xlim([struct_sstvt.analysisDomain(1) struct_sstvt.analysisDomain(length(struct_sstvt.analysisDomain))]);
    xticks(struct_sstvt.analysisDomain);

    x = struct_sstvt.analysisDomain;
    
    hold on

    for j = 1:length(objs)
        lgdEntry = ['Obj.=' struct_sstvt.resultArray{1,j}.objective];
        plot(x,struct_sstvt.deltaPArray(:,j),clrsArray{j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    end

    hold off

    grid on

    print(['caseStudy23_' prmtr  '_deltaP'],'-depsc');

    %--------------------------------- Delta L vs parameter---------------------------------------------------------------------------------------

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    ylabel('\Delta L_{WF} [%]');

    xlabel([struct_sstvt.parameter ' ' lgdList{f}]);
    xlim([struct_sstvt.analysisDomain(1) struct_sstvt.analysisDomain(length(struct_sstvt.analysisDomain))]);
    xticks(struct_sstvt.analysisDomain);

    x = struct_sstvt.analysisDomain;

    hold on

    for j = 1:length(objs)
        lgdEntry = ['Obj.=' struct_sstvt.resultArray{1,j}.objective];
        plot(x,struct_sstvt.deltaLArray(:,j),clrsArray{j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    end

    hold off

    grid on

    print(['caseStudy23_' prmtr  '_deltaL'],'-depsc');

end