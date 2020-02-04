% script to plot the figures on the assumption that turning off the DISCON
% control for the generator torque, and replace the changing rotor speed
% with my code, is no problem.
close all
clear all
cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\modelValidation\singleTurbine'

%This code loads the variables to be plotted, so it only needs to be run
%once.
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\OutList.mat
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\modelValidation\singleTurbine\turbineSim_U8T10_DISCONcontrol.mat
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\modelValidation\singleTurbine\turbineSim_U8T10_myControl.mat

outputs = {'RtAeroCp','RtAeroCt','RtTSR'};
clrs = {'-r','-b'};
data1 = outDataFilterOnset(5,data1);
data2 = outDataFilterOnset(5,data2);
[data1,~] = outDataCombineLoads(data1,OutList);
[data2,OutList] = outDataCombineLoads(data2,OutList);



figure('Position', [0 0 1600 600]);
set(gcf,'renderer','painters')

n = findLineNumber('Wind1VelX',OutList);  
plot(data1(:,1),data1(:,n),'k-');

xlabel('Time (s)');
xlim([0 600]);

ylabel('Wind speed (m/s)');
ylim([6 10]);
yticks((6:1:10));
set(gca,'ycolor','k') 

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', 24); 

legend('Instantaneous axial wind speed');
legend('Location','northwest');
legend('boxoff');

print('Verif_wind','-depsc')

%----------------

figure('Position', [0 0 1600 600]);
set(gcf,'renderer','painters')

xlabel('Time (s)');
xlim([0 600]);
%title('Generator torque controlled by FAST');

hold on

yyaxis left
for i = 1:2
    n = findLineNumber(outputs{i},OutList);
    
    plot(data1(:,1),data1(:,n),clrs{i});
end
ylabel('Cp,Ct');
ylim([0.4 0.9]);
yticks((0.4:0.1:0.9));
set(gca,'ycolor','k') 

yyaxis right
n = findLineNumber(outputs{3},OutList);
plot(data1(:,1),data1(:,n),'k-');
ylabel('TSR');
ylim([6.5 9]);
set(gca,'ycolor','k') 

hold off

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', 24); 

legend('Cp','Ct','TSR');
legend('Location','northwest');
legend('boxoff');

print('Verif_DISCONon','-depsc')

%------------------

figure('Position', [0 0 1600 600])
set(gcf,'renderer','painters')

xlabel('Time (s)');
xlim([0 600]);
%title('Generator torque control off');

hold on

yyaxis left
for i = 1:2
    n = findLineNumber(outputs{i},OutList);
    
    plot(data2(:,1),data2(:,n),clrs{i});
end
ylabel('Cp,Ct');
ylim([0.4 0.9]);
yticks((0.4:0.1:0.9));
set(gca,'ycolor','k') 

yyaxis right
n = findLineNumber(outputs{3},OutList);
plot(data2(:,1),data2(:,n),'k-');
ylabel('TSR');
ylim([6.5 9]);
set(gca,'ycolor','k') 

hold off

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', 24); 

legend('Cp','Ct','TSR');
legend('Location','northwest');
legend('boxoff');

print('Verif_DISCONoff','-depsc')


%------------

figure('Position', [0 0 1600 1200])
set(gcf,'renderer','painters')

xlabel('Time (s)');
xlim([0 600]);
%title('Blade root bending moments');

hold on

yyaxis left
n = findLineNumber('CombRootMc1',OutList);
plot(data1(:,1),data1(:,n),'-b');
plot(data2(:,1),data2(:,n),'-r');
ylabel('Comb. BRBM (Nm)');
ylim([3000 10000]);
yticks([3000:1000:10000]);
set(gca,'ycolor','k')

yyaxis right
n = findLineNumber('RtSpeed',OutList);
aux = data1(:,n);
aux = aux .* (1/mean(data2(:,n)));
plot(data1(:,1),aux,'-k');
ylabel('Rotor speed');
ylim([0.4 1.2]);
yticks(0.4:0.2:1.2);
set(gca,'ycolor','k')

hold off

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', 24); 

legend('Comb. BRBM, traditional control','Comb. BRBM, const. rotor speed','Rotor speed');
legend('Location','northwest');
legend('boxoff');

print('Verif_BRM','-depsc')

%------------

figure('Position', [0 0 1600 600])
set(gcf,'renderer','painters')

xlabel('Time (s)');
xlim([300 400]);
xticks((300:20:400));

hold on

n = findLineNumber('CombRootMc1',OutList);
plot(data1([58999:80001],1),data1([58999:80001],n),'-b');
plot(data2([58999:80001],1),data2([58999:80001],n),'-r');
ylabel('Comb. BRBM (Nm)');
ylim([4000 9000]);
yticks((4000:1000:9000));
set(gca,'ycolor','k');

hold off

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', 24); 

legend('Comb. BRBM, traditional control','Comb. BRBM, const. rotor speed');
legend('Location','northwest');
legend('boxoff');

print('Verif_BRMZoom','-depsc')