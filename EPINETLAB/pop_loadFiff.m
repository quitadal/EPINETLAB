%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function allows to read raw .fif files (Elekta MEG system) and
% create an eeglab .set file. It makes use of functions in the MNE/shared/Matlab folder.
% Author: LR Quitadamo, l.quitadamo@aston.ac.uk, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [EEG]= pop_loadFiff

[fileName,filePath] = uigetfile('*.fif','Select RAW .fiff file');
if strcmp(filePath(end), '\')
    fullFile= [filePath fileName];
else
    fullFile= [filePath '\' fileName];
end
allow_maxshield =0; % allow_maxshield     Accept unprocessed MaxShield data
[raw] = fiff_setup_read_raw(fullFile,allow_maxshield);


EEG= eeg_emptyset; % create eeglab empty set
EEG.setname= 'MEG .fif file';
EEG.filename= fileName;
EEG.filepath= filePath;
EEG.comments= 'File converted from the .fif format. For any problem please contact Lucia Quitadamo (lucia.quitadamo@gmail.com)';

EEG.nbchan= raw.info.nchan;
EEG.srate= raw.info.sfreq; 
EEG.pnts= raw.last_samp-raw.first_samp+1;
EEG.xmin= double(raw.first_samp/EEG.srate);
EEG.xmax= double(raw.last_samp/ EEG.srate);

MEGLabels= raw.info.ch_names';
for i=1:EEG.nbchan
    EEG.chanlocs(i).labels= MEGLabels{i};
    
    EEG.chanlocs(i).X= 1000*raw.info.chs(i).loc(1); %1000 to have coordinates in mm
    EEG.chanlocs(i).Y= 1000*raw.info.chs(i).loc(2);
    EEG.chanlocs(i).Z= 1000*raw.info.chs(i).loc(3);
    
    if raw.info.chs(i).coil_type == 0
        EEG.chanlocs(i).type= 'unknown';
    elseif raw.info.chs(i).coil_type == 5
        EEG.chanlocs(i).type= 'ecg';
    elseif raw.info.chs(i).coil_type == 3024
        EEG.chanlocs(i).type= 'megmag';
    elseif raw.info.chs(i).coil_type == 3012
        EEG.chanlocs(i).type= 'megplanar';
    else
        EEG.chanlocs(i).type= 'unknown';
    end
end

choice = questdlg('Do you want to add atlas position?','Atlas Virtual sensors positions',...
                  'Yes', 'No', 'Yes');

switch choice
    case 'Yes'
        [filenameATLAS, filepathATLAS]= uigetfile('*loc', 'Select ATLAS regions');
        
        if filenameATLAS == 0
            error('ATLAS regions will not be added into EEGLab structure');
        end

        ATLASFID= fopen([filepathATLAS filenameATLAS], 'r');
        ATLAS= textscan(ATLASFID, '%s', 'Delimiter', '');
        nAtlas= size(ATLAS{1,1},1);
        if nAtlas ~= EEG.nbchan
            warning('Number of ATLAS regions different from number of channels. Channel labels will be added until the end of ATLAS file');
        end
        
        for i=1:EEG.nbchan
            EEG.chanlocs(i).type= ATLAS{1,1}{i,:};
        end
        
    case 'No'
        disp('No ATLAS regions added')
end
   
[DATA,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp);
EEG.data= DATA;
EEG.times= times;
[EEG] = eeg_checkset(EEG);
