%Script to plot wake model vs axial induction, and vs undisturbed wind speed

clear all
close all

prmtrList = {'N','Uinf','TIinf','X'};
lgdPrmtrList = {'N','U_{\infty}','TI_{\infty}','X'};
prmtrUnitsList = {' [-]',' [m/s]',' [%]','D [m]'};
outputArray = {'Power','CombRootMc1','RtAeroCt'};
clrsArray = {'r-x';'b-p';'m-d';'g-o';'k-s'};

figSize1 = [0 0 900 600];
powerLimArray = {[0 10]; [0 20]; [0 10]; [0 10]};
loadsLimArray = {[500 2500]; [1000 2500]; [1300 1600]; [1300 1600]};
ULimArray = {[4 8];[2 12];[4 8];[3 8]};
TILimAray = {[5 20];[5 25];[4 20];[8 30]};

fontSize = 30;
lineWidth = 1.8;
markerSize = 9;





X = 7;
UinfArray = [4 6 8 10 12];
TIinf = 8;

%CtArray = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
CtArray = [1 1.2 1.2 1.2 1.2];

UCells = cell(length(UinfArray),1); TICells = cell(length(UinfArray),1);

for i = 1:length(UinfArray)
    Uinf = UinfArray(i);
    
    UArray = zeros(length(CtArray),1); TIArray = zeros(length(CtArray),1);

    for j = 1:length(CtArray)
        [UArray(j),TIArray(j)] = wakeModel('jensenCrespo',CtArray(j),2.6,X,Uinf,TIinf);
    end

    UCells{i} = UArray; TICells{i} = TIArray;
end

figure('position',figSize1)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
%legend('Location','southoutside','NumColumns',length(struct_sstvt.resultArray));
legend('Location','best');
legend('boxoff');

ylabel('TI');
%ylim(TILimAray{l});

xlabel('Ct');

hold on

for i = 1:length(UinfArray)

    y = TICells{i};
    plot(CtArray,y,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize);

end

hold off