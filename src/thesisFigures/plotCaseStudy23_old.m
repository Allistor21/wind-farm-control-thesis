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

figSize1 = [0 0 900 900];
figSize2 = [0 0 900 600];
fontSize = 30;
lineWidth = 2.5;
markerSize = 10;

clrsArray = {'r-s'; 'b-p'; 'k-x'}; 
clrsArrayCoeffs = {'r-s','r--s'; 'b-p','b--p'; 'k-x','k--x'}; 

lgdList = {'[%]'; '[m/s]'; '[-]'; '[-]'}; 

ylimPower = {[0.5 2]; [0 4]; [0.5 2]; [0.5 2]}; 
ylimSigma = {[500 760]; [600 900]; [640 740]; [640 740]};
ylimU = {[5.5 8]; [3 10]; [5.5 8]; [5.5 8]};
ylimTI = {[0 20]; [6 25]; [6 18]; [6 18]};
ylimCoeffs = {[0.4 0.6]; [0.3 0.6]; [0.4 0.6]; [0.4 0.6]};


%----------------------------------------------- CODE TO GENERATE FIGURES ----------------------------------------------------------

names = dir('caseStudy*.mat');
names = {names.name};

for f = 1:length(names)
    load(names{f});

    %------------------------------------ Performance figures ------------------------------------------------------------

    for i = 1:2:3

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

        legend('-DynamicLegend');
        legend('Location','southoutside','NumColumns',2);
        legend('boxoff');

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

        %----------------------------------------- Performance coeffs vs turbine number --------------------------------------------------------

        figure('position',figSize2)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);
        
        ylabel('C_{P} & C_{T} [-]');
        ylim(ylimCoeffs{f});

        xlabel('Turbine number');
        xlim([1 struct_sstvt.resultArray{i,1}.turbineNumber(length(struct_sstvt.resultArray{i,1}.turbineNumber))]);
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);

        x = struct_sstvt.resultArray{i,1}.turbineNumber;

        hold on


        %Cp
        plot(x,baseCps,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize)

        aux = zeros(length(struct_sstvt.resultArray{i,1}.turbineNumber),3);
        for j = 1:length(objs)

            for b = 1:length(struct_sstvt.resultArray{i,1}.turbineNumber)
                aux(b,j) = struct_sstvt.resultArray{i,j}.turbinePower(b)*1000/(0.5*rho*(struct_sstvt.resultArray{i,j}.turbineU(b)^3)*(pi()*(D^2)/4));
            end

            plot(x,aux(:,j),clrsArrayCoeffs{j,1},'LineWidth', lineWidth,'MarkerSize',markerSize);
        end

        %Ct
        plot(x,baseCts,'g--o','LineWidth', lineWidth,'MarkerSize',markerSize)

        for j = 1:length(objs)

            for b = 1:length(struct_sstvt.resultArray{i,1}.turbineNumber)
                aux(b,j) = double(solve([ 4*A*((1-A)^2) == aux(b,j) , A <= 0.5 ],A));
                aux(b,j) = 4*aux(b,j)*(1-aux(b,j));
            end

            plot(x,aux(:,j),clrsArrayCoeffs{j,2},'LineWidth', lineWidth,'MarkerSize',markerSize);
        end

        hold off

        grid on

        print(['caseStudy23_' prmtr '_' num2str(i)  '_turbineCoeffs'],'-depsc');

        %------------------------------------------- Turbine U vs turbine number --------------------------------------------------

        figure('position',figSize1)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);

        legend('-DynamicLegend');
        legend('Location','southoutside','NumColumns',2);
        legend('boxoff');

        ylabel('U [m/s]');
        ylim(ylimU{f});

        xlabel('Turbine number');
        xlim([1 struct_sstvt.resultArray{i,1}.turbineNumber(length(struct_sstvt.resultArray{i,1}.turbineNumber))]);
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);

        x = struct_sstvt.resultArray{i,1}.turbineNumber;

        hold on

        lgdEntry = 'Baseline';
        plot(x,wind,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

        for j = 1:length(objs)
            lgdEntry = ['Obj.=' struct_sstvt.resultArray{i,j}.objective];
            plot(x,struct_sstvt.resultArray{i,j}.turbineU,clrsArray{j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        end

        hold off

        grid on

        print(['caseStudy23_' prmtr '_' num2str(i)  '_turbineU'],'-depsc');

        %------------------------------------------- Turbine TI vs turbine number --------------------------------------------------

        figure('position',figSize1)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);

        legend('-DynamicLegend');
        legend('Location','southoutside','NumColumns',2);
        legend('boxoff');

        ylabel('TI [%]');
        ylim(ylimTI{f});

        xlabel('Turbine number');
        xlim([1 struct_sstvt.resultArray{i,1}.turbineNumber(length(struct_sstvt.resultArray{i,1}.turbineNumber))]);
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);

        x = struct_sstvt.resultArray{i,1}.turbineNumber;

        hold on

        lgdEntry = 'Baseline';
        plot(x,turb,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

        for j = 1:length(objs)
            lgdEntry = ['Obj.=' struct_sstvt.resultArray{i,j}.objective];
            plot(x,struct_sstvt.resultArray{i,j}.turbineTI,clrsArray{j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        end

        hold off

        grid on

        print(['caseStudy23_' prmtr '_' num2str(i)  '_turbineTI'],'-depsc');

        %------------------------------------------- Turbine power vs turbine number --------------------------------------------------

        figure('position',figSize1)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);

        legend('-DynamicLegend');
        legend('Location','southoutside','NumColumns',2);
        legend('boxoff');

        ylabel('Power [MW]');
        ylim(ylimPower{f});

        xlabel('Turbine number');
        xlim([1 struct_sstvt.resultArray{i,1}.turbineNumber(length(struct_sstvt.resultArray{i,1}.turbineNumber))]);
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);

        x = struct_sstvt.resultArray{i,1}.turbineNumber;

        hold on

        lgdEntry = 'Baseline';
        plot(x,power/1000,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

        for j = 1:length(objs)
            lgdEntry = ['Obj.=' struct_sstvt.resultArray{i,j}.objective];
            plot(x,struct_sstvt.resultArray{i,j}.turbinePower/1000,clrsArray{j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        end

        hold off

        grid on

        print(['caseStudy23_' prmtr '_' num2str(i)  '_turbinePower'],'-depsc');

        %------------------------------------------- Turbine Loads vs turbine number --------------------------------------------------

        figure('position',figSize1)

        set(gcf,'color','w');
        set(gca, 'FontName', 'Arial');
        set(gca, 'FontSize', fontSize);

        legend('-DynamicLegend');
        legend('Location','southoutside','NumColumns',2);
        legend('boxoff');

        ylabel('\sigma_{BRBM} [Nm]');
        ylim(ylimSigma{f});

        xlabel('Turbine number');
        xlim([1 struct_sstvt.resultArray{i,1}.turbineNumber(length(struct_sstvt.resultArray{i,1}.turbineNumber))]);
        xticks(struct_sstvt.resultArray{i,1}.turbineNumber);

        x = struct_sstvt.resultArray{i,1}.turbineNumber;

        hold on

        lgdEntry = 'Baseline';
        plot(x,loads,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

        for j = 1:length(objs)
            lgdEntry = ['Obj.=' struct_sstvt.resultArray{i,j}.objective];
            plot(x,struct_sstvt.resultArray{i,j}.turbineLoads,clrsArray{j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
        end

        hold off

        grid on

        print(['caseStudy23_' prmtr '_' num2str(i)  '_turbineLoads'],'-depsc');

    end

    %--------------------------------- Delta P vs parameter---------------------------------------------------------------------------------------

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    legend('-DynamicLegend');
    legend('Location','southoutside','NumColumns',2);
    legend('boxoff');

    ylabel('\Delta P [%]');

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

    legend('-DynamicLegend');
    legend('Location','southoutside','NumColumns',2);
    legend('boxoff');

    ylabel('\Delta L [%]');

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

    %--------------------------------- Total WF power vs parameter---------------------------------------------------------------------------------------

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    legend('-DynamicLegend');
    legend('Location','southoutside','NumColumns',2);
    legend('boxoff');

    ylabel('FWEP [MW]');

    xlabel([struct_sstvt.parameter ' ' lgdList{f}]);
    xlim([struct_sstvt.analysisDomain(1) struct_sstvt.analysisDomain(length(struct_sstvt.analysisDomain))]);
    xticks(struct_sstvt.analysisDomain);

    x = struct_sstvt.analysisDomain;


    
    hold on

    baseFarmPower = zeros(length(struct_sstvt.analysisDomain),1);
    for b = 1:2:3
        if strcmp(prmtr,'X')
            baseFarmPower(b) = sumPower(zeros(length(struct_sstvt.resultArray{b,1}.turbineNumber),1),length(struct_sstvt.resultArray{b,1}.turbineNumber),struct_sstvt.resultArray{b,1}.turbineU(1),struct_sstvt.resultArray{b,1}.turbineTI(1),struct_sstvt.analysisDomain(b),wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
        else
            baseFarmPower(b) = sumPower(zeros(length(struct_sstvt.resultArray{b,1}.turbineNumber),1),length(struct_sstvt.resultArray{b,1}.turbineNumber),struct_sstvt.resultArray{b,1}.turbineU(1),struct_sstvt.resultArray{b,1}.turbineTI(1),X,wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
        end
    end

    lgdEntry = 'Baseline';
    plot(x,baseFarmPower/1000,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

    for j = 1:length(objs)

        farmPower = zeros(length(struct_sstvt.analysisDomain),1);
        for b = 1:2:3

            farmPower(b) = sum(struct_sstvt.resultArray{b,j}.turbinePower);
        end

        lgdEntry = ['Obj.=' struct_sstvt.resultArray{1,j}.objective];
        plot(x,farmPower/1000,clrsArray{j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    end

    hold off

    grid on

    print(['caseStudy23_' prmtr  '_farmPower'],'-depsc');

    %--------------------------------- overall fatigue inducing loads vs parameter---------------------------------------------------------------------------------------

    figure('position',figSize1)

    set(gcf,'color','w');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', fontSize);

    legend('-DynamicLegend');
    legend('Location','southoutside','NumColumns',2);
    legend('boxoff');

    ylabel('FWFL [Nm]');

    xlabel([struct_sstvt.parameter ' ' lgdList{f}]);
    xlim([struct_sstvt.analysisDomain(1) struct_sstvt.analysisDomain(length(struct_sstvt.analysisDomain))]);
    xticks(struct_sstvt.analysisDomain);

    x = struct_sstvt.analysisDomain;
    
    hold on

    baseFarmLoads = zeros(length(struct_sstvt.analysisDomain),1);
    for b = 1:2:3
        if strcmp(prmtr,'X')
            baseFarmLoads(b) = rssLoads(zeros(length(struct_sstvt.resultArray{b,1}.turbineNumber),1),length(struct_sstvt.resultArray{b,1}.turbineNumber),struct_sstvt.resultArray{b,1}.turbineU(1),struct_sstvt.resultArray{b,1}.turbineTI(1),struct_sstvt.analysisDomain(b),wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);
        else
            baseFarmLoads(b) = rssLoads(zeros(length(struct_sstvt.resultArray{b,1}.turbineNumber),1),length(struct_sstvt.resultArray{b,1}.turbineNumber),struct_sstvt.resultArray{b,1}.turbineU(1),struct_sstvt.resultArray{b,1}.turbineTI(1),X,wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);
        end
    end

    lgdEntry = 'Baseline';
    plot(x,baseFarmLoads,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

    for j = 1:length(objs)

        farmLoads = zeros(length(struct_sstvt.analysisDomain),1);
        for b = 1:2:3
            farmLoads(b) = rssq(struct_sstvt.resultArray{b,j}.turbineLoads); 
        end

        lgdEntry = ['Obj.=' struct_sstvt.resultArray{1,j}.objective];
        plot(x,farmLoads,clrsArray{j},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    end

    hold off

    grid on

    print(['caseStudy23_' prmtr  '_farmLoads'],'-depsc');

end