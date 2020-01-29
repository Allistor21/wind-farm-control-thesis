function FASTnAToutput = FASTnAT(N,pitchSettings,Uinf,TIinf,X,TMax,wakeModelType)
%% FASTnAT
% Function that simulates the FASTnAT scenario, i.e "N" aligned turbines in
% a wind farm, with free-stream wind speed "Uinf", free-stream turbulence
% intensity "TIinf", distance between turbines "X"*D, with simulation time
% "TMax". Uses FAST simulation tool, embedded in functions. Applies a wake
% model of type "wakeModelType" in between each simulation.
%%

%FAST only publishes the OutList variable (critical for findLineNumber
%function) when a run is over, regardless of where the sim() command is
%placed. So, for now, OutList is loaded here as a variable.
load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\OutList.mat');

%Initialize the output variables, and declare pitch input global.
FASTnAToutput = struct('turbineNumber',(1:1:N),'pitchSettings',pitchSettings,'turbineU',zeros(1,N),'turbineTI',zeros(1,N),'turbineData',{cell(1,N)});
global pitchInput TMax
pitchInput = zeros(1,3);

%Begin loop, one for each turbine.
WS = Uinf;
TI = TIinf;
disp('%-----------------------------------------------------------------------------------------------------');
disp(['                        Starting simulation of ' num2str(N) ' aligned turbines...                     ']);
disp('%-----------------------------------------------------------------------------------------------------');
for i = 1:N
    %Reset flag.
    flag = 0;

    %Save Wind Speed and Turb. Intensity of current iteration.
    FASTnAToutput.turbineU(i) = WS;
    FASTnAToutput.turbineTI(i) = TI;
    
    %Simulate turbine with FAST, with corresponding pitch setting.
    disp('%-----------------------------------------------------------------------------------------------------');
    disp(['                               Simulating turbine #' num2str(i) ' ....                              ']);
    disp('%-----------------------------------------------------------------------------------------------------');
    pitchInput(:) = deg2rad(pitchSettings(i));
    try
        %Simulate turbine with FAST, and save result to output variable.
        outData = turbineSim(WS,TI,TMax,'PitchOpenLoop.mdl');
        FASTnAToutput.turbineData{i} = outData;
        
        %Turbine simulated sucessfully, apply wake model at X*D distance.
        xx = X;
    catch ME
        %Save error message on output variable.
        FASTnAToutput.turbineData(i) = {ME.message};

        %Change flag.
        flag = 1;
    end

    %Apply wake model. If statement checks if the wind speed is lower than cut-in speed. In that case,
    %apply wake model using Ct of last turbine, with twice the downstream distance.
    if WS < 3 | flag == 1
        xx = 2*X;
        [WS,TI] = wakeModel(wakeModelType,Ct,FASTnAToutput.turbineU(i-1),xx,Uinf,TIinf);
    else
        n = findLineNumber('RtAeroCt',OutList);
        Ct = mean(outData(:,n));
        [WS,TI] = wakeModel(wakeModelType,Ct,WS,xx,Uinf,TIinf);
    end
end

disp('%-----------------------------------------------------------------------------------------------------');
disp(['                          Ended simulation of ' num2str(N) ' aligned turbines...                      ']);
disp('%-----------------------------------------------------------------------------------------------------');
end

