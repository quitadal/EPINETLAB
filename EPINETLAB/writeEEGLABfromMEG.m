%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROUTINE TO READ MEG DATA SAVED IN .MAT FILES
% Author: Lucia Rita Quitadamo (l.quitadamo@aston.ac.uk)
% 10/06/2016
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[filename, filepath]= uigetfile('*.mat', 'Select the .MAT file');

if filename == 0
    return
end

S= load([filepath filename]);
fieldName= fieldnames(S);
nCh= size(S.(fieldName{1}),2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the eeglab structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG= eeg_emptyset;
EEG.setname= filename(1:end-4);
EEG.filename= filename;
EEG.filepath= filepath;
EEG.subject= '';
EEG.group= '';
EEG.condition= '';
EEG.session= [];
EEG.comments= 'For any problem contact Lucia Quitadamo (l.quitadamo@aston.ac.uk)';
EEG.nbchan= nCh;
EEG.trials= size(S.(fieldName{1})(1).trial,2);
EEG.pnts= size(S.(fieldName{1})(1).time{1,1},2);
EEG.xmin= S.(fieldName{1})(1).time{1,1}(1);
EEG.xmax= S.(fieldName{1})(1).time{1,1}(end);
EEG.times= S.(fieldName{1})(1).time{1,1};
EEG.srate= 2000;

for i= 1:nCh
    EEG.chanlocs(i).labels= S.(fieldName{1})(i).label{:};
        
    for j= 1:EEG.trials
        DATA= S.(fieldName{1})(i).trial{1,j};
        EEG.data(i,:,j)= DATA;
    end  
end

% ALLEEG= [];
% [ALLEEG, EEG, index] = eeg_store(ALLEEG, EEG);

pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', EEG.filepath );
disp('Done') 

