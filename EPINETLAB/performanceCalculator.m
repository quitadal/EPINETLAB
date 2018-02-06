%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute performances
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SOZ= {'L3-L4' 'L4-L5' 'T4-T5' 'T5-T6' 'T6-T7' 'T7-T8'};

[fileToAnalyse, filepath]= uigetfile('*.txt', 'Select HFO detection results files',  'MultiSelect', 'on' );

if length(fileToAnalyse)==1
    if fileToAnalyse == 0
        return
    end
end

if iscell(fileToAnalyse)
    nFiles= length(fileToAnalyse);
else
    nFiles= 1;
end

finalCHAN= [];
finalTOTHFO= [];