%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function reads files in the NPXLab native format
% (www.brainterface.com) into Matlab variables.
% Author: Lucia Rita Quitadamo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [progr_ver, dim, fs, n_chs, CH_LABS, DATA, EVENT_STRUCT, ICA]=read_npx(filename, filepath, inter_events)

fullFileName_npx= [filepath filesep filename '.npx'];
fullFileName_bin= [filepath filesep filename '.bin'];
MachineFormat='ieee-le';
fid = fopen(fullFileName_bin, 'r', MachineFormat);

if fid<0
    error('File cannot be open');
end

% READ IN AN UNSIGNED 8-BITS INTEGER AND SAVE THEM IN A 8-BITS CHARACTER
NPXFILE = fread(fid,8,'uint8=>char');
k = strcmp(NPXFILE,['NPXFILE' char(0)]');

XX= [];
XX= xml2struct(fullFileName_npx);
XX= XX.DOC;

if k~=1
    warning('This is not an NPX file or the header is missing')
    progr_ver= 0;
    dim= 0;
    fs_string= XX.Recording.BaseSR.Text;
    
    for i=1:length(fs_string)-1
        fs_string_2(i)=fs_string(i);
    end
    
    fs=str2num(fs_string_2);
    n_chs = length(XX.Sensor);
    
    for i=1:n_chs
        CH_LABS{i}= XX.Sensor{1,i}. Attributes.Name;
    end
    
    CH_LABS=char(CH_LABS');
    
    frewind(fid)
    DATA = fread(fid,[n_chs, inf], '*single');
else
    % READ THE VERSION OF THE PROGRAM
    progr_ver = fread(fid,1,'uint32');
    
    % READ THE DIMENSION OF THE HEADER SECTION
    dim = fread(fid,1,'uint32');
    
    % READ THE SAMPLING RATE AND SKIPS 4 BYTES
    fs = fread(fid,1,'uint32',4);
    
    % READ THE NUMBER OF CHANNELS AND SKIPS FOUR BYTES
    n_chs = fread(fid,1,'uint32', 4);
    
    % READ THE CHANNELS LABELS INTO THE MATRIX ch_labs
    ch_labs = fread(fid,[16, n_chs],'uint8=>char');
    CH_LABS = ch_labs';
    
    % READ THE EEG DATA INTO THE MATRIX DATA
    DATA = fread(fid,[n_chs, inf], '*single');
end

% READ THE EVENTS OF INTEREST

field_ex= isfield(XX.Events, 'Type');

if field_ex == 1
    n_events = length(XX.Events.Type);
    EVENT_RESOLUTION= XX.Events.Attributes.ResolutionSR;
    
    if strcmp(EVENT_RESOLUTION(end),'i')== 1
        EVENT_RESOLUTION_SR=str2num(EVENT_RESOLUTION(1:end-1));
    else
        EVENT_RESOLUTION_SR=str2num(EVENT_RESOLUTION(1:end));
    end
    
    if fs == 0
        fatt_conv= 1;
    else
        fatt_conv= EVENT_RESOLUTION_SR/fs;
    end
    
    for i=1:n_events
        if n_events == 1
            EVENT_LIST{i}= XX.Events.Type.Attributes.Name;
        else
            EVENT_LIST{i}= XX.Events.Type{1,i}.Attributes.Name;
        end
    end
    
else
    EVENT_LIST= [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sometimes there is a discrepancy between the virtual sample and the real
% sample, maybe due to some pauses in the signal. If this is not corrected,
% there is a jitter in the real beginning of events, and this makes further
% analyses not to work. Check the PAUSE event.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PAUSES= isfield(XX.Recording, 'Pause');

if PAUSES ~=0
    n_PAUSES= length(XX.Recording.Pause);
    
    for i= 1:n_PAUSES
        PAUSES_vsb(i)= (str2num(XX.Recording.Pause{1,i}.Attributes.VSB));
        PAUSES_vse(i)= (str2num(XX.Recording.Pause{1,i}.Attributes.VSE));
    end
    
    delay_vect=  PAUSES_vse - PAUSES_vsb;
    idx_delay= find(delay_vect ~= 0);
    
    if ~isempty(idx_delay)
        begin_delay_smpl= min(PAUSES_vse(idx_delay));
        delay_amount= sum(delay_vect(idx_delay));
    else
        delay_amount= 0;
    end
    
else
    idx_delay= [];
    delay_amount= 0;
end

EVENTS= [];
for e= 1:length(inter_events)
    idx_events= strmatch(inter_events{e}, EVENT_LIST, 'exact' );
    EVENTS{e}= idx_events;
end

[~, ll_c]= size(EVENTS);
EVENTS_NEW= [];

for i= 1: ll_c
    EVENTS_NEW= vertcat(EVENTS_NEW, EVENTS{i});
end

EVENTS= EVENTS_NEW;

EVENT_STRUCT= [];

for i=1:length(EVENTS)
    
    if length(EVENTS)== 1 && length(XX.Events.Type)==1
        EVENT_STRUCT(i,:).name= XX.Events.Type.Attributes.Name;
        EVENT_STRUCT(i,:).Class= str2num(XX.Events.Type.Attributes.Class);
    else
        EVENT_STRUCT(i,:).name= XX.Events.Type{1,EVENTS(i)}.Attributes.Name;
        EVENT_STRUCT(i,:).Class= str2num(XX.Events.Type{1,EVENTS(i)}.Attributes.Class);
    end
    
    
    if  EVENT_STRUCT(i,:).Class == 1
        
        if length(EVENTS)==1
            isF= isfield(XX.Events.Type, 'Event');
            if isF == 1
                n_sub_event= length(XX.Events.Type.Event);
            else
                n_sub_event = 0;
            end
        else
            isF= isfield(XX.Events.Type{1,EVENTS(i)}, 'Event');
            
            if isF == 1
                n_sub_event= length(XX.Events.Type{1,EVENTS(i)}.Event);
            else
                n_sub_event = 0;
            end
        end
        if  n_sub_event ~= 0
            for j=1:n_sub_event
                
                if n_sub_event ==1
                    VSB= ceil((str2num(XX.Events.Type{1,EVENTS(i)}.Event.Attributes.VSB))/fatt_conv);
                else
                    VSB= ceil((str2num(XX.Events.Type{1,EVENTS(i)}.Event{1,j}.Attributes.VSB))/fatt_conv);
                end
                
                if ~isempty(idx_delay)
                    if VSB >= ceil(begin_delay_smpl/fatt_conv)
                        EVENT_STRUCT(i,:).VSB(j)= VSB- delay_amount;
                    else
                        EVENT_STRUCT(i,:).VSB(j)= VSB;
                    end
                else
                    EVENT_STRUCT(i,:).VSB(j)= VSB;
                end
                
            end
        end
        
    elseif   EVENT_STRUCT(i,:).Class==2
        
        if length(EVENTS)== 1
            isF= isfield(XX.Events.Type, 'Event');
            if isF == 1
                n_sub_event= length(XX.Events.Type.Event);
            else
                n_sub_event = 0;
            end
        else
            isF= isfield(XX.Events.Type{1,EVENTS(i)}, 'Event');
            
            if isF == 1
                n_sub_event= length(XX.Events.Type{1,EVENTS(i)}.Event);
            else
                n_sub_event = 0;
            end
        end
        
        if  n_sub_event ~= 0
            
            for j=1:n_sub_event
                
                if n_sub_event ==1
                    VSB= ceil((str2num(XX.Events.Type{1,EVENTS(i)}.Event.Attributes.VSB))/fatt_conv);
                    VSE= (str2num(XX.Events.Type{1,EVENTS(i)}.Event.Attributes.VSE))/fatt_conv;
                else
                    VSB= ceil((str2num(XX.Events.Type{1,EVENTS(i)}.Event{1,j}.Attributes.VSB))/fatt_conv);
                    VSE= (str2num(XX.Events.Type{1,EVENTS(i)}.Event{1,j}.Attributes.VSE))/fatt_conv;
                end
                
                if ~isempty(idx_delay)
                    
                    if VSB >= ceil(begin_delay_smpl/fatt_conv)
                        EVENT_STRUCT(i,:).VSB(j)= VSB- delay_amount;
                        EVENT_STRUCT(i,:).VSE(j)= VSE- delay_amount;
                    else
                        EVENT_STRUCT(i,:).VSB(j)= VSB;
                        EVENT_STRUCT(i,:).VSE(j)= VSE;
                    end
                else
                    
                    EVENT_STRUCT(i,:).VSB(j)= VSB;
                    EVENT_STRUCT(i,:).VSE(j)= VSE;
                end
            end
            
        end
    else
        EVENT_LIST= [];
        EVENT_STRUCT= [];
        fatt_conv= 1;
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Search for ICA weights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ICA= [];
SpatialFilter= isfield(XX, 'SpatialFilter');

if SpatialFilter
    ICA=  isfield(XX.SpatialFilter, 'ICA');
    %     CSP=  isfield(XX.SpatialFilter, 'CSP');
    
    if ICA
        n_ICAcomps= length(XX.SpatialFilter.ICA.Weights.Source);
        W= zeros(n_ICAcomps,n_ICAcomps);
        Sp= zeros(n_ICAcomps,n_ICAcomps);
        InvW= zeros(n_ICAcomps,n_ICAcomps);
        
        for i=1: n_ICAcomps
            for j=1:n_ICAcomps
                W(i,j)= str2num(XX.SpatialFilter.ICA.Weights.Source{1,i}.Sensor{1,j}.Attributes.Value);
                Sp(i,j)= str2num(XX.SpatialFilter.ICA.Sphere.Source{1,i}.Sensor{1,j}.Attributes.Value);
                InvW(i,j)= str2num(XX.SpatialFilter.ICA.InvertedWeights.Source{1,i}.Sensor{1,j}.Attributes.Value);
            end
        end
        ICA.n_ICAcomps;
        ICA.W= W;
        ICA.Sp= Sp;
        ICA.InvW= InvW;
    end
    
end

fclose(fid);



