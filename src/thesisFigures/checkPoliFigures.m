%Script to build figures, that show that my polynomial fit functions are very good nice yes.
close all
clear all
cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\checkPoliWorkspace.mat')

outputArray = {'Average power [kW]','\sigma_{BM} [Nm]','Ct'};
pitchs = [0 2.5 5];
turbs = [8 12 16];
turbCol = [1 3 5];
UArray = [3	4 5	6 7	7.84 8 9 10	10.45 11 11.4];

fontSize = 22;
%figSize = [0 0 0.5 0.5];
figSize = [0 0 900 600];
lineWidth = 1.8;
markerSize = 8;

clrs = { 'b-o','r-o','k-o';'b--d','r--d','k--d' };

for p = 1:length(pitchs)


    for o = 1:length(outputArray)

        %figure('units','normalized','position',figSize)
        figure('position',figSize)

        set(gcf,'color','w'); %Set background color
        set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
        set(gca, 'FontSize', fontSize);

        xlabel('Wind speed [m/s]');
        ylabel(outputArray{o});

        hold on

        for t = 1:length(turbs)

            if p == 3
                xlim([7 12]);

                x = [7.84 8 9 10 10.45 11 11.4];

                y = pitchCellFAST{p}{t}(6:12,o);
                plot(x,y,clrs{1,t},'LineWidth', lineWidth, 'MarkerSize',markerSize)

                y = pitchCellPoli{p}{t}(6:12,o);
                plot(x,y,clrs{2,t},'LineWidth', lineWidth, 'MarkerSize',markerSize)
            else
                xlim([3 12]);

                x = UArray;

                y = pitchCellFAST{p}{t}(:,o);
                plot(x,y,clrs{1,t},'LineWidth', lineWidth, 'MarkerSize',markerSize)

                y = pitchCellPoli{p}{t}(:,o);
                plot(x,y,clrs{2,t},'LineWidth', lineWidth, 'MarkerSize',markerSize)
            end

        end

        hold off

        if o == 1
            legend('FAST, TI = 8%','f, TI = 8%','FAST, TI = 12%','f, TI = 12%','FAST, TI = 16%','f, TI = 16%');
            legend('Location','best');
            legend('boxoff');
        end

        if o == 3 & p == 3
            ylim([0.45 0.5]);
        end

        name = ['beta' num2str(p) 'output' num2str(o)];
        print(name,'-depsc');

    end
    
    


end







