function lineNumber = findLineNumber(output,OutList)
%FindLineNumber is a function that determines in which line in OutList 
%(and therefore in which column of OutData) is a given output of FAST.

%Initialise variables.
lineNumber = 0;
n = length(OutList);

%Loop to look in OutList for output.
i=1;
while i <= n
    if strcmp(output,OutList{i})
        lineNumber = i;
        break
    end
    i = i+1;
end

end

