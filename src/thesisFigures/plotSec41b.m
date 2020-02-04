% script to plot the 4 figures for the quatification of a turbine's output.
% 4 figures, 2 for power, 2 for a load: output vs (U,TI), for both pitch=0
% and pitch = 5
close all
clear all
cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\modelValidation\singleTurbine'

%The following code takes a long time to run, so it only needs to be done
%once, and then can be commented out.
pitch0 = load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\simulations\sweepUvsTIdataset_updt\theta__0','sweepStruct');
pitch5 = load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\simulations\sweepUvsTIdataset_updt\theta__5','sweepStruct');
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\OutList.mat;
outputArray = {'Power','CombRootMc1'};
[pitch0.sweepStruct,~] = FASTSweepUvsTIProcess(pitch0.sweepStruct,outputArray,OutList);
[pitch5.sweepStruct,OutList] = FASTSweepUvsTIProcess(pitch5.sweepStruct,outputArray,OutList);
structs = [pitch0.sweepStruct,pitch5.sweepStruct];

zLabelNames = {'Power (MW)','BRDM (kNm)'};
zlimsArray = { [0 6] , [0 0.5] ; [2 10] , [0.5 2] };

for t = 1:length(outputArray)
    for f = 1:length(structs)
        for lin = [1 2]

            s = size(structs(f).matrixesUvsTI);
            z = zeros(s);
            for i = 1:s(1)
                for j = 1:s(2)
            
                    if isnan(structs(f).matrixesUvsTI{i,j})
                        z(i,j) = nan(1);
                        continue
                    end
            
                    z(i,j) = structs(f).matrixesUvsTI{i,j}(lin,t)/1000;
                end
            end
            x = structs(f).UArray;
            y = structs(f).TIArray;
    
            figure('Position', [0 0 900 600])

            surf(y,x,z)
    
            xlabel('TI (%)');
            xlim([6 20]);
            xticks((6:2:20));
            
            ylabel('WS (m/s)');
            ylim([3 12]);
            yticks((3:2:12));
            
            zlabel(zLabelNames(t));
            zlim(zlimsArray{t,lin});
            
            set(gcf,'color','w'); %Set background color
            set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
            set(gca, 'FontSize', 24);
            
            filename = ['Verif_' num2str(t) num2str(f) num2str(lin)];
            print(filename,'-depsc');

        end
    end
end

