%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% With this function, you can export eeglab data structure into an .npx
% format (made of an .npx and a .bin file). It makes use of the eeglab
% function pop_loadset.
% Author Lucia Quitadamo, 2011, lucia.quitadamo@gmail,com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_npx_fromset(EEG)

if nargin < 1
    W = evalin('base','whos');
    extVar= zeros(size(W,1),1);
    for i=1:size(W,1)
        extVar(i)= strcmp('EEG', W(i).name);
    end
    
    if ~any(extVar)
        [EEG, ~] = pop_loadset;
    else
        EEG= evalin('base', 'EEG');
        if isempty (EEG.data)
            [EEG, ~] = pop_loadset;
        end
    end
end

n= ndims(EEG.data);

if n==3
    [chs,smpl,trials]=size(EEG.data);
    DATA=zeros(chs,smpl*trials);
    DATA(:,1:smpl)=EEG.data(:,1:smpl,1);
    for i=2:trials
        DATA(:,(i-1)*smpl+1:i*smpl)=EEG.data(:,1:smpl,i);
    end
else
    DATA= EEG.data;
end

[chs,smpl]=size(DATA);
Labels=zeros(chs,16);

if isempty(EEG.chanlocs)==0
    [aa,bb]= size(EEG.chanlocs);
    if aa < bb
        for i=1:chs
            lbl_size(i)=size(EEG.chanlocs(1,i).labels,2);
            Labels(i,1:lbl_size(i))=EEG.chanlocs(1,i).labels;
            Labels(i,lbl_size(i)+1: 16)=0;
        end
    else
        for i=1:chs
            lbl_size(i)=size(EEG.chanlocs(i,1).labels,2);
            Labels(i,1:lbl_size(i))=EEG.chanlocs(i,1).labels;
            Labels(i,lbl_size(i)+1: 16)=0;
        end
    end
    
else
    for i=1:chs
        EEG.chanlocs(1,i).labels= sprintf('%s%s','Ch',num2str(i));
        lbl_size(i)=size(EEG.chanlocs(1,i).labels,2);
        Labels(i,1:lbl_size(i))= EEG.chanlocs(1,i).labels;
        Labels(i,lbl_size(i)+1: 16)=0;
    end
end

%%%%%%%%%%%%%%%%%%%%%%
% WRITE THE BIN FILE
%%%%%%%%%%%%%%%%%%%%%%
if isempty(EEG.filename)
    [filename, filepath] = uiputfile('*.bin', 'Export .SET file to .NPX');
    if filename == 0
        return
    end
else
    filename= EEG.filename;
    if strcmp(filename(end-3:end), '.set')
        filename(end-3:end)= '.bin';
    end
    filepath= EEG.filepath;
    if strcmp(filepath(end), '/') || strcmp(filepath(end),'\')
        filepath=filepath;
    else
        filepath= [filepath filesep];
    end
end

filename2 = [filepath filename];

fid_w= fopen(filename2,'w');

file_title=['NPXFILE' char(0)];
fwrite(fid_w,file_title,'uint8');

progr_ver=17;
fwrite(fid_w,progr_ver,'uint32');

dim=chs*16+16;
fwrite(fid_w,dim,'uint32');

fs=EEG.srate;
fwrite(fid_w,fs,'uint32');

n_samples=smpl;
fwrite(fid_w,n_samples,'uint32');

fwrite(fid_w,chs,'uint32');
toskip=0;

fwrite(fid_w,toskip,'uint32');

%%%write the labels
fwrite(fid_w,Labels');

tmpmat = DATA;
fwrite(fid_w,tmpmat, 'float');
disp('Bin written')
fclose(fid_w);


%%%%%%%%%%%%%%%%%%%%%
%WRITE THE NPX FILE
%%%%%%%%%%%%%%%%%%%%%
docNode = com.mathworks.xml.XMLUtils.createDocument('DOC');
docRootNode = docNode.getDocumentElement;

FileInfo=docNode.createElement('FileInfo');
docRootNode = docNode.getDocumentElement;
docRootNode=docRootNode.appendChild(FileInfo);

Format=docNode.createElement('Format');
Format.appendChild(docNode.createTextNode('NPX'));
docRootNode.appendChild(Format);

Version=docNode.createElement('Version');
Version.appendChild(docNode.createTextNode('17'));
docRootNode.appendChild(Version);

VersionMaj=docNode.createElement('VersionMaj');
VersionMaj.appendChild(docNode.createTextNode('0i'));
docRootNode.appendChild(VersionMaj);

VersionMin=docNode.createElement('VersionMin');
VersionMin.appendChild(docNode.createTextNode('17i'));
docRootNode.appendChild(VersionMin);

MultiRate=docNode.createElement('MultiRate');
MultiRate.appendChild(docNode.createTextNode('N'));
docRootNode.appendChild(MultiRate);

DataTypeMode=docNode.createElement('DataTypeMode');
DataTypeMode.appendChild(docNode.createTextNode('0'));
docRootNode.appendChild(DataTypeMode);

Parent=docNode.createElement('Parent');
docParentNode = docRootNode.appendChild(Parent);

Type=docNode.createElement('Type');
Type.appendChild(docNode.createTextNode('Live'));
docParentNode.appendChild(Type);

FileName=docNode.createElement('FileName');
FileName.appendChild(docNode.createTextNode(' '));
docParentNode.appendChild(FileName);

Owner=docNode.createElement('Owner');
docOwnerNode = docRootNode.appendChild(Owner);

Subject=docNode.createElement('Subject');
docSubjectNode=docOwnerNode.appendChild(Subject);
docSubjectNode = docRootNode.appendChild(Subject);

FirstName=docNode.createElement('FirstName');
FirstName.appendChild(docNode.createTextNode(EEG.subject));
docSubjectNode.appendChild(FirstName);

LastName=docNode.createElement('LastName');
LastName.appendChild(docNode.createTextNode(''));
docSubjectNode.appendChild(LastName);

BirthDate=docNode.createElement('BirthDate');
BirthDate.appendChild(docNode.createTextNode(''));
docSubjectNode.appendChild(BirthDate);

Data=docNode.createElement('Data');
docDataNode = docRootNode.appendChild(Data);

Type=docNode.createElement('Type');
Type.appendChild(docNode.createTextNode('EEG'));
docDataNode.appendChild(Type);

docRootNode = docNode.getDocumentElement;
Generator=docNode.createElement('Generator');
docRootNode=docRootNode.appendChild(Generator);

Program=docNode.createElement('Program');
Program.appendChild(docNode.createTextNode('NPXFile.dll'));
docRootNode.appendChild(Program);

VersionMaj=docNode.createElement('VersionMaj');
VersionMaj.appendChild(docNode.createTextNode('0'));
docRootNode.appendChild(VersionMaj);

VersionMin=docNode.createElement('VersionMin');
VersionMin.appendChild(docNode.createTextNode('9'));
docRootNode.appendChild(VersionMin);

Author=docNode.createElement('Author');
Author.appendChild(docNode.createTextNode('Lucia Quitadamo from a .set file'));
docRootNode.appendChild(Author);

docRootNode = docNode.getDocumentElement;
Format=docNode.createElement('Format');
docRootNode=docRootNode.appendChild(Format);

FileMode_attribute=docNode.createAttribute('FileMode');
FileMode_attribute.setNodeValue('Binary');
Format.setAttributeNode(FileMode_attribute);

LinkMode_attribute=docNode.createAttribute('LinkMode');
LinkMode_attribute.setNodeValue('External');
Format.setAttributeNode(LinkMode_attribute);

SortMode_attribute=docNode.createAttribute('SortMode');
SortMode_attribute.setNodeValue('BySample');
Format.setAttributeNode(SortMode_attribute);

DataMode_attribute=docNode.createAttribute('DataMode');
DataMode_attribute.setNodeValue('Real4');
Format.setAttributeNode(DataMode_attribute);

docRootNode = docNode.getDocumentElement;
Recording=docNode.createElement('Recording');
docRootNode=docRootNode.appendChild(Recording);

BaseSR=docNode.createElement('BaseSR');
BaseSR.appendChild(docNode.createTextNode(sprintf('%s%s', num2str(fs),'i')));
docRootNode.appendChild(BaseSR);

Samples=docNode.createElement('Samples');
Samples.appendChild(docNode.createTextNode(sprintf('%s%s',num2str(smpl), 'i')));
docRootNode.appendChild(Samples);

Begin=docNode.createElement('Begin');
docRootNode.appendChild(Begin);
Year_attribute=docNode.createAttribute('Year');
Year_attribute.setNodeValue('');
Begin.setAttributeNode(Year_attribute);

Month_attribute=docNode.createAttribute('Month');
Month_attribute.setNodeValue('');
Begin.setAttributeNode(Month_attribute);

Day_attribute=docNode.createAttribute('Day');
Day_attribute.setNodeValue('');
Begin.setAttributeNode(Day_attribute);

Hour_attribute=docNode.createAttribute('Hour');
Hour_attribute.setNodeValue('');
Begin.setAttributeNode(Hour_attribute);

Minute_attribute=docNode.createAttribute('Minute');
Minute_attribute.setNodeValue('');
Begin.setAttributeNode(Minute_attribute);

Second_attribute=docNode.createAttribute('Second');
Second_attribute.setNodeValue('');
Begin.setAttributeNode(Second_attribute);

Millisecond_attribute=docNode.createAttribute('Millisecond');
Millisecond_attribute.setNodeValue('');
Begin.setAttributeNode(Millisecond_attribute);

End=docNode.createElement('End');
docRootNode.appendChild(End);
Year_attribute=docNode.createAttribute('Year');
Year_attribute.setNodeValue('');
End.setAttributeNode(Year_attribute);

Month_attribute=docNode.createAttribute('Month');
Month_attribute.setNodeValue('');
End.setAttributeNode(Month_attribute);

Day_attribute=docNode.createAttribute('Day');
Day_attribute.setNodeValue('');
End.setAttributeNode(Day_attribute);

Hour_attribute=docNode.createAttribute('Hour');
Hour_attribute.setNodeValue('');
End.setAttributeNode(Hour_attribute);

Minute_attribute=docNode.createAttribute('Minute');
Minute_attribute.setNodeValue('');
End.setAttributeNode(Minute_attribute);

Second_attribute=docNode.createAttribute('Second');
Second_attribute.setNodeValue('');
End.setAttributeNode(Second_attribute);

Millisecond_attribute=docNode.createAttribute('Millisecond');
Millisecond_attribute.setNodeValue('');
End.setAttributeNode(Millisecond_attribute);

% write sensors info

if isfield (EEG.chanlocs,'type')==0
    sensors={'EEG';'EMG'; 'EKG'; 'EOG'; 'Unknown'};
    [list_type,ok] = listdlg('PromptString','Select the sensor type:','ListString',sensors, 'Name', 'Sensors types','ListSize',[350 150] );
    sensor_type = sensors(list_type);
end

for i=1:chs
    docRootNode = docNode.getDocumentElement;
    Sensor=docNode.createElement('Sensor');
    docRootNode=docRootNode.appendChild(Sensor);
    
    Name_attribute=docNode.createAttribute('Name');
    Name_attribute.setNodeValue(EEG.chanlocs(1,i).labels);
    Sensor.setAttributeNode(Name_attribute);
    
    Type_attribute=docNode.createAttribute('Type');
    
    if isfield (EEG.chanlocs,'type')
        
        if isempty (EEG.chanlocs(1,i).type)==0
            chan_type=EEG.chanlocs(1,i).type;
        else
            chan_type='EEG';
        end
    else
        chan_type=sensor_type;
    end
    
    Type_attribute.setNodeValue(chan_type);
    Sensor.setAttributeNode(Type_attribute);
end

%%%%%%%%%%%%%
%WRITE EVENTS
%%%%%%%%%%%%%
docRootNode = docNode.getDocumentElement;
Events=docNode.createElement('Events');
docRootNode=docRootNode.appendChild(Events);

ResolutionSR_attribute=docNode.createAttribute('ResolutionSR');
ResolutionSR_attribute.setNodeValue(sprintf('%s%s', num2str(fs),'i'));
Events.setAttributeNode(ResolutionSR_attribute);

ReferenceTime=docNode.createElement('ReferenceTime');
docRootNode.appendChild(ReferenceTime);

Year_attribute=docNode.createAttribute('Year');
Year_attribute.setNodeValue('');
ReferenceTime.setAttributeNode(Year_attribute);

Month_attribute=docNode.createAttribute('Month');
Month_attribute.setNodeValue('');
ReferenceTime.setAttributeNode(Month_attribute);

Day_attribute=docNode.createAttribute('Day');
Day_attribute.setNodeValue('Day');
ReferenceTime.setAttributeNode(Day_attribute);

Hour_attribute=docNode.createAttribute('Hour');
Hour_attribute.setNodeValue('Hour');
ReferenceTime.setAttributeNode(Hour_attribute);

Minute_attribute=docNode.createAttribute('Minute');
Minute_attribute.setNodeValue('Minute');
ReferenceTime.setAttributeNode(Minute_attribute);

Second_attribute=docNode.createAttribute('Second');
Second_attribute.setNodeValue('Second');
ReferenceTime.setAttributeNode(Second_attribute);

Millisecond_attribute=docNode.createAttribute('Millisecond');
Millisecond_attribute.setNodeValue('Millisecond');
ReferenceTime.setAttributeNode(Millisecond_attribute);

% find the class which the events belong to

if isempty(EEG.event)==0
    events_struct=cell(length(EEG.event),1);
    
    for i=1:length(EEG.event)
        events_struct{i}=num2str(EEG.event(i).type);
        
        if isfield(EEG.event(i),'duration') && EEG.event(i).duration~=0 && strcmp(EEG.event(i).type,'boundary')~=1
            event_duration(i)=2;
        else
            event_duration(i)=1;
        end
    end
    
    spot_events=find(event_duration==1);
    state_events=find(event_duration==2);
    
    spot_struct=events_struct(spot_events);
    state_struct=events_struct(state_events);
    
    for i=1:length(spot_struct)
        sp_name= strcmp(state_struct,spot_struct(i));
        spot_idx=find(sp_name);
        
        if isempty(spot_idx)~=1
            sp_idx(i)=i;
        else
            sp_idx(i)=0;
        end
    end
    
    spot_amb=spot_events(sp_idx(find(sp_idx)));
    
    for i=1:length(spot_amb)
        events_struct(spot_amb(i))=cellstr(sprintf('%c%s',events_struct{spot_amb(i)},'_spot'));
    end
    
    events_class= unique(events_struct);
    
    for i=1:length(events_class)
        for j=1:length(events_struct)
            idx(i,j)=strcmp(events_struct{j},events_class{i});
        end
        duration(i)=unique(event_duration(find(idx(i,:))));
    end
    
    for i=1:length(events_class)
        
        Type=docNode.createElement('Type');
        docTypeNode=docRootNode.appendChild(Type);
        
        Name_attribute=docNode.createAttribute('Name');
        Name_attribute.setNodeValue(events_class{i});
        Type.setAttributeNode(Name_attribute);
        
        Class_attribute=docNode.createAttribute('Class');
        
        Class_attribute.setNodeValue(num2str(duration(i)));
        Type.setAttributeNode(Class_attribute);
        
        events_occ=find(idx(i,:));
        
        for k=1:length(events_occ)
            Event=docNode.createElement('Event');
            docTypeNode.appendChild(Event);
            
            VSB_attribute=docNode.createAttribute('VSB');
            VSB=round(EEG.event(1,events_occ(k)).latency);
            VSB_attribute.setNodeValue(num2str(VSB));
            Event.setAttributeNode(VSB_attribute);
            
            if duration(i)==2
                VSE_attribute=docNode.createAttribute('VSE');
                VSE=round(EEG.event(1,events_occ(k)).latency+EEG.event(1,events_occ(k)).duration);
                VSE_attribute.setNodeValue(num2str(VSE));
                Event.setAttributeNode(VSE_attribute);
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%
% WRITE ICA PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%
if isempty(EEG.icaweights)==1
    display('No ICA weights')
    
elseif size(EEG.icaweights, 1) ~=size(EEG.icaweights, 2)
    warning('Number of ICA Components different from number of channels. ICA will not be saved')
else
    SpatialFilter=docNode.createElement('SpatialFilter');
    docRootNode = docNode.getDocumentElement;
    docSpatialFilterNode=docRootNode.appendChild(SpatialFilter);
    
    
    ICA=docNode.createElement('ICA');
    docICANode=docSpatialFilterNode.appendChild(ICA);
    
    Method_attribute=docNode.createAttribute('Method');
    Method_attribute.setNodeValue('EEGLab function');
    ICA.setAttributeNode(Method_attribute);
    
    Weights=docNode.createElement('Weights');
    docWeightsNode=docICANode.appendChild(Weights);
    
    for i=1:size(EEG.icaweights,1)
        Source=docNode.createElement('Source');
        docSourceNode=docWeightsNode.appendChild(Source);
        
        Name_attribute=docNode.createAttribute('Name');
        Name_attribute.setNodeValue(sprintf('%s%s', 'IC_',num2str(i)));
        Source.setAttributeNode(Name_attribute);
        
        for j=1:size(EEG.icaweights,1)
            Sensor=docNode.createElement('Sensor');
            docSourceNode.appendChild(Sensor);
            
            Label_attribute=docNode.createAttribute('Label');
            Label_attribute.setNodeValue(EEG.chanlocs(1,i).labels);
            Sensor.setAttributeNode(Label_attribute);
            
            Value_attribute=docNode.createAttribute('Value');
            Value_attribute.setNodeValue(num2str(EEG.icaweights(i,j)));
            Sensor.setAttributeNode(Value_attribute);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Write ICA Sphere
    %%%%%%%%%%%%%%%%%%%%%%
    Sphere=docNode.createElement('Sphere');
    docSphereNode=docICANode.appendChild(Sphere);
    
    for i=1:size(EEG.icaweights,1)
        Source=docNode.createElement('Source');
        docSourceNode=docSphereNode.appendChild(Source);
        Name_attribute=docNode.createAttribute('Name');
        Name_attribute.setNodeValue(sprintf('%s%s', 'IC_',num2str(i)));
        Source.setAttributeNode(Name_attribute);
        
        for j=1:size(EEG.icasphere,1)
            Sensor=docNode.createElement('Sensor');
            docSourceNode.appendChild(Sensor);
            
            Label_attribute=docNode.createAttribute('Label');
            Label_attribute.setNodeValue(EEG.chanlocs(1,i).labels);
            Sensor.setAttributeNode(Label_attribute);
            
            Value_attribute=docNode.createAttribute('Value');
            Value_attribute.setNodeValue(num2str(EEG.icasphere(i,j)));
            Sensor.setAttributeNode(Value_attribute);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Write ICA inverse weights
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    InvertedWeights=docNode.createElement('InvertedWeights');
    docInvertedWeightsNode=docICANode.appendChild(InvertedWeights);
    
    for i=1:size(EEG.icaweights,1)
        Source=docNode.createElement('Source');
        docSourceNode=docInvertedWeightsNode.appendChild(Source);
        Name_attribute=docNode.createAttribute('Name');
        Name_attribute.setNodeValue(sprintf('%s%s', 'IC_',num2str(i)));
        Source.setAttributeNode(Name_attribute);
        
        for j=1:size(EEG.icaweights,1)
            Sensor=docNode.createElement('Sensor');
            docSourceNode.appendChild(Sensor);
            
            Label_attribute=docNode.createAttribute('Label');
            Label_attribute.setNodeValue(EEG.chanlocs(1,i).labels);
            Sensor.setAttributeNode(Label_attribute);
            
            Value_attribute=docNode.createAttribute('Value');
            Value_attribute.setNodeValue(num2str(EEG.icawinv(i,j)));
            Sensor.setAttributeNode(Value_attribute);
        end
    end
end

class_file= sprintf('%s%s', [filepath filename(1:end-4)], '.npx');
xmlwrite(class_file,docNode);
disp('Npx written')

return;



