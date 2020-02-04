%Script to plot all figures for case study 1, in optimisation chapter

close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\case_study_1'

load('caseStudy1.mat')

figSize1 = [0 0 900 900];
figSize2 = [0 0 1200 600];
fontSize = 30;
lineWidth = 2.5;
markerSize = 10;

clrsArray = {'r-s';'b-p';'k-x'};
legendLocation = {'southoutside','eastoutside'};

%------------ Calculate baseline values -------------------------------------------------------------------------------------------------

load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

N = 5;
Uinf = 8;
TIinf = 6;
X = 5;

rho = 1.225;
D = 126;
syms A C
gearboxRatio = 97; %These three values are to calculate the TSR, check function turbineSim.
slope = 41.5289;
intercept = 545.5132;

power = zeros(N,1); loads = zeros(N,1); wind = zeros(N,1); turb = zeros(N,1); baseCps = zeros(N,1); baseAI = zeros(N,1); baseCts = zeros(N,1); baseTSR = zeros(N,1);

power(1) = fitFun(coeffsFitObjArray1,0,Uinf,TIinf);
loads(1) = fitFun(coeffsFitObjArray2,0,Uinf,TIinf);
wind(1) = Uinf; turb(1) = TIinf;
baseCps(1) = power(1)*1000/(0.5*rho*(Uinf^3)*(pi()*(D^2)/4));
baseAI(1)  = double(solve([ 4*A*((1-A)^2) == baseCps(1) , A <= 0.5 ],A));
baseCts(1) = 4*baseAI(1)*(1-baseAI(1));
baseTSR(1) = ((D/2)*((slope*wind(1) + intercept)/gearboxRatio))/wind(1);


U = Uinf; TI = TIinf;
for i = 2:N

    Ct = fitFun(coeffsFitObjArrayCt,0,U,TI);
    [U,TI] = wakeModel('jensenCrespo',Ct,U,X,Uinf,TIinf);
    
    power(i) = fitFun(coeffsFitObjArray1,0,U,TI);
    loads(i) = fitFun(coeffsFitObjArray2,0,U,TI);
    wind(i) = U; turb(i) = TI;

    baseCps(i) = power(i)*1000/(0.5*rho*(U^3)*(pi()*(D^2)/4));
    baseAI(i)  = double(solve([ 4*A*((1-A)^2) == baseCps(i) , A <= 0.5 ],A));
    baseCts(i) = 4*baseAI(i)*(1-baseAI(i));
    baseTSR(i) = ((D/2)*((slope*wind(i) + intercept)/gearboxRatio))/wind(i);
end

%------------Pitch setting vs. turbine, vs. objective------------------------------------------------------------------------------------

figure('position',figSize1)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
legend('Location',legendLocation{1},'NumColumns',2);
legend('boxoff');

ylim([0 5]);
ylabel(['\beta_{i} [' char(176) ']']);

xlabel('Turbine number')

x = 1:1:5;

hold on

for i = 1:3
    lgdEntry = ['Obj.=' caseStudy1Array{i}.objective];
    plot(x,caseStudy1Array{i}.pitchSettings,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
end

hold off

grid on

print('caseStudy1_turbinePitch','-depsc');

%----------- Turbine power vs. turbine, vs objective --------------------------------------------------------------------------------------

figure('position',figSize1)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
legend('Location',legendLocation{1},'NumColumns',2);
legend('boxoff');

ylim([0.5 2]);
ylabel('Power [MW]');

xlabel('Turbine number')

x = 1:1:5;

hold on

lgdEntry = 'Baseline';
plot(x,power/1000,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

for i = 1:3
    lgdEntry = ['Obj.=' caseStudy1Array{i}.objective];
    plot(x,caseStudy1Array{i}.turbinePower/1000,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
end

hold off

grid on

print('caseStudy1_turbinePower','-depsc');

%----------- Turbine loads vs. turbine, vs objective --------------------------------------------------------------------------------------

figure('position',figSize1)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
legend('Location',legendLocation{1},'NumColumns',2);
legend('boxoff');

ylim([640 740]);
ylabel('\sigma_{BRBM} [Nm]');

xlabel('Turbine number')

x = 1:1:5;

hold on

lgdEntry = 'Baseline';
plot(x,loads,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

for i = 1:3
    lgdEntry = ['Obj.=' caseStudy1Array{i}.objective];
    plot(x,caseStudy1Array{i}.turbineLoads,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
end

hold off

grid on

print('caseStudy1_turbineLoads','-depsc');

%----------- Turbine WS vs. turbine, vs objective --------------------------------------------------------------------------------------

figure('position',figSize1)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
legend('Location',legendLocation{1},'NumColumns',2);
legend('boxoff');

%ylim([0.5 0.75]);
ylabel('U [m/s]');

xlabel('Turbine number')

x = 1:1:5;

hold on

lgdEntry = 'Baseline';
plot(x,wind,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

for i = 1:3
    lgdEntry = ['Obj.=' caseStudy1Array{i}.objective];
    plot(x,caseStudy1Array{i}.turbineU,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
end

hold off

grid on

print('caseStudy1_turbineU','-depsc');

%----------- Turbine TI vs. turbine, vs objective --------------------------------------------------------------------------------------

figure('position',figSize1)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
legend('Location',legendLocation{1},'NumColumns',2);
legend('boxoff');

%ylim([0.5 0.75]);
ylabel('TI [%]');

xlabel('Turbine number')

x = 1:1:5;

hold on

lgdEntry = 'Baseline';
plot(x,turb,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

for i = 1:3
    lgdEntry = ['Obj.=' caseStudy1Array{i}.objective];
    plot(x,caseStudy1Array{i}.turbineTI,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
end

hold off

grid on

print('caseStudy1_turbineTI','-depsc');

%----------- Turbine Cp vs. turbine, vs objective --------------------------------------------------------------------------------------

figure('position',figSize1)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
legend('Location',legendLocation{1},'NumColumns',2);
legend('boxoff');

ylim([0.4 0.5]);
ylabel('C_{P} [-]');

xlabel('Turbine number')

x = 1:1:5;

hold on

lgdEntry = 'Baseline';
plot(x,baseCps,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

aux = zeros(N,3);
for i = 1:3

    for j = 1:N
        aux(j,i) = caseStudy1Array{i}.turbinePower(j)*1000/(0.5*rho*(caseStudy1Array{i}.turbineU(j)^3)*(pi()*(D^2)/4));
    end

    lgdEntry = ['Obj.=' caseStudy1Array{i}.objective];
    plot(x,aux(:,i),clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
end

hold off

grid on

print('caseStudy1_turbineCps','-depsc');

%----------- Turbine axial induction factor vs. turbine, vs objective --------------------------------------------------------------------------------------

figure('position',figSize2)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
legend('Location',legendLocation{2});
legend('boxoff');

ylim([0.1 0.2]);
ylabel('a [-]');

xlabel('Turbine number')

x = 1:1:5;

hold on

lgdEntry = 'Baseline';
plot(x,baseAI,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

for i = 1:3

    for j = 1:N
        aux(j,i) = double(solve([ 4*A*((1-A)^2) == aux(j,i) , A <= 0.5 ],A));
    end

    lgdEntry = ['Obj.=' caseStudy1Array{i}.objective];
    plot(x,aux(:,i),clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
end

hold off

grid on

print('caseStudy1_turbineAI','-depsc');

%----------- Turbine TSR vs. turbine, vs objective --------------------------------------------------------------------------------------

figure('position',figSize1)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
legend('Location',legendLocation{1},'NumColumns',2);
legend('boxoff');

%ylim([0.45 0.6]);
ylabel('TSR [-]');

xlabel('Turbine number')

x = 1:1:5;

hold on

lgdEntry = 'Baseline';
plot(x,baseTSR/10,'g-o','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)

for i = 1:3

    for j = 1:N
        aux(j,i) = ((D/2)*((slope*caseStudy1Array{i}.turbineU(j) + intercept)/gearboxRatio))/caseStudy1Array{i}.turbineU(j);
    end

    lgdEntry = ['Obj.=' caseStudy1Array{i}.objective];
    plot(x,aux(:,i)/10,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
end

hold off

grid on

print('caseStudy1_turbineTSR','-depsc');