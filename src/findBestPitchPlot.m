
outputs = {'OoPDefl1';'BldPitch1';'B1Pitch';'GenTq';'GenSpeed';'B1N1M';'B1N2M';'B1N3M';'RtAeroFxh';'B1N1Cl';'B1N2Cl';'B1N3Cl'};

pitches = [1;3;4];
testfBP = cell(2,length(pitches));

for i = 1:length(pitches)
    testfBP{1,i} = ['Pitch=' num2str(pitchSettings(pitches(i))) 'º'];
    testfBP{2,i} = outDataCell(pitches(i));
end

FASTnATplot(outputs,testfBP,testfBP,OutList,5);
