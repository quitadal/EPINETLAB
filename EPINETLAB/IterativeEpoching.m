%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This functions allows to epoch an EEG file loaded in the EEGLAB structure
% on all the events present in the dataset
% Author: Lucia Rita Quitadamo, 29/01/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Select folder for saving epoched files 
saveFolder= uigetdir('', 'Select folder to save epoched files');
if saveFolder == 0
    return
end

inputParameters = inputdlg({'Epoch Limits [sec1 sec2]:' , 'Baseline limits [sec1 sec2]:'},...
             'Select parameters for epoching', [1 70] );
if isempty(inputParameters) || isempty(inputParameters{1,1}) || isempty(inputParameters{2,1}) 
    warndlg('Either epoch limits or baseline is empty', 'Epoching parameters')
    return
end

% Select epoch limits
candidatepoch= str2num(inputParameters{1,:});
   if isempty(candidatepoch)
       warndlg('Please, insert correct limits for epoch', 'Epoch error')
       return
   elseif length(candidatepoch)~=2
       warndlg('Epoch limits should be two numbers', 'Epoch error')
       return
   elseif candidatepoch(2)<= candidatepoch(1)
        warndlg('Second epoch limit should be > than the first one', 'Epoch error')
       return
   end
timelim = candidatepoch;

% Select baseline limits
candidatebaseline= str2num(inputParameters{2,:});
   if isempty(candidatebaseline)
       warndlg('Please, insert correct limits for baseline', 'Baseline error')
       return
   elseif length(candidatebaseline)~=2
       warndlg('Baseline limits should be two numbers', 'Baseline error')
       return
   elseif candidatebaseline(2)<= candidatebaseline(1)
        warndlg('Second baseline limit should be > than the first one', 'Baseline error')
       return
   end
baseline = candidatebaseline;

EEG= evalin('base', 'EEG');
eventTypeAll= arrayfun(@(x) x.type, EEG.event, 'UniformOutput', false);
eventType= unique(eventTypeAll);
num_events=length(eventType);

for i=1:num_events
    EEGnew= EEG;
    EEGsave= pop_epoch(EEGnew, eventType(i),  timelim);
    rmBaseEEGsave = pop_rmbase( EEGsave, baseline);
    pop_saveset( rmBaseEEGsave, 'filename', ['Epoch_' eventType{i}], 'filepath',saveFolder ); 
end

clear baseline candidatebaseline candidatepoch EEGnew EEGsave eventType ...
     eventTypeAll i inputParameters num_events saveFolder timelim rmBaseEEGsave ans